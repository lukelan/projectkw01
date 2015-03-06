//
//  NotificationViewController.h
//  Giga
//
//  Created by Hoang Ho on 12/2/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface NotificationViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbNotifications;
@property (weak, nonatomic) id<TabViewProtocol> delegate;
- (void)loadNotificationData;
@end
