//
//  AdvertiseArticleCell.h
//  Giga
//
//  Created by Hoang Ho on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseCell.h"

@interface AdvertiseArticleCell : BaseCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAdsImage;
@property (weak, nonatomic) IBOutlet UILabel *lbAdsDes;
@property (weak, nonatomic) IBOutlet UILabel *lbAdsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbAdsSource;

@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *lbComments;
@property (weak, nonatomic) IBOutlet UILabel *lbNumberComments;

@end
