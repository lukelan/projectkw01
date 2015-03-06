//
//  Utils.m
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "Utils.h"
#import "CustomMBProgressHUD.h"
#import <objc/runtime.h>
#import "UIAlertView+Block.h"

@implementation Utils

+ (void)showHUDForView:(UIView*)v
{
    [CustomMBProgressHUD showHUDAddedTo:v
                         animated:YES];
}

+ (void)showHUDForView:(UIView*)v
               message:(NSString*)msg
{
    if (!msg)
        [CustomMBProgressHUD showHUDAddedTo:v
                             animated:YES];
    else {
        CustomMBProgressHUD *hud = [CustomMBProgressHUD showHUDAddedTo:v
                                                  animated:YES];
        hud.labelText = msg;
    }
}

+ (void)hideHUDForView:(UIView*)v
{
    [CustomMBProgressHUD hideHUDForView:v
                         animated:NO];
}


//Object
+ (NSString*)autoDescribe:(id)instance
{
    @try {
        NSString *headerString = [NSString stringWithFormat:@"%@:%p:: ",[instance class], instance];
        return [headerString stringByAppendingString:[self autoDescribe:instance classType:[instance class]]];
    }
    @catch (NSException *exception){
        return [instance description];
    }
    @finally {
        
    }
}

// Finds all properties of an object, and prints each one out as part of a string describing the class.
+ (NSString*)autoDescribe:(id)instance classType:(Class)classType
{
    NSUInteger count;
    objc_property_t *propList = class_copyPropertyList(classType, &count);
    NSMutableString *propPrint = [NSMutableString string];
    int numberLine = 3;
    for ( int i = 0; i < count; i++ )
    {
        objc_property_t property = propList[i];
        
        const char *propName = property_getName(property);
        NSString *propNameString =[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        
        if(propName)
        {
            id value = [instance valueForKey:propNameString];
            [propPrint appendString:[NSString stringWithFormat:@"%@=%@ ; ", propNameString, value]];
            numberLine --;
            if (numberLine == 0){
                numberLine = 3;
                [propPrint appendString:@"\n"];
            }
        }
    }
    free(propList);
    
    
    // Now see if we need to map any superclasses as well.
    Class superClass = class_getSuperclass( classType );
    if ( superClass != nil && ! [superClass isEqual:[NSObject class]] )
    {
        NSString *superString = [self autoDescribe:instance classType:superClass];
        [propPrint appendString:superString];
    }
    
    return propPrint;
}


//localized strings
NSString* localizedString(NSString *key)
{
    static NSDictionary * jsonLanguage;
    if (!jsonLanguage) {
        NSString* filePath = @"language";
        NSString* fileRoot = [[NSBundle mainBundle]
                              pathForResource:filePath ofType:@"json"];
        NSString* fileContents =
        [NSString stringWithContentsOfFile:fileRoot
                                  encoding:NSUTF8StringEncoding error:nil];
        NSData *webData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error;
        jsonLanguage = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    }
    NSString *tt = [jsonLanguage objectForKey:key];
    return tt ? tt: key;
}

UIFont* BOLD_FONT_WITH_SIZE(CGFloat size)
{
    return [UIFont fontWithName:FONT_BOLD size:size];
}

UIFont* NORMAL_FONT_WITH_SIZE(CGFloat size)
{
    return [UIFont fontWithName:FONT_NORMAL size:size];
}

//for refresh/load more

+ (NSString*)getUpdatedStringFromDate:(NSDate*)aDate
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        dateFormatter.locale = [NSLocale currentLocale];
        //version 1.0.2
        [dateFormatter setAMSymbol:@"AM"];
        [dateFormatter setPMSymbol:@"PM"];
        [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:a"];
        
    }
    return [NSString stringWithFormat:@"%@: %@",localizedString(@"Last updated"), [dateFormatter stringFromDate:aDate]];
}

NSString* RANDOM_STRING(int lenght)
{
    static NSString *letters = @"誌関係聞取材日産自動車 最悪場合燃料が漏 を国に届け出まし 興奮再発防止を命る行政処分を経済産業省は不正競争防止法";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: lenght];
    for (int i=0; i<lenght; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

UIImage* RANDOM_IMAGE(int imageIndex)
{
    int index = (imageIndex % 9) + 1;
    NSString *imageName = [NSString stringWithFormat:@"img%d",index];
    return [UIImage imageNamed:imageName];
}

#pragma mark - ALERT

UIAlertView *globalAlertView;

void ALERT(NSString* title, NSString* message) {
    alertView(title, message, localizedString(@"OK"));
}

void alertView(NSString *title, NSString *message,NSString *dismissString){
    [Utils showDialogWithTitle:title message:message cancelButtonTitle:dismissString otherButtonTitles:nil];
}

+ (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message
{
    globalAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:localizedString(@"OK") otherButtonTitles:nil];
    [globalAlertView show];
}

+ (void)showNoInternetConnectionErrorIfNeed:(BOOL)show
{
    if(show)
        ALERT(@"", localizedString(@"There is no network connection!"));
    else
        [self closeAlertView:NO];
}

+ (void)closeAlertView:(BOOL)animated
{
    if (globalAlertView && globalAlertView.isVisible) {
        [globalAlertView dismissWithClickedButtonIndex:0 animated:animated];
    }
}

+ (void)handleRequestError:(NSError*)err
                      from:(id)source
                 withTitle:(NSString*)title
{
    if (err.code == -1004) {
        [self showNoInternetConnectionErrorIfNeed:YES];
    }else{
        [self showDialogWithTitle:title
                          message:[self getErrorStringFromErrorCode:err.code]
                cancelButtonTitle:localizedString(@"OK")
                otherButtonTitles:nil];
    }
}


+ (NSString*)getErrorStringFromErrorCode:(int)errorCode
{
    switch (errorCode) {
        case 400:
            return @"Best Request";
            
        case 404:
            return @"Not Found";
            
        case 405:
            return @"Method Not Allowed";
            
        case 500:
            return @"Internal Server Error";
            
        case 408:
            return nil;//don't show request time out
            //            return @"Request Timeout";
            
        case 598:
            return @"Network Read Timeout Error";
            
        case 599:
            return @"Network Connect Timeout Error";
            
        case 502:
            return @"Bad Gateway";
            
        case 503:
            return @"Service Unavailable";
            
        case 504:
            return @"Gateway Timeout";
            
        case -999://The operation couldn’t be completed
            return nil;
            
        case -1011://The request sent by the client was syntactically incorrect
            return nil;
            
        case -1001:
            return nil;//don't show request time out
            //            return @"Request Timeout";
        default:
            break;
    }
    return nil;
}

+ (void)showDialogWithTitle:(NSString*)title
                    message:(NSString*)message
          cancelButtonTitle:(NSString*)cancelBtn
          otherButtonTitles:(NSString*)otherBtns
{
    if ([self shouldShowAlertViewWithMessage:message]){
        globalAlertView = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:cancelBtn
                                           otherButtonTitles:otherBtns, nil];
        [globalAlertView show];
    }
}

+ (void)showDialogWithTitle:(NSString*)title
                    message:(NSString*)message
                 completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
          cancelButtonTitle:(NSString*)cancelBtn
          otherButtonTitles:(NSString*)otherBtns
{
    if ([self shouldShowAlertViewWithMessage:message]){
        globalAlertView = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelBtn otherButtonTitle:otherBtns];
        [globalAlertView showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (completion) {
                if (buttonIndex == 0) {
                    completion(YES, 0);
                }else
                    completion(NO, buttonIndex);
            }
        }];
    }
}

+ (BOOL)shouldShowAlertViewWithMessage:(NSString*)message
{
    if (!message) {
        return NO;
    }
    if (globalAlertView){
        if (globalAlertView.isVisible){
            return NO;
        }
    }
    globalAlertView = nil;
    return YES;
}


+ (NSMutableDictionary *)repairingDictionaryWith:(NSDictionary *)dictionary
{
    NSMutableDictionary *muDictionary = [[NSMutableDictionary alloc] init];
    NSArray *allKeys = [dictionary allKeys];
    for (int i = 0; i < [allKeys count]; i ++) {
        NSMutableDictionary *childDictionary = [dictionary objectForKey:[allKeys objectAtIndex:i]];
        NSString *key = [allKeys objectAtIndex:i];
        if ([childDictionary isKindOfClass:[NSDictionary class]]) {
            [muDictionary setValue:[self repairingDictionaryWith:[dictionary objectForKey:[allKeys objectAtIndex:i]]] forKey:key];
        } else {
            if ((NSNull *)[dictionary objectForKey:[allKeys objectAtIndex:i]] == [NSNull null]) {
                [muDictionary setObject:@"" forKey:[allKeys objectAtIndex:i]];
            }
            else {
                [muDictionary setObject:[dictionary objectForKey:[allKeys objectAtIndex:i]] forKey:[allKeys objectAtIndex:i]];
            }
        }
    }
    return muDictionary;
}

@end
