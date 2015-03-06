//
// Created by Tetsuyak on 2014/05/30.
// Copyright (c) 2014 8crops. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChkRecordData;


@protocol AdCropsHScrollViewDelegate

-(void)viewDidAdcropsItem:(ChkRecordData *)recordData;

@end

@interface AdCropsHScrollView : UIScrollView

@property (nonatomic, weak) id <AdCropsHScrollViewDelegate> customDelegate;
+(AdCropsHScrollView *)create:(NSArray *)chkRecords delegate:(id<AdCropsHScrollViewDelegate>)delegate;
-(void)rotateAdItem;

@end