//
//  CompanyInforModel.m
//  Giga
//
//  Created by Hoang Ho on 12/3/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyInforModel.h"
#import "CompanyModel.h"

@implementation CompanyInforModel

@dynamic companyId;
@dynamic categoryName;
@dynamic industry;
@dynamic companyName;
@dynamic companyDes;
@dynamic logoUrl;
@dynamic siteUrl;

+ (instancetype)initFromCompanyModel:(CompanyModel*)company
{
    id existedObj = [self getCompanyByID:company.companyId];
    if (existedObj) {
        [existedObj MR_deleteEntity];
//        [SharedDataCenter.managedObjectContext deleteObject:existedObj];
    }
    CompanyInforModel *obj = [self insertNewObject];
    obj.companyId = company.companyId;
    obj.companyName = company.companyName;
    obj.categoryName = company.categoryName;
    obj.industry = company.industry;
    obj.companyDes = company.companyDes;
    obj.logoUrl = company.logoUrl;
    obj.siteUrl = company.siteUrl;
    
    [SharedDataCenter saveContext];
    
    return obj;
}

- (CompanyModel*)toCompanyModel
{
    CompanyModel *obj = [CompanyModel new];
    obj.companyId = self.companyId;
    obj.code = self.companyId;
    obj.companyName = self.companyName;
    obj.companyDes = self.companyDes;
    obj.categoryName = self.categoryName;
    obj.logoUrl = self.logoUrl;
    obj.siteUrl = self.siteUrl;
    obj.industry = self.industry;
    return obj;
}

+ (id)getCompanyByID:(NSString*)companyID
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"companyId == %@", companyID];
    return [self getOneItemWithPredicate:pre];
}
@end
