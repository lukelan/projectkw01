//
//  RecruitArticleViewController.m
//  Giga
//
//  Created by Hoang Ho on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "RecruitArticleViewController.h"
#import "NormalArticleCell.h"
#import "AdvertiseArticleCell.h"
#import "RecruitArticleCell.h"

#import "RecruitDetailViewController.h"

#import "ArticleModel.h"
#import "RecruitArticleModel.h"
#import "AdsModel.h"

#import "SVPullToRefresh.h"
#import "MNMBottomPullToRefreshManager.h"

#define NormalArticleCellID     @"NormalArticleCell"
#define AdvertiseArticleCellID  @"AdvertiseArticleCell"
#define RecruitArticleCellID    @"RecruitArticleCell"


@interface RecruitArticleViewController ()<UITableViewDataSource,  UITableViewDelegate,MNMBottomPullToRefreshManagerClient>
{
    NSMutableArray *tableData;
    
    //refresh
    BOOL refreshing;
    
    //load more
    BOOL loadingMore;
    MNMBottomPullToRefreshManager *_loadMoreFooterView;
}
@end

@implementation RecruitArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    [self loadData];
}

- (void)loadInterface
{
    _loadMoreFooterView = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tbArticles withClient:self];
    [self.tbArticles addPullToRefreshWithActionHandler:^{
        if ([self shouldLoadData:NO]) {
////            pageIndex = 1;
//            [self loadData];
        }else{
            [self performSelector:@selector(doneRefreshData) withObject:nil afterDelay:0.3f];
        }
    }];
    
    [self.tbArticles registerNib:[UINib nibWithNibName:NormalArticleCellID bundle:nil] forCellReuseIdentifier:NormalArticleCellID];
    [self.tbArticles registerNib:[UINib nibWithNibName:AdvertiseArticleCellID bundle:nil] forCellReuseIdentifier:AdvertiseArticleCellID];
    [self.tbArticles registerNib:[UINib nibWithNibName:RecruitArticleCellID bundle:nil] forCellReuseIdentifier:RecruitArticleCellID];
    self.tbArticles.backgroundColor = RGB(226, 231, 237);
}

- (void)loadData
{
    //sample data
    
    int numberAd = 10;
    //5 advertiment article
    NSMutableArray *ads = [NSMutableArray array];
    for (int i = 1; i <= numberAd; i++) {
        AdsModel *ad = [AdsModel new];
        ad.adsTitle = RANDOM_STRING(8);
        ad.adsSource = RANDOM_STRING(8);
        ad.adsDes = RANDOM_STRING((rand() % 20) + 10);
        
        ad.numberComment = [NSNumber numberWithInt:rand() % 100];
        
        [ads addObject:ad];
    }
    
    //10 recruit article
    NSMutableArray *recruits = [NSMutableArray array];
    for (int i = 1; i <= numberAd * 2; i++) {
        RecruitArticleModel *recruit = [RecruitArticleModel new];
        recruit.companyName = RANDOM_STRING(8);
        recruit.companyDes = RANDOM_STRING(20);
        recruit.recruitType = [NSString stringWithFormat:@"%@・%@\n%@",RANDOM_STRING(3),RANDOM_STRING(4),RANDOM_STRING(8)];
        recruit.recruitFromValue = (rand() % 10) + 10;
        recruit.recruitToValue = recruit.recruitFromValue + (rand() % 10) + 5;
        recruit.isNew = YES;
        recruit.numberComment = rand() % 100;
        
        [recruits addObject:recruit];
    }

    //15 normal article
    NSMutableArray *normals = [NSMutableArray array];
    for (int i = 1; i <= numberAd * 3; i++) {
        NSString *articleID = [NSString stringWithFormat:@"test %d",i];
        NSString *categoryId = [NSString stringWithFormat:@"test category %d",i];
        NSString *articleTitle = RANDOM_STRING((rand() % 20) + 10);
        NSString *siteName = RANDOM_STRING(5);
        NSString *overview = RANDOM_STRING(30);
         NSString *sourceUrl = RANDOM_STRING(10);
        NSNumber *numberComment = [NSNumber numberWithInt:(rand() % 100)];
        NSString *imageUrl = (rand() % 100) % 2 == 0 ? @"http://u.m3q.jp/upload/2014/9/26/l_2014-9-26_cc83bd15d7ddddf0c7b17426a242d7e2.jpg": @"http://u.m3q.jp/upload/2014/10/22/l_2014-10-22_4a0b5ec4498bd9990c2e65b27bb054d5.jpg";
        
        NSMutableDictionary *sampleJson = [NSMutableDictionary dictionary];
        [sampleJson setObject:articleID forKey:@"article_id"];
        [sampleJson setObject:categoryId forKey:@"category_id"];
        [sampleJson setObject:articleTitle forKey:@"title"];
        [sampleJson setObject:siteName forKey:@"site"];
        [sampleJson setObject:overview forKey:@"overview"];
        [sampleJson setObject:sourceUrl forKey:@"url"];
        [sampleJson setObject:numberComment forKey:@"cmt_count"];
        [sampleJson setObject:numberComment forKey:@"view_count"];
        [sampleJson setObject:imageUrl forKey:@"image"];
        [sampleJson setObject:[NSDate date].description forKey:@"created_at"];
        
        ArticleModel *article = [ArticleModel insertFromJsonData:sampleJson jobType:SharedUserData.curFilterJobType];
        [normals addObject:article];
    }
    
    //Merge
    tableData = [NSMutableArray array];
    for (int i = 0; i < numberAd; i++) {
        //3 normal article
        [tableData addObjectsFromArray:[normals subarrayWithRange:NSMakeRange(3 * i, 3)]];
        //2 recruit article
        [tableData addObjectsFromArray:[recruits subarrayWithRange:NSMakeRange(2 * i, 2)]];
        //1 ad article
        [tableData addObjectsFromArray:[ads subarrayWithRange:NSMakeRange(1 * i, 1)]];
    }
    [self.tbArticles reloadData];
    
    [self doneLoadMoreData];
    [self doneRefreshData];
}


#pragma mark - UITableViewDataSource


#import "ArticleModel.h"
#import "RecruitArticleModel.h"
#import "AdsModel.h"

#define NormalArticleCellID     @"NormalArticleCell"
#define AdvertiseArticleCellID  @"AdvertiseArticleCell"
#define RecruitArticleCellID    @"RecruitArticleCell"


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
    id obj = tableData[indexPath.row];
    if ([obj isMemberOfClass:[ArticleModel class]]) {
        return [NormalArticleCell getCellHeight];
    }
    if ([obj isMemberOfClass:[RecruitArticleModel class]]) {
        return [RecruitArticleCell getCellHeight];
    }
    if ([obj isMemberOfClass:[AdsModel class]]) {
        return [AdvertiseArticleCell getCellHeight];
    }
    DLog(@"Something went wrong!");
    return [BaseCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = tableData[indexPath.row];
    
    NSString *cellID = [self cellIdentifierForObject:obj];
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell applyStyleIfNeed];
    [cell setObject:obj];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = tableData[indexPath.row];
    if ([object isMemberOfClass:[RecruitArticleModel class]] || [object isMemberOfClass:[ArticleModel class]]) {
        RecruitDetailViewController *vc = [RecruitDetailViewController new];
        vc.recruitItem = object;
        [vc setUpdateCommentCount:^(int adding) {
            ArticleModel *article = tableData[indexPath.row];
            [article updateNumberComment:adding];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];

        [self.navigationController pushViewController:vc animated: YES];
        
    }
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

-(void)doneRefreshData {
    refreshing = NO;
    [self.tbArticles.pullToRefreshView stopAnimating];
    [self.tbArticles.pullToRefreshView setSubtitle:[Utils getUpdatedStringFromDate:[NSDate date]] forState:SVPullToRefreshStateAll];
}

- (BOOL)shouldLoadData:(BOOL)isLoadMore
{
    return NO;
}

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    if ([self shouldLoadData:YES]) {
//        pageIndex = (tableData.count / DEFAULT_PAGE_SIZE) + 1;
//        loadingMore = YES;
//        [self loadData];
    }else{
        [self performSelector:@selector(doneLoadMoreData) withObject:nil afterDelay:0.3f];
    }
}
@end
