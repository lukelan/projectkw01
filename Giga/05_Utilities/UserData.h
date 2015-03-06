//
//  UserData.h
//  Giga
//
//  Created by CX MAC on 12/1/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedUserData                          [UserData sharedUserData]

@interface UserData : NSObject<NSCoding>

+ (UserData*)sharedUserData;
@property (strong, nonatomic) NSString *deviceID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSMutableArray *listProvinces;//a list of CityItem


@property (assign) NSInteger          curFilterJobType; // not backup to userdefaut

//for notification
@property (assign, nonatomic) int ntfCount;
@property (strong, nonatomic) NSDate *ntfRequestDate;

@property (assign, nonatomic) BOOL loadedNotificationList;
- (void)save;
- (BOOL)shouldRequestNotificationList;
- (void)getNotificationCount;
- (void)updateNotificationCount:(int)nValue shouldPostNotification:(BOOL)shouldPost;

- (NSString*)getFilterCity;
@end
