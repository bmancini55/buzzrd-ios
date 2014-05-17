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

    @property (strong, nonatomic) UITextView *textView;

@end

@implementation RoomViewController

const int MARGIN_SIZE = 5;
const int BUTTON_WIDTH = 52;

- (void)loadView
{
    [super loadView];
            
    self.messages = [[NSMutableArray alloc] init];
    
    // connect to the room
    NSLog(@"Connecting to room %@", self.room.name);
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    [self.socket connectToHost:@"derpturkey.listmill.com" onPort:5050];
    
    
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-40,self.view.frame.size.width, 40)];
    self.inputView.backgroundColor = [[UIColor alloc]initWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    [self.view addSubview:self.inputView];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = CGRectMake(40, MARGIN_SIZE, self.inputView.frame.size.width - 100, self.inputView.frame.size.height - (2 * MARGIN_SIZE));
    textView.editable = true;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.masksToBounds = true;
    textView.layer.cornerRadius = 5.0f;
    [self.inputView addSubview:textView];
    self.textView = textView;
    
    
    UIButton *sendButton = [[UIButton alloc]init];
    sendButton.frame = CGRectMake(self.inputView.frame.size.width - BUTTON_WIDTH - MARGIN_SIZE, MARGIN_SIZE, BUTTON_WIDTH, self.inputView.frame.size.height - (2 * MARGIN_SIZE));
    sendButton.backgroundColor = [UIColor orangeColor];
    sendButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    sendButton.layer.masksToBounds = true;
    sendButton.layer.cornerRadius = 5.0f;
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.inputView addSubview:sendButton];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(onKeyboardOpen:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardClose:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


-(void)sendTouch
{
    // get message from text view
    NSString *message = self.textView.text;
    
    // send message
    [self.socket sendEvent:@"message" withData:message];
    
    // clear textview
    self.textView.text = @"";
}


#pragma mark - Keyboard methods

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




#pragma mark - UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    return true;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.frame.size.height != textView.contentSize.height)
    {
        float delta = textView.contentSize.height - textView.frame.size.height;
        
        // change textview size
        CGRect textViewFrame = textView.frame;
        textViewFrame.size.height = textView.contentSize.height;
        textView.frame = textViewFrame;
        
        // change view size
        CGRect inputFrame = self.inputView.frame;
        inputFrame.size.height = inputFrame.size.height + delta;
        inputFrame.origin.y = inputFrame.origin.y - delta;
        self.inputView.frame = inputFrame;
        
        // change button position
        // TODO
    }
}


#pragma mark - SocketIODelegate

-(void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Websocket connected, joining room: %@", self.room.idroom);
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
