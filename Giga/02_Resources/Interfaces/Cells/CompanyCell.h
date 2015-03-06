//
//  CompanyCell.h
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseCell.h"

@interface CompanyCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyDes;
@property (weak, nonatomic) IBOutlet UIImageView *imgCompanyLogo;
@property (weak, nonatomic) IBOutlet UIImageView *shortLineBottom;
@property (weak, nonatomic) IBOutlet UIImageView *lenghtLineBottom;


@end
