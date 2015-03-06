//
//  AppDelegate.m
//  TabDemo
//
//  Created by Hoang Ho on 11/18/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AdSupport/ASIdentifierManager.h>
#import <AppDavis/AppDavis.h>
#import "LPSDK.h"
#import "ArticleModel.h"
#import "RecruitDetailViewController.h"
#import "iVersion.h"

#define kTrackingId @"UA-59180976-1"


#import "ImobileSdkAds/ImobileSdkAds.h"
#define IMOBILE_SDK_ADS_PUBLISHER_ID_1 @"34560"
#define IMOBILE_SDK_ADS_MEDIA_ID_1 @"132964"
#define IMOBILE_SDK_ADS_SPOT_ID_1 @"339576"

#define IMOBILE_SDK_ADS_PUBLISHER_ID_2	@"34560"//@"34816"
#define IMOBILE_SDK_ADS_MEDIA_ID_2	@"132964"//@"135002"
#define IMOBILE_SDK_ADS_SPOT_ID_2	@"370117"//@"342411"

#define IMOBILE_SDK_ADS_PUBLISHER_ID_3	@"34560"
#define IMOBILE_SDK_ADS_MEDIA_ID_3	@"132964"
#define IMOBILE_SDK_ADS_SPOT_ID_3	@"375470"


@implementation AppDelegate

+ (void)initialize
{
    [iVersion sharedInstance].appStoreCountry = @"jp";
    [iVersion sharedInstance].ignoreButtonLabel = @"行わない";
    [iVersion sharedInstance].remindButtonLabel = @"後で行う";
    [iVersion sharedInstance].downloadButtonLabel = @"今すぐダウンロード";
    [iVersion sharedInstance].okButtonLabel = localizedString(@"OK");

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"GIGA"];
    
    // login with udid
    [AppDavis initMedia:@"470"];
    
    // LPSDKをインスタンス化します.
    // インスタンス化は +instanceメソッドを使用して行います.
    LPSDK *push = [LPSDK instance];
    [push setDelegate:self];
    // デバッグモードを指定します.
    [push setDebugMode:YES];
    
    // PUSH通知サービスより発行された API Keyを設定します.
    [push setApiKey:LPSDK_API_KEY]; // Real
    [push setApiSecret:LPSDK_SECRET_KEY];
    
    if(kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1) {
        [push setMinimumBackgroundFetchInterval:1];
    }
    
    // PUSH通知サービスの処理を開始します.
    [push start];
    
    [ImobileSdkAds registerWithPublisherID:IMOBILE_SDK_ADS_PUBLISHER_ID_1 MediaID:IMOBILE_SDK_ADS_MEDIA_ID_1 SpotID:IMOBILE_SDK_ADS_SPOT_ID_1];
    [ImobileSdkAds startBySpotID:IMOBILE_SDK_ADS_SPOT_ID_1];
    
    [ImobileSdkAds registerWithPublisherID:IMOBILE_SDK_ADS_PUBLISHER_ID_2 MediaID:IMOBILE_SDK_ADS_MEDIA_ID_2 SpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
    [ImobileSdkAds startBySpotID:IMOBILE_SDK_ADS_SPOT_ID_2];
    
    [ImobileSdkAds registerWithPublisherID:IMOBILE_SDK_ADS_PUBLISHER_ID_3 MediaID:IMOBILE_SDK_ADS_MEDIA_ID_3 SpotID:IMOBILE_SDK_ADS_SPOT_ID_3];
    [ImobileSdkAds startBySpotID:IMOBILE_SDK_ADS_SPOT_ID_3];
    
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    
    //    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
    //     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    _isActionFromFB = NO;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (!_isActionFromFB) {
        [[NSNotificationCenter defaultCenter] postNotificationName:STRING_NOTIFICATION_APP_ACTIVE object:nil];
        [FBAppEvents activateApp]; //FB
    } else {
        _isActionFromFB = NO;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    id appSchema = infoPlist[@"CFBundleURLTypes"][1][@"CFBundleURLSchemes"][0];
    
    if ([url.scheme isEqualToString:infoPlist[@"CFBundleURLTypes"][0][@"CFBundleURLSchemes"][0]]) {
        
        BOOL urlWasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication]; //FB
        
        //        [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        //            if (call.appLinkData && call.appLinkData.targetURL) {
        //                [[NSNotificationCenter defaultCenter] postNotificationName: infoPlist[@"FacebookAppID"] object:call.appLinkData.targetURL];
        //            }
        //        }];
        
        _isActionFromFB = YES;
        return urlWasHandled;
    }
    else if ([[url absoluteString] rangeOfString:appSchema].location != NSNotFound) {
        
        // check if link is a notification to request open a screen
        if ([[url absoluteString] rangeOfString:[appSchema stringByAppendingString:APP_URL_SCHEMA_OPEN_ARTICLE]].location != NSNotFound ) {
            NSString *query = [url fragment];
            if (!query) {
                query = [url query];
            }
            // get list params
            //            NSDictionary *dictionary = [self parseURLParams:query];
            //            [self redirectToSpecificScreen:dictionary];
            //
            //            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            //            [mixpanel track:@"Opens app from email" properties:@{@"Screen": @"GLOBAL"}];
            if (query) {
                // go to article detail screen
                [self openArticleDetail:query];
            }
            return YES;
        }
    }
    
    return YES;
}


#pragma mark - LPSDKDelegate methods.

- (void)didRegisterApns {
    NSLog(@"[LPSDKSample] didRegisterApns called");
}

- (void)didFailToRegisterApnsWithError:(NSError *)error {
    NSLog(@"[LPSDKSample] didFailToRegisterApnsWithError: called");
}

- (void)didRegisterDeviceTokenWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@"[LPSDKSample] didRegisterDeviceTokenWithUserInfo: called. : %@", userInfo);
}

- (void)didFailToRegisterDeviceTokenWithError:(NSError *)error {
    NSLog(@"[LPSDKSample] didFailToRegisterDeviceTokenWithError: called. error : %@", error);
}

- (void)shouldDisplayConfirmDialogRemoteNotificationMessageInActive
{
    
}

- (void)didReceiveRemotePushNotificationWithStateActive:(NSDictionary *)userInfo actionCompletionHandler:(void (^)())actionCompletionHandler {
    NSLog(@"[LPSDKSample] didReceiveRemotePushNotificationWithStateActive:actionComletionHandler: called. userInfo: %@", userInfo);
    actionCompletionHandler();
}

- (void)didReceiveRemotePushNotificationWithStateInactive:(NSDictionary *)userInfo {
    NSLog(@"[LPSDKSample] didReceiveRemotePushNotificationWithStateInactive: called. userInfo: %@", userInfo);
    NSDictionary *appDic = [userInfo objectForKey:@"aps"];
    NSString *article_id = [appDic objectForKey:@"article_id"];
    if (article_id) {
        // go to article detail screen
        [self openArticleDetail:article_id];
    }
}

-(void)openArticleDetail:(NSString*)articleID
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue: articleID forKey:@"article_id"];
    if (SharedUserData.userID) [params setValue: SharedUserData.userID forKey:@"client_id"];
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_ARTICLE_DETAIL andPostMethodKind:YES andParams:params inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        if ([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0) {
            NSDictionary *dict = responseObject[0];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleID = %@",articleID];
            ArticleModel *article = [ArticleModel getOneItemWithPredicate:predicate];
            if (!article) {
                article = [ArticleModel insertNewObject];
                article.articleID = articleID;
            }
            [article updateDataFromJsonData:dict jobType:0];
            
            RecruitDetailViewController *vc = [RecruitDetailViewController new];
            vc.recruitItem = article;
            [vc setUpdateCommentCount:nil];
            if (!self.nav) {
                self.nav = (id)self.window.rootViewController;
            }
            [self.nav pushViewController:vc animated:NO];
        }
        
        
    } failureBlock:^(NSError *error) {
    }];
    
    
}

- (void)didReceiveRemotePushNotificationWithStateActive:(NSDictionary *)userInfo
                                actionCompletionHandler:(void (^)())actionCompletionHandler
                                 fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))fetchCompletionHandler {
    NSLog(@"[LPSDKSample] didReceiveRemotePushNotificationWithStateActive:actionComletionHandler:fetchCompletionHandler called. userInfo: %@", userInfo);
    actionCompletionHandler();
    fetchCompletionHandler(UIBackgroundFetchResultNoData);
}

- (void)didReceiveRemotePushNotificationWithStateInactive:(NSDictionary *)userInfo
                                   fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))fetchCompletionHandler {
    NSLog(@"[LPSDKSample] didReceiveRemotePushNotificationWithStateInactive:fetchCompletionHandler called. userInfo: %@", userInfo);
    fetchCompletionHandler(UIBackgroundFetchResultNoData);
}

- (void)didReceiveRemotePushNotificationWithStateInBackground:(NSDictionary *)userInfo
                                       fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))fetchCompletionHandler {
    NSLog(@"[LPSDKSample] didReceiveRemotePushNotificationWithStateInBackground:fetchCompletionHandler called. userInfo: %@", userInfo);
    fetchCompletionHandler(UIBackgroundFetchResultNewData);
}

- (void)didCommitData {
    NSLog(@"[LPSDKSample] didCommitData called.");
}

- (void)didFailToCommitDataWithError:(NSError *)error {
    NSLog(@"[LPSDKSample] didFailToCommitData: called. error : %@", error);
}

// View

- (void)lpsdkViewWillAppear {
    NSLog(@"[LPSDKSample] lpsdkViewWillAppear: called.");
}

- (void)lpsdkViewDidAppear {
    NSLog(@"[LPSDKSample] lpsdkViewDidAppear: called.");
}

- (void)lpsdkViewWillDisappear {
    NSLog(@"[LPSDKSample] lpsdkViewWillDisappear: called.");
}

- (void)lpsdkViewDidDisappear {
    NSLog(@"[LPSDKSample] lpsdkViewDidDisappear: called.");
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

#pragma mark - Quang cao
-(void)chkViewDidDisappearInterstitial:(NSString *)tag {
    NSLog(@"chkViewDidDisappearInterstitial:%@",tag);
}

-(void)chkView:(UIView *)chkView willAppearInterstitial:(NSString *)tag {
    NSLog(@"willAppearInterstitial:%@:%@",chkView,tag);
    
    chkView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5f,0.5f);
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         chkView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f,1.1f);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              chkView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9f,0.9f);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.1
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   chkView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0f,1.0f);
                                                               }
                                                               completion:nil
                                               ];
                                              
                                          }
                          ];
                         
                     }
     ];
    
}



-(void)chkView:(UIView *)chkView didCloseInterstitial:(NSString *)tag {
    NSLog(@"didCloseInterstitial:%@:%@",chkView,tag);
    
    // 非表示アニメーションをつける。
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];    // 時間の指定
    [chkView setAlpha:0.0f];    // アルファチャンネルを0.0fに
    chkView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.0f,0.0f);
    
}

- (void)chkViewDidClickInterstitial:(NSString *)tag {
    NSLog(@"chkViewDidClickInterstitial:%@",tag);
}

// インタースティシャル表示でエラーが発生した時に呼び出される物
- (void)chkViewDidFailToLoadInterstitial:(NSString *)tag {
    NSLog(@"chkViewDidFailToLoadInterstitial:%@",tag);
}


@end
