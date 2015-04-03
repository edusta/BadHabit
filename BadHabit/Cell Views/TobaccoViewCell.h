//
//  TobaccoViewCell.h
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHConnector.h"

@interface TobaccoViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *pic_name;
@property (strong, nonatomic) IBOutlet UILabel *brand;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *count;

@property (strong, nonatomic) IBOutlet UIView *plusButton;
@property (strong, nonatomic) IBOutlet UIView *minusButton;

@property NSDictionary* currentDict;

@end
