//
//  CompanyCategoryModel.m
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyCategoryModel.h"

@implementation CompanyCategoryModel

- (instancetype)init
{
    if (self = [super init]) {
        self.companies = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)initWithJsonData:(NSDictionary*)json
{
    CompanyCategoryModel *instance = [[CompanyCategoryModel alloc] init];
    instance.categoryID = json[@"id"];
    instance.categoryTitle = json[@"industry_name"];

    return instance;
}

@end
