//
//  CigaretteViewController.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "CigaretteViewController.h"
#import "TopBar.h"
#import "TobaccoViewCell.h"

@interface CigaretteViewController ()
{
    NSMutableArray *loadData;
}
@end

@implementation CigaretteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    loadData = [NSMutableArray new];
    TopBar* top = [[TopBar alloc] initTopBar:@"Tobacco"];
    top.frame = topCenter.frame;
    [self.view addSubview:top];
    
    [[BHConnector sharedConnector] setTobaccoDelegate:self];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //[table reloadData];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self manualTobaccoGenerator];    
}
- (void) manualTobaccoGenerator
{
    [loadData removeAllObjects];
    
    for(NSDictionary* dict in [[BHConnector sharedConnector] allTobaccos])
    {
        NSDictionary* newDict = @{@"pic_name":@"smoke.png",
                                  @"brand":[NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]],
                                  @"price":[NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"] floatValue]],
                                  @"count":[[dict valueForKey:@"currentCount"] stringValue]};
        
        [loadData addObject:newDict];
    }
    
    [table reloadData];
}
- (void) dbDidUpdated
{
    NSLog(@"Updated");
    
    [self manualTobaccoGenerator];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [loadData count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *stringName = @"TobaccoViewCell";
    
    TobaccoViewCell *cell = (TobaccoViewCell *)[tableView dequeueReusableCellWithIdentifier:stringName];
    
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
    [cell.brand setText:[dict objectForKey:@"brand"]];
    [cell.price setText:[dict objectForKey:@"price"]];
    [cell.count setText:[NSString stringWithFormat:@"%d", [[dict objectForKey:@"count"] intValue]]];
    
    
    
    NSDictionary* tmp = [[[BHConnector sharedConnector] allTobaccos] objectAtIndex:indexPath.row];
    
    NSMutableDictionary* dictNew = [NSMutableDictionary dictionaryWithDictionary:tmp];
    [dictNew setValue:@"Tobacco" forKey:@"tableID"];
    [dictNew removeObjectForKey:@"id"];
    [dictNew removeObjectForKey:@"currentCount"];
    
    cell.currentDict = dictNew;
    
    NSLog(@"%@", dictNew);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
