//
//  Utils.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (void)showHUDForView:(UIView*)v;
+ (void)showHUDForView:(UIView*)v message:(NSString*)msg;
+ (void)hideHUDForView:(UIView*)v;

//Object
+ (NSString*)autoDescribe:(id)instance;

NSString* localizedString(NSString *key);

UIFont* BOLD_FONT_WITH_SIZE(CGFloat size);
UIFont* NORMAL_FONT_WITH_SIZE(CGFloat size);

//for refresh/load more

+ (NSString*)getUpdatedStringFromDate:(NSDate*)aDate;

//for sample data
NSString* RANDOM_STRING(int lenght);
UIImage* RANDOM_IMAGE(int imageIndex);

//Alert
void ALERT(NSString* title, NSString* message);
void alertView(NSString *title, NSString *message,NSString *dismissString);

+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message;

//Network handler
+ (void)showNoInternetConnectionErrorIfNeed:(BOOL)show;
+ (void)handleRequestError:(NSError*)err
                      from:(id)source
                 withTitle:(NSString*)title;

// repair json from api
+ (NSMutableDictionary *)repairingDictionaryWith:(NSDictionary *)dictionary;
@end
