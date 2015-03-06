//
//  ArticleViewController.m
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "ArticleViewController.h"
#import "ArticleCategoryModel.h"
#import "NormalArticleCell.h"
#import "RecruitArticleCell.h"
#import "ArticleModel.h"
#import "SVPullToRefresh.h"
#import "MNMBottomPullToRefreshManager.h"
#import "RecruitDetailViewController.h"
#import <AppDavis/ADVSInstreamAdLoader.h>
#import <AppDavis/ADVSInstreamInfoModel.h>
#import <AppDavis/ADVSInstreamWebViewInfoModel.h>
#import <AppDavis/ADVSInterstitialAdLoader.h>
#import <AppDavis/ADVSInstreamAdLoader.h>
#import "UIImageView+WebCache.h"

#import "AdvertiseArticleCell.h"
#import "SelectProvinceView.h"

#define NormalArticleCellID                 @"NormalArticleCell"
#define NormalArticleLargeCellID            @"NormalArticleLargeCell"
#define RecruitArticleCellID                 @"RecruitArticleCell"
#define RecruitArticleLargeCellID            @"RecruitArticleLargeCell"


#define MTBurnAdsCellID                 @"MTBurnAdsCell"

#import "ChkController.h"
#import "AdCropsConstants.h"
#import "ChkControllerDelegate.h"

#import "ISGumView.h"
#import "AdCropsHScrollView.h"
#import "AdCropsConstants.h"


@interface ArticleViewController()<MNMBottomPullToRefreshManagerClient, ADVSInstreamAdLoaderDelegate,ChkControllerDelegate,AdCropsHScrollViewDelegate>
{
    BOOL requestFirstTime;
    NSMutableArray *tableData;
    
    //refresh
    BOOL refreshingArticle;
    
    //load more
    BOOL loadingMoreArticle;
    BOOL doneLoadMoreArticle;
    
    NSUInteger offset;
    MNMBottomPullToRefreshManager *_loadMoreFooterView;
    
    int             category_id;
    
    //ads
    BOOL loadingMoreAds;
    BOOL refreshingAds;
    NSArray *ADVItems;
    ADVSInstreamAdLoader *instreamAdLoader;
    
    BOOL _bReadyAds;
}
@property (nonatomic, strong) ChkController *chkController;
@property(nonatomic, strong) ISGumView *gumView;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) AdCropsHScrollView *scrollAdView;

@end

@implementation ArticleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInterface];
    
    _bReadyAds =NO;
    
    _chkController = [[ChkController alloc] initWithConfigDelegate:nil callback:self];
    [_chkController requestDataList];
}

- (void)dealloc
{
    [tableData removeAllObjects];
    tableData = nil;
}

- (void)loadInterface
{
    [self.tbArticles setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    _loadMoreFooterView = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tbArticles withClient:self];
    
    [self.tbArticles registerNib:[UINib nibWithNibName:NormalArticleCellID bundle:nil] forCellReuseIdentifier:NormalArticleCellID];
    [self.tbArticles registerNib:[UINib nibWithNibName:NormalArticleLargeCellID bundle:nil] forCellReuseIdentifier:NormalArticleLargeCellID];
    [self.tbArticles registerNib:[UINib nibWithNibName:RecruitArticleCellID bundle:nil] forCellReuseIdentifier:RecruitArticleCellID];
    [self.tbArticles registerNib:[UINib nibWithNibName:RecruitArticleLargeCellID bundle:nil] forCellReuseIdentifier:RecruitArticleLargeCellID];
    [self.tbArticles registerNib:[UINib nibWithNibName:MTBurnAdsCellID bundle:nil] forCellReuseIdentifier:MTBurnAdsCellID];

    [self.tbArticles addPullToRefreshWithActionHandler:^{
        doneLoadMoreArticle = NO;
        if ([self shouldLoadData:NO]) {
            offset = 0;
            loadingMoreAds = NO;
            refreshingAds = !loadingMoreAds;
            refreshingArticle = YES;
            [self loadData];
            [self addAds];
        }else{
            [self performSelector:@selector(doneRefreshData) withObject:nil afterDelay:0.3f];
        }
    }];
    self.tbArticles.backgroundColor = RGB(226, 231, 237);
}

- (void)reloadData {
    if ([self shouldLoadData:NO]) {
        offset = 0;
        refreshingArticle = YES;
        [self loadData];
    }
}

- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // fix tam thoi cho api
    //if (!self.isTopic)
    //{
    
    if (SharedUserData.curFilterJobType <= 1)
    {
        [params setObject:@(category_id) forKey:@"category_id"];
        [params setObject:@(1) forKey:@"filter_news"];
        
        NSArray *arr =[[NSUserDefaults standardUserDefaults] valueForKey:@"keyEmployment"];
        NSMutableString *ids = [NSMutableString string];
        for (int i = 0; i < arr.count; i++) {
            [ids appendString:arr[i]];
            if (i  < arr.count - 1) {
                [ids appendString:@","];
            }
        }
        [params setObject:ids forKey: @"filter_recruit"];
    }
    else
    {
        
        if(category_id==11)
        {
            NSArray *arr =[[NSUserDefaults standardUserDefaults] valueForKey:@"keyJob"];
            NSMutableString *ids = [NSMutableString string];
            for (int i = 0; i < arr.count; i++) {
                [ids appendString:arr[i]];
                if (i  < arr.count - 1) {
                    [ids appendString:@","];
                }
            }
            [params setObject:ids forKey:@"category_id"];
            [params setObject:@(2) forKey:@"filter_news"];
            
            NSArray *arr1 =[[NSUserDefaults standardUserDefaults] valueForKey:@"keyEmployment"];
            NSMutableString *ids1 = [NSMutableString string];
            for (int i = 0; i < arr1.count; i++) {
                [ids1 appendString:arr1[i]];
                if (i  < arr1.count - 1) {
                    [ids1 appendString:@","];
                }
            }
            [params setObject:ids1 forKey: @"filter_recruit"];
        }
        else
        {
            [params setObject:@(category_id) forKey:@"category_id"];
            [params setObject:@(2) forKey:@"filter_news"];
            NSArray *arr =[[NSUserDefaults standardUserDefaults] valueForKey:@"keyEmployment"];
            NSMutableString *ids = [NSMutableString string];
            for (int i = 0; i < arr.count; i++) {
                [ids appendString:arr[i]];
                if (i  < arr.count - 1) {
                    [ids appendString:@","];
                }
            }
            [params setObject:ids forKey: @"filter_recruit"];
        }
    }
    
    
    
    
        // send city filter based on city select screen
        // format: string "1,2,3" :1, 2, 3 is selected company ids
        [params setObject:[SharedUserData getFilterCity] forKey:@"filter_cities[]"];

    [params setObject:@(offset) forKey:@"offset"];
    [params setObject:@(DEFAULT_PAGE_SIZE) forKey:@"limit"];
    
    UIView *requestView = self.view;
    
    ENUM_API_REQUEST_TYPE requestType = self.isTopic ? ENUM_API_REQUEST_TYPE_GET_TOPICS : ENUM_API_REQUEST_TYPE_GET_LIST_ARTICLE;
    [SharedAPIRequestManager operationWithType:requestType andPostMethodKind:YES andParams:params inView:requestView shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        if (offset == 0)
        {
            [tableData removeAllObjects];
        }
        [self.tbArticles endEditing:YES];
        NSMutableArray *result = [NSMutableArray array];
        if (requestType == ENUM_API_REQUEST_TYPE_GET_LIST_ARTICLE)
        {
            NSLog(@"%@",responseObject);
            
            if([responseObject isKindOfClass:[NSDictionary class]])
            {
                NSArray *arRecruits = responseObject[@"recruits"];
                NSArray *arNews = responseObject[@"news"];
                if (arNews)
                {
                    [result addObjectsFromArray:arNews];
                }
                if (arRecruits)
                {
                    [result addObjectsFromArray:arRecruits];
                }
            }
        }
        else if (requestType == ENUM_API_REQUEST_TYPE_GET_TOPICS)
        {
            result = responseObject;
        }
        
        // clear old data if refreshing
        if (refreshingArticle && [result count] > 0) {
            if (self.isTopic) {
                [ArticleModel removeAllArticleInTopicWithJobType:SharedUserData.curFilterJobType];
            }
            else {
                [ArticleModel removeAllArticleByCategoryID:[NSString stringWithFormat:@"%d", category_id] andJobType:SharedUserData.curFilterJobType];
            }
        }
        
        for (NSDictionary *dict in result) {
            [ArticleModel insertArticleFromJsonData:dict isBookmark:NO isTopic:self.isTopic jobType:SharedUserData.curFilterJobType];
        }

        if ([result count] > 0)
        {
            [self mergeArticle:refreshingArticle ? DEFAULT_PAGE_SIZE : 0];
            doneLoadMoreArticle = NO;
        }else{
            doneLoadMoreArticle = YES;
        }
            
        [self.tbArticles reloadData];
        
        [self doneLoadMoreData];
        [self doneRefreshData];
        
        //load ads here
        if ([result count] > 0)
        {
            if (!instreamAdLoader)
            {
                //load MTBurn
                instreamAdLoader = [ADVSInstreamAdLoader new];
                instreamAdLoader.delegate = self;
            }

            //load MTBurn
            int numberNormalArticle = 0;
            int numberRecruitArticle = 0;
            int numberAds = 0;
            for (ArticleModel *obj in tableData)
            {
                if (obj.news_type.intValue == 1) {
                    numberNormalArticle ++;
                }
                if (obj.news_type.intValue == 2) {
                    numberRecruitArticle ++;
                }
            }
            if (numberNormalArticle > numberRecruitArticle) {
                numberAds = numberNormalArticle / 3;
            }else
                numberAds = numberRecruitArticle / 3;
            [self loadAdWithReturn:numberAds];
        }else{
            refreshingAds = loadingMoreAds = NO;
        }
        
        // call complete block to enable change jobtype
        if (self.completeRequest) {
            self.completeRequest(NO);
        }

    } failureBlock:^(NSError *error) {
        [self doneLoadMoreData];
        [self doneRefreshData];
        
        // call complete block to enable change jobtype
        if (self.completeRequest) {
            self.completeRequest(NO);
        }
    }];
}

//only get DEFAULT_PAGE_SIZE items when is refreshing
- (void)mergeArticle:(int)limitNumber
{
    NSMutableArray *ar = nil;
    if (self.isTopic) {
        ar = [NSMutableArray arrayWithArray:[ArticleModel getAllArticleInTopicWithJobType:SharedUserData.curFilterJobType numberItem:limitNumber]];
    }else
    {
        if(category_id == 11 && !SharedUserData.curFilterJobType <= 1)
        {
            NSArray *arr =[[NSUserDefaults standardUserDefaults] valueForKey:@"keyJob"];
            ar = [NSMutableArray new];
            for (int i = 0; i < arr.count; i++)
            {
               [ar addObjectsFromArray:[ArticleModel getAllArticleByCategoryID: [NSString stringWithFormat:@"%@", arr[i]] andJobType:SharedUserData.curFilterJobType numberItem:limitNumber]];
            }
            
        }
        else if(category_id == 13 && !SharedUserData.curFilterJobType <= 1)
        {
            ar = [NSMutableArray new];
            [ar addObjectsFromArray:[ArticleModel getAllArticleByCategoryID: [NSString stringWithFormat:@"%@", @"7"] andJobType:SharedUserData.curFilterJobType numberItem:limitNumber]];
            [ar addObjectsFromArray:[ArticleModel getAllArticleByCategoryID: [NSString stringWithFormat:@"%@", @"8"] andJobType:SharedUserData.curFilterJobType numberItem:limitNumber]];
            [ar addObjectsFromArray:[ArticleModel getAllArticleByCategoryID: [NSString stringWithFormat:@"%@", @"9"] andJobType:SharedUserData.curFilterJobType numberItem:limitNumber]];
            [ar addObjectsFromArray:[ArticleModel getAllArticleByCategoryID: [NSString stringWithFormat:@"%@", @"10"] andJobType:SharedUserData.curFilterJobType numberItem:limitNumber]];
            
        }
        else
            ar = [NSMutableArray arrayWithArray:[ArticleModel getAllArticleByCategoryID: [NSString stringWithFormat:@"%i", category_id] andJobType:SharedUserData.curFilterJobType numberItem:limitNumber]];
            
    }
    
    
    NSMutableArray *arArticleItems = [NSMutableArray new];
    NSMutableArray *arRecruitItems = [NSMutableArray new];
    NSMutableArray *ads = nil;
    
    for (int i = 0; i < ar.count; i++) {
        ArticleModel *article = ar[i];
        switch (article.news_type.integerValue) {
            case 1:
                [arArticleItems addObject:article];
                break;
            case 2:
                [arRecruitItems addObject:article];
                break;
            default:
                break;
        }
    }
    //don't cache MTBurn ads
    if (ADVItems.count > 0) {
        ads = [NSMutableArray arrayWithArray:[ArticleModel getADVSAdds:ADVItems.count]];
    }
    

    [tableData removeAllObjects];

    NSInteger posRecruit = 0;
    NSInteger posArticle = 0;
    NSInteger posAds     = 0;
    while (posRecruit < arRecruitItems.count || posArticle < arArticleItems.count ||
           posAds < ads.count)
    {
        //3 normal article
        if (posArticle < arArticleItems.count) {
            if (arArticleItems.count - posArticle < 3) {
                [tableData addObjectsFromArray:[arArticleItems subarrayWithRange:NSMakeRange(posArticle, arArticleItems.count  - posArticle)]];
            } else {
                [tableData addObjectsFromArray:[arArticleItems subarrayWithRange:NSMakeRange(posArticle, 3)]];
            }
        }

        //3 recruit article
        if (posRecruit < arRecruitItems.count) {
            if (arRecruitItems.count - posRecruit < 3) {
                [tableData addObjectsFromArray:[arRecruitItems subarrayWithRange:NSMakeRange(posRecruit, arRecruitItems.count  - posRecruit)]];
            } else {
                [tableData addObjectsFromArray:[arRecruitItems subarrayWithRange:NSMakeRange(posRecruit, 3)]];
            }
        }
        
        //1 ads
        if (posAds < ads.count) {
            if (ads.count - posAds < 1) {
                [tableData addObjectsFromArray:[ads subarrayWithRange:NSMakeRange(posAds, ads.count  - posAds)]];
            } else {
                [tableData addObjectsFromArray:[ads subarrayWithRange:NSMakeRange(posAds, 1)]];
            }
        }

        posRecruit += 3;
        posArticle += 3;
        posAds += 1;
    }

}

- (void)setCategory:(ArticleCategoryModel *)category
{
    requestFirstTime = YES;
    _category = category;

    category_id = [self.category.categoryID intValue];

    
    //load offline data first
    if (!tableData) {
        tableData = [NSMutableArray array];
    }
    [self mergeArticle:0];
    [self.tbArticles reloadData];
    
    BOOL shouldLoad = NO;
    //if don't have cached data
    if (tableData.count == 0)
        shouldLoad = YES;
    
    //if all items is bookmark
    int count = 0;
    for (ArticleModel *art in tableData) {
        if (art.isBookmark.boolValue) {
            count++;
        }else if(art.isTopic.boolValue)
            count++;
    }
    if (count == tableData.count && !self.isTopic && count >= DEFAULT_PAGE_SIZE) {
        shouldLoad = YES;
    }
    if (shouldLoad) {
        refreshingArticle = YES;
        //get article by category
        [self loadData];
    }else{//load only ads
        //load ads here
        if (!instreamAdLoader) {
            //load MTBurn
            instreamAdLoader = [ADVSInstreamAdLoader new];
            instreamAdLoader.delegate = self;
        }
        
        //load MTBurn
        int numberNormalArticle = 0;
        int numberRecruitArticle = 0;
        int numberAds = 0;
        for (ArticleModel *obj in tableData) {
            if (obj.news_type.intValue == 1) {
                numberNormalArticle ++;
            }
            if (obj.news_type.intValue == 2) {
                numberRecruitArticle ++;
            }
        }
        if (numberNormalArticle > numberRecruitArticle) {
            numberAds = numberNormalArticle / 3;
        }else
            numberAds = numberRecruitArticle / 3;
        [self loadAdWithReturn:numberAds];
        //set update time
        [self doneLoadMoreData];
        [self doneRefreshData];
    }
}

#pragma mark - MTBurn

- (void)instreamAdLoaderDidFinishLoadingAdWithReturn:(ADVSInstreamAdLoader *)instreamAdLoader
                                  instreamInfoModels:(NSArray*)instreamInfoModels
{
    if (instreamInfoModels.count > 0) {
        NSArray *arr = [ArticleModel getADVSAdds:100000];
        for (id obj in arr) {
            [obj MR_deleteEntity];
//            [SharedDataCenter.managedObjectContext deleteObject:obj];
        }
        for (id model in instreamInfoModels) {
            [ArticleModel insertArticleFromADVSModel:model];
        }
        ADVItems = instreamInfoModels;
        [self mergeArticle:refreshingAds ? DEFAULT_PAGE_SIZE : 0];
        [self.tbArticles reloadData];
        loadingMoreAds = refreshingAds = NO;
    }
}


- (void)instreamAdLoader:(ADVSInstreamAdLoader *)instreamAdLoader didFailToLoadAdWithError:(NSError *)error
{
    
}

- (void)measureImp:(ADVSInstreamInfoModel *)obj {
    [instreamAdLoader measureImp:obj];
}
- (void)sendClickEvent:(ADVSInstreamInfoModel *)obj {
    [instreamAdLoader sendClickEvent:obj];
}

- (void)loadAdWithReturn:(int)numberAds
{
    //    [self.instreamAdLoader loadAdWithReturn:@"NDQ0OjMx" adCount:6 positions:@[@3,@6,@9,@12,@15,@18]];
    // [instreamAdLoader loadAdWithReturn:@"NDQ0OjMx" adCount:20 positions:@[]];
//    [instreamAdLoader loadAdWithReturn:@"NDQ0OjMx" adCount:6 positions:@[@3,@6,@9,@12,@15,@18]];
//    [instreamAdLoader loadAdWithReturn:@"OTM2OjEyMTA" adCount:20 positions:@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20]];
    NSMutableArray *positions = [NSMutableArray array];
    for (int i = 1; i <= numberAds; i++)
    {
        [positions addObject:@(i)];
    }
    [instreamAdLoader loadAdWithReturn:@"OTM2OjEyMTA" adCount:numberAds positions:positions];
}

#pragma mark - UITableViewDataSource

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
    if (article.news_type.intValue == ENUM_ARTICLE_TYPE_ADVS_ADS) {
        return  [AdvertiseArticleCell getCellHeight];
    }
    if (article.news_type.intValue == 1) {
        if (indexPath.row == 0) {//large cell
            return 200;
        }
        return [NormalArticleCell getCellHeight];
    }else if (article.news_type.intValue == 2) {//recruit
        if (indexPath.row == 0) {//large cell
            return 240;
        }
        return [RecruitArticleCell getCellHeight];
    }
    return 0;//unknown
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *article = tableData[indexPath.row];
    if (article.news_type.intValue == ENUM_ARTICLE_TYPE_ADVS_ADS)
    {
        ADVSInstreamInfoModel *adItem = nil;
        for (ADVSInstreamInfoModel *obj in ADVItems) {
            if ([[obj valueForKeyPath:@"adId"] isEqualToString:article.articleID]) {
                adItem = obj;
                break;
            }
        }
        AdvertiseArticleCell *adsCell = [tableView dequeueReusableCellWithIdentifier:MTBurnAdsCellID];
        [adsCell applyStyleIfNeed];
        
        adsCell.lbAdsTitle.text = article.title;
        adsCell.lbAdsDes.text = article.overview;
        [adsCell.imgAdsImage sd_setImageWithURL:[NSURL URLWithString:article.imageUrl]];
        
        [adItem loadIconImage:adsCell.imgAdsImage completion:^(NSError *iconImageLoadError) {
            [instreamAdLoader measureImp:adItem];
            [adItem loadImage:adsCell.imgAdsImage completion:^(NSError *imageLoadError) {
                [instreamAdLoader measureImp:adItem];
                if (iconImageLoadError || imageLoadError) {
                    NSLog(@"error");
                } else {
                    NSLog(@"ok, start sending an impression log");
                    [instreamAdLoader measureImp:adItem];
                }
            }];
        }];
        
        return adsCell;
    }
    if (article.news_type.intValue == 1) {//force show article cell
        NormalArticleCell *normalCell = nil;
        ENUM_ARTICLE_CELL_TYPE cellType;
        if(indexPath.row == 0){//large cell
            normalCell = [tableView dequeueReusableCellWithIdentifier:NormalArticleLargeCellID];
            cellType = ENUM_ARTICLE_CELL_TYPE_LARGE;
        }else{
            normalCell = [tableView dequeueReusableCellWithIdentifier:NormalArticleCellID];
            cellType = ENUM_ARTICLE_CELL_TYPE_NORMAL;
        }
        [normalCell applyStyleIfNeed];
        
        [normalCell setObject:article type:cellType];
        
        return normalCell;
    }else if (article.news_type.intValue == 2) {
        RecruitArticleCell *cell = nil;
        ENUM_ARTICLE_CELL_TYPE cellType;
        if(indexPath.row == 0){//large cell
            cell = [tableView dequeueReusableCellWithIdentifier:RecruitArticleLargeCellID];
            cellType = ENUM_ARTICLE_CELL_TYPE_LARGE;
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:RecruitArticleCellID];
            cellType = ENUM_ARTICLE_CELL_TYPE_NORMAL;
        }
        [cell applyStyleIfNeed];
        
        [cell setObject:article type:cellType];
        
        return cell;

    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//to avoid crash
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleModel *article = tableData[indexPath.row];
    if (article.news_type.intValue == ENUM_ARTICLE_TYPE_ADVS_ADS)
    {
        ADVSInstreamInfoModel *adItem = nil;
        for (ADVSInstreamInfoModel *obj in ADVItems)
        {
            NSString *adID = [NSString stringWithFormat:@"%@ADVS",[obj valueForKeyPath:@"adId"]];
            if ([adID isEqualToString:article.articleID]) {
                adItem = obj;
                break;
            }
        }
        if (adItem) {
            [instreamAdLoader sendClickEvent:adItem];
        }
    }else{
        RecruitDetailViewController *vc = [RecruitDetailViewController new];
        vc.recruitItem = article;
        [vc setUpdateCommentCount:^(int adding) {
            ArticleModel *article = tableData[indexPath.row];
            [article updateNumberComment:adding];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mainTabViewController)]) {
            [[self.delegate mainTabViewController].navigationController pushViewController:vc animated:YES];
        }
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

-(void)doneLoadMoreData
{
    loadingMoreArticle = NO;
    [_loadMoreFooterView tableViewReloadFinished];
    [_loadMoreFooterView refreshLastUpdatedDate:[NSDate date]];
}

-(void)doneRefreshData
{
    refreshingArticle = NO;
    [self.tbArticles.pullToRefreshView stopAnimating];
    [self.tbArticles.pullToRefreshView setSubtitle:[Utils getUpdatedStringFromDate:[NSDate date]] forState:SVPullToRefreshStateAll];
}

- (BOOL)shouldLoadData:(BOOL)isLoadMore
{
    if (isLoadMore) {
        int numberArticle = tableData.count - ADVItems.count;
        if (numberArticle > 0 && !loadingMoreArticle && !refreshingArticle && !doneLoadMoreArticle)
            return YES;
        return NO;
    }else{
        if (!loadingMoreArticle && !refreshingArticle)
            return YES;
        return NO;
    }
}
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
{
    if ([self shouldLoadData:YES]) {
        int numberArticle = tableData.count - ADVItems.count;
        offset = numberArticle;
        loadingMoreArticle = YES;
        loadingMoreAds = YES;
        refreshingAds = !loadingMoreAds;
        [self loadData];
    }else{
        [self performSelector:@selector(doneLoadMoreData) withObject:nil afterDelay:0.3f];
    }
}

-(void)addAds
{
    if(!self.gumView && _bReadyAds)
    {
        self.gumView = [[ISGumView alloc] init];
        self.gumView.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, 110);
        self.gumView.backgroundColor = RGB(226, 231, 237);
        
        _scrollAdView = [AdCropsHScrollView create:_chkController.dataList delegate:self];
        _scrollAdView.frame = CGRectMake(0, 0, self.view.frame.size.width, 90);
        _scrollAdView.backgroundColor = [UIColor whiteColor]; // forDebug
        _scrollAdView.contentSize = CGSizeMake(_scrollAdView.contentSize.width, 90);
        [self.gumView addSubview:_scrollAdView];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame =CGRectMake(0, 90, self.view.frame.size.width, 20);
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(closeAds) forControlEvents:UIControlEventTouchUpInside];
        [self.gumView addSubview:_closeButton];
        
        [UIView animateWithDuration:0.3 animations:^{
             _tbArticles.tableHeaderView =  self.gumView;
        } completion:^(BOOL finished) {
            
        }];
       
    }
    
    
}
-(void)closeAds
{
    [UIView animateWithDuration:0.3 animations:^{
        _gumView.frame =CGRectMake(0.f, -110, self.view.frame.size.width, 110);
        [self.gumView removeFromSuperview];
        _gumView =nil;
        _tbArticles.tableHeaderView= nil;
    } completion:^(BOOL finished) {
       
    }];
    
    
}
- (void)viewDidAdcropsItem:(ChkRecordData *)recordData {
    if (!_chkController || !recordData) {
        NSLog(@"%s インプレッション送信に失敗。_chkController又はrecordDataがnilである", __PRETTY_FUNCTION__);
    } else {
        NSLog(@"%s インプレッション送信 %@", __PRETTY_FUNCTION__, [recordData debugDescription]);
        [_chkController sendImpression:recordData];
    }
}

#pragma mark - AdCrops ChkControllerDelegate
- (void)chkControllerDataListWithSuccess:(NSDictionary *)data {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, data);
    _bReadyAds =YES;
}

- (void)chkControllerDataListWithError:(NSError *)error {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, [error debugDescription]);
    _bReadyAds = NO;
}


@end
