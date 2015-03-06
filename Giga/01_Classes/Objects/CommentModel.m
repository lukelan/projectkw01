//
//  CommentItem.m
//  Giga
//
//  Created by vandong on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
+ (CommentModel *)commentByDict:(NSDictionary *)dict {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];

    
    CommentModel *obj = [[CommentModel alloc] init];
    
    obj.comment_id = [dict valueForKey:@"comment_id"];
    obj.article_id = [dict valueForKey:@"article_id"];
    obj.user_id = [dict valueForKey:@"client_id"];
    obj.comment = [dict valueForKey:@"content"];
    
    obj.created_at = [dict valueForKey:@"created_at"];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormat dateFromString:obj.created_at];
    dateFormat.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd%@ hh:mm", localizedString(@"年"), localizedString(@"月"), localizedString(@"日")];
    obj.created_at = [dateFormat stringFromDate:date];
    
    obj.modified_at = [dict valueForKey:@"updated_at"];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    date = [dateFormat dateFromString:obj.modified_at];
    dateFormat.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd%@ hh:mm", localizedString(@"年"), localizedString(@"月"), localizedString(@"日")];
    obj.modified_at = [dateFormat stringFromDate:date];
    
    obj.is_deleted = [[dict valueForKey:@"is_deleted"] boolValue];
    obj.like_type = [dict[@"like_type"] intValue];
    obj.numLike = [[dict valueForKey:@"like_count"] integerValue];
    obj.numDisLike = [[dict valueForKey:@"dislike_count"] integerValue];
    obj.arReply = [NSMutableArray new];
    NSArray *ar = [dict valueForKey:@"reply_list"];
    for (NSDictionary *dictReply in ar) {
        CommentModel *reply = [CommentModel replyByDict:dictReply];
        [obj.arReply addObject:reply];
    }
    
    return obj;
}

+ (CommentModel *)replyByDict:(NSDictionary *)dict {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    
    CommentModel *obj = [[CommentModel alloc] init];
    obj.isReply = YES;
    obj.comment_id = [dict valueForKey:@"reply_id"];
    obj.article_id = @"";//[dict valueForKey:@"article_id"];
    obj.user_id = [dict valueForKey:@"client_id"];
    obj.comment = [dict valueForKey:@"content"];
    
    obj.created_at = [dict valueForKey:@"created_at"];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormat dateFromString:obj.created_at];
    dateFormat.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd%@ hh:mm", localizedString(@"年"), localizedString(@"月"), localizedString(@"日")];
    obj.created_at = [dateFormat stringFromDate:date];
    
    obj.modified_at = [dict valueForKey:@"updated_at"];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    date = [dateFormat dateFromString:obj.modified_at];
    dateFormat.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd%@ hh:mm", localizedString(@"年"), localizedString(@"月"), localizedString(@"日")];
    obj.modified_at = [dateFormat stringFromDate:date];
    
    obj.is_deleted = [[dict valueForKey:@"is_deleted"] boolValue];
    obj.like_type = [dict[@"like_type"] intValue];    
    obj.numLike = [[dict valueForKey:@"like_count"] integerValue];
    obj.numDisLike = [[dict valueForKey:@"dislike_count"] integerValue];
    obj.arReply = [dict valueForKey:@"reply_list"];
    
    return obj;

}
@end
