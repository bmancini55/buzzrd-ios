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

@interface RoomViewController ()

    @property (strong, nonatomic) SocketIO *socket;
    @property (strong, nonatomic) NSArray *messages;
    @property (strong, nonatomic) KeyboardTextView *inputView;

@end

@implementation RoomViewController

- (void)loadView
{
    [super loadView];
            
    self.messages = [[NSArray alloc] init];

    // load recent messages
    [self loadMessagesWithPage:1];
    
    // connect to socket service
    [self connectToSocketServer];

    // wire-up keyboard
    self.inputView = [[KeyboardTextView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-40,self.view.frame.size.width, 40)];
    self.inputView.delegate = self;
    [self.view addSubview:self.inputView];
    
    // adjust table view
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = tableFrame.size.height - 40;
    self.tableView.frame = tableFrame;
    
    // create hooks for keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardOpen:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardClose:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Internal helper methods

- (void)loadMessagesWithPage:(uint)page
{
    // success handler
    void (^success)(NSArray *messages) = ^(NSArray *messages) {
        
        NSMutableArray *mergeArray = [[NSMutableArray alloc]initWithArray:messages];
        [mergeArray addObjectsFromArray:self.messages];
        self.messages = mergeArray;
        
        [self.tableView reloadData];
      
        // scroll to bottom if this was first page
        if (page == 1)
        {
            [self scrollToBottom:false];
        }
    };
    
    // failure handler
    void (^failure)(NSError *error) = ^(NSError *error) {
        NSLog(@"Error retrieving messages: %@", error);
    };
    
    // retrive from API
    [BuzzrdAPI.current.messageService getMessagesForRoom:self.room
                                                    page:page
                                                 success:success
                                                 failure:failure];
}

- (void)scrollToBottom:(BOOL)animated
{
    CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height);
    [self.tableView setContentOffset:bottomOffset animated:animated];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Room"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Room"];
    }
    cell.textLabel.text = ((Message *)self.messages[indexPath.row]).message;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - KeyboardTextViewDelegate

- (void)keyboardTextView:(KeyboardTextView *)keyboardTextView sendTouched:(NSString *)text
{
    [self sendMessage:text];
}


#pragma mark - Socket Interactions

- (void)connectToSocketServer
{
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    [self.socket connectToHost:@"localhost" onPort:5050];
}

- (void)sendMessage:(NSString *)message
{
    [self.socket sendEvent:@"message" withData:message];
}

- (void)receiveMessage:(NSString *)message;
{
    Message *messageInstance = [[Message alloc]init];
    messageInstance.message = message;
    NSMutableArray *mergeArray = [[NSMutableArray alloc]initWithArray:self.messages];
    
    [mergeArray addObject:messageInstance];
    self.messages = [[NSArray alloc]initWithArray:mergeArray];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self scrollToBottom:false];
}


#pragma mark - SocketIODelegate

-(void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Websocket connected");
    NSLog(@"Joining room: %@", self.room.idroom);
    [self.socket sendEvent:@"join" withData:self.room.idroom];
}
-(void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"Websocket disconnected with error: %@", error);
}
-(void)socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"Websocket error: %@", error);
}
-(void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    if([packet.name isEqualToString:@"message"]) {
        NSString *message = packet.args[0];
        [self receiveMessage:message];
    }            
}


#pragma mark - Keyboard methods

-(void)onKeyboardOpen:(NSNotification *)notification
{
    // This code will move the keyboard
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.tableView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - 40;
    self.tableView.frame = newFrame;
    
    [UIView commitAnimations];
}

-(void)onKeyboardClose:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    
    CGRect newFrame = self.tableView.frame;
    newFrame.origin.y = keyboardFrameEndRect.origin.y - newFrame.size.height - 40;
}



@end
