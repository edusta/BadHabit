//
//  CigaretteSub.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "CigaretteSub.h"

@implementation CigaretteSub

- (id) initSub: (NSDictionary*) dict
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CigaretteSub" owner:nil options:nil] objectAtIndex:0];
    
    [pic_name setImage:[UIImage imageNamed:[dict objectForKey:@"pic_name"]]];
    [brand setText:[dict objectForKey:@"brand"]];
    [price setText:[dict objectForKey:@"price"]];
    
    pic_name.layer.cornerRadius = pic_name.frame.size.width/2.0;
    pic_name.layer.masksToBounds = YES;
    
    addButton.layer.cornerRadius = addButton.frame.size.width/2;
    addButton.layer.masksToBounds = YES;
    return self;
}

- (IBAction)add:(id)sender
{
    //Server Message needs to be send.
    UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    act.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    act.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:act];
    [act startAnimating];
    [act performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];

    NSMutableDictionary* dictToMake = [NSMutableDictionary dictionary];
    
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.currencyCode = @"USD";
    float realPrice = [[formatter numberFromString:price.text] floatValue];
    
    [dictToMake setValue:brand.text forKey:@"name"];
    [dictToMake setValue:[NSString stringWithFormat:@"%f",realPrice/20] forKey:@"price"];
    [dictToMake setValue:@"Tobacco" forKey:@"tableID"];
    
    NSLog(@"%@", dictToMake);
    [[BHConnector sharedConnector] addEntity:dictToMake];
}

@end
