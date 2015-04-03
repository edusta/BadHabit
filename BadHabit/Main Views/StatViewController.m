//
//  StatViewController.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "StatViewController.h"
#import "TopBar.h"
#import "StatsViewCell.h"

@interface StatViewController ()
{
    NSMutableArray *loadData;
    BOOL isFirst;
}
@end

@implementation StatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TopBar* top = [[TopBar alloc] initTopBar:@"Statistics"];
    loadData = [NSMutableArray new];
    [self autoTobaccoGenerator];
    isFirst = YES;
    top.frame = topCenter.frame;
    [self.view addSubview:top];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    cibik.frame = CGRectMake(0, cigaretteButton.frame.size.height, self.view.frame.size.width, 1);
    [cigaretteButton addSubview:cibik];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isFirst)
    {
        return;
    }
    [self manualTobaccoGenerator];
    isFirst = false;
    //[self manualAlcoholGenerator];
}

- (void) refreshGenerators:(NSInteger) choice
{
    if(choice == 0)
    {
        if([[[BHConnector sharedConnector] tobaccoValues] count] > 0)
        {
            [self manualTobaccoGenerator];
        }
        else
        {
            [self autoTobaccoGenerator];
        }
    }
    else
    {
        if([[[BHConnector sharedConnector] alcoholValues] count] > 0)
        {
            [self manualAlcoholGenerator];
        }
        else
        {
            [self autoAlcoholGenerator];
        }
    }

}

- (void) manualTobaccoGenerator
{
    [loadData removeAllObjects];
    
    NSArray * brands = @[@"Daily Cigarette", @"Total Cigarettes",@"Total Money Spent", @"Daily Money Spent", @"Time Spent Smoking"];
    NSArray * types  = @[@"20", @"200",@"$1200", @"$10", @"100Min"];
    NSArray * symbols = @[@"cigarette.png", @"packofCigar.jpg", @"money.png", @"money2.png", @"time2.png"];
    
    NSMutableArray* tobaccoArray = [[BHConnector sharedConnector] tobaccoValues];
    
    if([tobaccoArray count] == 0)
    {
        [self performSelector:@selector(manualTobaccoGenerator) withObject:nil afterDelay:1];
        return;
    }
    
    NSLog(@"%@", tobaccoArray);

    for (int i = 0; i<5; i++)
    {
        NSDictionary *dict = @{@"pic_name":[symbols objectAtIndex:i],
                               @"info":[brands objectAtIndex:i],
                               @"stat":[tobaccoArray objectAtIndex:i]};
        [loadData addObject:dict];
    }
    
    [table reloadData];
}
- (void) autoTobaccoGenerator
{
    [loadData removeAllObjects];
    
    NSArray * brands = @[@"Daily Cigarette", @"Total Cigarettes",@"Total Money Spent", @"Daily Money Spent", @"Time Spent Smoking"];
    NSArray * types  = @[@"20", @"200",@"$1200", @"$10", @"100Min"];
    NSArray * symbols = @[@"cigarette.png", @"packofCigar.jpg", @"money.png", @"money2.png", @"time2.png"];
    
    NSMutableArray* tobaccoArray = [[BHConnector sharedConnector] tobaccoValues];
    
    for (int i = 0; i<5; i++)
    {
        NSDictionary *dict = @{@"pic_name":[symbols objectAtIndex:i],
                               @"info":[brands objectAtIndex:i],
                               @"stat":[types objectAtIndex:i]};
        [loadData addObject:dict];
    }
    
    //[table reloadData];
}

- (void) manualAlcoholGenerator
{
    [loadData removeAllObjects];
    
    NSArray * brands = @[@"Daily Alcohol", @"Total Alcohol",@"Total Money Spent", @"Daily Money Spent", @"Time Spent Drinking"];
    NSArray * types  = @[@"3lt", @"50lt",@"$1200", @"$10", @"100Min"];
    NSArray * symbols = @[@"beer.png", @"wine.png", @"money.png", @"money2.png", @"time2.png"];
    
    NSMutableArray* alcoholArray = [[BHConnector sharedConnector] alcoholValues];
    
    if([alcoholArray count] == 0)
    {
        [self performSelector:@selector(manualAlcoholGenerator) withObject:nil afterDelay:1];
        return;
    }
    
    for (int i = 0; i<5; i++)
    {
        NSDictionary *dict = @{@"pic_name":[symbols objectAtIndex:i],
                               @"info":[brands objectAtIndex:i],
                               @"stat":[alcoholArray objectAtIndex:i]};
        [loadData addObject:dict];
    }
    
    [table reloadData];
}

- (void) autoAlcoholGenerator
{
    [loadData removeAllObjects];
    
    NSArray * brands = @[@"Daily Alcohol", @"Total Alcohol",@"Total Money Spent", @"Daily Money Spent", @"Time Spent Drinking"];
    NSArray * types  = @[@"3lt", @"50lt",@"$1200", @"$10", @"100Min"];
    NSArray * symbols = @[@"beer.png", @"wine.png", @"money.png", @"money2.png", @"time2.png"];
    
    for (int i = 0; i<5; i++)
    {
        NSDictionary *dict = @{@"pic_name":[symbols objectAtIndex:i],
                               @"info":[brands objectAtIndex:i],
                               @"stat":[types objectAtIndex:i]};
        [loadData addObject:dict];
    }
    
    [table reloadData];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [loadData count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *stringName = @"StatsViewCell";
    
    StatsViewCell *cell = (StatsViewCell *)[tableView dequeueReusableCellWithIdentifier:stringName];
    
    if (cell == nil)
    {
        // Eğer ayrı bir xib file varsa tableCell için bu yapıyı kullan
        //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TobaccoViewCell" owner:self options:nil];
        //cell = [nib objectAtIndex:0];
        // Yoksa bunu kullanabilirsin
        //cell = [[TobaccoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringName];
        
        [tableView registerNib:[UINib nibWithNibName:stringName bundle:nil] forCellReuseIdentifier:stringName];
        cell = [tableView dequeueReusableCellWithIdentifier:stringName];
    }
    
    NSDictionary* dict = [loadData objectAtIndex:indexPath.row];
    
    [cell.pic_name setImage:[UIImage imageNamed:[dict objectForKey:@"pic_name"]]];
    [cell.infoText setText:[dict objectForKey:@"info"]];
    [cell.statText setText:[dict objectForKey:@"stat"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (IBAction)cigaretteClick:(id)sender
{
    [cigaretteButton setTitleColor:[UIColor colorWithRed:123/255.0 green:49/255.0 blue:9/255.0 alpha:1] forState:UIControlStateNormal];
    [alcoholButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self refreshGenerators:0];
    
    [table reloadData];
}

- (IBAction)alcoholClick:(id)sender
{
    [alcoholButton setTitleColor:[UIColor colorWithRed:123/255.0 green:49/255.0 blue:9/255.0 alpha:1] forState:UIControlStateNormal];
    [cigaretteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self refreshGenerators:1];
    
    [table reloadData];
}




@end
