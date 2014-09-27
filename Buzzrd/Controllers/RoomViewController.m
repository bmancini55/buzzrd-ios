//
//  RoomViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "RoomViewController.h"
#import "SocketIOPacket.h"
#import "BuzzrdAPI.h"
#import "Message.h"
#import "GetMessagesForRoomCommand.h"
#import "MessageCell.h"
#import "UserCountBarButton.h"
#import "BuzzrdBackgroundView.h"
#import "UITableView+ScrollHelpers.h"

@interface RoomViewController ()

    @property (strong, nonatomic) KeyboardBarView *keyboardBar;
    @property (strong, nonatomic) SocketIO *socket;
    @property (strong, nonatomic) NSMutableArray *messages;
    @property (strong, nonatomic) NSMutableArray *messageHeights;
    @property (nonatomic) uint loading;
    @property (strong, nonatomic) UserCountBarButton *rightBar;

@end

@implementation RoomViewController

- (void)loadView
{
    [super loadView];

    self.title = self.room.name;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[BuzzrdBackgroundView alloc]init];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
    // create hooks for keyboard to shrink table view on open/close
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    // Add the info for the right bar menu
    self.rightBar = [[UserCountBarButton alloc]initWithFrame:CGRectMake(0, 0, 75, self.navigationController.navigationBar.frame.size.height)];
    [self.rightBar setUserCount:(uint)self.room.userCount];
    self.navigationItem .rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];

    
    // Dismiss the keyboard be recognizing tab gesture
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    [self loadRoom];
}

- (void) hideKeyboard {
    KeyboardBarView *keyboardBar = (KeyboardBarView *)self.inputAccessoryView;
    [keyboardBar dismissKeyboard];
}


// Fires on room exit
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];    
    [self disconnect];
}



- (void)loadRoom
{
    // reset messages
    self.messages = [[NSMutableArray alloc]init];
    self.messageHeights = [[NSMutableArray alloc]init];
    
    // load recent messages
    [self loadMessages];
}


// reset the socket connection
- (void)disconnect
{
    self.socket.delegate = nil;
    [self.socket disconnect];
    self.socket = nil;
}

// loads the latest messages and reconnects
// if currently disconnected from the server
- (void) reconnect
{
    if(self.socket == nil || !self.socket.isConnected) {
        [self loadRoom];
    }
}

// Reimplements inputAccessorView from UIResponder to dock keyboardBar at bottom
- (UIView*)inputAccessoryView
{
    if (self.keyboardBar == nil) {
        self.keyboardBar = [[KeyboardBarView alloc]init];
        self.keyboardBar.delegate = self;
    }
    return self.keyboardBar;
}

// Enables the keyboard bar
- (BOOL)canBecomeFirstResponder
{
    return true;
}


// Scroll to bottom when keyboard is shown
-(void)keyboardWillShow:(NSNotification *)notification
{
    // Only do the scrolling if we are at the bottom of the scrollview
    if(self.tableView.scrolledToBottom) {
        
        NSDictionary *userInfo = [notification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardBeginFrame;
        CGRect keyboardEndFrame;
        
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBeginFrame];
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        [UIView animateKeyframesWithDuration:animationDuration delay:0 options:(animationCurve << 16) animations:^{
            
            // Make the tableview scroll DOWN by the change in keyboard size.
            // This causes the scroll position to match the change in table size 1 for 1
            // since the animation is the same as the keyboard expansion
            CGFloat keyboardHeightChange = (keyboardEndFrame.size.height - keyboardBeginFrame.size.height);
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + keyboardHeightChange);
            
        } completion:^(BOOL finished) {
            
            // Finalize by scrolling any additional offset
            [self.tableView scrollToBottom:true];
        }];
    }
}





#pragma mark - Internal helper methods

- (void)loadMessages
{
    if(!self.loading)
    {
        self.loading = true;
        GetMessagesForRoomCommand *command = [[GetMessagesForRoomCommand alloc]init];
        command.room = self.room;

        if(self.messages.count > 0)
            command.after = ((Message *)self.messages[0]).idmessage;
        
        [command listenForCompletion:self selector:@selector(messagesForRoomDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

- (void)messagesForRoomDidComplete:(NSNotification *)notification
{
    NSDate *timer = [NSDate date];
    self.loading = false;
    GetMessagesForRoomCommand *command = notification.object;
    if(command.status == kSuccess)
    {
        // merge results into table
        NSArray *newMessages = command.results;
        
        // on fresh reload
        if (self.messages.count == 0)
        {
            // set messages
            for(int i = 0; i < newMessages.count; i++) {
                [self.messages addObject:newMessages[i]];
                [self.messageHeights addObject:[[NSNumber alloc]initWithFloat:0]];
            }
            
            // reprocess table
            [self.tableView reloadData];
            [self.tableView scrollToBottom:false];
            [self connectToSocketServer];
        }
        // on additional pages loaded
        else
        {
            // only update if there are results
            if(newMessages.count > 0)
            {
                // set messages
                for(int i = 0; i < newMessages.count; i++) {
                    [self.messages insertObject:newMessages[i] atIndex:i];
                    [self.messageHeights insertObject:[[NSNumber alloc]initWithFloat:0] atIndex:i];
                }
                
                // turn off animations for the update block
                [UIView setAnimationsEnabled:false];
                
                // perform row additions in the table
                [self.tableView beginUpdates];

                CGPoint tableViewOffset = [self.tableView contentOffset];
                NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
                
                // for each message...
                for(int index = 0; index < newMessages.count; index++) {
                    
                    // insert the row
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    [indexPaths addObject:indexPath];
                    
                    // calculate the row height
                    tableViewOffset.y += [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
                }

                // insert the rows at the index paths
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                
                // end animations
                [self.tableView endUpdates];
                
                // enable animations
                [UIView setAnimationsEnabled:true];
                
                // move scroll to previous position
                [self.tableView setContentOffset:tableViewOffset animated:false];
            }
            
        }
            
        NSLog(@"Rendered in: %f", [timer timeIntervalSinceNow] * -1000.0);
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = self.messages[indexPath.row];
    
    bool mine = message.isMine;
    bool revealed = message.revealed;
    NSString *identifier = [NSString stringWithFormat:@"MessageCell-%@-%@",
                            (mine ? @"Mine" : @"Other"),
                            (revealed ? @"Revealed": @"Hidden")];
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier myMessage:mine revealedMessage:revealed];
    }
    [cell setMessage:message];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.keyboardBar dismissKeyboard];
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cachedValue = [self.messageHeights[indexPath.row] floatValue];
    if(cachedValue > 0)
    {
        return cachedValue;
    }
    else
    {
        Message *message = self.messages[indexPath.row];
        MessageCell *cell = [[MessageCell alloc]initWithMyMessage:message.isMine revealedMessage:message.revealed];
        [cell setMessage:message];
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        [self.messageHeights replaceObjectAtIndex:indexPath.row withObject:[[NSNumber alloc] initWithFloat:height]];
        return height;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y <= 10) {
        [self loadMessages];
    }
}



#pragma mark - KeyboardBarDelegate

- (void)keyboardBar:(KeyboardBarView *)keyboardBarView buttonTouched:(NSString *)text
{
    [self sendMessage:text];
}


#pragma mark - Socket Interactions

- (void)connectToSocketServer
{
    if(self.socket == nil || !self.socket.isConnected)
    {
        self.socket = [[SocketIO alloc] initWithDelegate:self];
        [self.socket connectToHost:@"devapi.buzzrd.io" onPort:5050];
    }
}

- (void)sendMessage:(NSString *)message
{
    [self.socket sendEvent:@"message" withData:message];
}

- (void)receiveMessage:(Message *)message;
{
    bool currentlyAtBottom = [self.tableView scrolledToBottom];
    
    [self.messages addObject:message];
    [self.messageHeights addObject:[[NSNumber alloc]initWithFloat:0]];
    
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    // if we were at the bottom scroll position prior to adding a new row,
    // we will now scroll to the bottom position again
    if(currentlyAtBottom || message) {
        
        [self.tableView scrollToBottom:true];
        
    } else {
        // todo create notification similar to Line or facebook
    }
}

- (void)receiveJoin:(uint)users;
{
    
    self.rightBar.userCount = users;
}

- (void)receiveLeave:(uint)users;
{
    self.rightBar.userCount = users;
}


#pragma mark - SocketIODelegate

-(void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Authenticating with socket server");
    [self.socket sendEvent:@"authenticate" withData:[[[BuzzrdAPI current] authorization] bearerToken]];
}
-(void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"Websocket disconnected with error: %@", error);
    [self reconnect];
}
-(void)socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"Websocket error: %@", error);
}

-(void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    if([packet.name isEqualToString:@"message"]) {
        Message *message = [[Message alloc] initWithJson:packet.args[0]];
        [self receiveMessage:message];
    }
    
    else if([packet.name isEqualToString:@"userjoin"]) {
        [self receiveJoin:[packet.args[0] unsignedIntegerValue]];
    }
    
    else if([packet.name isEqualToString:@"userleave"]) {
        [self receiveLeave:[packet.args[0] unsignedIntegerValue]];
    }
    
    else if([packet.name isEqualToString:@"authenticate"]) {
        [self.socket sendEvent:@"join" withData:self.room.id];
    }
        
}

@end
