//
//  LPSDK.h
//  LPSDK
//
//  Copyright 2014 livepass All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPSDKDelegate.h"

#pragma mark - constants 

typedef NS_ENUM(NSInteger, LPSDKErrorCode) {
    LPSDKErrorCodeNone = 0,             // 正常終了
    LPSDKErrorCodeInvalidParameter,     // パラメータ不正
    LPSDKErrorCodeServerError,          // サーバ処理失敗
    LPSDKErrorCodeApiKeyNotSetting,     // API KEYが未設定
    LPSDKErrorCodeApiSecretNotSetting,  // API SECRETが未設定
    LPSDKErrorCodeFileNotFound,         // ファイルが見つからない
    LPSDKErrorCodeDeviceTokenNotExist,  // デバイストークンが存在しない
    LPSDKErrorCodeUnknown               // 未知のエラー
};

// アクティブ時にリッチプッシュを受信した際のふるまい
typedef NS_ENUM(NSInteger, LPSDKRecievedBehaviorType) 
{
    LPSDKRecievedBehaviorTypeConfirmation, // 確認ダイアログを出す (default)
    LPSDKRecievedBehaviorTypeIgnore,       // 無視する
    LPSDKRecievedBehaviorTypeForceDisplay, // 強制的に表示
};

#pragma mark - class LPSDK 

/*!
 * @class LPSDK
 */
@interface LPSDK : NSObject

/*!
 @property backgroundNotificationEnable
 アプリケーションがバックグラウンドで通知が受けられるかを判断するフラグ(iOS7以降のみ可となる)
 */
@property (nonatomic, assign, readonly) BOOL backgroundNotificationEnabled;

/*!
 @property autoBadgeDelete
 バッジの自動消去機能を設定する
 */
@property (nonatomic, assign, getter = isAutoBadgeDelete) BOOL autoBadgeDelete;

/*!
 @property recievedBehaviorType
 アクティブ時にリッチプッシュを受信した際のふるまい
 LPSDKRecievedBehaviorTypeConfirmation, // 確認ダイアログを出す (default)
 LPSDKRecievedBehaviorTypeIgnore,       // 無視する
 LPSDKRecievedBehaviorTypeForceDisplay, // 強制的に表示
 */
@property (nonatomic, assign) LPSDKRecievedBehaviorType recievedBehaviorType;

/*!
 @method lpsdkVersion
 @return バージョン番号文字列
 */
+ (NSString *)lpsdkVersion;

/*!
 @method instance
 @return LPSDKインスタンス
 シングルトンインスタンスを取得する
 */
+ (LPSDK *)instance;

/*!
 @method setDelegate:
 @param delegate 設定するデリゲートインスタンス
 デリゲートを設定する
 */
- (void)setDelegate:(id<LPSDKDelegate>)delegate;

/*!
 @method delegate
 @param 設定されているデリゲートインスタンス
 設定されているデリゲートを取得する
 */
- (id)delegate;

/*!
 @method setSettingFileName:
 @param fileName LPSDK設定用ファイルのファイル名(拡張子は含まないこと)
 LPSDKの設定ファイルを指定する.設定可能なファイルフォーマットは plistファイル.
 */
- (void)setSettingFileName:(NSString *)fileName;

/*!
 @method setDebugMode:
 @param YES: デバッグモードON, NO: デバッグモードOFF
 デバッグモードを設定する
 */
- (void)setDebugMode:(BOOL)debugMode;

/*!
 @method isDebugMode
 @return YES: デバッグモード, NO:リリースモード
 設定されているデバッグモード値を取得する
 */
- (BOOL)isDebugMode;

/*!
 @method setApiKey:
 @param aApiKey アプリケーション用に発行されているAPI KEY文字列
 SDKで使用するサービスから発行されたAPI KEYを設定する
 */
- (void)setApiKey:(NSString *)aApiKey;

/*!
 @method setApiSecret:
 @param aApiSecret アプリケーション用に発行されているAPI SECRET文字列
 SDKで使用するサービスから発行されたAPI SECRETを設定する
 */
- (void)setApiSecret:(NSString *)aApiSecret;

/*!
 @method setDeviceIdentifier:
 @param aDeviceIdentifier 設定するデバイスID文字列
 デバイスIDを設定する
 */
- (void)setDeviceIdentifier:(NSString *)aDeviceIdentifier;

/*!
 @method tags
 @return 設定されているタグ(文字列)の配列
 設定されているタグを取得する
 */
- (NSArray *)tags;

/*!
 @method setTags:
 @param tags 設定するタグ(文字列)の配列
 タグを設定する
 */
- (void)setTags:(NSArray *)tags;

/*!
 @method alias
 @return 設定されているエイリアス(文字列)
 設定されているエイリアスを取得する
 */
- (NSString *)alias;

/*!
 @method setAlias:
 @param alias 設定するエイリアス(文字列)
 エイリアスを設定する
 */
- (void)setAlias:(NSString *)alias;

/*!
 @method setNotificationEnabled:
 @param enabled YES:有効 NO:無効
 通知の有効/無効を設定する
 */
- (void)setNotificationEnabled:(BOOL)enabled;

/*!
 @method notificationEnabled
 @return YES:有効 NO:無効
 通知の有効/無効を取得する
 */
- (BOOL)notificationEnabled;

/*!
 @method setLocationEnabled:
 @param YES:有効 NO:無効
 位置情報の有効/無効を設定する
 */
- (void)setLocationEnabled:(BOOL)enabled;

/*!
 @method locationEnabled
 @return YES:有効 NO:無効
 位置情報の有効/無効を取得する
 */
- (BOOL)locationEnabled;


/*!
 @method commitData
 設定したデータ(tags,alias,notification,location)をコミットする
 */
- (void)commitData;


/*!
 @method setRemoteNotificationType:
 @param 通知種別(UIRemoteNotificationType)
 Push通知で使用する種別(UIRemoteNotificationType)を設定する.
 デフォルト値はUIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert.
 */
- (void)setRemoteNotificationType:(UIRemoteNotificationType)types;

/*!
 @method setMinimumBackgroundFetchInterval:
 @param 設定するInterval値(NSTimeInterval)
 Background Fetch用Intervalを設定する(iOS7以降のみ有効)
 */
- (void)setMinimumBackgroundFetchInterval:(NSTimeInterval)interval;


/*!
 @method start
 Push通知処理を開始する
 */
- (void)start;

@end
