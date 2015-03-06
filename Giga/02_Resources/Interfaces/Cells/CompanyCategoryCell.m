//
//  CompanyCategoryCell.m
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyCategoryCell.h"
#import "CompanyCategoryModel.h"

@implementation CompanyCategoryCell

- (void)applyStyleIfNeed
{
    if (isAppliedStyle) {
        return;
    }
    isAppliedStyle = YES;
    self.lbTitle.font = NORMAL_FONT_WITH_SIZE(19);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setObject:(id)obj
{
    [super setObject:obj];
    CompanyCategoryModel *category = obj;
    self.lbTitle.text = category.categoryTitle;
}

+ (CGFloat)getCellHeight
{
    return 60;
}
@end
