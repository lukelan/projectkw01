//
//  NotificationModel.m
//  Giga
//
//  Created by CX MAC on 12/16/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel

@dynamic notifTitle;
@dynamic notifID;
@dynamic fromUser;
@dynamic toUser;
@dynamic articleID;
@dynamic createdDate;
@dynamic isRead;
@dynamic notifType;

+ (instancetype)initWithJsonData:(NSDictionary*)dict
{
    NSString *ntfID = [dict valueForKey:@"notif_id"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"notifID == %@",ntfID];
    id existedObj = [self getOneItemWithPredicate:pre];
    if (existedObj) {
        [existedObj MR_deleteEntity];
//        [SharedDataCenter.managedObjectContext deleteObject:existedObj];
    }
    NotificationModel *obj = [self insertNewObject];
    obj.notifID = [dict valueForKey:@"notif_id"];
    obj.fromUser = [dict valueForKey:@"from_client"];
    obj.toUser = [dict valueForKey:@"to_client"];
    obj.createdDate = [[self dateFormatter] dateFromString:[dict valueForKey:@"created_at"]];
    obj.articleID = [dict valueForKey:@"article_id"];
    obj.isRead = @([[dict valueForKey:@"is_read"] boolValue]);
    obj.notifType = @([[dict valueForKey:@"type"] intValue]);
    
    [SharedDataCenter saveContext];
    
    return obj;
}

+ (NSMutableArray *)getAllObjects
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
    NSMutableArray *result = [NSMutableArray arrayWithArray:[self getItemsWithPredicate:nil sorts:@[sortDescriptor]]];
    return result;
}
+ (NSArray*)getNotificationByArticleID:(NSString*)artID
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"articleID == %@",artID];
    return [self getItemsWithPredicate:pre sorts:nil];
}

+ (NSDateFormatter*)dateFormatter
{
   static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return formatter;
}
@end
