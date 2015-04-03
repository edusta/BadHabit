//
//  TopBar.h
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "BHConnector.h"

@interface TopBar : UIView
{
    IBOutlet UILabel *pageLabel;
    IBOutlet UIButton *addButton;
    IBOutlet UIImageView *profilePic;
}

-(id) initTopBar: (NSString*) name;

@end
