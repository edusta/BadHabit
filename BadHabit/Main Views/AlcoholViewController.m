//
//  AlcoholViewController.m
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import "AlcoholViewController.h"
#import "TopBar.h"
#import "AlcoholViewCell.h"

@interface AlcoholViewController ()
{
    NSMutableArray *loadData;
}
@end

@implementation AlcoholViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    loadData = [NSMutableArray new];
    TopBar* top = [[TopBar alloc] initTopBar:@"Alcohol"];
    top.frame = topCenter.frame;
    [self.view addSubview:top];
    
    [[BHConnector sharedConnector] setAlcoholDelegate:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self manualAlcoholGenerator];
}
- (void) dbDidUpdated
{
    [self manualAlcoholGenerator];
}
- (void) manualAlcoholGenerator
{
    [loadData removeAllObjects];
    
    for(NSDictionary* dict in [[BHConnector sharedConnector] allAlcohols])
    {
        NSDictionary* newDict = @{@"pic_name":@"wine.png",
                                  @"brand":[NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]],
                                  @"price":[NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"] floatValue]],
                                  @"count":[[dict valueForKey:@"currentCount"] stringValue]};
        
        [loadData addObject:newDict];
    }
    
    [table reloadData];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [loadData count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *stringName = @"AlcoholViewCell";
    
    AlcoholViewCell *cell = (AlcoholViewCell *)[tableView dequeueReusableCellWithIdentifier:stringName];
    
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
    
    NSDictionary* tmp = [[[BHConnector sharedConnector] allAlcohols] objectAtIndex:indexPath.row];
    
    NSMutableDictionary* dictNew = [NSMutableDictionary dictionaryWithDictionary:tmp];
    [dictNew setValue:@"Alcohol" forKey:@"tableID"];
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
