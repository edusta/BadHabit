//
//  TopBar.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "TopBar.h"
#import "PopCigaretteView.h"
#import "PopAlcoholView.h"

@implementation TopBar

-(id) initTopBar: (NSString*) name
{
    NSLog(@"TOP BAR CREATED %@", name);
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"TopBar" owner:nil options:nil] objectAtIndex:0];
    [self setBackgroundColor:[UIColor colorWithRed:123/255.0 green:44/255.0 blue:4/255.0 alpha:0.9]];
    
    [pageLabel setText:name];
    [pageLabel setTextColor:[UIColor colorWithRed:234/255.0 green:174/255.0 blue:71/255.0 alpha:1]];
    
    addButton.layer.cornerRadius = addButton.frame.size.width/2.0;
    addButton.layer.masksToBounds = YES;
    
    if ([name isEqualToString:@"Statistics"] || [name isEqualToString:@"Junk Food"] || [name isEqualToString:@"Settings"])
        addButton.hidden = YES;
    if ([name isEqualToString:@"Tobacco"])
        addButton.tag = 2;
    if ([name isEqualToString:@"Alcohol"])
        addButton.tag = 3;
    
    
    UIView* img = [[BHConnector sharedConnector] getFacebookPicture];
    
    img.layer.borderWidth = 2;
    img.layer.borderColor = [UIColor blackColor].CGColor;
    
    img.center = profilePic.center;
    img.transform = CGAffineTransformMakeScale(0.35, 0.35);
    img.layer.zPosition = MAXFLOAT;
    [self addSubview:img];
    
    return self;
}

- (IBAction)showPopup:(id)sender
{
    if ([sender tag] == 2)
    {
        PopCigaretteView * p __unused = [[PopCigaretteView alloc] initPopCigarette];
    }
    if ([sender tag] == 3)
    {
        PopAlcoholView * p __unused = [[PopAlcoholView alloc] initPopAlcohol];
    }
}



@end
