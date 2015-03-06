//
// Created by Tetsuyak on 2014/05/30.
// Copyright (c) 2014 8crops. All rights reserved.
//

#import "AdCropsHScrollView.h"
#import "AdCropsConstants.h"
#import "ChkRecordData.h"
#import "AdCropsItem.h"

@interface AdCropsHScrollView () <UIScrollViewDelegate>

@property(nonatomic, strong) NSArray *chkRecords;
@property(nonatomic, strong) NSMutableArray *adItemArray;
@property(nonatomic) NSUInteger currentPageNum;    // 1スタート
@property(nonatomic) BOOL initFlg;    // 初回表示フラグ
@property(nonatomic) CGFloat topPadding;

- (void)_create;

@end


@implementation AdCropsHScrollView

+ (AdCropsHScrollView *)create:(NSArray *)chkRecords delegate:(id)delegate {

	NSLog(@"%s", __PRETTY_FUNCTION__);
	if (!chkRecords || [chkRecords count] == 0) return nil;

	AdCropsHScrollView *scrollView = [[AdCropsHScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kAdCropsItemHeight)];

	// UINavigationController配下でないUITablevViewControllerなどに設置する場合は下記をコメントアウトしてください。
	//	if ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {//iOS7 later
	//		scrollView.topPadding = 20;
	//	} else {
	//		scrollView.topPadding = 0;
	//	}

	scrollView.customDelegate = delegate;
	scrollView.chkRecords = chkRecords;
	[scrollView _create];

	return scrollView;
}


#pragma mark -Public
- (void)rotateAdItem {

	CGFloat targetX = self.contentOffset.x + self.frame.size.width;
	if (targetX >= self.contentSize.width || !_initFlg) {    // 末端にきたら先頭へ戻す
		[self setContentOffset:CGPointMake(0, 0) animated:YES];
		if (!_initFlg) {
			[self viewDidAdcropsItem];
		}
		_initFlg = YES;
	} else {
		[self setContentOffset:CGPointMake(targetX, 0) animated:YES];
	}

}

#pragma mark - Private

- (void)_create {

	// 広告アイテムの作成
	_adItemArray = [[NSMutableArray alloc] init];
	NSUInteger itemCnt = [_chkRecords count];
	if (kAdCropsItemCount < itemCnt){
		itemCnt = kAdCropsItemCount;
	}
	CGFloat itemWidth = self.frame.size.width;
	CGFloat contentsWidth = itemCnt * itemWidth;
	self.contentSize = CGSizeMake(contentsWidth, kAdCropsItemHeight);

	for (int i = 0; i < itemCnt ; i++) {

		ChkRecordData *recordData = _chkRecords[i];
		AdCropsItem *adItemView = [AdCropsItem createItem:recordData itemWidth:itemWidth];
		// CGFloat x = (itemWidth + kAdCropsItemmPadding) * i;
		CGFloat x = itemWidth * i;
		// adItemView.frame = CGRectOffset(adItemView.frame , x + kAdCropsItemmPadding , 0);
		adItemView.frame = CGRectOffset(adItemView.frame, x, _topPadding);
		[_adItemArray addObject:adItemView];
		[self addSubview:adItemView];

	}

	self.pagingEnabled = YES; // ページ単位
	self.indicatorStyle = UIScrollViewIndicatorStyleDefault;
	[self setCanCancelContentTouches:NO];
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = YES;    // 横スクロールバー

	self.scrollsToTop = NO;
	self.clipsToBounds = NO;
	self.scrollEnabled = YES;

	self.delegate = self;

}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self viewDidAdcropsItem];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self viewDidAdcropsItem];
}


- (void)viewDidAdcropsItem {
	// 現在のページ数を算出
	CGFloat x = self.contentOffset.x;
	if (x <= 0) {
		_currentPageNum = 1;
	} else {
		_currentPageNum = (NSUInteger) ((x + self.frame.size.width) / self.frame.size.width);
	}

	NSUInteger cnt = [_adItemArray count];
	if (_currentPageNum <= cnt) {

		ChkRecordData *data = _chkRecords[_currentPageNum - 1];
		if (_customDelegate) {
			[_customDelegate viewDidAdcropsItem:data];
		}

	}

}


- (void)dealloc {
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end