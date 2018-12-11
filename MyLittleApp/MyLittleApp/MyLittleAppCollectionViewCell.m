//
//  MyLittleAppCollectionViewCell.m
//  MyLittleApp
//
//  Created by Jasmin Simon on 25.11.18.
//  Copyright © 2018 Jasmin Simon. All rights reserved.
//

#import "MyLittleAppCollectionViewCell.h"

@implementation MyLittleAppCollectionViewCell

#pragma mark -
#pragma mark Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // add label to cell
        CGRect frame = self.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        self.customLabel = [[UILabel alloc]initWithFrame:frame];
        self.customLabel.textAlignment = NSTextAlignmentCenter;
        self.customLabel.textColor = [UIColor whiteColor];
        self.customLabel.font = [UIFont systemFontOfSize:20];
        
        [self addSubview:self.customLabel];
    }
    return self;
}

@end
