//
//  RelativeNewsViewController.m
//  Giga
//
//  Created by vandong on 11/29/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "RelativeNewsViewController.h"
#import "RecruitArticleCell.h"
#import "NormalArticleCell.h"
#import "AdvertiseArticleCell.h"
#import "ArticleModel.h"
#import "RecruitArticleModel.h"
#import "AdsModel.h"
#import "CompanyModel.h"
#import "RecruitDetailViewController.h"

#define NormalArticleCellID     @"NormalArticleCell"
#define AdvertiseArticleCellID  @"AdvertiseArticleCell"
#define RecruitArticleCellID    @"RecruitArticleCell"
#define DEFAULT_LIMIT                   20

@interface RelativeNewsViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation RelativeNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
}

- (void)loadInterface
{
    [self.tbArticles registerNib:[UINib nibWithNibName:NormalArticleCellID bundle:nil] forCellReuseIdentifier:NormalArticleCellID];
    [self.tbArticles registerNib:[UINib nibWithNibName:AdvertiseArticleCellID bundle:nil] forCellReuseIdentifier:AdvertiseArticleCellID];
    [self.tbArticles registerNib:[UINib nibWithNibName:RecruitArticleCellID bundle:nil] forCellReuseIdentifier:RecruitArticleCellID];
    
    self.tbArticles.backgroundColor = RGB(226, 231, 237);
    self.tbArticles.tableFooterView = [[UIView alloc] initWithFrame: RECT_WITH_HEIGHT(self.view.frame, 45)];
    
    _loadMoreFooterView = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f
                                                                                       tableView:self.tbArticles
                                                                                      withClient:self];
    self.lbCompanyName.font = BOLD_FONT_WITH_SIZE(14);
    self.lbCategory.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbIndustry.font = NORMAL_FONT_WITH_SIZE(11);
    self.lbCurrentStatus.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbCurrentPrice.font = BOLD_FONT_WITH_SIZE(26);
    
    //binding data
    if (self.company) {
        self.company = self.company;
    }
    if (self.stockData) {
        self.stockData = self.stockData;
    }
}

- (IBAction)btBack_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

        NSDateFormatter *dateFormate = [NSDateFormatter new];
        dateFormate.dateFormat = @"HH:mm";
        
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

- (void)setCompany:(CompanyModel *)company
{
    _company = company;
    self.lbCompanyName.text = company.companyName;
    
    self.lbCategory.text = company.market;
    
    self.lbIndustry.text = [NSString stringWithFormat:@"%@ %@", company.code, company.categoryName];
    
    if (!tableData) {
        tableData = [NSMutableArray array];
    }
    //get relative news
    [self loadRelativeNews];
}

#pragma mark - UITableViewDataSource

- (NSString*)cellIdentifierForObject:(id)obj
{
    if ([obj isMemberOfClass:[ArticleModel class]]) {
        return NormalArticleCellID;
    }
    if ([obj isMemberOfClass:[RecruitArticleModel class]]) {
        return RecruitArticleCellID;
    }
    if ([obj isMemberOfClass:[AdsModel class]]) {
        return AdvertiseArticleCellID;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *article = tableData[indexPath.row];
    if (article.news_type.intValue == 1) {
        return [NormalArticleCell getCellHeight];
    }else if (article.news_type.intValue == 2) {
        return [RecruitArticleCell getCellHeight];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *article = tableData[indexPath.row];
    
    if (article.news_type.intValue == 1) {
        NormalArticleCell *normalCell = [tableView dequeueReusableCellWithIdentifier:NormalArticleCellID];
        
        [normalCell applyStyleIfNeed];
        
        [normalCell setObject:article];
        
        return normalCell;
    }else if (article.news_type.intValue == 2) {
        RecruitArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:RecruitArticleCellID];
        
        [cell applyStyleIfNeed];
        
        [cell setObject:article];
        
        return cell;
        
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalArticleCellID];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *article = tableData[indexPath.row];
    RecruitDetailViewController *vc = [RecruitDetailViewController new];
    vc.recruitItem = article;
    [vc setUpdateCommentCount:^(int adding) {
        ArticleModel *article = tableData[indexPath.row];
        [article updateNumberComment:adding];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.navigationController pushViewController:vc animated: YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_loadMoreFooterView relocatePullToRefreshView];
    
    [_loadMoreFooterView tableViewScrolled];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_loadMoreFooterView tableViewReleased];
}

#pragma mark - Load More

-(void)doneLoadMoreData {
    loadingMore = NO;
    [_loadMoreFooterView tableViewReloadFinished];
    [_loadMoreFooterView refreshLastUpdatedDate:[NSDate date]];
}

- (BOOL)shouldLoadData
{
    if (tableData.count > 0 &&
        tableData.count % DEFAULT_LIMIT == 0 &&
        !loadingMore)
        return YES;
    return NO;
}

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    if ([self shouldLoadData]) {
        offset = tableData.count;
        loadingMore = YES;
        [self loadRelativeNews];
    }else{
        [self performSelector:@selector(doneLoadMoreData) withObject:nil afterDelay:0.3f];
    }
}

- (void)loadRelativeNews
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *companyName = [[self.company.companyName stringByReplacingOccurrencesOfString:REMOVE_COMPANY_NAME_STRING_1 withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    companyName = [[companyName stringByReplacingOccurrencesOfString:REMOVE_COMPANY_NAME_STRING_2 withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    DLog(@"name-1 {%@}", self.company.companyName);
    DLog(@"name-2 {%@}", companyName);
    [params setObject:companyName forKey:@"company_name"];
    [params setObject:@(offset) forKey:@"offset"];
    [params setObject:@(DEFAULT_LIMIT) forKey:@"limit"];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_RELATIVE_NEWS andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        if (offset == 0) {
            [tableData removeAllObjects];
        }
        NSArray *result = responseObject;
        
        if ([result isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result) {
               ArticleModel *art= [ArticleModel insertArticleFromJsonData:dict isBookmark:NO jobType:SharedUserData.curFilterJobType];
                [tableData addObject:art];
            }
        }
        [self.tbArticles reloadData];
        [self doneLoadMoreData];
    } failureBlock:^(NSError *error) {
        [self doneLoadMoreData];
    }];
}
@end
