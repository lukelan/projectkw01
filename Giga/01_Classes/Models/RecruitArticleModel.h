//
//  RecruitArticleModel.h
//  Giga
//
//  Created by Hoang Ho on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseModel.h"

@interface RecruitArticleModel : BaseModel
@property (copy, nonatomic) NSString *companyName;
@property (copy, nonatomic) NSString *companyDes;
@property (copy, nonatomic) NSString *recruitType;
@property (assign, nonatomic) int recruitFromValue;
@property (assign, nonatomic) int recruitToValue;
@property (assign, nonatomic) BOOL isNew;
@property (copy, nonatomic) NSString *recruitImageUrl;
@property (copy, nonatomic) NSString *recruitLogoUrl;
@property (assign, nonatomic) int numberComment;

@end
