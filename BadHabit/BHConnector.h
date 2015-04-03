//
//  BHConnector.h
//  AzureTest
//
//  Created by Engin Usta on 28/03/15.
//  Copyright (c) 2015 Engin Usta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "SSKeychain.h"

@protocol BHConnectorDelegate <NSObject>

@required

- (void) connectorDidLogin;
- (void) loginDidFinish;

@end

@protocol BHTobaccoUpdateDelegate <NSObject>

@required

- (void) dbDidUpdated;

@end

@protocol BHAlcoholUpdateDelegate <NSObject>

@required

- (void) dbDidUpdated;

@end

@interface BHConnector : NSObject <FBSDKLoginButtonDelegate>

@property MSClient* client;
@property NSString* userID;
@property NSDate* userCreatedDate;

@property FBSDKProfile* userProfile;
@property FBSDKProfilePictureView* userProfileView;
@property FBSDKLoginButton* loginButton;

@property UIViewController* connectedController;

@property id<BHConnectorDelegate> connectorDelegate;
@property id<BHTobaccoUpdateDelegate> tobaccoDelegate;
@property id<BHAlcoholUpdateDelegate> alcoholDelegate;

@property NSMutableArray* tobaccoValues;
@property NSMutableArray* alcoholValues;

@property NSMutableArray* allTobaccos;
@property NSMutableArray* allAlcohols;

+ (BHConnector *) sharedConnector;

- (void) loginWithFacebook:(UIViewController *) currentController;
- (void) removeLoginButton;

- (void) addEntity:(NSMutableDictionary *) dict;
- (void) deleteEntity:(NSMutableDictionary *)dict;

- (UIView *) getFacebookPicture;
- (NSString *) getFacebookName;

- (void) getTobaccoStatistics;
- (void) getAlcoholStatistics;
- (void) getUserCreatedDate;

@end

