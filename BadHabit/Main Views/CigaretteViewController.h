//
//  CigaretteViewController.h
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHConnector.h"

@interface CigaretteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, BHTobaccoUpdateDelegate>
{
    IBOutlet UIImageView *topCenter;
    IBOutlet UITableView *table;
}


@end
