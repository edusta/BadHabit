//
//  BHConnector.m
//  AzureTest
//
//  Created by Engin Usta on 28/03/15.
//  Copyright (c) 2015 Engin Usta. All rights reserved.
//

#import "BHConnector.h"

#define APP_URL @"https://badhabitmobile.azure-mobile.net/"
#define APP_KEY @"sUQxfWuYnsbOXdCjigyhaESwbbWQVJ95"

#define USER_ID @"userID"
#define TABLE_ID @"tableID"

#define NAME @"name"
#define PRICE @"price"

#define CC @"cc"

@implementation BHConnector

#pragma mark - Init

+ (BHConnector *) sharedConnector
{
    static BHConnector *instance = nil;
    static dispatch_once_t predicate;
    
    if(instance == nil)
    {
        dispatch_once(&predicate,
                      ^{
                          instance = [[BHConnector alloc] init];
                      });
    }
    
    return instance;
}
- (instancetype) init
{
    self = [super init];
    
    if(self)
    {
        self.client = [MSClient clientWithApplicationURLString:APP_URL
                                               applicationKey:APP_KEY];
        
        self.userID = @"";
        
        self.userProfile = nil;
        
        self.tobaccoValues = [NSMutableArray array];
        self.alcoholValues = [NSMutableArray array];
        
        self.allAlcohols = [NSMutableArray array];
        self.allTobaccos = [NSMutableArray array];
        
        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateFacebookProfile)
                                                     name:FBSDKProfileDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - Interface

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Facebook error: %@", error);
    }
    else
    {
        NSLog(@"Facebook login is successful.");
        
        self.userProfile = [FBSDKProfile currentProfile];
        
        NSDictionary* fbDict = @{@"access_token": result.token.tokenString};
        
        [self.client loginWithProvider:@"facebook"
                                 token:fbDict
                            completion:^(MSUser *user, NSError *error) {
            if(error)
            {
                NSLog(@"Azure error: %@", error);
            }
            else
            {
                [self saveAuthInfo];
                
                NSLog(@"Azure login is successful.");
            }
        }];
        
        [_connectorDelegate loginDidFinish];
    }
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"User has logout.");
}

- (void) loginWithFacebook:(UIViewController *)currentController
{
    self.connectedController = currentController;
    
    /*if(self.client.currentUser != nil)
    {
        return;
    } */
    
    if([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"User is already logged in.");
                
        [self loadAuthInfo];
        
        // User is logged in.
    }
    else
    {
        self.loginButton = [[FBSDKLoginButton alloc] init];
        
        self.loginButton.center = CGPointMake(CGRectGetMidX(currentController.view.frame),
                                         CGRectGetMidY(currentController.view.frame) + 20);
        
        self.loginButton.delegate = self;
        self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
        
        [currentController.view addSubview:self.loginButton];
    }

}

- (void) removeLoginButton
{
    [self.loginButton removeFromSuperview];
}

#pragma mark - Queries

- (void) addEntity:(NSMutableDictionary *)dict
{
    [dict setValue:self.userID forKey:USER_ID];
    
    NSString* tableName = [dict valueForKey:TABLE_ID];
    
    MSTable *itemTable = [self.client tableWithName:[dict valueForKey:TABLE_ID]];

    [dict removeObjectForKey:TABLE_ID];
    
    [itemTable insert:dict completion:^(NSDictionary *insertedItem, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
        else
        {
            NSLog(@"Item inserted, id: %@", insertedItem);
            
            if([tableName isEqualToString:@"Tobacco"])
            {
                [self getTobaccoStatistics];
            }
            else
            {
                [self getAlcoholStatistics];
            }
        }
    }];
}
- (void) deleteEntity:(NSMutableDictionary *)dict
{
    [dict setValue:self.userID forKey:USER_ID];
    
    MSTable *itemTable = [self.client tableWithName:[dict valueForKey:TABLE_ID]];
    
    [dict removeObjectForKey:TABLE_ID];
    
    [dict setValue:[self getLatestEntity:dict] forKey:@"id"];
    
    NSLog(@"%@", [dict valueForKey:@"id"]);
    
    [itemTable delete:dict completion:^(id itemId, NSError *error)
    {
        if(error)
        {
            NSLog(@"Error: %@", error);
        }
        else
        {
            NSLog(@"Item deleted, id: %@", itemId);
        }
    }];
}
- (NSString *) getLatestEntity:(NSMutableDictionary *) dict
{
    __block NSString* toReturn = nil;
    
    MSTable *table = [self.client tableWithName:[dict valueForKey:TABLE_ID]];
    
    [dict removeObjectForKey:TABLE_ID];

    MSQuery *tQuery = [table query];
    
    NSLog(@"%@", [dict valueForKey:NAME]);
    
    NSPredicate *tPredicate = [NSPredicate predicateWithFormat: @"(userID == %@) AND (name == %@)",
                               self.userID,
                               [dict valueForKey:NAME]];
    
    tQuery.predicate = tPredicate;
    [tQuery orderByAscending:@"__createdAt"];
    
    [tQuery readWithCompletion:^(MSQueryResult *result, NSError *error)
    {
        NSLog(@"Count is %ld", [[result items] count]);
        
        if(!error && [[result items] count] > 0)
        {
            NSDictionary* upmostItem = [[result items] objectAtIndex:0];
            
            toReturn = upmostItem[@"id"];
        }
    }];
    
    return toReturn;
}
#pragma mark - Authentication

- (void) saveAuthInfo
{
    [SSKeychain setPassword:self.client.currentUser.mobileServiceAuthenticationToken
                 forService:@"AzureMobileServiceTutorial"
                    account:self.client.currentUser.userId];
    
    [self updateUserID];
    //[self updateFacebookProfile];
    
    NSLog(@"Authentication is saved successfully.");
}

- (void) loadAuthInfo
{
    NSString *userid = [[SSKeychain accountsForService:@"AzureMobileServiceTutorial"][0] valueForKey:@"acct"];
    
    if (userid)
    {
        NSLog(@"Authentication is loaded successfully.");
        
        self.client.currentUser = [[MSUser alloc] initWithUserId:userid];
        self.client.currentUser.mobileServiceAuthenticationToken = [SSKeychain passwordForService:@"AzureMobileServiceTutorial" account:userid];
        
        [self updateUserID];
        //[self updateFacebookProfile];
    }
    
}
- (void) updateFacebookProfile
{
    self.userProfile = [FBSDKProfile currentProfile];
    
    self.userProfileView = [[FBSDKProfilePictureView alloc]initWithFrame:CGRectMake(120, 120, 120, 120)];
    
    self.userProfileView.layer.cornerRadius = CGRectGetWidth(self.userProfileView.frame)/2;
    self.userProfileView.layer.masksToBounds = YES;
    
    self.userProfileView.profileID = self.userProfile.userID;
        
    NSLog(@"Your name is: %@",self.userProfile.name);
}

- (void) updateUserID
{
    NSArray* components = [self.client.currentUser.userId componentsSeparatedByString:@":"];
    self.userID = [components objectAtIndex:1];
    
    NSLog(@"Your userID is: %@", self.userID);
    
    [self getUserCreatedDate];

    [_connectorDelegate connectorDidLogin];
}

#pragma mark - Getters

- (UIView *) getFacebookPicture
{
    NSData * d = [NSKeyedArchiver archivedDataWithRootObject:self.userProfileView];
    UIView * v = [NSKeyedUnarchiver unarchiveObjectWithData:d];
    v.layer.cornerRadius = v.frame.size.width/2.0;
    v.layer.masksToBounds = YES;
    return v;
    return self.userProfileView;
}

- (NSString *) getFacebookName
{
    return self.userProfile.firstName;
}

#pragma mark - Statistics

- (int) isContains:(NSMutableArray *) array theDict:(NSMutableDictionary *) dict
{
    int counter = 0;
    
    for(NSDictionary* curDict in array)
    {
        if ([[curDict valueForKey:NAME] isEqualToString:[dict valueForKey:NAME]])
        {
            return counter;
        }
        
        counter++;
    }
    
    return -1;
}
- (void) getTobaccoStatistics
{
    [self.tobaccoValues removeAllObjects];
    [self.allTobaccos removeAllObjects];
    
    MSTable *tobaccoTable = [self.client tableWithName:@"Tobacco"];
    
    MSQuery *tQuery = [tobaccoTable query];
    NSPredicate *tPredicate = [NSPredicate predicateWithFormat: @"(userID == %@)", self.userID];
    tQuery.predicate = tPredicate;
    
    [tQuery readWithCompletion:^(MSQueryResult *result, NSError *error)
     {
         if(!error) {
             
             float CIGAR_TAKE_LIFE_BY_MINUTE = 11;
             float CIGAR_TIME_TO_SMOKE_BY_MINUTE = 4.2;
             
             float totalPrice = 0;
             long int cigarCount = [result items].count;
             float timeSpentSmoking = cigarCount * CIGAR_TIME_TO_SMOKE_BY_MINUTE;
             float lifeSpentSmoking = cigarCount * CIGAR_TAKE_LIFE_BY_MINUTE;
             
             long int dailyCigar = 0;
             
             for (NSDictionary* item in [result items])
             {
                 NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:item];
                 [newDict setValue:[NSNumber numberWithLong:1] forKey:@"currentCount"];
                 
                 int index = [self isContains:self.allTobaccos theDict:newDict];
                 
                 if(index == -1)
                 {
                     [self.allTobaccos addObject:newDict];
                 }
                 else
                 {
                     NSMutableDictionary* curDict = [self.allTobaccos objectAtIndex:index];
                     [curDict setValue:[NSNumber numberWithLong:[[curDict valueForKey:@"currentCount"] longValue] + 1] forKey:@"currentCount"];
                 }
                 
                 NSNumber* cigarPrice = item[@"price"];
                 totalPrice += [cigarPrice floatValue];
                 
                 NSDate* today = [NSDate date];
                 NSTimeInterval distanceBetweenDates = [today timeIntervalSinceDate:self.userCreatedDate];
                 NSInteger daysBetweenDates = (distanceBetweenDates / (60 * 60 * 24)) + 1;
                 
                 if(daysBetweenDates -1 < 1)
                     dailyCigar++;
             }
             
             //NSLog(@"%@", self.allTobaccos);
             
             NSDate* today = [NSDate date];
             NSTimeInterval distanceBetweenDates = [today timeIntervalSinceDate:self.userCreatedDate];
             NSInteger daysBetweenDates = (distanceBetweenDates / (60 * 60 * 24)) + 1;
             
             float dailyAverageCigarAmount = cigarCount / daysBetweenDates;
             
             [self.tobaccoValues addObject:[NSString stringWithFormat:@"%ld", dailyCigar]];
             [self.tobaccoValues addObject:[NSString stringWithFormat:@"%ld", cigarCount]];
             [self.tobaccoValues addObject:[NSString stringWithFormat:@"$%.2f", totalPrice]];
             [self.tobaccoValues addObject:[NSString stringWithFormat:@"$%.2f", totalPrice / daysBetweenDates]];
             [self.tobaccoValues addObject:[NSString stringWithFormat:@"%.2f Min", timeSpentSmoking]];
             
             NSLog(@"Tobacco count is %lu", cigarCount);
             NSLog(@"Tobacco total price %f", totalPrice);
             NSLog(@"Time spent smoking %f minutes", timeSpentSmoking);
             NSLog(@"Total amount of life you lost %f minutes", lifeSpentSmoking);
             NSLog(@"Daily average cigar %f", dailyAverageCigarAmount);
             
             //            NSLog(@"Tobacco are %@", [result items]);
             
             [_tobaccoDelegate dbDidUpdated];
         }
     }];
}

- (void) getUserCreatedDate
{
    MSTable *alchoholTable = [self.client tableWithName:@"User"];
    
    MSQuery *aQuery = [alchoholTable query];
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat: @"(userID == %@)", self.userID];
    aQuery.predicate = aPredicate;
    
    [aQuery readWithCompletion:^(MSQueryResult *result, NSError *error)
     {
         if(!error)
         {
             if([[result items] count] == 0)
             {
                 self.userCreatedDate = [NSDate date];
                 
                 NSMutableDictionary* newDict = [NSMutableDictionary dictionary];
                 
                 [newDict setValue:@"User" forKey:@"tableID"];
                 
                 [self addEntity:newDict];
             }
             else
             {
                 for (NSDictionary* item in [result items])
                 {
                     id createdDate = item[@"createdAt"];
                     
                     if (createdDate != [NSNull null]) {
                         
                         self.userCreatedDate = createdDate;
                         
                         NSLog(@"USER CREATED AT %@", createdDate);
                     }
                 }
             }
             

             
             [self getAlcoholStatistics];
             [self getTobaccoStatistics];
             
             
         }
     }];
    
}

- (void) getAlcoholStatistics
{
    [self.alcoholValues removeAllObjects];
    [self.allAlcohols removeAllObjects];
    
    MSTable *alchoholTable = [self.client tableWithName:@"Alcohol"];
    
    MSQuery *aQuery = [alchoholTable query];
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat: @"(userID == %@)", self.userID];
    aQuery.predicate = aPredicate;
    
    
    [aQuery readWithCompletion:^(MSQueryResult *result, NSError *error)
     {
         if(!error)
         {
             float PURE_ALCOHOL_LIMIT = 14; // in grams
             float BEER_ALCOHOL_PERCENTAGE = 0.05;
             float MALTLIQUOR_ALCOHOL_PERCENTAGE = 0.07;
             float WINE_ALCOHOL_PERCENTAGE = 0.12;
             float PROOF80_ALCOHOL_PERCENTAGE = 0.40; //(e.g., gin, rum, vodka, whiskey)
             
             int beerCC = 0;
             int maltliquorCC = 0;
             int wineCC = 0;
             int proof80CC = 0;
             float totalPrice = 0;
             
             for (NSDictionary* item in [result items])
             {
                 NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:item];
                 [newDict setValue:[NSNumber numberWithLong:1] forKey:@"currentCount"];
                 
                 int index = [self isContains:self.allAlcohols theDict:newDict];
                 
                 if(index == -1)
                 {
                     [self.allAlcohols addObject:newDict];
                 }
                 else
                 {
                     NSMutableDictionary* curDict = [self.allAlcohols objectAtIndex:index];
                     [curDict setValue:[NSNumber numberWithLong:[[curDict valueForKey:@"currentCount"] longValue] + 1] forKey:@"currentCount"];
                 }
                 
                 NSString* name = item[@"name"];
                 NSInteger cc = [item[@"cc"] integerValue];
                 totalPrice += [item[@"price"] floatValue];

                 if ([name isEqualToString:@"Beer"])
                 {
                     beerCC += cc;
                 }
                 else if ([name isEqualToString:@"Malt Liquor"])
                 {
                     maltliquorCC += cc;
                 }
                 else if ([name isEqualToString:@"Wine"])
                 {
                     wineCC += cc;
                 }
                 else if ([name isEqualToString:@"Proof80"])
                 {
                     proof80CC += cc;
                 }
             }
             
             float totalBeerAlcoholAmount = beerCC * BEER_ALCOHOL_PERCENTAGE;
             float totalMaltLiquorAlcoholAmount = beerCC * MALTLIQUOR_ALCOHOL_PERCENTAGE;
             float totalWineAlcoholAmount = beerCC * WINE_ALCOHOL_PERCENTAGE;
             float totalProf80AlcoholAmount = beerCC * PROOF80_ALCOHOL_PERCENTAGE;
             float totalAlcohol = totalBeerAlcoholAmount + totalMaltLiquorAlcoholAmount + totalWineAlcoholAmount + totalProf80AlcoholAmount;
             
             NSDate* today = [NSDate date];
             NSTimeInterval distanceBetweenDates = [today timeIntervalSinceDate:self.userCreatedDate];
             NSInteger daysBetweenDates = (distanceBetweenDates / (60 * 60 * 24)) + 1;
             
             float dailyAverageAlcoholAmount = totalAlcohol / daysBetweenDates;
             
             [self.alcoholValues addObject:[NSString stringWithFormat:@"%ld", [[result items] count] / daysBetweenDates]];
             [self.alcoholValues addObject:[NSString stringWithFormat:@"%ld", [[result items] count]]];
             [self.alcoholValues addObject:[NSString stringWithFormat:@"$%.2f", totalPrice]];
             [self.alcoholValues addObject:[NSString stringWithFormat:@"$%.2f", totalPrice / daysBetweenDates]];
             [self.alcoholValues addObject:[NSString stringWithFormat:@"%.2f Min", [[result items] count] * 15.0]];
             
             NSLog(@"#1 %f", totalBeerAlcoholAmount);
             NSLog(@"#2 %f", totalMaltLiquorAlcoholAmount);
             NSLog(@"#3 %f", totalWineAlcoholAmount);
             NSLog(@"#4 %f", totalProf80AlcoholAmount);
             NSLog(@"#5 %f", dailyAverageAlcoholAmount);
             NSLog(@"#6 %f", totalAlcohol);
             
             [_alcoholDelegate dbDidUpdated];
         }
     }];
    
}
@end
