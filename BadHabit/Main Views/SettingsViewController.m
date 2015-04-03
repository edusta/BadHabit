//
//  SettingsViewController.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "SettingsViewController.h"
#import "TopBar.h"

@interface SettingsViewController ()
{
    IBOutlet UISwitch *switch1;
    IBOutlet UISwitch *switch2;
    IBOutlet UISwitch *switch3;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    TopBar* top = [[TopBar alloc] initTopBar:@"Settings"];
    top.frame = topCenter.frame;
    [self.view addSubview:top];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self adjustSwitches];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) adjustSwitches
{
    NSString* string = [[NSUserDefaults standardUserDefaults] objectForKey:@"initial"];
    if ([string isEqual:@"cigarette"])
    {
        [switch2 setOn:YES animated:YES];
        [switch1 setOn:NO animated:YES];
        [switch3 setOn:NO animated:YES];
    }
    if ([string isEqual:@"stats"])
    {
        [switch2 setOn:NO animated:YES];
        [switch1 setOn:YES animated:YES];
        [switch3 setOn:NO animated:YES];
    }
    if ([string isEqual:@"alcho"])
    {
        [switch2 setOn:NO animated:YES];
        [switch1 setOn:NO animated:YES];
        [switch3 setOn:YES animated:YES];
    }
}

- (IBAction)switchChange:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([sender tag] == 0)
    {
        [defaults setObject:@"stats" forKey:@"initial"];
    }
    if ([sender tag] == 1)
    {
        [defaults setObject:@"cigarette" forKey:@"initial"];
    }
    if ([sender tag] == 2)
    {
        [defaults setObject:@"alcho" forKey:@"initial"];
    }
    [defaults synchronize];
    [self adjustSwitches];
}

@end
