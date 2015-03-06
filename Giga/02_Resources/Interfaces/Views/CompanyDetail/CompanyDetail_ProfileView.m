//
//  CompanyDetail_ProfileView.m
//  Giga
//
//  Created by vandong on 12/6/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_ProfileView.h"
#import "CompanyDetail_TextCell.h"
#import "CompanyDetail_BottomButtonView.h"
#import "WebDetailViewController.h"

#define CompanyDetail_ProfileViewCellIdentify       @"CompanyDetail_TextCell"

@interface CompanyDetail_ProfileView() <UITableViewDataSource, UITableViewDelegate>
{
    BOOL        isSetData;
    NSDictionary *dictData;
}
@end

@implementation CompanyDetail_ProfileView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CompanyDetail_ProfileView" owner:self options:nil] lastObject];
    self.frame = frame;
    [self.tbv registerNib:[UINib nibWithNibName:@"CompanyDetail_TextCell" bundle:nil] forCellReuseIdentifier:CompanyDetail_ProfileViewCellIdentify];

    //// sample data test
    
    NSMutableArray *ar = [NSMutableArray new];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"特色", key_title_value, @"水産品の貿易、加工、買い付け主力。 すしネタに強み。加工食品は業務用が 軸。海外加工比率高い",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"連結事業", key_title_value, @"水産商事50(3)、冷凍食品28(0)、 常温食品9(0)、物流サービス1(1)、 鰹・鮪13(2)、他0(11)(2014.",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"本社所在地", key_title_value, @"〒107-0052 東京都港区赤坂３−３−５[周辺地図]",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"電話番号", key_title_value, @"03-5545-0701",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"業種分類", key_title_value, @"水産・農林業",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"英文社名", key_title_value, @"ＫＹＯＫＵＹＯ　ＣＯ．，ＬＴＤ．",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"代表者名", key_title_value, @"多田 久樹",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"設立年月日", key_title_value, @"1937年9月3日",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"市場名", key_title_value, @"東証1部",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"上場年月日", key_title_value, @"1949年5月",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"決算", key_title_value, @"3月末日",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"単元株数", key_title_value, @"1,000株",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"従業員数（単独）", key_title_value, @"564人",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"従業員数（連結）", key_title_value, @"2,111人",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"平均年齢", key_title_value, @"39.7歳",key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"平均年収", key_title_value, @"6,700千円",key_detail_value, nil]];
    
    _arData = ar;
    
    CompanyDetail_BottomButtonView *footer = [CompanyDetail_BottomButtonView new];
    footer.delegate = self;
    
    self.tbv.tableFooterView = footer;
    self.tbv.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    return self;
}

- (void)setCompany:(CompanyModel *)company
{
    _company = company;
    CompanyDetail_BottomButtonView *footer = (CompanyDetail_BottomButtonView*)self.tbv.tableFooterView;
    if (footer && [footer isMemberOfClass:[CompanyDetail_BottomButtonView class]]) {
        [footer setCompany:company];
    }
}
- (void)setDataWithDict:(NSDictionary *)dict {
    if (isSetData == YES) return;
//    isSetData = YES;
    dictData = dict;
    
    NSMutableArray *ar = [NSMutableArray new];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"特色", key_title_value, dict[@"characteristic"],key_detail_value, nil]];//
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"連結事業", key_title_value, dict[@"consolidated_business"],key_detail_value, nil]];//
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"本社所在地", key_title_value, dict[@"headquarters"],key_detail_value, nil]];//
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"電話番号", key_title_value, dict[@"phone_number"],key_detail_value, nil]];//
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"業種分類", key_title_value, dict[@"industry_classification"],key_detail_value, nil]];//
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"英文社名", key_title_value, dict[@"english_club_name"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"代表者名", key_title_value, dict[@"representative_name"],key_detail_value, nil]];//
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"設立年月日", key_title_value, dict[@"establishment_date"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"市場名", key_title_value, dict[@"market_name"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"上場年月日", key_title_value, dict[@"listing_date"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"決算", key_title_value, dict[@"closing"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"単元株数", key_title_value, dict[@"unit_shares"],key_detail_value, nil]];//
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"従業員数（単独）", key_title_value, dict[@"number_alone_employees"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"従業員数（連結）", key_title_value, dict[@"number_consolidated_employees"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"平均年齢", key_title_value, dict[@"average_age_range"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"平均年収", key_title_value, dict[@"average_annual_salary"],key_detail_value, nil]];
//nearest_station
    
    [self setArData:ar];
}
- (void)setArData:(NSMutableArray *)arData {
    [_arData removeAllObjects];
    _arData = arData;
    [_tbv reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _arData[indexPath.row];
    return [CompanyDetail_TextCell heightWithObject:dict];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyDetail_TextCell *cell = (CompanyDetail_TextCell *)[tableView dequeueReusableCellWithIdentifier:CompanyDetail_ProfileViewCellIdentify];
    [cell applyStyleIfNeed];
    NSDictionary *dict = _arData[indexPath.row];
    [cell setObject:dict];
//    [cell formatForProfileView];
    return cell;
}

@end
