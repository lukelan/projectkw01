//
//  CompanyModel.m
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyModel.h"

@implementation CompanyModel

//code = 1301;
//description = "\U6c34\U7523\U54c1\U306e\U8cbf\U6613\U3001\U52a0\U5de5\U3001\U8cb7\U3044\U4ed8\U3051\U4e3b\U529b\U3002\U3059\U3057\U30cd\U30bf\U306b\U5f37\U307f\U3002\U52a0\U5de5\U98df\U54c1\U306f\U696d\U52d9\U7528\U304c\U8ef8\U3002\U6d77\U5916\U52a0\U5de5\U6bd4\U7387\U9ad8\U3044";
//industry = "\U6c34\U7523\U30fb\U8fb2\U6797\U696d";
//logo = "";
//market = "\U6771\U8a3c1\U90e8";
//name = "(\U682a)\U6975\U6d0b";
//url = "http://www.kyokuyo.co.jp/";

+ (instancetype)initWithJsonData:(NSDictionary*)json
{
    CompanyModel *cp = [[CompanyModel alloc] init];
    cp.companyId = json[@"code"];
    cp.code = json[@"code"];
    cp.categoryName = json[@"industry_name"];
    cp.market = json[@"market"];
    cp.companyName = json[@"name"];
    cp.companyDes = json[@"description"];
    cp.logoUrl = json[@"logo"];
    cp.siteUrl = json[@"url"];
    cp.industry = json[@"industry"];
    
    if (!cp.companyName || [cp.companyName isKindOfClass:[NSNull class]]) {
        cp.companyName = json[@"company_name"];
    }
    [cp prepareObject];
    return cp;
}

@end
