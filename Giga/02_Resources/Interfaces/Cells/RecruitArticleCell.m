//
//  RecruitArticleCell.m
//  Giga
//
//  Created by Hoang Ho on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "RecruitArticleCell.h"
#import "ArticleModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation RecruitArticleCell

+ (CGFloat)getCellHeight
{
    return 110;
}

- (void)applyStyleIfNeed{
    if (isAppliedStyle) {
        return;
    }
    isAppliedStyle = YES;
    self.lbCompanyDes.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbCompanyName.font = BOLD_FONT_WITH_SIZE(13);
    self.lbRecruitType.font = NORMAL_FONT_WITH_SIZE(12);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lbComments.text = localizedString(@"Comment");
    self.lbComments.font = NORMAL_FONT_WITH_SIZE(8);
    
    self.btnIsNew.layer.cornerRadius = 2.0f;
    self.btnIsNew.layer.masksToBounds = YES;
    
    self.btnJobType.layer.cornerRadius = 2.0f;
    self.btnJobType.layer.masksToBounds = YES;
    self.btnJobType.titleLabel.minimumScaleFactor = 0.6f;
    self.btnJobType.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.btnEX.layer.cornerRadius = 4.0f;
    self.btnEX.layer.masksToBounds = YES;
//    self.btnCompany.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.btnCompany.imageView.clipsToBounds = YES;
}

- (void)setObject:(id)obj
{
    [self setObject:obj type:ENUM_ARTICLE_CELL_TYPE_NORMAL];
}

- (void)setObject:(id)obj type:(ENUM_ARTICLE_CELL_TYPE)type
{
    [super setObject:obj];
    ArticleModel *art = obj;

    self.lbCompanyName.text = art.company_name;
    self.lbCompanyDes.text = art.title;
    self.lbRecruitType.text = art.recruiting_target;

    if (art.logo_site && art.logo_site.length > 0) {
        self.btnCompany.hidden = NO;
        [self.btnCompany sd_setBackgroundImageWithURL:[NSURL URLWithString:art.logo_site]  forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error == nil) {
                self.btnCompany.frame = RECT_WITH_WIDTH(self.btnCompany.frame, self.btnCompany.frame.size.height * image.size.width / image.size.height);
            }

        }];
    }else
        self.btnCompany.hidden = YES;

    // setcolor base on number comment
    if (type == ENUM_ARTICLE_CELL_TYPE_NORMAL) {
        self.lbComments.textColor = [UIColor grayColor];
        [self.btnCompany setTitleColor:HEX_COLOR_STRING(@"696969") forState:UIControlStateNormal];
        self.lbCompanyName.textColor = self.lbCompanyDes.textColor = HEX_COLOR_STRING(@"696969");
    }else{
        self.lbCompanyDes.textColor = self.lbCompanyName.textColor = [UIColor whiteColor];
        self.lbComments.textColor = [UIColor grayColor];
        [self.btnCompany setTitleColor:HEX_COLOR_STRING(@"696969") forState:UIControlStateNormal];
    }
    
    
    if (art.numberComment.integerValue >= 50) {
        self.lbNumberComments.font = BOLD_FONT_WITH_SIZE(15);
    }else
        self.lbNumberComments.font = NORMAL_FONT_WITH_SIZE(13);

    
    if (art.imageUrl) {
        [self.imgCompanyLogo sd_setImageWithURL:[NSURL URLWithString:art.imageUrl]];
    }
    
    self.lbNumberComments.text = [NSString stringWithFormat:@"%d",art.numberComment.intValue];
    if (art.numberComment.intValue >= 50) {
        self.lbNumberComments.font = BOLD_FONT_WITH_SIZE(15);
    }else
        self.lbNumberComments.font = NORMAL_FONT_WITH_SIZE(13);
    self.lbRecruitValue.text = art.salary;
    self.lbRecruitType.text = art.recruiting_target;
    
    if (art.is_new.intValue == 1) {
        self.btnIsNew.hidden = NO;
        //self.btnJobType.frame = RECT_WITH_X(self.btnJobType.frame, self.btnIsNew.frame.origin.x + self.btnIsNew.frame.size.width + 3);
        
    }else{
        self.btnIsNew.hidden = YES;
        //self.btnJobType.frame = RECT_WITH_X(self.btnJobType.frame, self.btnIsNew.frame.origin.x);
    }
    [self.btnJobType setTitle:[art.employee substringToIndex:1] forState:UIControlStateNormal];
    //self.btnEX.frame =RECT_WITH_X(self.btnEX.frame, self.btnJobType.frame.origin.x+18);
    
    int titleLeftMargin = 5;
    
    self.btnEX.hidden = art.no_xp.intValue == 0;
    if(self.btnEX.hidden)
    {
        self.btnJobType.frame = RECT_WITH_X(self.btnJobType.frame, self.btnEX.frame.origin.x);
        self.btnIsNew.frame = RECT_WITH_X(self.btnIsNew.frame, self.btnJobType.frame.origin.x+18);
    }
    else
    {
        self.btnJobType.frame = RECT_WITH_X(self.btnJobType.frame, self.btnEX.frame.origin.x+self.btnEX.frame.size.width+3);
        self.btnIsNew.frame = RECT_WITH_X(self.btnIsNew.frame, self.btnJobType.frame.origin.x+18);
    }
    if (art.imageUrl && art.imageUrl.length > 0) {
        self.imgCompanyLogo.hidden = NO;
        [self.activity startAnimating];
        if (type == ENUM_ARTICLE_CELL_TYPE_LARGE) {
            [self.imgCompanyLogo sd_setImageWithURL:[NSURL URLWithString:art.imageUrl] placeholderImage:[UIImage imageNamed:@"GIGA_place_holder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.activity stopAnimating];
            }];
            
        } else {
            [self.imgCompanyLogo sd_setImageWithURL:[NSURL URLWithString:art.imageUrl] placeholderImage:[UIImage imageNamed:@"GIGA_place_holder1.png"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.activity stopAnimating];
            }];
            
        }
        
        if (type == ENUM_ARTICLE_CELL_TYPE_NORMAL) {
            int xPosition = self.imgCompanyLogo.frame.origin.x + self.imgCompanyLogo.frame.size.width;
            self.lbCompanyDes.frame = RECT_WITH_X_WIDTH(self.lbCompanyDes.frame, xPosition + titleLeftMargin,self.frame.size.width - titleLeftMargin * 2 - xPosition);
            
            self.btnCompany.frame = RECT_WITH_X(self.btnCompany.frame, self.lbCompanyDes.frame.origin.x);
        }else{
            self.btnCompany.frame = RECT_WITH_X(self.btnCompany.frame, self.frame.size.width - self.btnCompany.frame.size.width - 5);
        }
        
    }else{
        [self.activity stopAnimating];
        if (type == ENUM_ARTICLE_CELL_TYPE_NORMAL) {
//            self.imgCompanyLogo.hidden = YES;
//            self.lbCompanyDes.frame = RECT_WITH_X_WIDTH(self.lbCompanyDes.frame, titleLeftMargin, self.frame.size.width - titleLeftMargin * 2);
//            self.btnCompany.frame = RECT_WITH_X(self.btnCompany.frame, self.lbCompanyDes.frame.origin.x);
            self.imgCompanyLogo.hidden = NO;
            self.imgCompanyLogo.image = [UIImage imageNamed:@"GIGA_place_holder1.png"];
            //self.lbCompanyDes.frame = RECT_WITH_X_WIDTH(self.lbCompanyDes.frame, titleLeftMargin, self.frame.size.width - titleLeftMargin * 2);
            //self.btnCompany.frame = RECT_WITH_X(self.btnCompany.frame, self.lbCompanyDes.frame.origin.x);

        }else{
            self.imgCompanyLogo.hidden = NO;
            self.imgCompanyLogo.image = [UIImage imageNamed:@"GIGA_place_holder.jpg"];
            self.btnCompany.frame = RECT_WITH_X(self.btnCompany.frame, self.frame.size.width - self.btnCompany.frame.size.width - 5);
        }
    }
    
    if (art.numberComment.integerValue > 0) {
        self.contentView.backgroundColor = [HEX_COLOR_STRING(@"f0f8ff") colorWithAlphaComponent:0.5f];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }    
}

@end


@implementation NSMutableAttributedString (Extension)
- (void)setFont:(UIFont*)font
          color:(UIColor*)color
        atRange:(NSRange)range
         string:(NSString*)msg
{
    if (color && range.location < msg.length) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
        [self addAttribute:NSFontAttributeName value:font range:range];
    }
}
@end