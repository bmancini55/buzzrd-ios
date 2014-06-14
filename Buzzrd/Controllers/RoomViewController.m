//
//  RoomViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "RoomViewController.h"
#import "RoomMainView.h"
#import "SocketIOPacket.h"
#import "BuzzrdAPI.h"
#import "Message.h"

@interface RoomViewController ()

    @property (strong, nonatomic) SocketIO *socket;
    @property (strong, nonatomic) NSArray *messages;

@end

@implementation RoomViewController

- (void)loadView
{
    [super loadView];

    self.title = self.room.name;
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.messages = [[NSArray alloc] init];

    // create the main view
    CGRect frame = self.view.frame;
    self.view = [[RoomMainView alloc]initWithFrame:frame
                               keyboardBarDelegate:self
                                 tableViewDelegate:self
                               tableViewDataSource:self];
    
    // load recent messages
    [self loadMessagesWithPage:1];
    
    // connect to socket service
    [self connectToSocketServer];
}

#pragma mark - Internal helper methods

- (void)loadMessagesWithPage:(uint)page
{
    // success handler
    void (^success)(NSArray *messages) = ^(NSArray *messages) {
        
        NSMutableArray *mergeArray = [[NSMutableArray alloc]initWithArray:messages];
        [mergeArray addObjectsFromArray:self.messages];
        self.messages = mergeArray;
        
        UITableView *tableView = ((RoomMainView *)self.view).tableView;
        [tableView reloadData];
      
        // scroll to bottom if this was first page
        if (page == 1)
        {
            [(RoomMainView *)self.view scrollToBottom:false];
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
    KeyboardBarView *keyboardBarView = ((RoomMainView *)self.view).keyboardBarView;
    [keyboardBarView.textView endEditing:true];

    [tableView deselectRowAtIndexPath:indexPath animated:false];
}



#pragma mark - KeyboardBarDelegate

- (void)keyboardBar:(KeyboardBarView *)keyboardBarView buttonTouched:(NSString *)text
{
    [self sendMessage:text];
}


#pragma mark - Socket Interactions

- (void)connectToSocketServer
{
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    [self.socket connectToHost:@"devapi.buzzrd.io" onPort:5050];
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
    UITableView *tableView = ((RoomMainView *)self.view).tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
    
    [(RoomMainView *)self.view scrollToBottom:true];
}


#pragma mark - SocketIODelegate

-(void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Websocket connected");
    NSLog(@"Joining room: %@", self.room.id);
    [self.socket sendEvent:@"join" withData:self.room.id];
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



@end
