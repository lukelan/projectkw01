//
//  CompanyDetail_BottomButtonView.m
//  Giga
//
//  Created by vandong on 12/6/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_BottomButtonView.h"
#import "CompanyInforModel.h"
#import "CompanyModel.h"

@implementation CompanyDetail_BottomButtonView

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
    if(self){
        [self loadInterface];
    }
    return self;
}

- (void)loadInterface{
    [self.btWebDetailPage setTitleColor:RGB(0, 179, 255) forState:UIControlStateNormal];
    [self.btWebDetailPage setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.btWebDetailPage.layer.borderWidth = 2.0f;
    self.btWebDetailPage.layer.borderColor = RGB(0, 179, 255).CGColor;
    self.btWebDetailPage.layer.cornerRadius = 5.0f;
    self.btWebDetailPage.layer.masksToBounds = YES;
    
    self.btRelativeCompany.layer.borderWidth = 2.0f;
    self.btRelativeCompany.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btRelativeCompany.layer.cornerRadius = 5.0f;
    self.btRelativeCompany.layer.masksToBounds = YES;

    self.btWebDetailPage.titleLabel.font = BOLD_FONT_WITH_SIZE(16);
    self.btRelativeCompany.titleLabel.font = BOLD_FONT_WITH_SIZE(16);
}

- (void)setCompany:(CompanyModel*)cp
{
    company = cp;
    isBookmark = [CompanyInforModel getCompanyByID:company.companyId] != nil;
    self.btWebDetailPage.backgroundColor = !isBookmark ? [UIColor whiteColor] : RGB(0, 179, 255);
    self.btWebDetailPage.selected = isBookmark;
}

- (IBAction)btWebDetailTouchUpInside:(id)sender{
    if (self.btWebDetailPage.selected) {
        //remove bookmark
        CompanyInforModel *obj = [CompanyInforModel getCompanyByID:company.companyId];
        [obj MR_deleteEntity];
//        [SharedDataCenter.managedObjectContext deleteObject:obj];
        [self setCompany:company];
    }else{
        //add book mark
        [CompanyInforModel initFromCompanyModel:company];
        [self setCompany:company];
    }
    if([self.delegate respondsToSelector:@selector(bottomViewDidClickOnBookmark)])
       [self.delegate bottomViewDidClickOnBookmark];
    [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_NOTIFICATION_COMPANY_BOOKMARK_CHANGE object:nil];
}

- (IBAction)btRelativeCompanyTouchUpInside:(id)sender{
    if([self.delegate respondsToSelector:@selector(bottomViewDidClickOnRelativeNews)])
        [self.delegate bottomViewDidClickOnRelativeNews];
}
@end
