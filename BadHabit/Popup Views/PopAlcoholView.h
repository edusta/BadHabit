//
//  popAlcoholView.h
//  BadHabit
//
//  Created by Arinc Elhan on 28/03/15.
//  Copyright (c) 2015 Reengen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopAlcoholView : UIView 
{
    NSMutableArray *loadData;
    IBOutlet UIScrollView *scrollView;
}

-(id) initPopAlcohol;
@end
