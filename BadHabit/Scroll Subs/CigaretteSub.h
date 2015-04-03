//
//  CigaretteSub.h
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHConnector.h"

@interface CigaretteSub : UIView
{    
    IBOutlet UIImageView *pic_name;
    IBOutlet UILabel *brand;
    IBOutlet UILabel *price;
    IBOutlet UIButton *addButton;
}

- (id) initSub: (NSDictionary*) dict;
@end
