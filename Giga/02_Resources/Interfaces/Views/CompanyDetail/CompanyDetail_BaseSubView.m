//
//  CompanyDetail_BaseSubView.m
//  Giga
//
//  Created by Hoang Ho on 12/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_BaseSubView.h"

@implementation CompanyDetail_BaseSubView

#pragma mark - CompanyDetailBottomViewDelegate

- (void)bottomViewDidClickOnRelativeNews{
    if ([self.delegate respondsToSelector:@selector(companyDetailSubViewDidClickOnRelativeNews)]) {
        [self.delegate companyDetailSubViewDidClickOnRelativeNews];
    }
}

-(void)bottomViewDidClickOnBookmark
{
    if ([self.delegate respondsToSelector:@selector(companyDetailSubViewDidClickOnBookmark)]) {
        [self.delegate companyDetailSubViewDidClickOnBookmark];
    }
}

@end
