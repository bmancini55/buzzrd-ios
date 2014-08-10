//
//  TableSectionHeader.m
//  Buzzrd
//
//  Created by Brian Mancini on 8/10/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "TableSectionHeader.h"
#import "ThemeManager.h"
#import "UIView+UIView_Borders.h"

@interface TableSectionHeader()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation TableSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[ThemeManager getPrimaryColorMedium]];
        [self addBottomBorder:[ThemeManager getSecondaryColorMedium] width:2.0];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, frame.size.width - 14, frame.size.height)];
        self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:9.0];
        self.titleLabel.textColor = [ThemeManager getPrimaryColorLight];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void) setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

@end
