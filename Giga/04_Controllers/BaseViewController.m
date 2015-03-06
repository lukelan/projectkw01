    //
//  BaseViewController.m
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "ImobileSdkAds/ImobileSdkAds.h"

#define AMOB_AD_ID @"62056d310111552cf552a82cc9de130c4771817ce97c1b609e5d99de654b20d2"

#define NEND_AD_ID @"f6b403ec7027f37b9ef52c7ab0072396a1f591d7"
#define NEND_AD_SPOT_ID @"252394"

#define kAdmodID                                            @"ca-app-pub-4342463355994667/1216636234"

//iMobile
#define IMOBILE_SDK_ADS_PUBLISHER_ID_1 @"34560"
#define IMOBILE_SDK_ADS_MEDIA_ID_1 @"132964"
#define IMOBILE_SDK_ADS_SPOT_ID_1 @"339576"

#define IMOBILE_SDK_ADS_PUBLISHER_ID_2	@"34560"//@"34816"
#define IMOBILE_SDK_ADS_MEDIA_ID_2	@"132964"//@"135002"
#define IMOBILE_SDK_ADS_SPOT_ID_2	@"370117"//@"342411"

#define SharedAppDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

//#define IMOBILE_AD_PUB_ID @"31709"
//#define IMOBILE_AD_MEDIA_ID @"124256"
//#define IMOBILE_AD_SPOT_ID @"304451"

@interface BaseViewController()<IMobileSdkAdsDelegate>

@end

@implementation BaseViewController


- (instancetype)init
{
    @try {
        self = [[SharedAppDelegate mainStoryboard] instantiateViewControllerWithIdentifier:[self.class description]];
    }
    @catch (NSException *exception) {
        if (!self) {
            self = [super init];
        }
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //default is enable
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = SharedAppDelegate;

    //[ImobileSdkAds setSpotDelegate:IMOBILE_SDK_ADS_SPOT_ID_1 delegate:self];
    [ImobileSdkAds setSpotDelegate:IMOBILE_SDK_ADS_SPOT_ID_2 delegate:self];
}

- (void)enablePopGesture:(BOOL)enable
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (enable) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = SharedAppDelegate;
        }else{
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (void)dealloc
{
    DLog(@"DEALOC CALLED");
}

#pragma mark - IMobile Adds

- (void)addIMobileAddInController:(UIViewController*)vc
{
    //[ImobileSdkAds registerWithPublisherID:IMOBILE_AD_PUB_ID MediaID:IMOBILE_AD_MEDIA_ID SpotID:IMOBILE_AD_SPOT_ID]; //広告の取得に必要な情報を設定します
    //[ImobileSdkAds startBySpotID:IMOBILE_AD_SPOT_ID]; //広告の取得を開始します
    [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_1 ViewController:vc Position:CGPointMake(0, self.view.frame.size.height - 50)]; //広告を表示します
    //[ImobileSdkAds setSpotDelegate:IMOBILE_AD_SPOT_ID delegate:self];
}
- (void)addIMobileAddInControllerComment:(UIViewController*)vc
{
    //[ImobileSdkAds registerWithPublisherID:IMOBILE_AD_PUB_ID MediaID:IMOBILE_AD_MEDIA_ID SpotID:IMOBILE_AD_SPOT_ID]; //広告の取得に必要な情報を設定します
    //[ImobileSdkAds startBySpotID:IMOBILE_AD_SPOT_ID]; //広告の取得を開始します
    [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_1 ViewController:vc Position:CGPointMake(0, self.view.frame.size.height - 50-45)]; //広告を表示します
    //[ImobileSdkAds setSpotDelegate:IMOBILE_AD_SPOT_ID delegate:self];
}
- (void)addIMobileAddInControllerPopup:(UIViewController*)vc
{
//    [ImobileSdkAds registerWithPublisherID:IMOBILE_SDK_ADS_PUBLISHER_ID_2 MediaID:IMOBILE_SDK_ADS_MEDIA_ID_2 SpotID:IMOBILE_SDK_ADS_SPOT_ID_2]; //広告の取得に必要な情報を設定します
//    [ImobileSdkAds startBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2]; //広告の取得を開始します
//    [ImobileSdkAds setSpotDelegate:IMOBILE_SDK_ADS_SPOT_ID_2 delegate:self];

    [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
    [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
    [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
    [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
    
//    ImobileSdkAdsStatus status = [ImobileSdkAds getStatusBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
//    if (IMOBILESDKADS_STATUS_READY == status ) {
//        [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
//    }
//    ImobileSdkAdsStatus status2 = [ImobileSdkAds getStatusBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
//    if (IMOBILESDKADS_STATUS_READY == status2 ) {
//        [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
//    }
}
-(void)imobileSdkAdsSpot:(NSString *)spotId didFailWithValue:(ImobileSdkAdsFailResult)value
{
    NSLog(@"ADs Failed %d", value);
}

-(void)imobileSdkAdsSpot:(NSString *)spotId didReadyWithValue:(ImobileSdkAdsReadyResult)value
{
    NSLog(@"ADs Ready %d", value);
//    if ([IMOBILE_SDK_ADS_SPOT_ID_2 isEqualToString:spotId]) {
//        
//        [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
//    }
}



#pragma mark - ROTATE

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL) automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers
{
    return YES;
}

//For iO6

// iOS 6.x and later
- (BOOL)shouldAutorotate {
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
        [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        return NO;
    }
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}
//for ios 7
- (NSUInteger)supportedInterfaceOrientations {
    //for ipad
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return  YES;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return  YES;
}

@end
