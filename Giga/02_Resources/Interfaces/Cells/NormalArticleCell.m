//
//  NormalArticleCell.m
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "NormalArticleCell.h"
#import "ArticleModel.h"
#import "UIImageView+WebCache.h"
#import "UILabel+resizewithtext.h"

@implementation NormalArticleCell

+ (CGFloat)getCellHeight
{
    return 100;
}

- (void)applyStyleIfNeed
{
    if (isAppliedStyle) return;
    isAppliedStyle = YES;
    UIFont *lbFont = NORMAL_FONT_WITH_SIZE(12);
    self.lbNumberComments.font = self.btnCompany.titleLabel.font = lbFont;
    self.lbTitle.font = BOLD_FONT_WITH_SIZE(14);
    
    self.lbComments.text = localizedString(@"Comment");
    self.lbComments.font = NORMAL_FONT_WITH_SIZE(8);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)btnCompanyTouchUnInSide:(id)sender {
}

- (void)setObject:(id)obj
{
    [self setObject:obj type:ENUM_ARTICLE_CELL_TYPE_NORMAL];
}

- (void)setObject:(id)obj type:(ENUM_ARTICLE_CELL_TYPE)type
{
    [super setObject:obj];
    if ([obj isKindOfClass:[ArticleModel class]])
    {
        [self.activity startAnimating];
        ArticleModel *article = (ArticleModel*)obj;
        
        // setcolor base on number comment
        if (type == ENUM_ARTICLE_CELL_TYPE_NORMAL) {
            self.lbComments.textColor = [UIColor darkGrayColor];
            [self.btnCompany setTitleColor:HEX_COLOR_STRING(@"696969") forState:UIControlStateNormal];
            self.lbTitle.textColor = HEX_COLOR_STRING(@"696969");
        }else{
            self.lbTitle.textColor = self.lbComments.textColor = [UIColor whiteColor];
            [self.btnCompany setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        self.lbTitle.text = article.title;
        
        self.lbNumberComments.text = [NSString stringWithFormat:@"%d",article.numberComment.intValue];
        [self.btnCompany setTitle:article.siteName forState:UIControlStateNormal];
        if (article.numberComment.integerValue >= 50) {
            self.lbNumberComments.font = BOLD_FONT_WITH_SIZE(15);
        }else
            self.lbNumberComments.font = NORMAL_FONT_WITH_SIZE(13);
        
        int titleLeftMargin = 5;
        if (article.imageUrl && article.imageUrl.length > 0)
        {
            self.imgArticleImage.hidden = NO;
            if (type == ENUM_ARTICLE_CELL_TYPE_LARGE)
            {
                [self.imgArticleImage sd_setImageWithURL:[NSURL URLWithString:article.imageUrl] placeholderImage:[UIImage imageNamed:@"GIGA_place_holder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     [self.activity stopAnimating];
                }];
            }
            else
            {
                [self.imgArticleImage sd_setImageWithURL:[NSURL URLWithString:article.imageUrl] placeholderImage:[UIImage imageNamed:@"GIGA_place_holder1.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     [self.activity stopAnimating];
            }];
            }
           
            CGRect titleFrame = CGRectZero;
            if (type == ENUM_ARTICLE_CELL_TYPE_NORMAL) {
                titleFrame = RECT_WITH_X(self.lbTitle.frame, self.imgArticleImage.frame.origin.x + self.imgArticleImage.frame.size.width + titleLeftMargin);
                titleFrame = RECT_WITH_WIDTH(titleFrame, self.frame.size.width - titleFrame.origin.x - titleLeftMargin);
                
            }else{//large
                titleFrame = CGRectMake(titleLeftMargin, 1, self.frame.size.width - titleLeftMargin * 2, 50);
            }
            self.lbTitle.frame = titleFrame;
        }
        else
        {
            [self.activity stopAnimating];
            
             CGRect titleFrame = CGRectZero;
            if (type == ENUM_ARTICLE_CELL_TYPE_NORMAL) {
                //self.imgArticleImage.hidden = YES;
                //titleFrame = RECT_WITH_X(self.lbTitle.frame, titleLeftMargin);
                //titleFrame = RECT_WITH_WIDTH(titleFrame, self.frame.size.width - titleFrame.origin.x - titleLeftMargin);
                
                
                self.imgArticleImage.hidden = NO;
                self.imgArticleImage.image = [UIImage imageNamed:@"GIGA_place_holder1.png"];
                titleFrame = RECT_WITH_X(self.lbTitle.frame, self.imgArticleImage.frame.origin.x + self.imgArticleImage.frame.size.width + titleLeftMargin);
                titleFrame = RECT_WITH_WIDTH(titleFrame, self.frame.size.width - titleFrame.origin.x - titleLeftMargin);
                    
                
                
            }
            else{
                self.imgArticleImage.hidden = NO;
                self.imgArticleImage.image = [UIImage imageNamed:@"GIGA_place_holder.jpg"];
                titleFrame = CGRectMake(titleLeftMargin, 1, self.frame.size.width - titleLeftMargin * 2, 50);
            }
            self.lbTitle.frame = titleFrame;
        }
        CGRect r = self.headerLbl.frame;
        r.origin.x = self.lbTitle.frame.origin.x;
        self.headerLbl.frame = r;
        self.btnCompany.frame = RECT_WITH_X_WIDTH(self.btnCompany.frame, self.lbTitle.frame.origin.x,self.commentView.frame.origin.x - self.lbTitle.frame.origin.x - 5);
        
        //set background
        if (article.numberComment.integerValue > 0) {
            self.contentView.backgroundColor = [HEX_COLOR_STRING(@"f0f8ff") colorWithAlphaComponent:0.5f];
        }else{
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
    }
}

#define HOMETABLE_CELL_DESCRIPTION_MAX_HEIGHT 40.0f
#define HOMETABLE_CELL_DESCRIPTION_EXPAND_DELTA 10.0f

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect desRect = self.lbTitle.frame;
    CGSize desSize = [self.lbTitle.text sizeWithFont:self.lbTitle.font constrainedToSize:CGSizeMake(desRect.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    desRect.size.height = desSize.height > HOMETABLE_CELL_DESCRIPTION_MAX_HEIGHT ? HOMETABLE_CELL_DESCRIPTION_MAX_HEIGHT : desSize.height + HOMETABLE_CELL_DESCRIPTION_EXPAND_DELTA;
    self.lbTitle.frame = desRect;
}
@end
