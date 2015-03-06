//
//  AdsModel.h
//  Giga
//
//  Created by Hoang Ho on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseModel.h"

@interface AdsModel : BaseModel
@property (copy, nonatomic) NSString *adsID;
@property (copy, nonatomic) NSString *adsTitle;
@property (copy, nonatomic) NSString *adsSource;
@property (copy, nonatomic) NSString *adsDes;
@property (copy, nonatomic) NSString *adsUrlSource;
@property (copy, nonatomic) NSNumber *numberComment;
@property (copy, nonatomic) NSString *adsImageUrl;
@end
