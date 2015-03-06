//
//  ArticleModel.m
//  Giga
//
//  Created by Hoang Ho on 12/4/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "ArticleModel.h"
#import "Utils.h"
#import <AppDavis/ADVSInstreamInfoModel.h>
#import <objc/runtime.h>

@implementation ArticleModel

@dynamic articleID;
@dynamic articleIndex;
@dynamic categoryID;
@dynamic dateCreate;
@dynamic dateUpdate;
@dynamic imageUrl;
@dynamic numberComment;
@dynamic numberView;
@dynamic overview;
@dynamic publishStatus;
@dynamic siteName;
@dynamic sourceUrl;
@dynamic title;
@dynamic isBookmark;
@dynamic logo_site;

// for recruite
@dynamic jobType;
//
@dynamic news_type;
@dynamic status;
@dynamic company_name;
@dynamic employee;
@dynamic employment_type;
@dynamic features;
@dynamic job_content;
@dynamic position;
@dynamic location;
@dynamic recruiting_target;
@dynamic salary;
@dynamic is_new;
@dynamic retweet_inapp;
@dynamic collect_article_id;
@dynamic no_xp;
@dynamic share_inapp;
@dynamic isTopic;
@dynamic company_introduction;

+ (id)insertFromJsonData:(NSDictionary*)jsonData jobType:(NSInteger)type
{
    //default if article normal
    return [self insertArticleFromJsonData:jsonData isBookmark:NO jobType:type];
}

+ (id)insertArticleFromJsonData:(NSDictionary *)jsonData isBookmark:(BOOL)bookmark jobType:(NSInteger)type
{
    return [self insertArticleFromJsonData:jsonData isBookmark:bookmark isTopic:NO jobType:type];
}

+ (id)insertArticleFromJsonData:(NSDictionary *)jsonData isBookmark:(BOOL)bookmark isTopic:(BOOL)isTopic jobType:(NSInteger)type
{
    NSNumber *tempIndex = nil;
    BOOL tempValue = bookmark;
    NSString *articleID = [jsonData valueForKey:@"id"];
    if (articleID) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleID == %@",articleID];
        ArticleModel *existedObj = [self getOneItemWithPredicate:predicate];
        if (existedObj) {
            if (!tempValue) {
                tempValue = existedObj.isBookmark.boolValue;
            }
            tempIndex = existedObj.articleIndex;
            [existedObj MR_deleteEntity];
            //            [SharedDataCenter.managedObjectContext deleteObject:existedObj];
        }
    }
    ArticleModel *obj = [self insertNewObject];
    [obj updateDataFromJsonData:jsonData jobType:type];
    obj.isBookmark = @(tempValue);
    obj.isTopic = @(isTopic);
    
    //find max articleIndex
    if (tempIndex) {
        obj.articleIndex = tempIndex;
    }else
        obj.articleIndex = [self maxArticleIndexWithCategoryID:obj.categoryID isTopic:isTopic jobType:type];
    
    [SharedDataCenter saveContext];
    
    return obj;
}

+(void)removeAllArticleInTopicWithJobType:(NSInteger)type
{
    NSArray *items = [self getAllArticleInTopicWithJobType:type];
    for (ArticleModel *article in items)
    {
        if(!article.isBookmark.boolValue)//don't delete bookmark item
            [article MR_deleteEntity];
    }
    [SharedDataCenter saveContext];
}

+(void)removeAllArticleByCategoryID:(NSString *)categoryID andJobType:(NSInteger)type
{
    NSArray *items = [self getAllArticleByCategoryID:categoryID andJobType:type];
    for (ArticleModel *article in items)
    {
        if(!article.isBookmark.boolValue)//don't delete bookmark item
            [article MR_deleteEntity];
    }
    [SharedDataCenter saveContext];
}

+ (NSNumber*)maxArticleIndexWithCategoryID:(NSString*)categoryID isTopic:(BOOL)isTopic jobType:(NSInteger)type
{
    NSNumber *maxIndex = @(1);
    NSArray *items = nil;
    if (isTopic) {
        items = [self getAllArticleInTopicWithJobType:type];
    }else{
        items = [self getAllArticleByCategoryID:categoryID andJobType:type];
    }
    if (items.count > 0) {
        ArticleModel *art = [items lastObject];
        maxIndex = @(art.articleIndex.intValue + 1);
    }
    return maxIndex;
}

+ (NSString*)getStringFromDate:(NSDate*)date
{
    NSString *dateStr = [[self dateFormatter] stringFromDate:date];
    return dateStr;
}

+(NSDate*)getDateFromString:(NSString*)str
{
    NSDate *dt = [[self dateFormatter] dateFromString:str];
    return dt;
}


+ (NSDateFormatter*)dateFormatter
{
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    }
    return formatter;
}

+ (void)deleteAllObjects
{
    //don't delete bookmark/notification items
    NSArray *items = [self getAllObjects];
    for (ArticleModel *obj in items) {
        if (!obj.isBookmark.boolValue) {
            [obj MR_deleteEntity];
            //            [SharedDataCenter.managedObjectContext deleteObject:obj];
        }
    }
    [SharedDataCenter saveContext];
}

@end

@implementation ArticleModel (Query)

+ (NSArray*)getAllArticleByCategoryID:(NSString*)categoryID andJobType:(NSInteger)type
{
    return [self getAllArticleByCategoryID:categoryID andJobType:type numberItem:0];
}

+ (NSArray*)getAllArticleByCategoryID:(NSString*)categoryID andJobType:(NSInteger)type numberItem:(int)numberItem
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryID == %@ AND jobType = %i",categoryID, type];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"articleIndex" ascending:YES];
    return  [self getItemsWithPredicate:predicate sorts:@[sortDescriptor] numberItem:numberItem];
}

+ (NSArray*)getBookmarkItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isBookmark == %i",YES];
    return [self getItemsWithPredicate:predicate sorts:nil];
}

+ (id)getArticleByID:(NSString*)articleID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleID == %@",articleID];
    return  [self getOneItemWithPredicate:predicate];
}

+ (NSArray*)getAllArticleInTopicWithJobType:(NSInteger)type;//mutil category
{
    return [self getAllArticleInTopicWithJobType:type numberItem:0];
}

+ (NSArray*)getAllArticleInTopicWithJobType:(NSInteger)type numberItem:(int)numberItem
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isTopic == %i AND jobType == %i", YES, type];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"articleIndex" ascending:YES];
    return [self getItemsWithPredicate:predicate sorts:@[sortDescriptor] numberItem:numberItem];
}

@end;

@implementation ArticleModel (Update)

- (void)updateNumberComment:(int) adding {
    self.numberComment = @(self.numberComment.integerValue + adding);
    [SharedDataCenter saveContext];
}

//obj.article_id = [dic valueForKey:@"article_id"];
//obj.publish_status = [dic valueForKey:@"publish_status"];
//obj.created_at = [dic valueForKey:@"created_at"];
//obj.modified_at = [dic valueForKey:@"updated_at"];
//obj.org_sitename = [dic valueForKey:@"site"];
//obj.title = [dic valueForKey:@"title"];
//obj.overview = [dic valueForKey:@"overview"];
//obj.org_url = [dic valueForKey:@"url"];
//obj.view_count = [dic valueForKey:@"view_count"];
//obj.retweet_inapp = [dic valueForKey:@"retweet_inapp"];
//obj.fbshare_inapp = [dic valueForKey:@"fbshare_inapp"];
//obj.retweet_org = [dic valueForKey:@"retweet_org"];
//obj.fbshare_org = [dic valueForKey:@"fbshare_org"];
//obj.retweet_org6 = [dic valueForKey:@"retweet_org6"];
//obj.fbshare_org6 = [dic valueForKey:@"fbshare_org6"];
//obj.retweet_org48 = [dic valueForKey:@"retweet_org48"];
//obj.fbshare_org48 = [dic valueForKey:@"fbshare_org48"];
//obj.category_id = [dic valueForKey:@"category_id"];
//obj.order = [dic valueForKey:@"order"];
//obj.img_url = [dic valueForKey:@"image"];
//obj.cmt_count = [dic valueForKey:@"cmt_count"];


- (void)updateDataFromJsonData:(NSDictionary*)json jobType:(NSInteger)type {
    json = [Utils repairingDictionaryWith: json];
    self.articleID = json[@"id"];
    self.categoryID = json[@"category_id"];
    self.title = json[@"title"];
    self.siteName = json[@"site"];
    self.overview = json[@"overview"];
    self.sourceUrl = json[@"url"];
    if ([json.allKeys indexOfObject:@"comment_count"] != NSNotFound) {
        self.numberComment = @([json[@"comment_count"] intValue]);
    }
    if ([json.allKeys indexOfObject:@"view_count"] != NSNotFound) {
        self.numberView = @([json[@"view_count"] intValue]);
    }
    self.imageUrl = json[@"image"];
    self.dateCreate = [ArticleModel getDateFromString:json[@"created_at"]];
    NSDate *dateUpdate = [ArticleModel getDateFromString:json[@"updated_at"]];
    self.dateUpdate = dateUpdate != nil ? dateUpdate : self.dateCreate;
    if ([json.allKeys indexOfObject:@"publish_status"] != NSNotFound) {
        self.publishStatus = @([json[@"publish_status"] integerValue]);
    }
    if ([json.allKeys indexOfObject:@"logo_site"] != NSNotFound) {
        if (json[@"logo_site"]) self.logo_site = json[@"logo_site"];
    }

    // for recruite
    if (type > 0) {
        self.jobType = @(type);
    }
    
    
    self.news_type = @([json[@"news_type"] integerValue]);
    self.status = json[@"status"];
    self.company_name = json[@"company_name"];
    self.employee = json[@"employee"];
    self.employment_type = @([json[@"employment_type"] integerValue]);
    self.features = json[@"features"];
    self.job_content = json[@"job_content"];
    self.position = json[@"position"];
    self.location = json[@"location"];
    self.recruiting_target = json[@"recruiting_target"];
    self.salary = json[@"salary"];
    self.is_new = json[@"is_new"];
    self.retweet_inapp = @([json[@"retweet_inapp"] integerValue]);
    self.collect_article_id = @([json[@"collect_article_id"] integerValue]);
    self.no_xp = @([json[@"no_xp"] integerValue]);
    self.share_inapp = @([json[@"share_inapp"] integerValue]);
    self.company_introduction = json[@"company_introduction"];
}

@end

@implementation ArticleModel (Ads)

+ (id)insertArticleFromADVSModel:(id)model
{
    ADVSInstreamInfoModel *ads = model;
    NSString *articleID = [ads valueForKey:@"adId"];
    //dont' compare with real article
    articleID = [articleID stringByAppendingString:@"ADVS"];
    if (articleID) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"articleID == %@",articleID];
        ArticleModel *existedObj = [self getOneItemWithPredicate:predicate];
        if (existedObj) {
            [existedObj MR_deleteEntity];
            //            [SharedDataCenter.managedObjectContext deleteObject:existedObj];
        }
    }
    ArticleModel *obj = [self insertNewObject];
    
    obj.title = ads.title;
    obj.articleID = articleID;
    obj.sourceUrl = [[ads valueForKey:@"redirectURL"] description];//a url
    obj.imageUrl = [[ads valueForKey:@"imageURL"] description];//a url
    obj.overview =  ads.content;
    obj.news_type = @(ENUM_ARTICLE_TYPE_ADVS_ADS);
    
    //find max articleIndex
    ArticleModel *lastArt = [[self getADVSAdds:MAXFLOAT] lastObject];
    NSNumber *maxIndex = lastArt ? @(lastArt.articleIndex.intValue + 1) : @(1);
    obj.articleIndex = maxIndex;
    
    [SharedDataCenter saveContext];
    
    return obj;
}

+ (NSArray*)getADVSAdds:(NSInteger)numberItem
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"news_type == %d", ENUM_ARTICLE_TYPE_ADVS_ADS];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"articleIndex" ascending:NO];
    return [self getItemsWithPredicate:pre sorts:@[sortDescriptor] numberItem:numberItem];
}
@end