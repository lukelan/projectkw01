//
//  CommentItem.h
//  Giga
//
//  Created by vandong on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface CommentModel : BaseModel
@property (nonatomic, retain) NSString          *article_id;
@property (nonatomic, retain) NSString          *user_id;
@property (nonatomic, retain) NSString          *comment_id;
@property (nonatomic, retain) NSString          *comment;
@property (nonatomic, retain) NSString          *created_at;
@property (nonatomic, retain) NSString          *modified_at;
@property (nonatomic) BOOL                      is_deleted;
@property (nonatomic) int                       like_type; // 0: no action, 1: like 2:disklike
@property(nonatomic) NSInteger                  numLike;
@property(nonatomic) NSInteger                  numDisLike;
@property(strong, nonatomic) NSMutableArray     *arReply;

+ (CommentModel *)commentByDict:(NSDictionary *)dict;
+ (CommentModel *)replyByDict:(NSDictionary *)dict;


@property(nonatomic) BOOL                       isReply; // to identify this is comment or reply

// for layout of cell
@property(nonatomic) float                      cellHeight;
@property(nonatomic) float                      commentTextHeight;
@end
