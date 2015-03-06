//
//  CompanyDetail_BaseSubView.h
//  Giga
//
//  Created by Hoang Ho on 12/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyDetail_BottomButtonView.h"

@protocol CompanyDetailSubViewDelegate <NSObject>

@optional
- (void)companyDetailSubViewDidClickOnBookmark;
- (void)companyDetailSubViewDidClickOnRelativeNews;

@end

@interface CompanyDetail_BaseSubView : UIView<CompanyDetailBottomViewDelegate>
@property (weak, nonatomic) id<CompanyDetailSubViewDelegate> delegate;
@end
