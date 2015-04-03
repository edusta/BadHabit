//
//  popAlcoholView.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "popAlcoholView.h"
#import "AlcoholSub.h"

@implementation PopAlcoholView

-(id) initPopAlcohol
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"PopAlcoholView" owner:nil options:nil] objectAtIndex:0];
    loadData = [NSMutableArray new];
    [self performSelector:@selector(addMe) withObject:nil afterDelay:0.1];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    return self;
}

-(void)addMe
{
    int h = 0;
    float height = 0;
    
    [self autoAlcoholGenerator];
    
    for (NSDictionary* dict in loadData)
    {
        AlcoholSub* cg = [[AlcoholSub alloc] initSub:dict];
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



- (void) autoAlcoholGenerator
{
    NSArray * brands = @[@"Whiskey", @"Beer",@"Vodka", @"Raki", @"Wine"];
    
    NSArray * prices = @[@"$60", @"$5", @"$35", @"$40", @"$20"];
    
    
    
    for (int i = 0; i<[brands count]; i++)
    {
        NSDictionary *dict = @{@"pic_name":@"wine.png",
                               @"brand":[brands objectAtIndex:i],
                               @"price":[prices objectAtIndex:i],
                               @"count":[NSNumber numberWithInt:arc4random() %20]};
        [loadData addObject:dict];
    }
}

- (IBAction)close:(id)sender
{
    [UIView animateWithDuration:0.4 animations:^{self.alpha = 0;}
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
