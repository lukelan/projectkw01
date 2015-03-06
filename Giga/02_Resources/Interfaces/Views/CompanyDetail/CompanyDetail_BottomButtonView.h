//
//  CompanyDetail_BottomButtonView.h
//  Giga
//
//  Created by vandong on 12/6/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CompanyDetailBottomViewDelegate <NSObject>
@optional
- (void)bottomViewDidClickOnBookmark;
- (void)bottomViewDidClickOnRelativeNews;
@end
@class CompanyModel;

@interface CompanyDetail_BottomButtonView : UIView{
    CompanyModel *company;
    BOOL isBookmark;
}
@property (weak, nonatomic) id<CompanyDetailBottomViewDelegate> delegate;
@property(weak, nonatomic) IBOutlet UIButton                *btWebDetailPage;
@property(weak, nonatomic) IBOutlet UIButton                *btRelativeCompany;

- (IBAction)btWebDetailTouchUpInside:(id)sender;
- (IBAction)btRelativeCompanyTouchUpInside:(id)sender;
- (void)loadInterface;
- (void)setCompany:(CompanyModel*)cp;
@end
