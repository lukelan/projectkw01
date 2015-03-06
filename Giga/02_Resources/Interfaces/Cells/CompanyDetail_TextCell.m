//
//  CompanyDetail_TextCell.m
//  Giga
//
//  Created by vandong on 12/6/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_TextCell.h"

@implementation CompanyDetail_TextCell

- (void)applyStyleIfNeed
{
    if (isAppliedStyle) {
        return;
    }
    isAppliedStyle = YES;
    self.lbTitle.font = NORMAL_FONT_WITH_SIZE(14);
    self.lbDetail.font = NORMAL_FONT_WITH_SIZE(14);
}

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
    
    return self;
}

-(void)awakeFromNib
{
    self.lbTitle.font = NORMAL_FONT_WITH_SIZE(14);
    self.lbDetail.font = NORMAL_FONT_WITH_SIZE(14);
    
}
- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

+(float)heightWithObject:(NSObject *)object {
    NSDictionary *dict = (NSDictionary *)object;
    NSString *sTitle = dict[key_title_value];
    CGSize sizeTitle = [sTitle sizeWithFont:NORMAL_FONT_WITH_SIZE(14) constrainedToSize: CGSizeMake(120, 10000)];
    NSString *sDetail = dict[key_detail_value];
    CGSize sizeDetail = [sDetail sizeWithFont:NORMAL_FONT_WITH_SIZE(14) constrainedToSize: CGSizeMake(187, 10000)];

    float height = MAX(sizeTitle.height, sizeDetail.height);
    height = MAX(height + 15, 36); // 15 is padding top and bottom
    return height;
}

- (void)setObject:(id)obj {
    NSDictionary *dict = (NSDictionary *)obj;
    _lbTitle.text = dict[key_title_value];
    _lbDetail.text = dict[key_detail_value];
}

- (void)formatForPerformanceView
{
    int titleWidth = 140;
    self.lbTitle.textAlignment = self.lbDetail.textAlignment = NSTextAlignmentLeft;
    self.lbTitle.frame = RECT_WITH_WIDTH(self.lbTitle.frame, titleWidth);
    int xPosigion = self.lbTitle.frame.origin.x + self.lbTitle.frame.size.width + 5;
    self.lbDetail.frame = RECT_WITH_X_WIDTH(self.lbDetail.frame, xPosigion, self.frame.size.width - xPosigion - 2);
}

- (void)formatForProfileView
{
    int titleWidth = 120;
    self.lbTitle.textAlignment = self.lbDetail.textAlignment = NSTextAlignmentLeft;
    self.lbTitle.frame = RECT_WITH_WIDTH(self.lbTitle.frame, titleWidth);
    int xPosigion = self.lbTitle.frame.origin.x + self.lbTitle.frame.size.width + 5;
    self.lbDetail.frame = RECT_WITH_X_WIDTH(self.lbDetail.frame, xPosigion, self.frame.size.width - xPosigion - 2);
}

@end
