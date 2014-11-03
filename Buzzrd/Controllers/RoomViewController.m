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
#import "KeyboardBarTableView.h"
#import "MMDrawerBarButtonItem.h"
#import "RoomActionsViewController.h"
#import "ResetRoomBadgeCountCommand.h"

@interface RoomViewController ()

@property (nonatomic) float keyboardHeightCache;

@property (strong, nonatomic) SocketIO *socket;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *messageHeights;
@property (nonatomic) uint loading;
@property (strong, nonatomic) UserCountBarButton *rightBar;

@end

@implementation RoomViewController

- (void)loadView
{
    self.title = self.room.name;
    
    self.tableView = [[KeyboardBarTableView alloc]initWithDelegate:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[BuzzrdBackgroundView alloc]init];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.tableView becomeFirstResponder];
    
    [self initializeRightDrawerButton];
    
    // Dismiss the keyboard be recognizing tab gesture
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    [self initRoom];
}

- (void)dealloc {
    NSLog(@"RoomViewController:dealloc");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // create hook for keyboard to expand table view on close
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    [self initializeRightDrawerMenu];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    
    [self removeRightDrawerMenu];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    // Disconnect on room exit
    [self disconnect];
}



- (void) hideKeyboard {
    [self.tableView becomeFirstResponder];
}



- (void)initRoom
{
    // trigger badge reset
    [self resetRoomBadgeCount];
    
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
        [self initRoom];
    }
}


// Scrolls the table by an appropriate amount
-(void)keyboardWillChange:(NSNotification *)notification
{
    
    dispatch_after(1, dispatch_get_main_queue(), ^{
        CGRect beginFrame = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endFrame =  [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat delta = (endFrame.origin.y - beginFrame.origin.y);
        NSLog(@"Keyboard YDelta %f -> B: %@, E: %@", delta, NSStringFromCGRect(beginFrame), NSStringFromCGRect(endFrame));
        
        if(self.tableView.scrolledToBottom && fabs(delta) > 0.0) {
            
            NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
            UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;
            
            [UIView animateWithDuration:duration delay:0 options:options animations:^{
                
                if (self.isDrawerTransitioning == false)
                {
                    // Make the tableview scroll opposite the change in keyboard offset.
                    // This causes the scroll position to match the change in table size 1 for 1
                    // since the animation is the same as the keyboard expansion
                    self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y - delta);
                }
            } completion:nil];
        }
    });
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




- (void) resetRoomBadgeCount {
    NSLog(@"resetRoomBadgeCount");
    
    ResetRoomBadgeCountCommand *command = [[ResetRoomBadgeCountCommand alloc]init];
    command.roomId = self.room.id;
    [command listenForCompletion:self selector:@selector(resetRoomBadgeCountDidComplete:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)resetRoomBadgeCountDidComplete:(NSNotification *)notification {
    NSLog(@"resetRoomBadgeCountDidComplete");
    
    ResetRoomBadgeCountCommand *command = notification.object;
    if(command.status == kSuccess) {
        long clearCount = [command.results longLongValue];
        NSLog(@"  -> Resting %lu", clearCount);
        
        // reset the badge count for the app
        long currentBadgeCount = [[UIApplication sharedApplication] applicationIconBadgeNumber];
        long newBadgeCount = MAX(currentBadgeCount - clearCount, 0);
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:newBadgeCount];
    
        // send out application notification to clear unread status
        NSDictionary *userInfo =  @{ BZRoomDidClearBadgeRoomKey : self.room.id };
        [[NSNotificationCenter defaultCenter] postNotificationName:BZRoomDidClearBadgeNotification object:self userInfo:userInfo];
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
    // only send messages when there is text
    if(![text isEqualToString:@""]) {
        
        // attempt to send the message
        bool result = [self sendMessage:text];
        
        // if it successfully sent, clear the keyboard bar's text
        if(result) {
           [(KeyboardBarView *)self.tableView.inputAccessoryView clearText];
        }
    }
}


#pragma mark - Drawer Interactions

- (void) initializeRightDrawerMenu
{
    // Hide the text input area when the drawer is visible
    [self.drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        
        self.isDrawerTransitioning = true;
        
        if(drawerController.openSide == MMDrawerSideNone)
        {
            [self.tableView.inputAccessoryView setHidden:YES];
            [self.tableView.inputAccessoryView setUserInteractionEnabled:NO];
        }
    }];
    
    // Show the text input area when the drawer is hidden
    [self.drawerController setGestureCompletionBlock:^(MMDrawerController *drawerController, UIGestureRecognizer *gesture) {

        self.isDrawerTransitioning = false;
        
        if (drawerController.openSide == MMDrawerSideNone)
        {
            [self.tableView.inputAccessoryView setHidden:NO];
            [self.tableView.inputAccessoryView setUserInteractionEnabled:YES];
        }
    }];
    
    RoomActionsViewController * rightSideDrawerViewController = [[RoomActionsViewController alloc]init];
    
    rightSideDrawerViewController.room = self.room;
    
    UINavigationController *menuNavigationController = [[UINavigationController alloc] initWithRootViewController:rightSideDrawerViewController];

    self.drawerController.rightDrawerViewController = menuNavigationController;
}

- (void) removeRightDrawerMenu
{
    self.drawerController.rightDrawerViewController = nil;
}

- (void) initializeRightDrawerButton
{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    
    self.navigationItem.rightBarButtonItem = rightDrawerButton;
}

-(void)rightDrawerButtonPress:(id)sender
{
    [self toggleRightDrawerMenu];
}

- (void) toggleRightDrawerMenu
{    
    self.isDrawerTransitioning = true;
    
    [self.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
        if(self.drawerController.openSide == MMDrawerSideNone)
        {
            [self.tableView.inputAccessoryView setHidden:NO];
            [self.tableView.inputAccessoryView setUserInteractionEnabled:YES];
        }
    }];
}

#pragma mark - Socket Interactions

- (void)connectToSocketServer
{
    if(self.socket == nil || !self.socket.isConnected)
    {
        bool isSecure = [BuzzrdAPI current].config.apiUseTLS;
        NSString *host = [BuzzrdAPI current].config.apiHost;
        long port = [BuzzrdAPI current].config.apiPort;
        
        self.socket = [[SocketIO alloc] initWithDelegate:self];
        
        if(isSecure) {
            self.socket.useSecure = true;
        }
        [self.socket connectToHost:host onPort:port];
    }
}

- (bool)sendMessage:(NSString *)message
{
    if(self.socket.isConnected) {
        [self.socket sendEvent:@"message" withData:message];
        return true;
    } else {
        [self showRetryAlertWithTitle:NSLocalizedString(@"message_send_failure", nil)
                              message:NSLocalizedString(@"message_send_failure_description", nil)
                       retryOperation:nil];
        return false;
    }
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
    
    // If we were at the bottom scroll position prior to adding a new row,
    // we will now scroll to the bottom position again
    if(currentlyAtBottom || message) {
        
        [self.tableView scrollToBottom:true];
        
    } else {
        // Status message near inputAccessory similar to Line/Facebook
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
        [self receiveJoin:(uint)[packet.args[0] unsignedIntegerValue]];
    }
    
    else if([packet.name isEqualToString:@"userleave"]) {
        [self receiveLeave:(uint)[packet.args[0] unsignedIntegerValue]];
    }
    
    else if([packet.name isEqualToString:@"authenticate"]) {
        [self.socket sendEvent:@"join" withData:self.room.id];
    }
}

@end
