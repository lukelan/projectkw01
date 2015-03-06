//
//  SearchCompanyViewController.m
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "ListCompanyCategoryViewController.h"
#import "CustomNavigationView.h"
#import "CompanyCategoryCell.h"
#import "CompanyCategoryModel.h"
#import "ListCompanyViewController.h"
#import "CompanyModel.h"
#import "SVPullToRefresh.h"
#import "MNMBottomPullToRefreshManager.h"
#import "NSString+Utilities.h"

#define CompanyCategoryCellID           @"CompanyCategoryCell"
#define DEFAULT_LIMIT                   20 //B/c there are a lot of data from server

@interface ListCompanyCategoryViewController ()<MNMBottomPullToRefreshManagerClient>
{
    CustomNavigationView *customNavigation;
    NSMutableArray *tableData;
    
    //refresh
    BOOL refreshing;
    
    //load more
    NSUInteger offset;
    BOOL loadingMore;
    MNMBottomPullToRefreshManager *_loadMoreFooterView;
}
@end

@implementation ListCompanyCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    offset = 0;
    tableData = [NSMutableArray array];
    [self loadData];
}

- (void)dealloc
{
    [tableData removeAllObjects];
    tableData = nil;
}

- (void)loadInterface
{
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
    
    //
    self.searchView.layer.cornerRadius = 5.0f;
    self.searchView.layer.borderWidth = 1.5f;
    self.searchView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.tfSearchField.font = NORMAL_FONT_WITH_SIZE(14);
    self.tfSearchField.placeholder = localizedString(@"Search by company name");
    
    [self.tbCategories registerNib:[UINib nibWithNibName:CompanyCategoryCellID bundle:nil] forCellReuseIdentifier:CompanyCategoryCellID];
    self.tbCategories.rowHeight = [CompanyCategoryCell getCellHeight];
    [self.tbCategories addPullToRefreshWithActionHandler:^{
        if ([self shouldLoadData:NO]) {
            offset = 0;
            [self loadData];
        }else{
            [self performSelector:@selector(doneRefreshData) withObject:nil afterDelay:0.3f];
        }
    }];
    self.tbCategories.backgroundColor = RGB(226, 231, 237);
    
    _loadMoreFooterView = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tbCategories withClient:self];
}

- (void)loadData
{
    [self.tbCategories endUpdates];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_COMPANY_CATEGORIES andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        NSMutableArray *listCategories = [NSMutableArray array];
        if (offset == 0) {
            [tableData removeAllObjects];
        }
        NSArray *result = responseObject;
        
        if ([result isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result) {
                CompanyCategoryModel *category = [CompanyCategoryModel initWithJsonData:dict];
                [listCategories addObject:category];
            }
        }
        
        [tableData addObjectsFromArray:listCategories];
        
        [self.tbCategories reloadData];
        [self doneLoadMoreData];
        [self doneRefreshData];
    } failureBlock:^(NSError *error) {
        [self doneLoadMoreData];
        [self doneRefreshData];
    }];
}

- (NSMutableArray*)groupCompanyByCategory:(NSMutableArray*)companies outputArray:(NSMutableArray*)result
{
    NSMutableArray *processItems = [NSMutableArray array];
    for (CompanyCategoryModel *category in result) {
        for (CompanyModel *company in companies) {
            if ([company.categoryName isEqual:category.categoryTitle]) {
                [category.companies addObject:company];
                [processItems addObject:company];
            }
        }
    }
    [companies removeObjectsInArray:processItems];
    
    //groupd by categoryTitle
    for (CompanyModel *company in companies) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryTitle = %@",company.categoryName];
        NSArray *items = [result filteredArrayUsingPredicate:predicate];
        if(items.count > 0){//has existed
            CompanyCategoryModel *category = items[0];
            [category.companies addObject:company];
        }else{
            CompanyCategoryModel *category = [[CompanyCategoryModel alloc] init];
            category.categoryTitle = company.categoryName;
            category.industry = company.industry;
            [category.companies addObject:company];
            [result addObject:category];
        }
    }
    return result;
}

- (IBAction)btnSearchTouchUpInside:(id)sender {
    if (self.tfSearchField.text.validString.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.tfSearchField.text.validString forKey:@"search"];
        [params setObject:@(0) forKey:@"offset"];
        [params setObject:@(DEFAULT_LIMIT) forKey:@"limit"];
        [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_SEARCH_COMPANY_BY_NAME andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
            NSArray *result = responseObject;
            if (result.count > 0) {
                NSMutableArray *listCompanies = [NSMutableArray array];
                if ([result isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in result) {
                        CompanyModel *cp = [CompanyModel initWithJsonData:dict];
                        [listCompanies addObject:cp];
                    }
                }
                NSMutableArray *searchResult = [NSMutableArray array];
                searchResult = [self groupCompanyByCategory:listCompanies outputArray:searchResult];
                
                ListCompanyViewController *tempVC = [[ListCompanyViewController alloc] init];
                tempVC.title = localizedString(@"Company Search Result");
                [self.navigationController pushViewController:tempVC animated:YES];
                [tempVC setTableData:searchResult searchKey:self.tfSearchField.text.validString];
            }else{
                [Utils showAlertViewWithTitle:@"" message:localizedString(@"There is no item for your search")];
            }
        } failureBlock:nil];
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CompanyCategoryCellID];
    [cell applyStyleIfNeed];
    
    CompanyCategoryModel *category = tableData[indexPath.row];
    [cell setObject:category];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyCategoryModel *category = tableData[indexPath.row];
    
    ListCompanyViewController *tempVC = [[ListCompanyViewController alloc] init];
    tempVC.title = localizedString(@"Company Search Result");
    [self.navigationController pushViewController:tempVC animated:YES];
    
    [tempVC setTableData:[NSMutableArray arrayWithObject:category] searchKey:nil];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [self btnSearchTouchUpInside:self.btnSearch];
    return YES;
}


#pragma mark - Load More

-(void)doneLoadMoreData {
    loadingMore = NO;
    [_loadMoreFooterView tableViewReloadFinished];
    [_loadMoreFooterView refreshLastUpdatedDate:[NSDate date]];
}

-(void)doneRefreshData {
    refreshing = NO;
    [self.tbCategories.pullToRefreshView stopAnimating];
    [self.tbCategories.pullToRefreshView setSubtitle:[Utils getUpdatedStringFromDate:[NSDate date]] forState:SVPullToRefreshStateAll];
}

- (int)numberCompanies
{
    int numberCompanies = 0;
    for (CompanyCategoryModel *category in tableData) {
        numberCompanies += category.companies.count;
    }
    return numberCompanies;
}
- (BOOL)shouldLoadData:(BOOL)isLoadMore
{
    if (isLoadMore) {
        if (tableData.count > 0 &&
            tableData.count % DEFAULT_LIMIT == 0 &&
            !loadingMore && !refreshing
            )
            return YES;
        return NO;
    }else{
        if (!loadingMore && !refreshing)
            return YES;
        return NO;
    }
}
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    if ([self shouldLoadData:YES]) {
        offset = tableData.count;
        loadingMore = YES;
        [self loadData];
    }else{
        [self performSelector:@selector(doneLoadMoreData) withObject:nil afterDelay:0.3f];
    }
}

@end
