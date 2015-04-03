//
//  popCigaretteView.h
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopCigaretteView : UIView 
{
     NSMutableArray *loadData;
    IBOutlet UIScrollView *scrollView;
}

-(id) initPopCigarette;
@end
