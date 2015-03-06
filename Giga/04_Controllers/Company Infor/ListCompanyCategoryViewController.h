//
//  SearchCompanyViewController.h
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface ListCompanyCategoryViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,
UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
- (IBAction)btnSearchTouchUpInside:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfSearchField;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tbCategories;
@end
