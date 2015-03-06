//
//  CompanyInforModel.h
//  Giga
//
//  Created by Hoang Ho on 12/3/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseManagedObject.h"

@class CompanyModel;

@interface CompanyInforModel : BaseManagedObject

@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * industry;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * companyDes;
@property (nonatomic, retain) NSString * logoUrl;
@property (nonatomic, retain) NSString * siteUrl;

+ (instancetype)initFromCompanyModel:(CompanyModel*)company;
+ (id)getCompanyByID:(NSString*)companyID;
- (CompanyModel*)toCompanyModel;
@end
