//
//  CompanyDetail_RelatedCompanyView.m
//  Giga
//
//  Created by Hoang Ho on 12/3/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_RelatedCompanyView.h"
#import "CompanyCell.h"
#import "CompanyModel.h"
#import "CompanyCategoryModel.h"
#import "CompanyDetail_BottomButtonView.h"

#define CompanyCellID           @"CompanyCell"
#define DEFAULT_LIMIT           20

@interface CompanyDetail_RelatedCompanyView(){
    //load more
    NSUInteger offset;
    BOOL loadingMore;
}
@end
@implementation CompanyDetail_RelatedCompanyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CompanyDetail_RelatedCompanyView" owner:self options:nil] lastObject];
    self.frame = frame;
    [self.tbCompanies registerNib:[UINib nibWithNibName:CompanyCellID bundle:nil] forCellReuseIdentifier:CompanyCellID];
    self.tbCompanies.backgroundColor = RGB(226, 231, 237);
    
    CompanyDetail_BottomButtonView *footer = [CompanyDetail_BottomButtonView new];
    footer.delegate = self;
    
    self.tbCompanies.tableFooterView = footer;
    
    self.tableData = [NSMutableArray array];
    self.tbCompanies.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    return self;
}

- (void)setTableData:(NSMutableArray *)tableData
{
    _tableData = tableData;
    [self.tbCompanies reloadData];
}

- (void)setCompany:(CompanyModel *)company
{
    _company = company;
    CompanyDetail_BottomButtonView *footer = (CompanyDetail_BottomButtonView*)self.tbCompanies.tableFooterView;
    footer.delegate = self;
    if (footer && [footer isMemberOfClass:[CompanyDetail_BottomButtonView class]]) {
        [footer setCompany:company];
    }
}

- (void)loadData
{
    //load sample data
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(offset) forKey:@"offset"];
    [params setObject:@(DEFAULT_LIMIT) forKey:@"limit"];

    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_LIST_COMPANY andPostMethodKind:YES andParams:params inView:self shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        NSMutableArray *listCompanies = [NSMutableArray array];
        if (offset == 0) {
            [self.tableData removeAllObjects];
        }
        NSArray *result = responseObject;
        
        if ([result isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in result) {
                CompanyModel *cp = [CompanyModel initWithJsonData:dict];
                [listCompanies addObject:cp];
            }
        }
        
        [self.tableData addObjectsFromArray:listCompanies];
        
        [self.tbCompanies reloadData];
        loadingMore = NO;
    } failureBlock:^(NSError *error) {
        loadingMore = NO;
    }];
}

- (void)dealloc
{
    [self.tableData removeAllObjects];
    self.tableData = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < self.tableData.count ?  [CompanyCell getCellHeight] : 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
    return self.tableData.count + 1;//load more
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.tableData.count) {
        CompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:CompanyCellID];
        [cell applyStyleIfNeed];
//        cell.shortLineBottom.hidden = NO;
        cell.lenghtLineBottom.hidden = YES;
        CompanyModel *company = self.tableData[indexPath.row];
        [cell setObject:company];
        return cell;
    }else{//load more cell
        static NSString *CELLID = @"CELLID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.tag = 1234;
            [imageView setImage:[UIImage imageNamed:@"see-more"]];
            [cell.contentView addSubview:imageView];
            [cell.contentView bringSubviewToFront:imageView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.tableData.count){
        CompanyModel *company = self.tableData[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(RelatedCompanyViewDidSelectCompany:)]) {
            [self.delegate RelatedCompanyViewDidSelectCompany:company];
        }
    }else{
        if (!loadingMore) {
            offset = self.tableData.count;
            [self loadData];
        }
    }
}
@end
