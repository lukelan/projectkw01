//
//  ListCompanyViewController.m
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "ListCompanyViewController.h"
#import "CustomNavigationView.h"
#import "CompanyCell.h"
#import "CompanyModel.h"
#import "CompanyCategoryModel.h"
#import "CompanyDetailViewController.h"
#import "MNMBottomPullToRefreshManager.h"

#define CompanyCellID           @"CompanyCell"
#define SECTION_HEIGHT 30.0f
#define DEFAULT_LIMIT                   100

@interface ListCompanyViewController ()<UITableViewDataSource, UITableViewDelegate,MNMBottomPullToRefreshManagerClient>
{
    CustomNavigationView *customNavigation;
    
    //load more
    NSUInteger offset;
    BOOL loadingMore;
    MNMBottomPullToRefreshManager *_loadMoreFooterView;
}

@end

@implementation ListCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
}

- (void)dealloc
{
    [self.tableData removeAllObjects];
    self.tableData = nil;
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

    [self.tbCompanies registerNib:[UINib nibWithNibName:CompanyCellID bundle:nil] forCellReuseIdentifier:CompanyCellID];
    self.tbCompanies.rowHeight = [CompanyCell getCellHeight];
    self.tbCompanies.backgroundColor = RGB(226, 231, 237);
}

- (void)setTableData:(NSMutableArray *)tableData searchKey:(NSString*)str
{
    _tableData = tableData;
    self.searchKey = str;
    if (str) {
        int numberCompanies = [self numberCompanies];
        //if has more data
        if (numberCompanies > 0 &&
            numberCompanies % DEFAULT_LIMIT == 0){
        }
        [self.tbCompanies reloadData];
    }else{
        CompanyCategoryModel *category = [tableData lastObject];
        if (category) {
            
            _loadMoreFooterView = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.tbCompanies withClient:self];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:category.categoryID forKey:@"category_id"];
            [params setObject:@(offset) forKey:@"offset"];
            [params setObject:@(DEFAULT_LIMIT) forKey:@"limit"];
            [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_COMPANY_BY_CATEGORY andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
                NSMutableArray *listCompanies = [NSMutableArray array];
                NSArray *result = responseObject;
                
                if ([result isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in result) {
                        CompanyModel *cp = [CompanyModel initWithJsonData:dict];
                        [listCompanies addObject:cp];
                    }
                }
                category.companies = listCompanies;
                
                [self.tbCompanies reloadData];
                [self doneLoadMoreData];
            } failureBlock:^(NSError *error) {
                [self doneLoadMoreData];
            }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CompanyCategoryModel *category = self.tableData[section];
    return category.companies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:CompanyCellID];
    [cell applyStyleIfNeed];
    
    CompanyCategoryModel *category = self.tableData[indexPath.section];
    CompanyModel *company = category.companies[indexPath.row];
    [cell setObject:company];
    
    cell.shortLineBottom.hidden = indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    cell.lenghtLineBottom.hidden = !cell.shortLineBottom.hidden;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    }
    return SECTION_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, SECTION_HEIGHT-1)];
    label.opaque = YES;
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.font = NORMAL_FONT_WITH_SIZE(15);
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    
    CompanyCategoryModel *category = self.tableData[section];
    label.text = category.categoryTitle;
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(-20, SECTION_HEIGHT - 1, 400, 1)];
    lineImage.alpha = 0.8f;
    [lineImage setImage:[UIImage imageNamed:@"line-1"]];
    [view addSubview:lineImage];
    
    return view;
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
    CompanyCategoryModel *category = self.tableData[indexPath.section];
    CompanyModel *company = category.companies[indexPath.row];
    
    //load basic info
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:company.companyId forKey:@"code"];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_COMPANY_STOCK andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id stockData) {
        [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_COMPANY_INFO andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id companyInfoData) {
            if (stockData && companyInfoData) {
                CompanyDetailViewController *viewController = [[CompanyDetailViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
                viewController.company = company;
                viewController.stockData = stockData;
                viewController.infoData = companyInfoData;
            }
        } failureBlock:nil];
    } failureBlock:nil];
}


#pragma mark - Load More

-(void)doneLoadMoreData {
    loadingMore = NO;
    [_loadMoreFooterView tableViewReloadFinished];
    [_loadMoreFooterView refreshLastUpdatedDate:[NSDate date]];
}

- (int)numberCompanies
{
    int numberCompanies = 0;
    for (CompanyCategoryModel *category in self.tableData) {
        numberCompanies += category.companies.count;
    }
    return numberCompanies;
}

- (BOOL)shouldLoadData
{
    int numberCompanies = [self numberCompanies];
    if (numberCompanies > 0 &&
        numberCompanies % DEFAULT_LIMIT == 0 &&
        !loadingMore)
        return YES;
    return NO;
}

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    if ([self shouldLoadData]) {
        int numberCompanies = [self numberCompanies];
        offset = numberCompanies;
        loadingMore = YES;
        [self loadData];
    }else{
        [self performSelector:@selector(doneLoadMoreData) withObject:nil afterDelay:0.3f];
    }
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

- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.searchKey) {
        
    }else{
        [params setObject:@(offset) forKey:@"offset"];
        [params setObject:@(DEFAULT_LIMIT) forKey:@"limit"];
        [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_LIST_COMPANY andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
            NSMutableArray *listCompanies = [NSMutableArray array];
            NSArray *result = responseObject;
            
            if ([result isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in result) {
                    CompanyModel *cp = [CompanyModel initWithJsonData:dict];
                    [listCompanies addObject:cp];
                }
            }
            
            self.tableData = [self groupCompanyByCategory:listCompanies outputArray:self.tableData];
            
            [self.tbCompanies reloadData];
            [self doneLoadMoreData];
        } failureBlock:^(NSError *error) {
            [self doneLoadMoreData];
        }];
        
    }
}


@end
