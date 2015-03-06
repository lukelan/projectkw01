//
//  ListCompanyViewController.h
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@class CompanyCategoryModel;

@interface ListCompanyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tbCompanies;

@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSString *searchKey;
- (void)setTableData:(NSMutableArray *)tableData searchKey:(NSString*)str;
@end
