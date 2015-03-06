//
//  HBTabBar.m
//  DemoApp
//
//  Created by Hoang Ho on 11/18/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "HBTabBar.h"
#import "HBMacros.h"

@implementation HBTabBar
@synthesize currentItemIndex;

- (HBTabBar*)initWithWithFrame:(CGRect)frame items:(NSArray *)items
{
   if(self = [super initWithFrame:frame])
   {
      self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      
      scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
      scrollView.contentSize = self.bounds.size;
      scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      scrollView.delegate = self;
      scrollView.showsHorizontalScrollIndicator = scrollView.showsVerticalScrollIndicator = NO;
      [self addSubview:scrollView];
      
      //items
       totalItem = items.count;
      int startX = 0;
      for (int i = 0; i < items.count; i++)
      {
          HBTabItem *item = items[i];
       
          
              CGRect frameButton = CGRectMake(startX, self.frame.size.height - item.heightItem - HeightBorderBottom, item.widthItem, item.heightItem + 2);
              HBTabItemView *btn = [HBTabItemView tabViewWithItem:item andFrame:frameButton];

              btn.tag = i + 1;
              [btn addTarget:self action:@selector(clickOnItem:) forControlEvents:UIControlEventTouchUpInside];
              [scrollView addSubview:btn];
              startX += item.widthItem + MarginItem;
          
          
          
      }
      scrollView.contentSize = CGSizeMake(startX, self.frame.size.height);
      
      bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - HeightBorderBottom, startX, HeightBorderBottom)];
      bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
      bottomLineView.backgroundColor = RGB(237, 165, 52);
      [scrollView addSubview:bottomLineView];
      
      currentItemIndex = -1;
   }
   return self;
}

- (void)reloadData
{
   for (HBTabItemView *btn in scrollView.subviews) {
      if ([btn isKindOfClass:[HBTabItemView class]]) {
         btn.selected = NO;
      }
   }
   if (currentItemIndex == -1) {
      //select first item
      HBTabItemView *firstTabView = (HBTabItemView*)[scrollView viewWithTag:1];
      if (firstTabView) {
         [self clickOnItem:firstTabView.mainButton];
      }
   }else{
      //if has one item was selected
      HBTabItemView *currentBtn = (HBTabItemView*)[scrollView viewWithTag:currentItemIndex + 1];
      currentBtn.selected = YES;
        bottomLineView.backgroundColor =  currentBtn.imgBackground.backgroundColor;
       BOOL shouldSelect = [self.delegate HBTabBar:self shouldSelectAtIndex:currentItemIndex];
      if (shouldSelect) {
         [self.delegate HBTabBar:self didChangeItemIndex:currentItemIndex fromIndex:currentItemIndex];
      }
   }
}
-(void)hideItemWithIndex:(NSInteger)index withSelect:(BOOL)select
{
    HBTabItemView *btn = (HBTabItemView *)[scrollView viewWithTag:index+2];
    btn.hidden = !select;
    
    if(btn.hidden)
    {
        for(int i=index+3;i<totalItem;i++)
        {
            HBTabItemView *btn = (HBTabItemView *)[scrollView viewWithTag:i];
            HBTabItemView *btn1 = (HBTabItemView *)[scrollView viewWithTag:i-1];
            
            btn.frame =CGRectMake(btn1.frame.origin.x, btn1.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
        }
    }
}

- (void)clickOnItem:(UIButton*)btn
{
   int itemIndex = btn.tag - 1;
   if (currentItemIndex != itemIndex)
   {
      BOOL shouldSelect = [self.delegate HBTabBar:self shouldSelectAtIndex:itemIndex];
      if (shouldSelect)
      {
         [self.delegate HBTabBar:self didChangeItemIndex:itemIndex fromIndex:currentItemIndex];
         
         if (currentItemIndex != -1)
         {
            HBTabItemView *lastTabView = (HBTabItemView*)[scrollView viewWithTag:currentItemIndex + 1];
            lastTabView.selected = NO;
         }
         HBTabItemView *currentTabView = (HBTabItemView*)[scrollView viewWithTag:btn.tag];
         currentTabView.selected = YES;
         
         currentItemIndex = itemIndex;
         //scroll to center
         [self scrollToIndex:currentItemIndex];
         
          bottomLineView.backgroundColor =  currentTabView.imgBackground.backgroundColor;
      }
   }
}


- (void)scrollToIndex:(int)index
{
   int buttonTag = index + 1;
   UIButton *btn = (UIButton*)[scrollView viewWithTag:buttonTag];
   
   CGPoint desOffset = CGPointMake(btn.frame.origin.x - (scrollView.frame.size.width/2 - btn.frame.size.width /2), 0);
   if (desOffset.x < 0) {
      desOffset.x = 0;
   }
   if (desOffset.x > scrollView.contentSize.width - scrollView.frame.size.width) {
      desOffset.x = scrollView.contentSize.width - scrollView.frame.size.width;
   }
   [scrollView setContentOffset:desOffset animated:YES];
}

- (void)scrollToIndex:(int)index withAnimate:(BOOL)anima
{
    int buttonTag = index + 1;
    UIButton *btn = (UIButton*)[scrollView viewWithTag:buttonTag];
    
    CGPoint desOffset = CGPointMake(btn.frame.origin.x - (scrollView.frame.size.width/2 - btn.frame.size.width /2), 0);
    if (desOffset.x < 0) {
        desOffset.x = 0;
    }
    if (desOffset.x > scrollView.contentSize.width - scrollView.frame.size.width) {
        desOffset.x = scrollView.contentSize.width - scrollView.frame.size.width;
    }
    [scrollView setContentOffset:desOffset animated:NO];
}

- (void)reloadNotificationTabWithValue:(int)notifCount
{
    HBTabItemView *notificationTab = (HBTabItemView*)[scrollView viewWithTag:scrollView.subviews.count - 1];
    UILabel *lb = (UILabel*)[notificationTab viewWithTag:10000];
    lb.text = STRINGIFY_INT(notifCount);
    lb.hidden = notifCount == 0;
}

- (void)layoutItemAtIndex:(int)selectedIndex shouldChangeView:(BOOL)shouldChange
{
    if (selectedIndex != currentItemIndex) {
        if (selectedIndex >= 0 && selectedIndex < scrollView.subviews.count - 1) {
            BOOL shouldSelect = [self.delegate HBTabBar:self shouldSelectAtIndex:selectedIndex];
            if (shouldSelect) {
                for (HBTabItemView *btn in scrollView.subviews) {
                    if ([btn isKindOfClass:[HBTabItemView class]]) {
                        btn.selected = NO;
                    }
                }
                HBTabItemView *currentBtn = (HBTabItemView*)[scrollView viewWithTag:selectedIndex + 1];
                currentBtn.selected = YES;
                 bottomLineView.backgroundColor =  currentBtn.imgBackground.backgroundColor;
                if (shouldChange) {
                    [self.delegate HBTabBar:self didChangeItemIndex:selectedIndex fromIndex:currentItemIndex];
                }
                currentItemIndex = selectedIndex;
                //scroll to center
                [self scrollToIndex:currentItemIndex];
            }
        }
    }
}
@end


@implementation HBTabItemView

@synthesize imgBackground, lbTitle, mainButton;

+ (instancetype)tabViewWithItem:(HBTabItem*)item andFrame:(CGRect)frame
{
    HBTabItemView *instance = [[HBTabItemView alloc] initWithFrame:frame];
    instance.backgroundColor = [UIColor clearColor];
    
    instance.imgBackground = [[UIView alloc] initWithFrame:instance.bounds];
    instance.imgBackground.contentMode = UIViewContentModeScaleToFill;
    instance.imgBackground.backgroundColor = item.color;// [UIImage imageNamed:@"image-bg-white"];
    instance.imgBackground.userInteractionEnabled = NO;
    instance.imgBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    instance.lbTitle = [[UILabel alloc] initWithFrame:instance.bounds];
    instance.lbTitle.numberOfLines = 0;
    instance.lbTitle.textAlignment = NSTextAlignmentCenter;
    instance.lbTitle.lineBreakMode = NSLineBreakByWordWrapping;
    instance.lbTitle.textColor=[UIColor whiteColor];
    instance.backgroundColor = [UIColor clearColor];
    instance.lbTitle.text = item.title;
    [instance.lbTitle setFont:NORMAL_FONT_WITH_SIZE(14)];
    instance.lbTitle.userInteractionEnabled = NO;
    
    instance.layer.cornerRadius = 3.0f;
    instance.layer.masksToBounds = YES;
    
    instance.mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    instance.mainButton.backgroundColor = [UIColor clearColor];
    instance.mainButton.frame = instance.bounds;
    
    [instance addSubview:instance.imgBackground];
    [instance addSubview:instance.lbTitle];
    [instance addSubview:instance.mainButton];

    
    if (item.type == ENUM_TAP_TYPE_ADVANCE) {
        item.subContentView.tag = 10000;
        [instance addSubview:item.subContentView];
        [instance bringSubviewToFront:item.subContentView];
    }
    return instance;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    self.mainButton.selected = self.selected;
    //[imgBackground setImage:[UIImage imageNamed:self.selected ?  @"image-bg-blue" :  @"image-bg-white"]];
    [lbTitle setTextColor:self.selected ? [UIColor whiteColor] : [UIColor whiteColor]];// RGB(25, 178, 249) ];
   UIView *parentView = self.superview;
   int heightOfButton = self.selected ? HeightExpandedItem : HeightItem;
    //animation
    CGRect desFrame =RECT_WITH_Y_HEIGHT(self.frame, parentView.frame.size.height - heightOfButton - HeightBorderBottom, heightOfButton + 2);
    if (selected) {
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = desFrame;
        }];
    }else
        self.frame = desFrame;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.mainButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    self.mainButton.tag = tag;
}
@end


@implementation HBTabItem

+ (instancetype)initWithTitle:(NSString*)title type:(ENUM_TAP_TYPE)type contentView:(UIView*)contentView withColor:(UIColor *)color withSelect:(BOOL)select
{
    HBTabItem *instance = [[HBTabItem alloc] init];
    instance.title = title;
    instance.type = type;
    instance.subContentView = contentView;
    instance.color =color;
    instance.selected = select;
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.widthItem = 75;
        self.heightItem = 35;
    }
    return self;
}

@end

#define WidthItem 75
#define HeightItem 35
#define MarginItem 2
#define HeightExpandedItem 40
