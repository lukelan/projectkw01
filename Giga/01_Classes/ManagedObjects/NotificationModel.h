//
//  NotificationModel.h
//  Giga
//
//  Created by CX MAC on 12/16/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseManagedObject.h"

@interface NotificationModel : BaseManagedObject

@property (nonatomic, retain) NSString * notifTitle;
@property (nonatomic, retain) NSString * notifID;
@property (nonatomic, retain) NSString * fromUser;
@property (nonatomic, retain) NSString * toUser;
@property (nonatomic, retain) NSString * articleID;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * notifType;
+ (instancetype)initWithJsonData:(NSDictionary*)dict;
+ (NSArray*)getNotificationByArticleID:(NSString*)artID;
@end
