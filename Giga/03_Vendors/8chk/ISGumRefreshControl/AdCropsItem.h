//
// Created by Tetsuyak on 2014/05/30.
// Copyright (c) 2014 8crops. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChkRecordData;


@interface AdCropsItem : UIView

@property (nonatomic, strong) ChkRecordData *chkRecordData;

+(AdCropsItem *)createItem:(ChkRecordData *)chkRecordData itemWidth:(CGFloat)itemWidth;

@end