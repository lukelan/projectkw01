//
//  NotificationViewController.m
//  Giga
//
//  Created by Hoang Ho on 12/2/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "NotificationViewController.h"
#import "SVPullToRefresh.h"
#import "NotificationModel.h"
#import "ArticleModel.h"
#import "NotificationCell.h"
#import "RecruitDetailViewController.h"
#import "MNMBottomPullToRefreshManager.h"

#define NotificationCellID                          @"NotificationCell"

@interface NotificationViewController ()<MNMBottomPullToRefreshManagerClient>
{
    NSMutableArray *notifData;
    NSMutableArray *articleData;
    
    //refresh
    BOOL refreshingArticle;
    
    //load more
    int pageIndex;
    BOOL loadingMoreArticle;
    BOOL doneLoadMoreArticle;
    
    MNMBottomPullToRefreshManager *_loadMoreFooterView;
}
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex = 1;
    [self loadInterface];
    notifData = [NSMutableArray array];
    articleData = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([SharedUserData shouldRequestNotificationList]){
        [self loadNotificationData];
    }else{
        //load local data
        notifData = [NotificationModel getAllObjects];
        NSMutableArray *listIds = [NSMutableArray array];
        for (NotificationModel *ntf in notifData) {
            if (![listIds containsObject:ntf.articleID]) {
                [listIds addObject:ntf.articleID];
            }
        }
        for (NSString *artID in listIds) {
            ArticleModel *art = [ArticleModel getArticleByID:artID];
            if (art)
                [articleData addObject:art];
        }
        [self.tbNotifications reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //request notification data when app active/reactive
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc
{
    [notifData removeAllObjects];
    notifData = nil;
    [articleData removeAllObjects];
    articleData = nil;
}

- (void)loadInterface{
    [self.tbNotifications registerNib:[UINib nibWithNibName:NotificationCellID bundle:nil] forCellReuseIdentifier:NotificationCellID];
    self.tbNotifications.rowHeight = [NotificationCell getCellHeight];
    self.tbNotifications.backgroundColor = RGB(226, 231, 237);
    [self.tbNotifications addPullToRefreshWithActionHandler:^{
        doneLoadMoreArticle = NO;
        pageIndex = 1;
        if (!refreshingArticle && !loadingMoreArticle) {
            SharedUserData.loadedNotificationList = NO;
            [SharedUserData getNotificationCount];
            [self loadNotificationData];
        }else{
            [self performSelector:@selector(doneRefreshData) withObject:nil afterDelay:0.3f];
        }
    }];
    
    _loadMoreFooterView = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tbNotifications withClient:self];
}

- (void)appDidBecomActive:(NSNotification*)ntf
{
    SharedUserData.loadedNotificationList = NO;
    pageIndex = 1;
    [self loadNotificationData];
}

- (void)loadNotificationData{
    if ([SharedUserData shouldRequestNotificationList]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(pageIndex) forKey:@"page"];
//        [params setObject:@"" forKey:@"last_notif_id"];
        if (SharedUserData.userID) [params setObject:SharedUserData.userID forKey:@"client_id"];
        [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_NOTIFICATION_LIST andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {

            if (pageIndex == 1) {
                //delete old ntfs first
                [NotificationModel deleteAllObjects];
            }
            
            NSArray *data = responseObject;
            if (data.count > 0) {
                doneLoadMoreArticle = NO;
                for (NSDictionary *dict in data) {
                    [NotificationModel initWithJsonData:dict];
                }
                notifData = [NotificationModel getAllObjects];
                [self getListArticlesDetail1];
                [self.tbNotifications reloadData];
            }else{
                notifData = [NotificationModel getAllObjects];
                doneLoadMoreArticle = YES;
                [self doneLoadData];
            }
            SharedUserData.loadedNotificationList = YES;
        } failureBlock:^(NSError *error) {
            [self doneLoadData];
        }];
    }else{
        [self doneLoadData];
    }
}

- (void)doneLoadData
{
    [self doneRefreshData];
    [self doneLoadMoreData];
}
//get_article_by_ids
- (void)getListArticlesDetail1
{
    NSMutableArray *tempData = [NSMutableArray array];
    NSMutableArray *listIds = [NSMutableArray array];
    for (NotificationModel *ntf in notifData) {
        if (![listIds containsObject:ntf.articleID]) {
            [listIds addObject:ntf.articleID];
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[listIds componentsJoinedByString:@","] forKey:@"article_ids"];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_ARTICLES_BY_IDS andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
         NSArray *data = responseObject;
        if (data.count > 0) {
            for (NSDictionary *dict in data) {
                ArticleModel *article = [ArticleModel insertArticleFromJsonData:dict isBookmark:YES jobType:SharedUserData.curFilterJobType];
                [tempData addObject:article];
                
                //update title for notification model
                for (int i = 0; i < notifData.count; i++) {
                    NotificationModel *nt = notifData[i];
                    if([nt.articleID isEqualToString:article.articleID]){
                        nt.notifTitle = article.title;
                    }
                }
                
                //valid article
                [listIds removeObject:article.articleID];
            }
            
            //sync data
            //check invalid articles
            for (NSString *artID in listIds) {
                ArticleModel *art = [ArticleModel getArticleByID:artID];
                if(art){
                    [art MR_deleteEntity];
//                    [SharedDataCenter.managedObjectContext deleteObject:art];
                }
                
                //also delete notification data
                NSArray *ntfs = [NotificationModel getNotificationByArticleID:artID];
                for (id obj in ntfs) {
                    [obj MR_deleteEntity];
//                    [SharedDataCenter.managedObjectContext deleteObject:obj];
                }
            }
            [SharedDataCenter saveContext];
            
            articleData = tempData;
            notifData = [NotificationModel getAllObjects];
            
            //update notification count
            [SharedUserData updateNotificationCount:(int)notifData.count shouldPostNotification:YES];
            [self.tbNotifications reloadData];
            [self doneLoadData];
        }
        else{
            [self doneLoadData];
        }
    } failureBlock:nil];
}


//get_article_by_id
- (void)getListArticlesDetail2
{
    NSMutableArray *listArticles = [NSMutableArray array];
    NSMutableArray *tempData = [NSMutableArray array];
    
    for (NotificationModel *ntf in notifData) {
        if (![listArticles containsObject:ntf.notifID]) {
            [listArticles addObject:ntf.notifID];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:ntf.articleID forKey:@"article_id"];
            [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_ARTICLE_DETAIL andPostMethodKind:YES andParams:params inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
                NSArray *data = responseObject;
                if (data.count > 0) {
                    NSDictionary *dict = data[0];
                    ArticleModel *article = [ArticleModel insertArticleFromJsonData:dict isBookmark:YES jobType:SharedUserData.curFilterJobType];
                    [tempData addObject:article];
                    
                    //update title for notification model
                    for (int i = 0; i < notifData.count; i++) {
                        NotificationModel *nt = notifData[i];
                        if([nt.articleID isEqualToString:article.articleID]){
                            nt.notifTitle = article.title;
                        }
                    }
                    if (tempData.count == notifData.count) {
                        articleData = tempData;
                        [self.tbNotifications reloadData];
                       [self doneLoadData];
                    }
                }else{
                    [self doneLoadData];
                }
            } failureBlock:^(NSError *error) {
                [self doneLoadData];
            }];
        }
    }
}

-(void)doneRefreshData {
    refreshingArticle = NO;
    [self.tbNotifications.pullToRefreshView stopAnimating];
    [self.tbNotifications.pullToRefreshView setSubtitle:[Utils getUpdatedStringFromDate:[NSDate date]] forState:SVPullToRefreshStateAll];
}


#pragma mark - Load More

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    
    if (!loadingMoreArticle && !doneLoadMoreArticle && !refreshingArticle) {
        pageIndex++;
        loadingMoreArticle = YES;
        SharedUserData.loadedNotificationList = NO;
        [self loadNotificationData];
    }else{
        [self performSelector:@selector(doneLoadMoreData) withObject:nil afterDelay:0.3f];
    }
}

-(void)doneLoadMoreData {
    loadingMoreArticle = NO;
    [_loadMoreFooterView tableViewReloadFinished];
    [_loadMoreFooterView refreshLastUpdatedDate:[NSDate date]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notifData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NotificationCellID];
    [cell applyStyleIfNeed];
    
    NotificationModel *ntf = notifData[indexPath.row];
    [cell setObject:ntf];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_loadMoreFooterView relocatePullToRefreshView];
    
    [_loadMoreFooterView tableViewScrolled];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_loadMoreFooterView tableViewReleased];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationModel *ntf = notifData[indexPath.row];
    if (!ntf.isRead.boolValue) {
//        //I read it
//        //set first
        ntf.isRead = @(YES);
        [SharedDataCenter saveContext];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:ntf.notifID forKey:@"notif_id"];
        if (SharedUserData.userID) [params setObject:SharedUserData.userID forKey:@"client_id"];
        [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_READ_NOTIFICATION andPostMethodKind:YES andParams:params inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
            int ntfCount = SharedUserData.ntfCount - 1;
            if (ntfCount <= 0) ntfCount = 0;
            [SharedUserData updateNotificationCount:ntfCount shouldPostNotification:YES];
        } failureBlock:nil];
    }
    
    if (indexPath.row < notifData.count) {
        ArticleModel *article = nil;
        for (ArticleModel *obj in articleData) {
            if([obj.articleID isEqualToString:ntf.articleID])
                article = obj;
        }
        
        if (!article) {
            //find in db
            article = [ArticleModel getArticleByID:ntf.articleID];
        }
        if (article) {
            //view article
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:article.articleID forKey:@"article_id"];
            [params setObject:SharedUserData.userID forKey:@"client_id"];

            [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_VIEW_ARTICLE andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
                RecruitDetailViewController *vc = [RecruitDetailViewController new];
                vc.recruitItem = article;
                [vc setUpdateCommentCount:^(int adding) {
                    [article updateNumberComment:adding];
                }];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(mainTabViewController)]) {
                    [[self.delegate mainTabViewController].navigationController pushViewController:vc animated:YES];
                }
                
            } failureBlock:^(NSError *error) {
                RecruitDetailViewController *vc = [RecruitDetailViewController new];
                vc.recruitItem = article;
                if (self.delegate && [self.delegate respondsToSelector:@selector(mainTabViewController)]) {
                    [[self.delegate mainTabViewController].navigationController pushViewController:vc animated:YES];
                }
                
            }];
        }
    }
}
@end
