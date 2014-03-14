//
//  RoomViewController.m
//  FizBuz
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "RoomViewController.h"
#import "SocketIOPacket.h"

@interface RoomViewController ()

@end

@implementation RoomViewController {
    
    SocketIO *_socket;
    NSMutableArray *_messages;
    UIView *_inputView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = self.room.name;        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messages = [[NSMutableArray alloc] init];
    
    // connect to the room
    NSLog(@"Connecting to room %@", self.room.name);
    _socket = [[SocketIO alloc] initWithDelegate:self];
    [_socket connectToHost:@"derpturkey.listmill.com" onPort:8055];
    
    
    // configure this biatch
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc]
                                initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                         self.view.frame.size.height-60)];
    scrollView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:scrollView];
    
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-60,self.view.frame.size.width, 60)];
    _inputView.backgroundColor = [[UIColor alloc]initWithRed:245 green:245 blue:245 alpha:255];
    [self.view addSubview:_inputView];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(40, 10, _inputView.frame.size.width - 80, _inputView.frame.size.height - 20);
    textField.borderStyle = UITextBorderStyleLine;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.delegate = self;
    textField.backgroundColor = [UIColor whiteColor];
    [_inputView addSubview:textField];
    
    
    
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
    
    CGRect newFrame = _inputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    _inputView.frame = newFrame;
    
    [UIView commitAnimations];
}

-(void)onKeyboardClose:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    
    CGRect newFrame = _inputView.frame;
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Room"];
    cell.textLabel.text = @"";
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
    NSLog(@"Websocket connected");
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
    NSLog(@"Received event: %@", packet.data);
}



@end
