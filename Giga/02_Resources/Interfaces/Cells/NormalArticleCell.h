//
//  NormalArticleCell.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseCell.h"

@interface NormalArticleCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgArticleImage;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCompany;
- (IBAction)btnCompanyTouchUnInSide:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;


@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UILabel *lbComments;
@property (weak, nonatomic) IBOutlet UILabel *lbNumberComments;

- (void)setObject:(id)obj type:(ENUM_ARTICLE_CELL_TYPE)type;

@end
