//
//  CompanyDetailViewController.h
//  Giga
//
//  Created by Tai Truong on 11/29/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanyModel;

@interface CompanyDetailViewController : BaseViewController
@property(weak, nonatomic) IBOutlet UIView                  *vButtonBar;
@property (strong, nonatomic) CompanyModel *company;

@property (strong, nonatomic) id stockData;//response from server
@property (strong, nonatomic) id infoData;//response from server

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyDes;
@property (weak, nonatomic) IBOutlet UIImageView *imgCompanyLogo;

//in blue box
@property (weak, nonatomic) IBOutlet UILabel *lbCategory2;
@property (weak, nonatomic) IBOutlet UILabel *lbIndustry;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;

@property (weak, nonatomic) IBOutlet UILabel *lbTimeUpdate;

@property (weak, nonatomic) IBOutlet UIButton           *btCompanyProfile;
@property (weak, nonatomic) IBOutlet UIButton           *btCompanyChart;
@property (weak, nonatomic) IBOutlet UIButton           *btCompanyPerformance;
@property (weak, nonatomic) IBOutlet UIButton           *btRelativeCompany;

-(IBAction)btTab_Touched:(id)sender;

//content view
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
