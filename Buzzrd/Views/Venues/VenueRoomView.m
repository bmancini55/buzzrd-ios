//
//  VenueRoomView.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/3/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueRoomView.h"
#import "FrameUtils.h"

@interface VenueRoomView()

@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *userCountLabel;

@end

@implementation VenueRoomView

- (id)init
{
    CGSize screenSize = [FrameUtils getScreenSize];
    CGRect viewFrame = CGRectMake(48, 2, screenSize.width - 50, 40);
    self = [super init];
    if(self) {
        self.frame = viewFrame;
        self.backgroundColor = [[UIColor alloc]initWithRed:255.0f/255.0f green:218.0f/255.0f blue:109.0f/255.0f alpha:1.0f];

        CGRect nameLabelFrame = CGRectMake(8, 9, viewFrame.size.width - 60, 20);
        self.nameLabel = [[UILabel alloc]initWithFrame:nameLabelFrame];
        self.nameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        [self addSubview:self.nameLabel];
        
        CGRect userCountLabelFrame = CGRectMake(nameLabelFrame.origin.x + nameLabelFrame.size.width + 5, 10, 50, 18);
        self.userCountLabel = [[UILabel alloc]initWithFrame:userCountLabelFrame];
        self.userCountLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [self addSubview:self.userCountLabel];
    }
    return self;
}

- (void)setRoom:(Room *)room
{
    self.nameLabel.text = room.name;
    self.userCountLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)room.userCount, NSLocalizedString(@"users", nil)];
}

@end
