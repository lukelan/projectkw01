//
//  ArticleCell.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell{
    id model;
    BOOL isAppliedStyle;
}

+ (CGFloat)getCellHeight;

- (void)setObject:(id)obj;
- (void)applyStyleIfNeed;
@end
