//
//  TabBarController.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController () <UITabBarDelegate>
@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.tabBar.items objectAtIndex:0] setTitle:@""];
    [[self.tabBar.items objectAtIndex:1] setTitle:@""];
    [[self.tabBar.items objectAtIndex:2] setTitle:@""];
    [[self.tabBar.items objectAtIndex:3] setTitle:@""];
    
    [self.tabBar setTintColor:[UIColor colorWithRed:159/255.0 green:75/255.0 blue:45/255.0 alpha:1]];
    [self.tabBar setBackgroundColor:[UIColor colorWithRed:123/255.0 green:44/255.0 blue:4/255.0 alpha:1]];
    [self checkImages];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* string = [[NSUserDefaults standardUserDefaults] objectForKey:@"initial"];
    if ([string isEqualToString:@"cigarette"])
    {
        self.selectedIndex = 1;
    }
    if ([string isEqualToString:@"stats"])
    {
        self.selectedIndex = 0;
    }
    if ([string isEqualToString:@"alcho"])
    {
        self.selectedIndex = 2;
    }
}

- (void) changeImage: (NSString*) imageName forIndex:(NSUInteger) index
{
    UIViewController* tab1 = [self.viewControllers objectAtIndex:index];
    if ([tab1 isEqual:self.selectedViewController])
    {
        tab1.tabBarItem.image =[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    }
    else
    {
        tab1.tabBarItem.image =[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [self checkImages];
}

-(void)checkImages
{
    for (UITabBarItem* t in self.tabBar.items)
    {
        t.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    
    [self changeImage:@"stat.png" forIndex:0];
    [self changeImage:@"smoke.png" forIndex:1];
    [self changeImage:@"wine.png" forIndex:2];
    [self changeImage:@"settings.png" forIndex:3];
}

@end
