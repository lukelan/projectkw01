//
//  AppDelegate.h
//  TabDemo
//
//  Created by Hoang Ho on 11/18/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPSDKDelegate.h"

#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "ImobileSdkAds/ImobileSdkAds.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, LPSDKDelegate, UIGestureRecognizerDelegate,IMobileSdkAdsDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController        *nav;

@property(nonatomic, strong) id<GAITracker> tracker;

@property(nonatomic, assign) BOOL isActionFromFB;

-(UIStoryboard*)mainStoryboard;
@end
