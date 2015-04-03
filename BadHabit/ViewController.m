//
//  ViewController.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loginImage;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:@"initial"];
    
    if (data == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"cigarette" forKey:@"initial"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[BHConnector sharedConnector] setConnectorDelegate:self];
    
    [[BHConnector sharedConnector] loginWithFacebook:self];
    
    NSMutableString* str;
    
    if([[BHConnector sharedConnector] getFacebookName])
    {
        str = [NSMutableString stringWithString:@"Welcome back, "];
        
        [str appendString:[[BHConnector sharedConnector] getFacebookName]];
        [str appendString:@" !"];
        
        [self addIndicator];
    }
    else
    {
        str = [NSMutableString stringWithString:@"Please Login First..."];
    }
    
    _loginLabel.text = str;
    
    UIView* img = [[BHConnector sharedConnector] getFacebookPicture];
    
    img.frame = _loginImage.frame;
    
    [self.view addSubview:img];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) gotoNav
{
    [self performSegueWithIdentifier:@"gotoNav" sender:self];
}

- (void) addIndicator
{
    UIActivityIndicatorView* newIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    newIndicator.center = CGPointMake(_loginLabel.center.x, _loginLabel.center.y + 60);
    
    [self.view addSubview:newIndicator];
    
    [newIndicator startAnimating];
}
#pragma mark - Connector Delegate

- (void) connectorDidLogin
{
    NSLog(@"didConnect");
    [self performSelector:@selector(gotoNav) withObject:nil afterDelay:5];
}
- (void) loginDidFinish
{
    NSLog(@"didLogin");
    _loginLabel.text = @"Redirecting...";
    
    [[BHConnector sharedConnector] removeLoginButton];
    
    [self addIndicator];
}
@end
