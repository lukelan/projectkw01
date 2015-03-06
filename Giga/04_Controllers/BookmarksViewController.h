//
//  BookmarksViewController.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface BookmarksViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbBookmark;

@property (strong, nonatomic) IBOutlet UIView *noBookmarkView;
@property (weak, nonatomic) IBOutlet UILabel *lbNoBookmark;

@property (weak, nonatomic) id<TabViewProtocol> delegate;
@end
