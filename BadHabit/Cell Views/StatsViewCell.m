//
//  StatsViewCell.m
//  BadHabit
//
//  Created by Arinc Elhan on 29/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "StatsViewCell.h"

@implementation StatsViewCell

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.pic_name.layer.cornerRadius = self.pic_name.frame.size.width/2;
    self.pic_name.layer.masksToBounds = YES;
    
}

@end
