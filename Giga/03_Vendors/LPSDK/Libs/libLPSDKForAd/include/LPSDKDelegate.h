//
//  LPSDKDelegate.h
//  LPSDK
//
//  Copyright 2014 livepass All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - LPSDKDelegate Protocol

/*!
 @protocol LPSDKDelegate
 非同期処理終了通知用デリゲートプロトコル
 */
@protocol LPSDKDelegate <NSObject>

@optional

#pragma mark - Register

/*!
 APNsへの登録が完了した際に呼び出されるデリゲートメソッド
 */
- (void)didRegisterApns;

/*!
 APNsへの登録に失敗した際に呼び出されるデリゲートメソッド
 */
- (void)didFailToRegisterApnsWithError:(NSError *)error;

/*!
 プッシュサービスサーバへの登録が完了した際に呼び出されるデリゲートメソッド
 */
- (void)didRegisterDeviceTokenWithUserInfo:(NSDictionary *)userInfo;

/*!
 プッシュサービスサーバへの登録に失敗した際に呼び出されるデリゲートメソッド
 */
- (void)didFailToRegisterDeviceTokenWithError:(NSError *)error;

#pragma mark - Update Regist Data
/*!
 プッシュサービスサーバへの登録データ更新が完了した際に呼び出されるデリゲートメソッド
 */
- (void)didCommitData;

/*!
 プッシュサービスサーバへの登録データ更新に失敗した際に呼び出されるデリゲートメソッド
 */
- (void)didFailToCommitDataWithError:(NSError *)error;

#pragma mark - Remote Push Notification
/*!
 プッシュ通知をアクティブ状態で受け取った際に呼び出されるデリゲートメソッド
 Background Modes - Remote Notificationsが ONの場合は呼び出されません。
 */

- (void)didReceiveRemotePushNotificationWithStateActive:(NSDictionary *)userInfo
                             actionCompletionHandler:(void (^)())actionCompletionHandler;

/*!
 プッシュ通知をアクティブ状態で受け取った際に呼び出されるデリゲートメソッド
 Background Modes - Remote Notificationsが ONの場合は呼び出されません。
 */

- (void)didReceiveRemotePushNotificationWithStateInactive:(NSDictionary *)userInfo;

#pragma mark - Background Modes Push Notification
/*!
 バックグラウンドモードプッシュ通知(iOS7以降)をアクティブ状態で受け取った際に呼び出されるデリゲートメソッド
 Background Modes - Remote Notificationsが OFFの場合は呼び出されません。
 */

- (void)didReceiveRemotePushNotificationWithStateActive:(NSDictionary *)userInfo
                             actionCompletionHandler:(void (^)())actionCompletionHandler
                              fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))fetchCompletionHandler;

/*!
 バックグラウンドモードプッシュ通知(iOS7以降)を非アクティブ状態で受け取った際に呼び出されるデリゲートメソッド
 Background Modes - Remote Notificationsが OFFの場合は呼び出されません。
 */

- (void)didReceiveRemotePushNotificationWithStateInactive:(NSDictionary *)userInfo
                                   fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))fetchCompletionHandler;

/*!
 バックグラウンドモードプッシュ通知(iOS7以降)をバックグラウンド状態で受け取った際に呼び出されるデリゲートメソッド
 Background Modes - Remote Notificationsが OFFの場合は呼び出されません。
 */

- (void)didReceiveRemotePushNotificationWithStateInBackground:(NSDictionary *)userInfo
                                       fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))fetchCompletionHandler;

#pragma mark - View Events

/*!
 PUSH通知によりビューが表示される際に呼び出されるデリゲートメソッド
 */
- (void)lpsdkViewWillAppear;

/*!
 PUSH通知によりビューが表示された際に呼び出されるデリゲートメソッド
 */
- (void)lpsdkViewDidAppear;

/*!
 PUSH通知により表示されたビューが非表示になる際に呼び出されるデリゲートメソッド
 */
- (void)lpsdkViewWillDisappear;

/*!
 PUSH通知により表示されたビューが非表示になった際に呼び出されるデリゲートメソッド
 */
- (void)lpsdkViewDidDisappear;


@end