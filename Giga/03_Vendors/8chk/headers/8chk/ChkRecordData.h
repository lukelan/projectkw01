//
//  ChkRecordData.h
//  8chk
//
//  Ver 5.4.0
//
//  Created by Tatsuya Uemura on 11/09/06.
//  Copyright 2011 8crops inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UiKit/UIImage.h>

#pragma mark インタースティシャルの状態
typedef enum {
    CHK_INTERSTITIAL_HAS_NONE = 0,
    CHK_INTERSTITIAL_HAS_PORTRAIT = 1 << 0,
    CHK_INTERSTITIAL_HAS_LANDSCAPE = 1 << 1,
    CHK_INTERSTITIAL_HAS_BOTH = 1 << 2
} ChkInterstitialState;

@interface ChkRecordData : NSObject {
    
}

@property (nonatomic, retain, readonly) NSString  *articleId;
@property (nonatomic, retain, readonly) NSString  *appId;
@property (nonatomic, retain, readonly) NSString  *title;
@property (nonatomic, retain, readonly) NSString  *description;
@property (nonatomic, retain, readonly) NSString  *detail;
@property (nonatomic, retain, readonly) NSString  *cvCondition;
@property (nonatomic, retain, readonly) NSString  *linkUrl;
@property (nonatomic, retain, readonly) NSString  *type;
@property (nonatomic, retain, readonly) NSString  *imageIcon;
@property (nonatomic, retain, readonly) NSString  *appSearcher;
@property (nonatomic, retain, readonly) NSNumber  *price;
@property (nonatomic, retain, readonly) NSNumber  *oldPrice;
@property (nonatomic, retain, readonly) NSNumber  *reward;
@property (nonatomic, retain, readonly) NSNumber  *point;
@property (nonatomic, retain, readonly) NSNumber  *categoryId;
@property (nonatomic, retain, readonly) NSString  *category;
@property (nonatomic, retain, readonly) NSString  *impUrl;
@property (nonatomic, retain, readonly) NSString  *appStoreId;

@property (nonatomic, readonly)         BOOL      isInstalled;
@property (nonatomic, readonly)         BOOL      isImpSend;

@property (nonatomic, retain)           UIImage   *cacheImage;
@property (nonatomic, retain)           UIImage   *cashImage UNAVAILABLE_ATTRIBUTE __attribute__((unavailable("This property is unavailable!")));
@property (nonatomic, retain, readonly) NSNumber  *conversionActionType;
@property (nonatomic, readonly) BOOL              isMeasuring;

@property (nonatomic, retain, readonly) NSString  *nativeBannerUrl;
@property (nonatomic, readonly)         BOOL      hasNativeBanner;

@property (nonatomic, retain,readonly) NSString   *interstitialL;
@property (nonatomic, retain,readonly) NSString   *interstitialP;
@property (nonatomic, readonly)         ChkInterstitialState      hasInterstitialState;

- (id) initWithRecordData:(NSMutableDictionary*) data;

@end
