//
//  BookmarkCompanyCell.m
//  Giga
//
//  Created by Hoang Ho on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BookmarkCompanyCell.h"
#import "UIImageView+WebCache.h"
#import "CompanyInforModel.h"

@implementation BookmarkCompanyCell

- (void)applyStyleIfNeed{
    if (isAppliedStyle) {
        return;
    }
    isAppliedStyle = YES;
    self.lbCompanyName.font = BOLD_FONT_WITH_SIZE(14);
    self.lbCompanyDes.font = NORMAL_FONT_WITH_SIZE(12);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.imgCompany.image = nil;
}

- (void)setObject:(id)obj
{
    [super setObject:obj];
    CompanyInforModel *company = obj;
    self.lbCompanyName.text = company.companyName;
    self.lbCompanyDes.text = company.companyDes;
    [self.imgCompany sd_setImageWithURL:[NSURL URLWithString:company.logoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            company.logoUrl = nil;
            [self layoutSubviews];
        }
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CompanyInforModel *company = model;
    CGRect r = self.lbCompanyName.frame;
    CGRect r2 = self.lbCompanyDes.frame;
    if (company.logoUrl && ![company.logoUrl isEqualToString:@""]) {
        self.imgCompany.hidden = NO;
        r.origin.x = r2.origin.x = 117;
        r.size.width = r2.size.width = 195.0f;
    }
    else {
        self.imgCompany.hidden = YES;
        r.origin.x = r2.origin.x = 8;
        r.size.width = r2.size.width = CGRectGetWidth(self.frame) - 2*8;
    }
    self.lbCompanyName.frame = r;
    self.lbCompanyDes.frame = r2;
}

+ (CGFloat)getCellHeight
{
    return 90;
}
@end
