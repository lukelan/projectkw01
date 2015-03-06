//
//  CompanyDetail_ProfileView.h
//  Giga
//
//  Created by vandong on 12/6/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_BaseSubView.h"

@class CompanyModel;
@interface CompanyDetail_ChartView : CompanyDetail_BaseSubView
@property (strong, nonatomic) CompanyModel *company;
@property(weak, nonatomic) IBOutlet UITableView             *tbv;

@property(strong, nonatomic) NSMutableArray                 *arData;

- (void)setDataWithDict:(NSDictionary *)dict;
@end

