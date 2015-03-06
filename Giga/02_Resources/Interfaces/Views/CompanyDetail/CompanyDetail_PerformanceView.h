//
//  CompanyDetail_PerformanceView.h
//  Giga
//
//  Created by Hoang Ho on 12/3/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_BaseSubView.h"

@class CompanyModel;
@interface CompanyDetail_PerformanceView : CompanyDetail_BaseSubView
@property (strong, nonatomic) CompanyModel *company;
@property(weak, nonatomic) IBOutlet UITableView                 *tbv;

@property (strong, nonatomic) NSDictionary *data;//contains tableData items;

@property(strong, nonatomic) NSMutableArray                 *tableData;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UILabel *centerLbl;

@property(strong, nonatomic) IBOutlet UIView                    *vSectionHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIImageView *iconLeftArrow;
- (IBAction)btnLeftTouchUpInside:(id)sender;
- (IBAction)btnRightTouchUpInside:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *iconRightArrow;
@end
