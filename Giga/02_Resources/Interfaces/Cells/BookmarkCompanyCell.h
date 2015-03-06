//
//  BookmarkCompanyCell.h
//  Giga
//
//  Created by Hoang Ho on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseCell.h"

@interface BookmarkCompanyCell : BaseCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCompany;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyDes;

@end
