//
//  CompanyDetail_PerformanceView.m
//  Giga
//
//  Created by Hoang Ho on 12/3/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_PerformanceView.h"
#import "CompanyDetail_TextCell.h"
#import "CompanyDetail_BottomButtonView.h"

#define CompanyCellID       @"CompanyDetail_TextCell"

@interface CompanyDetail_PerformanceView()<UITableViewDataSource, UITableViewDelegate>
{
    NSUInteger currentItemIndex;
}
@end

@implementation CompanyDetail_PerformanceView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CompanyDetail_PerformanceView" owner:self options:nil] firstObject];
    self.frame = frame;
    [self.tbv registerNib:[UINib nibWithNibName:@"CompanyDetail_TextCell" bundle:nil] forCellReuseIdentifier:CompanyCellID];
    currentItemIndex = 0;
    
//    //// sample data test
//    
//    NSMutableArray *ar = [NSMutableArray new];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"決算期", key_title_value, @"2014年3月期",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"会計方式", key_title_value, @"日本方式",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"決算発表日", key_title_value, @"2014年5月9日",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"決算月数", key_title_value, @"12か月",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"売上高", key_title_value, @"202,387百万円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"営業利益", key_title_value, @"2,915百万円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"経常利益", key_title_value, @"2,985百万円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"当期利益", key_title_value, @"2,968百万円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"EPS（一株当たり利益）", key_title_value, @"28.26円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"調整一株当たり利益", key_title_value, @"27.55円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"BPS（一株当たり純資産）", key_title_value, @"187.57円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"総資産", key_title_value, @"84,319百万円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"自己資本", key_title_value, @"19,701百万円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"資本金", key_title_value, @"5,664百万円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"有利子負債", key_title_value, @"41,731百万円",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"自己資本比率", key_title_value, @"23.4%",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ROA（総資産利益率）", key_title_value, @"3.54%",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ROE（自己資本利益率）", key_title_value, @"15.56%",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"総資産経常利益率", key_title_value, @"3.56%",key_detail_value, nil]];
//    
//    _tableData = ar;
    
    CompanyDetail_BottomButtonView *footer = [CompanyDetail_BottomButtonView new];
    footer.delegate = self;
    
    self.tbv.tableFooterView = footer;
    self.tbv.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    
    self.btnLeft.titleLabel.font = BOLD_FONT_WITH_SIZE(14);
    self.btnRight.titleLabel.font = BOLD_FONT_WITH_SIZE(14);
    self.centerLbl.font = BOLD_FONT_WITH_SIZE(14);
    return self;
}

- (void)setData:(NSDictionary *)data
{
    _data =data;
    [self updateDataIndex:0];
}

- (void)updateDataIndex:(NSUInteger)nIndex
{
    currentItemIndex = nIndex;
     NSDictionary *dict = nil;
    if (currentItemIndex == 0) {
        dict = self.data[@"prophase"];
        self.btnLeft.hidden = YES;
        self.btnRight.hidden = NO;
        [self.btnRight setTitle:[NSString stringWithFormat:@"2期前"] forState:UIControlStateNormal];
        self.centerLbl.text = @"期前";
    }else if (currentItemIndex == 1){
        dict = self.data[@"previous1"];
        self.btnLeft.hidden = NO;
        self.btnRight.hidden = NO;
        [self.btnRight setTitle:[NSString stringWithFormat:@"3期前"] forState:UIControlStateNormal];
        [self.btnLeft setTitle:[NSString stringWithFormat:@"期前"] forState:UIControlStateNormal];
        self.centerLbl.text = @"2期前";
    }else if (currentItemIndex == 2){
        dict = self.data[@"previous2"];
        self.btnLeft.hidden = NO;
        self.btnRight.hidden = YES;
        [self.btnLeft setTitle:[NSString stringWithFormat:@"2期前"] forState:UIControlStateNormal];
        self.centerLbl.text = @"3期前";
    }
    self.iconLeftArrow.hidden =self.btnLeft.hidden;
    self.iconRightArrow.hidden = self.btnRight.hidden;
    self.tableData = [self parseDictToTableData:dict];
}


//決算期 : Accounting period
//会計方式 : Accounting method
//決算発表日 : Earnings announcement date
//決算月数 : Closing months
//売上高 : Sales figures
//営業利益 :Operating income
//経常利益 :Ordinary income
//当期利益: Net income
//EPS（一株当たり利益）: EPS (earnings per share)
//調整一株当たり利益 : Adjust earnings per share
//BPS（一株当たり純資産）: BPS (net assets per share)
//総資産 : Total assets
//自己資本 : Shareholders' equity
//資本金 : Capital
//有利子負債 : Interest-bearing debt
//自己資本比率 : Capital adequacy ratio
//ROA（総資産利益率）: ROA (return on assets ratio)
//ROE（自己資本利益率）: ROE (return on equity)
//総資産経常利益率 : Ordinary income to total assets ratio

- (NSMutableArray*)parseDictToTableData:(NSDictionary*)dict
{
    if (!dict) {
        return nil;
    }
    dict = [Utils repairingDictionaryWith:dict];
    NSMutableArray *ar = [NSMutableArray new];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"決算期", key_title_value, dict[@"accounting_period"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"会計方式", key_title_value, dict[@"accounting_method"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"決算発表日", key_title_value, dict[@"earnings_announcement_date"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"決算月数", key_title_value, dict[@"closing_months"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"売上高", key_title_value, dict[@"bai_high"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"営業利益", key_title_value, dict[@"operating_income"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"経常利益", key_title_value, dict[@"profit_or_interestd"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"当期利益", key_title_value, dict[@"often_benefit"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"EPS（一株当たり利益）", key_title_value, dict[@"earnings_per_share"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"調整一株当たり利益", key_title_value, dict[@"adjust_earnings_per_share"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"BPS（一株当たり純資産）", key_title_value, dict[@"net_assets_per_share"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"総資産", key_title_value, dict[@"total_assets"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"自己資本", key_title_value, dict[@"shareholders_equity"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"資本金", key_title_value, dict[@"capital"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"有利子負債", key_title_value, dict[@"interest_bearing_debt"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"自己資本比率", key_title_value, dict[@"own_capital_interest_rate"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ROA（総資産利益率）", key_title_value, dict[@"return_on_assets_ratio"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ROE（自己資本利益率）", key_title_value, dict[@"capital_adequacy_ratio"],key_detail_value, nil]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"総資産経常利益率", key_title_value, dict[@"ordinary_income_to_total_assets_ratio"],key_detail_value, nil]];
    
    return ar;
}

- (void)setCompany:(CompanyModel *)company
{
    _company = company;
    CompanyDetail_BottomButtonView *footer = (CompanyDetail_BottomButtonView*)self.tbv.tableFooterView;
    if (footer && [footer isMemberOfClass:[CompanyDetail_BottomButtonView class]]) {
        [footer setCompany:company];
    }
}

- (void)setTableData:(NSMutableArray *)tableData
{
    _tableData = tableData;
    [_tbv reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.vSectionHeader.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.vSectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _tableData[indexPath.row];
    return [CompanyDetail_TextCell heightWithObject:dict];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyDetail_TextCell *cell = (CompanyDetail_TextCell *)[tableView dequeueReusableCellWithIdentifier:CompanyCellID];
    [cell applyStyleIfNeed];
    NSDictionary *dict = _tableData[indexPath.row];
    [cell setObject:dict];
    [cell formatForPerformanceView];
    return cell;
}

- (IBAction)btnLeftTouchUpInside:(id)sender {
    [self updateDataIndex:currentItemIndex-1];
}

- (IBAction)btnRightTouchUpInside:(id)sender {
    [self updateDataIndex:currentItemIndex+1];
}
@end
