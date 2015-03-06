//
//  HBTabBar.h
//  DemoApp
//
//  Created by Hoang Ho on 11/18/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WidthItem 75
#define HeightItem 35
#define MarginItem 2
#define HeightExpandedItem 40
#define HeightBorderBottom 5

@class HBTabBar;

typedef enum {
    ENUM_TAP_TYPE_SIMPLE,
    ENUM_TAP_TYPE_ADVANCE
}ENUM_TAP_TYPE;

@interface HBTabItem :NSObject
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) ENUM_TAP_TYPE type;
@property (assign, nonatomic) int widthItem;
@property (assign, nonatomic) int heightItem;
@property (assign, nonatomic) int heightExpandedItem;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIView *subContentView;
@property (nonatomic, assign) BOOL selected;
+ (instancetype)initWithTitle:(NSString*)title type:(ENUM_TAP_TYPE)type contentView:(UIView*)contentView withColor:(UIColor *)color withSelect:(BOOL)select;
@end

@interface HBTabItemView : UIView
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) UIButton *mainButton;
@property (strong, nonatomic) UIView *imgBackground;
@property (strong, nonatomic) UILabel *lbTitle;
+ (instancetype)tabViewWithItem:(HBTabItem*)item andFrame:(CGRect)frame;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end

@protocol HBTabBarDelegate <NSObject>

@required
- (BOOL)HBTabBar:(HBTabBar*)tab shouldSelectAtIndex:(int)index;
- (void)HBTabBar:(HBTabBar*)tab didChangeItemIndex:(int)newIndex fromIndex:(int)oldIndex;
@optional
- (void)HBTabBar:(HBTabBar*)tab didChangeToIndex:(int)newIndex;
@end

@interface HBTabBar : UIView<UIScrollViewDelegate>
{
   UIScrollView *scrollView;
   NSArray *itemSources;
    UIView *bottomLineView;
    
    NSInteger totalItem;
}
@property (weak, nonatomic) id<HBTabBarDelegate> delegate;
- (HBTabBar*)initWithWithFrame:(CGRect)frame items:(NSArray*)items;
- (void)reloadData;
@property (assign, nonatomic) NSUInteger currentItemIndex;
- (void)reloadNotificationTabWithValue:(int)notifCount;
- (void)layoutItemAtIndex:(int)selectedIndex shouldChangeView:(BOOL)shouldChange;


-(void)hideItemWithIndex:(NSInteger)index withSelect:(BOOL)select;

- (void)scrollToIndex:(int)index withAnimate:(BOOL)anima;

@end
