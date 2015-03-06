//
//  CompanyCategoryModel.h
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseModel.h"

@interface CompanyCategoryModel : BaseModel
@property (copy, nonatomic) NSString *categoryID;
@property (copy, nonatomic) NSString *categoryTitle;
@property (copy, nonatomic) NSString *industry;
@property (strong, nonatomic) NSMutableArray *companies;

+ (instancetype)initWithJsonData:(NSDictionary*)json;
@end
