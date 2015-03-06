//
//  CompanyDetail_ProfileView.m
//  Giga
//
//  Created by vandong on 12/6/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_ChartView.h"
#import "CompanyDetail_TextCell.h"
#import "CompanyDetail_BottomButtonView.h"
#import "UIImageView+WebCache.h"
#import "CompanyDetail_ChartCell.h"

#define CompanyDetail_ProfileViewCellIdentify       @"CompanyDetail_TextCell"

#define key_char_url                    @"key_char_url"

@interface CompanyDetail_ChartView() <UITableViewDataSource, UITableViewDelegate>
{
    float           heightOfChartCell;
    
    NSMutableArray         *arLineTitles;
 
    NSDictionary            *dictData;
    BOOL                    isSetData;
}
@end

@implementation CompanyDetail_ChartView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CompanyDetail_ChartView" owner:self options:nil] lastObject];
    self.frame = frame;
    [self.tbv registerNib:[UINib nibWithNibName:@"CompanyDetail_TextCell" bundle:nil] forCellReuseIdentifier:CompanyDetail_ProfileViewCellIdentify];
    //// sample data test
    arLineTitles = [NSMutableArray new];
    [arLineTitles addObject:@"前日終値"];
    [arLineTitles addObject:@"始値"];
    [arLineTitles addObject: @"高値"];
    [arLineTitles addObject: @"安値"];
    [arLineTitles addObject: @"出来高"];
    [arLineTitles addObject: @"売買代金"];
    [arLineTitles addObject: @"値幅制限"];
    [arLineTitles addObject: @"時価総額"];
    
//    NSMutableArray *ar = [NSMutableArray new];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"前日終値", key_title_value, @"水産品の貿易、加工、買い付け主力。 すしネタに強み。加工食品は業務用が 軸。海外加工比率高い",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"始値", key_title_value, @"水産商事50(3)、冷凍食品28(0)、 常温食品9(0)、物流サービス1(1)、 鰹・鮪13(2)、他0(11)(2014.",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"高値", key_title_value, @"〒107-0052 東京都港区赤坂３−３−５[周辺地図]",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"安値", key_title_value, @"03-5545-0701",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"出来高", key_title_value, @"水産・農林業",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"売買代金", key_title_value, @"ＫＹＯＫＵＹＯ　ＣＯ．，ＬＴＤ．",key_detail_value, nil]];
//    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"値幅制限", key_title_value, @"多田 久樹",key_detail_value, nil]];
//    
//    _arData = ar;
    
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
//        isSetData = YES;
    
    dictData = dict;
    NSMutableArray *ar = [NSMutableArray new];
    
    NSDictionary *dictLine = dict[@"last_close"];
    NSString *value = [NSString stringWithFormat:@"%@ %@", dictLine[@"value"], dictLine[@"date"]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"前日終値", key_title_value, value,key_detail_value, nil]];

    dictLine = dict[@"opening_price"];
    value = [NSString stringWithFormat:@"%@ %@", dictLine[@"value"], dictLine[@"date"]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"始値", key_title_value, value,key_detail_value, nil]];

    
    dictLine = dict[@"high_price"];
    value = [NSString stringWithFormat:@"%@ %@", dictLine[@"value"], dictLine[@"date"]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"高値", key_title_value, value,key_detail_value, nil]];

    dictLine = dict[@"low_price"];
    value = [NSString stringWithFormat:@"%@ %@", dictLine[@"value"], dictLine[@"date"]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"安値", key_title_value, value,key_detail_value, nil]];

    dictLine = dict[@"volume"];
    value = [NSString stringWithFormat:@"%@ %@", dictLine[@"value"], dictLine[@"date"]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"出来高", key_title_value, value,key_detail_value, nil]];

    dictLine = dict[@"trading_value"];
    value = [NSString stringWithFormat:@"%@ %@", dictLine[@"value"], dictLine[@"date"]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"売買代金", key_title_value, value,key_detail_value, nil]];

    dictLine = dict[@"daily_limit"];
    value = [NSString stringWithFormat:@"%@ %@", dictLine[@"value"], dictLine[@"date"]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"値幅制限", key_title_value, value,key_detail_value, nil]];
    
    dictLine = dict[@"market_capitalization"];
    value = [NSString stringWithFormat:@"%@ %@", dictLine[@"value"], dictLine[@"date"]];
    [ar addObject:[NSDictionary dictionaryWithObjectsAndKeys: @"時価総額", key_title_value, value,key_detail_value, nil]];
    
    if([dict.allKeys indexOfObject:@"chart_url"] != NSNotFound) {
        [ar insertObject:[NSDictionary dictionaryWithObjectsAndKeys:dict[@"chart_url"], key_char_url, nil] atIndex:0];
    }
    
    
    [self setArData:ar];
}
- (void)setArData:(NSMutableArray *)arData {
    [_arData removeAllObjects];
    _arData = arData;
    [_tbv reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arData.count > 0? _arData.count + 1: 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arData.count) {
        return 33;
    }
    NSDictionary *dict = _arData[indexPath.row];
    if (indexPath.row == 0 && [dict.allKeys indexOfObject:key_char_url] != NSNotFound)
        return heightOfChartCell == 0 ? 190 : heightOfChartCell;
    
    return [CompanyDetail_TextCell heightWithObject:dict];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _arData.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notecell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notecell"];
            cell.clipsToBounds = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *imv = [[UIImageView alloc] initWithFrame: CGRectMake(21, 10, 13, 13)];
            imv.image = [UIImage imageNamed:@"icon_oclock.png"];
            [cell addSubview:imv];
            
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(39, 6, 273, 21)];
            lb.font = NORMAL_FONT_WITH_SIZE(11);
            lb.text = @"時計アイコンがついている数値は、リアルタイムです。";
            [cell addSubview:lb];
        }
        return cell;
    }
    
    NSDictionary *dict = _arData[indexPath.row];
    if (indexPath.row == 0 && [dict.allKeys indexOfObject:key_char_url] != NSNotFound) {
        CompanyDetail_ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:[CompanyDetail_ChartCell description]];
        if (cell == nil) {
            cell = [[CompanyDetail_ChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CompanyDetail_ChartCell description]];
        }
        [cell setObject:nil];
        UIImageView *imvChart = cell.chartImageView;
        [imvChart sd_setImageWithURL:[NSURL URLWithString:dict[key_char_url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell setObject:image];
            if (heightOfChartCell == 0 && error == nil) {
                heightOfChartCell =  CGRectGetWidth(imvChart.frame) * image.size.height / image.size.width + 10;
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:100];
                [tableView endUpdates];
            }
        }];
        return cell;
    }
    
    CompanyDetail_TextCell *cell = (CompanyDetail_TextCell *)[tableView dequeueReusableCellWithIdentifier:CompanyDetail_ProfileViewCellIdentify];
    [cell applyStyleIfNeed];
    [cell setObject:dict];
//    [cell formatForPerformanceView];
    return cell;
}

@end
