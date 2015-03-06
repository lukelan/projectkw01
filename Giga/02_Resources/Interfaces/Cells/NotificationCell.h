//
//  NotificationCell.h
//  Giga
//
//  Created by Hoang Ho on 12/2/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseCell.h"

@interface NotificationCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@end
