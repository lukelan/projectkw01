//
//  CompanyDetail_TextCell.h
//  Giga
//
//  Created by vandong on 12/6/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseCell.h"

#define key_title_value                 @"key_title_value"
#define key_detail_value                @"key_detail_value"

@interface CompanyDetail_TextCell : BaseCell
@property(weak, nonatomic) IBOutlet UILabel             *lbTitle;
@property(weak, nonatomic) IBOutlet UILabel             *lbDetail;

+(float)heightWithObject:(NSObject *)object;
- (void)setObject:(id)obj;
- (void)formatForPerformanceView;
- (void)formatForProfileView;
@end
