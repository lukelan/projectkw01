//
//  ArticleViewController.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleCategoryModel;

@interface ArticleViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) ArticleCategoryModel *category;
@property (assign, nonatomic) BOOL isTopic;//only for topic tab
@property (assign, nonatomic) BOOL isNeedReloadData; // reload data when active

@property (weak, nonatomic) IBOutlet UITableView *tbArticles;
@property (copy, nonatomic) void (^completeRequest)(BOOL isSuccess);
@property (weak, nonatomic) id<TabViewProtocol> delegate;

- (void)loadData;
- (void)reloadData;
@end

