//
//  RoomViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "RoomViewController.h"
#import "FrameUtils.h"
#import "SocketIOPacket.h"

@interface RoomViewController ()

    @property (strong, nonatomic) SocketIO *socket;
    @property (strong, nonatomic) NSMutableArray *messages;
    @property (strong, nonatomic) UIView *inputView;

@end

@implementation RoomViewController

- (void)loadView
{
    [super loadView];
            
    self.messages = [[NSMutableArray alloc] init];
    
    // connect to the room
    NSLog(@"Connecting to room %@", self.room.name);
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    [self.socket connectToHost:@"derpturkey.listmill.com" onPort:5050];
    
    
    // configure this biatch
    UIScrollView *scrollView = [[UIScrollView alloc]
                                initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                         self.view.frame.size.height-60)];
    [self.view addSubview:scrollView];
    
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-60,self.view.frame.size.width, 60)];
    self.inputView.backgroundColor = [[UIColor alloc]initWithRed:245 green:245 blue:245 alpha:255];
    [self.view addSubview:self.inputView];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(40, 10, _inputView.frame.size.width - 80, _inputView.frame.size.height - 20);
    textField.borderStyle = UITextBorderStyleLine;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.delegate = self;
    textField.backgroundColor = [UIColor whiteColor];
    [self.inputView addSubview:textField];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(onKeyboardOpen:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardClose:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}




-(void)onKeyboardOpen:(NSNotification *)notification
{
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
    
    CGRect newFrame = self.inputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.inputView.frame = newFrame;
    
    [UIView commitAnimations];
}

-(void)onKeyboardClose:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    
    CGRect newFrame = self.inputView.frame;
    newFrame.origin.y = keyboardFrameEndRect.origin.y - newFrame.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.textLabel.text = self.messages[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark - UITextViewDelete

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    
    return YES;
}



#pragma mark - SocketIODelegate

-(void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Websocket connected, joining room: %@", self.room.idroom);
    [_socket sendEvent:@"join" withData:self.room.idroom];
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
        NSLog(@"Recieved message");
        NSString *message = packet.args[0];
        [self.messages addObject:message];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];

        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }            
}



@end
