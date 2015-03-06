//
//  ArticleModel.h
//  Giga
//
//  Created by Hoang Ho on 12/4/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseManagedObject.h"

@interface ArticleModel : BaseManagedObject

@property (nonatomic, retain) NSNumber *articleIndex;//for sorting

@property (nonatomic, retain) NSString * articleID;
@property (nonatomic, retain) NSString * categoryID;
@property (nonatomic, retain) NSDate * dateCreate;
@property (nonatomic, retain) NSDate * dateUpdate;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * numberComment;
@property (nonatomic, retain) NSNumber * numberView;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSNumber * publishStatus;
@property (nonatomic, retain) NSString * siteName;
@property (nonatomic, retain) NSString * sourceUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * isBookmark;
@property (nonatomic, retain) NSString * logo_site;

/// for recruite
@property (nonatomic, retain) NSNumber * jobType;
//
@property (nonatomic, retain) NSNumber * news_type;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * company_name;
@property (nonatomic, retain) NSString * employee;
@property (nonatomic, retain) NSNumber * employment_type;
@property (nonatomic, retain) NSString * features;
@property (nonatomic, retain) NSString * job_content;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * recruiting_target;
@property (nonatomic, retain) NSString * salary;
@property (nonatomic, retain) NSString * is_new;
@property (nonatomic, retain) NSNumber * retweet_inapp;
@property (nonatomic, retain) NSNumber * collect_article_id;
@property (nonatomic, retain) NSNumber * no_xp;
@property (nonatomic, retain) NSNumber * share_inapp;
@property (nonatomic, retain) NSNumber * isTopic;
@property (nonatomic, retain) NSString * company_introduction;


+ (id)insertArticleFromJsonData:(NSDictionary *)jsonData isBookmark:(BOOL)bookmark jobType:(NSInteger)type;
+ (id)insertArticleFromJsonData:(NSDictionary *)jsonData isBookmark:(BOOL)bookmark isTopic:(BOOL)isTopic jobType:(NSInteger)type;
@end

@interface ArticleModel (Query)
+ (NSArray*)getAllArticleByCategoryID:(NSString*)categoryID andJobType:(NSInteger)type;
+ (NSArray*)getAllArticleByCategoryID:(NSString*)categoryID andJobType:(NSInteger)type numberItem:(int)numberItem;
+ (void)removeAllArticleByCategoryID:(NSString*)categoryID andJobType:(NSInteger)type;
+ (NSArray*)getBookmarkItems;
+ (id)getArticleByID:(NSString*)articleID;
+ (NSArray*)getAllArticleInTopicWithJobType:(NSInteger)type;//mutil category
+ (NSArray*)getAllArticleInTopicWithJobType:(NSInteger)type numberItem:(int)numberItem;
+ (void)removeAllArticleInTopicWithJobType:(NSInteger)type;
@end

@interface ArticleModel (Update)
- (void)updateNumberComment:(int) adding;
- (void)updateDataFromJsonData:(NSDictionary*)json jobType:(NSInteger)type;
@end

@interface ArticleModel (Ads)
+ (id)insertArticleFromADVSModel:(id)model;
+ (NSArray*)getADVSAdds:(NSInteger)numberItem;
@end