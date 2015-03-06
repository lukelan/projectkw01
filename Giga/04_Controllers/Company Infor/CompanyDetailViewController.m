//
//  CompanyDetailViewController.m
//  Giga
//
//  Created by Tai Truong on 11/29/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "CompanyModel.h"
#import "CustomNavigationView.h"
#import "UIImageView+WebCache.h"

#import "CompanyDetail_ProfileView.h"
#import "CompanyDetail_ChartView.h"
#import "CompanyDetail_RelatedCompanyView.h"
#import "CompanyDetail_PerformanceView.h"

#import "RelativeNewsViewController.h"
#import "WebDetailViewController.h"
#import "ListCompanyCategoryViewController.h"

#define unselectBackgroundColor                 RGB(239, 239, 239)
#define selectedTextColor                       RGB(1, 179, 248)
#define unselectedTextColor                     RGB(87, 86, 87)

@interface CompanyDetailViewController ()<CompanyDetail_RelatedCompanyViewDelegate, CompanyDetailSubViewDelegate>
{
    CustomNavigationView *customNavigation;
    CompanyDetail_ProfileView               *vProfile;
    CompanyDetail_ChartView                 *vChart;
    CompanyDetail_RelatedCompanyView *relatedView;
    CompanyDetail_PerformanceView   *performanceView;
    CompanyDetail_BaseSubView *currentContentView;
}

- (IBAction)bottomBackBtnTouchUpInside:(id)sender;
@end

@implementation CompanyDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadInterface];
    [self btTab_Touched: _btCompanyProfile];
}

- (void)setCompany:(CompanyModel *)company
{
    _company = company;
    
    customNavigation.lbTitle.text = company.companyName;
    self.lbCompanyDes.text = company.companyDes;
    
    self.lbCompanyName.text = company.companyName;
    self.lbCompanyDes.text = company.companyDes;
    self.lbCategory.text = company.market;
    if (company.categoryName) {
        self.lbIndustry.text = [NSString stringWithFormat:@"%@ %@", company.code, company.categoryName];
    }   
    else {
        self.lbIndustry.text = company.code ? company.code : @"";
    }

    self.lbCategory2.text = company.market;
    if (company.logoUrl && company.logoUrl.length > 0) {
        self.imgCompanyLogo.hidden = NO;
        [self.imgCompanyLogo sd_setImageWithURL:[NSURL URLWithString:company.logoUrl]];
    }else
        self.imgCompanyLogo.hidden = YES;
    if (currentContentView && [currentContentView respondsToSelector:@selector(setCompany:)]) {
        [currentContentView performSelector:@selector(setCompany:) withObject:company];
    }
}

- (void)setStockData:(id)stockData
{
    _stockData = stockData;
    NSDictionary *detail = stockData[@"detail"];
    NSDictionary *realTime = stockData[@"real_time_price"];
    if (detail) {
        
    }
    if (realTime) {
        self.imgArrow.hidden = NO;
//        self.lbTimeUpdate.text = [NSString stringWithFormat:@"%@ リアルタイム株価", realTime[@"date"]];//Real-time stock prices
        NSDateFormatter *dateFormate = [NSDateFormatter new];
        dateFormate.dateFormat = @"HH:mm";
        
        self.lbTimeUpdate.text = [NSString stringWithFormat:@"%@ リアルタイム株価", [dateFormate stringFromDate:[NSDate date]]];//Real-time stock prices
        self.lbCurrentPrice.text = realTime[@"price"];
        self.lbCurrentStatus.text = realTime[@"status"];
        if ([self.lbCurrentStatus.text rangeOfString:@"--"].location != NSNotFound) {
            self.imgArrow.hidden = YES;
        }else if ([self.lbCurrentStatus.text rangeOfString:@"+"].location != NSNotFound) {
            self.imgArrow.image = [UIImage imageNamed:@"up_arrow"];
        }else if ([self.lbCurrentStatus.text rangeOfString:@"-"].location != NSNotFound) {
            self.imgArrow.image = [UIImage imageNamed:@"down_arrow"];
        }else{
            self.imgArrow.hidden = YES;
        }
    }
}
- (void)setInfoData:(id)infoData
{
    _infoData = infoData;
    if (infoData) {
//        NSDictionary *overviewData = infoData[@"overview"];
//        NSDictionary *chartData = infoData[@"chart"];
//        NSDictionary *achieveData = infoData[@"achievements"];
//        NSArray *relatedComapanyData = infoData[@"interested"];
        if (currentContentView == vProfile) {
            NSDictionary *dict = infoData[@"overview"];
            [vProfile setDataWithDict:dict];
        }else if (currentContentView == vChart){
            NSDictionary *dict = infoData[@"chart"];
            [vChart setDataWithDict:dict];
        }else if (currentContentView == performanceView){
            NSDictionary *achieveData = infoData[@"achievements"];
            performanceView.data = achieveData;
        }else if (currentContentView == relatedView){
            NSArray *relatedComapanyData = infoData[@"interested"];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in relatedComapanyData) {
                CompanyModel *cp = [CompanyModel initWithJsonData:dict];
                [arr addObject:cp];
            }
            relatedView.tableData = arr;
        }
    }
}

- (void)loadInterface {

    customNavigation = [[CustomNavigationView alloc] initWithType:ENUM_NAVIGATION_TYPE_BACK frame:self.headerView.bounds];
    customNavigation.lbTitle.text = self.title;
    void(^actionCallback)(ENUM_NAVIGATION_ACTION_TYPE) = ^(ENUM_NAVIGATION_ACTION_TYPE type)
    {
        if (type == ENUM_NAVIGATION_TYPE_BACK) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [customNavigation addActionHandler:actionCallback];
    [self.headerView addSubview:customNavigation];
    
    //binding data for controls
    if (_company) {
        self.company = _company;
    }
    if (_stockData) {
        self.stockData = _stockData;
    }
    
    self.lbCompanyName.font = BOLD_FONT_WITH_SIZE(14);
    self.lbCategory.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbCompanyDes.font = NORMAL_FONT_WITH_SIZE(11);
    self.lbCategory2.font = NORMAL_FONT_WITH_SIZE(11);
    self.lbIndustry.font = NORMAL_FONT_WITH_SIZE(11);
    self.lbCurrentPrice.font = BOLD_FONT_WITH_SIZE(26);
    self.lbCurrentStatus.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbTimeUpdate.font = NORMAL_FONT_WITH_SIZE(11);
}


-(IBAction)btTab_Touched:(id)sender {
    // set default (un select) for all tab
    _btCompanyProfile.backgroundColor = unselectBackgroundColor;
    _btCompanyProfile.selected = NO;
    _btCompanyProfile.userInteractionEnabled = YES;
    _btCompanyProfile.frame = RECT_WITH_HEIGHT(_btCompanyProfile.frame, 41);

    _btCompanyChart.backgroundColor = unselectBackgroundColor;
    _btCompanyChart.selected = NO;
    _btCompanyChart.userInteractionEnabled = YES;
    _btCompanyChart.frame = RECT_WITH_HEIGHT(_btCompanyChart.frame, 41);

    _btCompanyPerformance.backgroundColor = unselectBackgroundColor;
    _btCompanyPerformance.selected = NO;
    _btCompanyPerformance.userInteractionEnabled = YES;
    _btCompanyPerformance.frame = RECT_WITH_HEIGHT(_btCompanyPerformance.frame, 41);

    _btRelativeCompany.backgroundColor = unselectBackgroundColor;
    _btRelativeCompany.selected = NO;
    _btRelativeCompany.userInteractionEnabled = YES;
    _btRelativeCompany.frame = RECT_WITH_HEIGHT(_btRelativeCompany.frame, 41);
    
    // set active state
    UIButton *bt = (UIButton *)sender;
    bt.backgroundColor = [UIColor whiteColor];
    bt.selected = YES;
    bt.userInteractionEnabled = NO;
    bt.frame = RECT_WITH_HEIGHT(bt.frame, 42);
    
    if (currentContentView) {
        [currentContentView removeFromSuperview];
        currentContentView = nil;
    }
    
    // actions
    if (self.btRelativeCompany.selected) {
        if (!relatedView) {
            relatedView = [[CompanyDetail_RelatedCompanyView alloc] initWithFrame:self.contentView.bounds];
        }
        [self.contentView addSubview:relatedView];
        [self.contentView bringSubviewToFront:relatedView];
        currentContentView = relatedView;
    } else if (self.btCompanyProfile.selected) {
        if (!vProfile) {
            vProfile = [[CompanyDetail_ProfileView alloc] initWithFrame:self.contentView.bounds];
        }
        [self.contentView addSubview:vProfile];
        [self.contentView bringSubviewToFront:vProfile];
        currentContentView = vProfile;
    } else if(self.btCompanyChart.selected) {
        if (!vChart) {
            vChart = [[CompanyDetail_ChartView alloc] initWithFrame:self.contentView.bounds];
        }
        [self.contentView addSubview:vChart];
        [self.contentView bringSubviewToFront:vChart];
        currentContentView = vChart;
    } else if(self.btCompanyPerformance.selected) {
        if (!performanceView) {
            performanceView = [[CompanyDetail_PerformanceView alloc] initWithFrame:self.contentView.bounds];
        }
        [self.contentView addSubview:performanceView];
        [self.contentView bringSubviewToFront:performanceView];
        currentContentView = performanceView;
    }
    if (currentContentView && [currentContentView respondsToSelector:@selector(setCompany:)]) {
        [currentContentView performSelector:@selector(setCompany:) withObject:self.company];
    }
    if (self.infoData) {
        self.infoData = self.infoData;
    }
    currentContentView.delegate = self;
}


#pragma mark - CompanyDetailSubViewDelegate

- (void)companyDetailSubViewDidClickOnRelativeNews
{
    if (self.company.siteUrl && self.company.siteUrl.length > 0) {
        WebDetailViewController *vc = [WebDetailViewController new];
        vc.pageLink = self.company.siteUrl;
        vc.objForShare = self.company;
        [self.navigationController pushViewController:vc animated: YES];
    }else{
        ALERT(@"", @"Cannot find url!");
    }

    
//    RelativeNewsViewController *viewController = [[RelativeNewsViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
//    viewController.stockData = self.stockData;
//    viewController.company = self.company;
}

-(void)companyDetailSubViewDidClickOnBookmark
{
    
}

#pragma mark - CompanyDetail_RelatedCompanyViewDelegate

- (void)RelatedCompanyViewDidSelectCompany:(id)sender
{
    CompanyModel *com = sender;
    
    //load basic info
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:com.code forKey:@"code"];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_COMPANY_STOCK andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id stockData) {
        [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_COMPANY_INFO andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id companyInfoData) {
            if (stockData && companyInfoData) {
                // TaiT: change to new controller
                CompanyDetailViewController *viewController = [[CompanyDetailViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
                viewController.company = com;
                viewController.stockData = stockData;
                viewController.infoData = companyInfoData;
            }
            else {
                ALERT(@"Error", @"Fail to get Company info.");
            }
        } failureBlock:nil];
    } failureBlock:nil];
}


- (IBAction)bottomBackBtnTouchUpInside:(id)sender {
    UIViewController *vc = nil;
    for (NSInteger i = 0; i < [self.navigationController.viewControllers count] ; i++)
    {
        UIViewController *temp = [self.navigationController.viewControllers objectAtIndex:i];
        if ([temp isMemberOfClass:[ListCompanyCategoryViewController class]]) {
            vc = temp;
            break;
        }
    }
    if (vc) {
        [self.navigationController popToViewController:vc animated:YES];
    }
}
@end
