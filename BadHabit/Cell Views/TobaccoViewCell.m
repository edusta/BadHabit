//
//  TobaccoViewCell.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "TobaccoViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TobaccoViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.plusButton.layer.cornerRadius = self.plusButton.frame.size.width/2.0;
    self.plusButton.layer.masksToBounds = YES;
    
    self.minusButton.layer.cornerRadius = self.minusButton.frame.size.width/2.0;
    self.minusButton.layer.masksToBounds = YES;
    
    self.pic_name.layer.cornerRadius = self.pic_name.frame.size.width/2;
    self.pic_name.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)plus:(id)sender
{
    //[self.count setText:[NSString stringWithFormat:@"%d", [self.count.text intValue] + 1]];
    UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    act.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    act.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:act];
    [act startAnimating];
    [act performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.5];
    
    [[BHConnector sharedConnector] addEntity:[self.currentDict mutableCopy]];
}
- (IBAction)minus:(id)sender
{
    if ([self.count.text intValue] == 0)
    {
        return;
    }
    
    [self.count setText:[NSString stringWithFormat:@"%d", [self.count.text intValue] - 1]];
    UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    act.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    act.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:act];
    [act startAnimating];
    [act performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
}

@end
