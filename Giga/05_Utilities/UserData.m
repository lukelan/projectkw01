//
//  UserData.m
//  Giga
//
//  Created by CX MAC on 12/1/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "UserData.h"
#import <AdSupport/ASIdentifierManager.h>
#import "NSDate+Utilities.h"
#import "SelectProvinceView.h"

#define GIGA_ARCHIVED_KEY               @"GIGA_USER_DATA"

@implementation UserData

+ (UserData*)sharedUserData
{
    static UserData *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if ([user objectForKey:GIGA_ARCHIVED_KEY]) {
            NSData *data = [user objectForKey:GIGA_ARCHIVED_KEY];
            instance = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }else{
            instance = [[UserData alloc] init];
            //load default value
            instance.deviceID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            instance.ntfCount = 0;
            instance.listProvinces = [NSMutableArray array];
        }
        instance.curFilterJobType = 1; // default for init is first item of segment
        //request notification data when app active/reactive
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(appDidBecomActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    });
    
    return instance;
}

- (void)appDidBecomActive:(NSNotification*)ntf
{
    if (self.userID) {
        self.loadedNotificationList = NO;
        [self getNotificationCount];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)save
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [user setObject:data forKey:GIGA_ARCHIVED_KEY];
    [user synchronize];
}

- (BOOL)shouldRequestNotificationList
{
    if (!SharedUserData.userID) {
        return NO;
    }
    return !self.loadedNotificationList;
    if (!self.ntfRequestDate) {
        self.ntfRequestDate = [NSDate date];
        [self save];
        return YES;
    }
    if ([self.ntfRequestDate isEqualToDate:[NSDate date]]) {
        return NO;
    }
    self.ntfRequestDate = [NSDate date];
    return YES;
}

- (void)getNotificationCount
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (SharedUserData.userID) [params setObject:SharedUserData.userID forKey:@"client_id"];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_NOTIFICATION_COUNT andPostMethodKind:YES andParams:params inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        if ([responseObject count] > 0) {
            NSDictionary *dict = responseObject[0];
            int ntfCount = [dict[@"notif_count"] intValue];
            [SharedUserData updateNotificationCount:ntfCount shouldPostNotification:YES];
        }
    } failureBlock:nil];
}

- (void)updateNotificationCount:(int)nValue shouldPostNotification:(BOOL)shouldPost
{
    self.ntfCount = nValue;
    [self save];
    if (shouldPost) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_NOTIFICATION_NOTIFICATION_COUNT_CHANGED object:nil];
    }
}

- (NSString*)getFilterCity
{
    if (self.listProvinces) {
        NSMutableString *str = [NSMutableString string];
        for (int i = 0; i < self.listProvinces.count; i++) {
            CityItem *item = self.listProvinces[i];
            [str appendString:item.cityID];
            if (i < self.listProvinces.count - 1) {
                [str appendString:@","];
            }
        }
        return str;
    }
    return @"";
}
#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.deviceID forKey:@"deviceID"];
    [aCoder encodeObject:self.ntfRequestDate forKey:@"ntfRequestDate"];
    [aCoder encodeInt:self.ntfCount forKey:@"ntfCount"];
    [aCoder encodeObject:self.listProvinces forKey:@"listProvinces"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.userID = [aDecoder decodeObjectForKey:@"userID"];
    self.deviceID = [aDecoder decodeObjectForKey:@"deviceID"];
    self.ntfRequestDate = [aDecoder decodeObjectForKey:@"ntfRequestDate"];
    self.ntfCount = [aDecoder decodeIntForKey:@"ntfCount"];
    self.listProvinces = [aDecoder decodeObjectForKey:@"listProvinces"];
    if (self.listProvinces == nil) self.listProvinces = [NSMutableArray new];
    
    return self;
}


@end
