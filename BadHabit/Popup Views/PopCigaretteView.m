//
//  popCigaretteView.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "PopCigaretteView.h"
#import "TobaccoViewCell.h"
#import "CigaretteSub.h"

@implementation PopCigaretteView

-(id) initPopCigarette
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PopCigaretteView" owner:nil options:nil] objectAtIndex:0];
    loadData = [NSMutableArray new];
    [self performSelector:@selector(addMe) withObject:nil afterDelay:0.1];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    return self;
}

-(void)addMe
{
    int h = 0;
    float height = 0;
    
    [self autoTobaccoGenerator];
    
    for (NSDictionary* dict in loadData)
    {
        CigaretteSub* cg = [[CigaretteSub alloc] initSub:dict];
        cg.frame = CGRectMake(0, h*cg.frame.size.height, self.frame.size.width, cg.frame.size.height);
        h++;
        height = cg.frame.size.height;
        [scrollView addSubview:cg];
        
    }
    scrollView.contentSize = CGSizeMake(self.frame.size.width, h*height);
    
    self.frame = [UIApplication sharedApplication].keyWindow.frame;

    self.alpha = 0;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.4 animations:^{self.alpha = 1;}];
}

- (IBAction)close:(id)sender
{
    [UIView animateWithDuration:0.4 animations:^{self.alpha = 0;}
                     completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) autoTobaccoGenerator
{
    NSArray * brands = @[@"Marlboro", @"Marlboro Light", @"Marlboro Red One", @"Marlboro Touch", @"Parliament", @"Camel Soft" ,@"Camel Box", @"Muratti Rosso", @"Lark", @"Viceroy"];
    NSArray * prices = @[@"$10", @"$10", @"$10", @"$10", @"$10", @"$7", @"$7", @"$8", @"$6", @"$6", @"$8"];
    
    for (int i = 0; i<[brands count]; i++)
    {
        NSDictionary *dict = @{@"pic_name":@"smoke.png",
                               @"brand":[brands objectAtIndex:i],
                               @"price":[prices objectAtIndex:i],
                               @"count":[NSNumber numberWithInt:arc4random() %20]};
        [loadData addObject:dict];
    }
}

@end
