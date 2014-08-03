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

@interface RoomViewController ()

    @property (strong, nonatomic) KeyboardBarView *keyboardBar;
    @property (strong, nonatomic) SocketIO *socket;
    @property (strong, nonatomic) NSArray *messages;

@end

@implementation RoomViewController

- (void)loadView
{
    [super loadView];

    self.title = self.room.name;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
    // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    // create hooks for keyboard to shrink table view on open/close
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowOrHide:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowOrHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
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

// Fires when app is restored
- (void)appDidBecomeActive
{
    [self connectToSocketServer];
    [self reconnect];
}

// Fires when app goes to background
- (void)appWillResignActive
{
    // Not sure if we want to disconnect or let timeout occur
    // probably want to let timeout naturally occur in the event
    // that a user briefly steps away from the app, it shouldn't
    // reload the entire chat...
    
    //[self disconnect];
}


- (void)loadRoom
{
    // reset messages
    self.messages = [[NSArray alloc]init];
    
    // load recent messages
    [self loadMessagesWithPage:1];
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


// Scroll to bottom when keyboard is shown or hidden
-(void)keyboardDidShowOrHide:(NSNotification *)notification
{
    [self scrollToBottom:false];
}

#pragma mark - Internal helper methods

- (void)loadMessagesWithPage:(uint)page
{
    GetMessagesForRoomCommand *command = [[GetMessagesForRoomCommand alloc]init];
    command.room = self.room;
    command.page = page;
    [command listenForCompletion:self selector:@selector(messageForRoomDidComplete:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)messageForRoomDidComplete:(NSNotification *)notification
{
    GetMessagesForRoomCommand *command = notification.object;
    if(command.status == kSuccess)
    {
        // merge results into table
        NSArray *newMessages = command.results;
        NSMutableArray *mergeArray = [[NSMutableArray alloc]initWithArray:newMessages];
        [mergeArray addObjectsFromArray:self.messages];
        self.messages = mergeArray;
        [self.tableView reloadData];
        
        // on fresh reload
        if (command.page == 1)
        {
            [self scrollToBottom:false];
            [self connectToSocketServer];
        }
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}

- (void)scrollToBottom:(BOOL)animated
{
    NSInteger lastSection = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView] - 1;
    NSInteger rowIndex = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:lastSection] - 1;
    
    if(rowIndex >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:lastSection];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
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
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    if(cell == nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"message"];
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
    Message *message = self.messages[indexPath.row];
    
    MessageCell *cell = [[MessageCell alloc]init];
    [cell setMessage:message];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
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
    NSMutableArray *mergeArray = [[NSMutableArray alloc]initWithArray:self.messages];
    
    [mergeArray addObject:message];
    self.messages = [[NSArray alloc]initWithArray:mergeArray];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self scrollToBottom:true];
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
    
    else if([packet.name isEqualToString:@"authenticate"]) {
        NSLog(@"Joining room: %@", self.room.id);
        [self.socket sendEvent:@"join" withData:self.room.id];
    }
        
}

@end
