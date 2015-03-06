//
//  ListCompanyInfoViewController.h
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface ListCompanyInfoViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UILabel *lbSearchCompany;
- (IBAction)btnSearchCompanyTouchUpInside:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tbCompanyInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbBookmarkCompanies;


@property (weak, nonatomic) id<TabViewProtocol> delegate;

@property (nonatomic, weak) IBOutlet UILabel *current_time;
@property (nonatomic, weak) IBOutlet UILabel *stock;
@property (nonatomic, weak) IBOutlet UILabel *stock1;

@end

