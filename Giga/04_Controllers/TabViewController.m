//
//  TabViewController.m
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "TabViewController.h"
#import "HBTabBar.h"

#import "ListCompanyInfoViewController.h"
#import "ArticleViewController.h"
#import "BookmarksViewController.h"

#import "ArticleCategoryModel.h"
#import "RecruitArticleViewController.h"
#import "SettingViewController.h"
#import "NotificationViewController.h"

#import "ArticleModel.h"
#import "SelectProvinceView.h"
#import "SwipeView.h"
#import "EAIntroView.h"

#import "AddViewController.h"

#import "AppDelegate.h"

#define OPENING_WALKTHROUGH_BG @[@"tutorial_1.jpg", @"tutorial_2.jpg", @"tutorial_3.jpg", @"tutorial_4.jpg", @"tutorial_5.jpg", @"tutorial_6.jpg", @"tutorial_7.jpg"]
#define OPENING_WALKTHROUGH_ICON @[@"opening_content_01.png", @"opening_content_02.png", @"opening_content_03.png", @"opening_content_04.png", @"opening_content_05.png", @"opening_content_06.png", @"opening_content_07.png"]
#define OPENING_WALKTHROUGH_ICON_POSY @[@100, @100, @100, @100, @100, @100, @100]

@interface TabViewController ()<HBTabBarDelegate,SwipeViewDataSource, SwipeViewDelegate, TabViewProtocol, EAIntroDelegate, AddControllerDelegate>
{
    HBTabBar *hbTabBarA;
    HBTabBar *hbTabBarB;
    
    NSMutableArray *itemsA;
    NSMutableArray *itemsB;
    
    NSMutableArray *itemsTempA;
    NSMutableArray *itemsTempB;
    
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
    
    NSInteger numberSwipeA;
    NSInteger numberSwipeB;
    
    NSMutableArray *_arrayItemNews;
    NSMutableArray *_arrayItemRecruit;
}

@property (strong, nonatomic) NSMutableArray *listVC;
@property (strong, nonatomic) NSMutableArray *listVCB;
@property (strong, nonatomic) UIViewController *currentController;
@property (strong, nonatomic) UIViewController *currentControllerB;
@property (nonatomic, strong) SwipeView *swipeView;
@property (nonatomic, strong) SwipeView *swipeViewB;
@property (strong, nonatomic) EAIntroView *walkthoughView;

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.listVC = [NSMutableArray array];
    self.listVCB = [NSMutableArray array];
    //delete all cached article in core data
    [ArticleModel deleteAllObjects];
    
    [self loadCategory];
    
    if (!SharedUserData.listProvinces || [SharedUserData.listProvinces count] == 0) {
        [self showOpeningWalkThrough:YES];
    }
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_TOP_TITLE andPostMethodKind:YES andParams:[NSMutableDictionary dictionary] inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        NSDictionary *infoDic = [responseObject firstObject];
        self.lbHeader.text = [NSString stringWithFormat:@"全求人数 %@件（%@更新)", [infoDic objectForKey:@"total"], [infoDic objectForKey:@"last_update"]];
    } failureBlock:^(NSError *error) {
    }];
    
    [self requestUserAccess];
    
    
    
    numberSwipeA=0;
    numberSwipeB=0;
    
    AppDelegate *app =[[UIApplication sharedApplication] delegate];
    
    [[GAI sharedInstance] setDefaultTracker:app.tracker];
    id<GAITracker> defaultTracker = [[GAI sharedInstance] defaultTracker];
    [defaultTracker send:[[[GAIDictionaryBuilder createAppView] set:@"IOS - Home Screen" forKey:kGAIScreenName] build]];
}

-(void)appBecomeActive
{
    if(self.smcMain.selectedSegmentIndex ==0)
    {
        UIView *currentView = [self.swipeView currentItemView];
        for (UIViewController *viewController in self.listVC)
        {
            if ([viewController isMemberOfClass:[ArticleViewController class]]) {
                if (viewController.view == currentView) {
                    [(ArticleViewController*)viewController reloadData];
                }
                else {
                    [(ArticleViewController*)viewController setIsNeedReloadData:YES];
                }
            }
        }
    }
    else
    {
        UIView *currentView = [self.swipeViewB currentItemView];
        for (UIViewController *viewController in self.listVCB)
        {
            if ([viewController isMemberOfClass:[ArticleViewController class]]) {
                if (viewController.view == currentView) {
                    [(ArticleViewController*)viewController reloadData];
                }
                else {
                    [(ArticleViewController*)viewController setIsNeedReloadData:YES];
                }
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //fix bug for list company info + bookmark
    if(self.smcMain.selectedSegmentIndex == 0)
    {
        if (self.currentController) {
            //call reload data
            [self.currentController viewWillAppear:animated];
        }
    }
    else
    {
        if (self.currentControllerB) {
            //call reload data
            [self.currentControllerB viewWillAppear:animated];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enablePopGesture:NO];
}

- (void)requestUserAccess
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:SharedUserData.deviceID forKey:@"device_id"];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_USER_ACCESS andPostMethodKind:YES andParams:params inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        if ([responseObject count] > 0) {
            NSDictionary *dict = responseObject[0];
            SharedUserData.userID = dict[@"id"];
            [SharedUserData save];
            [SharedUserData getNotificationCount];
        }
    } failureBlock:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STRING_NOTIFICATION_APP_ACTIVE object:nil];
    [hbTabBarA removeFromSuperview];
    [hbTabBarB removeFromSuperview];
    
    [self.listVC removeAllObjects];
    self.listVC = nil;
    [self.listVCB removeAllObjects];
    self.listVCB = nil;
    
    [itemsA removeAllObjects];
    itemsA = nil;
    [itemsB removeAllObjects];
    itemsB = nil;
}

-(void)loadCategory
{
    _arrayItemNews = [NSMutableArray new];
    _arrayItemRecruit = [NSMutableArray new];
    
    NSMutableArray *arrNews = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"categoryNews"]];
    NSMutableArray *arrRecruit = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"categoryRecruit"]];
    
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_CATEGORY andPostMethodKind:YES andParams:[NSMutableDictionary dictionary] inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject)
     {
         NSDictionary *result = (NSDictionary *)responseObject;
         NSArray *arr1 = [result objectForKey:@"news"];
         NSArray *arr2 = [result objectForKey:@"recruit"];
         
         
         
         if(arrNews.count==[arr1 count])
         {
             [_arrayItemNews addObjectsFromArray:arrNews];
         }
         else
         {
             arr1 = [arr1 sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
                 int first = [[a objectForKey:@"sort"] intValue];
                 int second = [[b objectForKey:@"sort"] intValue];
                 if(first>second) return YES;
                 else return NO;
             }];
             
             [arrNews removeAllObjects];
             for(int i=0;i<[arr1 count];i++)
             {
                 NSMutableDictionary *item =[arr1 objectAtIndex:i];
                 [item setObject:[NSNumber numberWithBool:YES] forKey:@"select"];
                 [arrNews addObject:item];
             }
             [[NSUserDefaults standardUserDefaults] setValue:arrNews forKey:@"categoryNews"];
             [_arrayItemNews addObjectsFromArray:arrNews];
         }
             
         if(arrRecruit.count==[arr2 count])
         {
             [_arrayItemRecruit addObjectsFromArray:arrRecruit];
         }
         else
         {
             arr2 = [arr2 sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
                 int first = [[a objectForKey:@"sort"] intValue];
                 int second = [[b objectForKey:@"sort"] intValue];
                 if(first>second) return YES;
                 else return NO;
             }];
             
             [arrRecruit removeAllObjects];
             for(int i=0;i<[arr2 count];i++)
             {
                 NSMutableDictionary *item =[arr2 objectAtIndex:i];
                 [item setObject:[NSNumber numberWithBool:YES] forKey:@"select"];
                 [arrRecruit addObject:item];
             }
             [[NSUserDefaults standardUserDefaults] setValue:arrRecruit forKey:@"categoryRecruit"];
             [_arrayItemRecruit addObjectsFromArray:arrRecruit];
         }
         
         [self loadInterface];
         // set tab 2 is default tab
         [hbTabBarB setCurrentItemIndex:1];
         [hbTabBarB reloadData];
         
         [hbTabBarA setCurrentItemIndex:1];
         [hbTabBarA reloadData];
         
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:STRING_NOTIFICATION_APP_ACTIVE object:nil];
         
     } failureBlock:^(NSError *error)
     {}];
}

- (void)loadInterface
{
    self.lbHeader.font = BOLD_FONT_WITH_SIZE(13);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:NORMAL_FONT_WITH_SIZE(14)
                                                           forKey:NSFontAttributeName];
    [self.smcMain setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    [self.smcMain setTitle:localizedString(@"Career Change") forSegmentAtIndex:0];
    [self.smcMain setTitle:localizedString(@"Part-time Job") forSegmentAtIndex:1];
    self.smcMain.momentary = NO;
    
    //Tab A
    itemsA = [NSMutableArray array];
    [itemsA addObject:[HBTabItem initWithTitle:localizedString(@"Company\nInformation") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(81, 178, 255) withSelect:YES]];
    for(int i =0;i<_arrayItemNews.count;i++)
    {
        UIColor *color;
        if(i==0) color = RGB(111, 203, 28);
        else if(i==1) color = RGB(237, 165, 52);
        else if(i==2) color = RGB(238, 106, 106);
        else if(i==3) color = RGB(165, 108, 218);
        else if(i==4) color = RGB(81, 178, 255);
        else if(i==5) color = RGB(111, 203, 28);
        else if(i==6) color = RGB(237, 165, 52);
        else if(i==7) color = RGB(238, 106, 106);
        else if(i==8) color = RGB(165, 108, 218);
        else if(i==9) color = RGB(81, 178, 255);
        else color =RGB(81, 178, 255);
        
        
        [itemsA addObject:[HBTabItem initWithTitle:[[_arrayItemNews objectAtIndex:i] objectForKey:@"name"] type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:color withSelect:[[[_arrayItemNews objectAtIndex:i] objectForKey:@"select"] boolValue]]];
        
    }
    [itemsA addObject:[HBTabItem initWithTitle:@"+" type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(111, 203, 28) withSelect:YES]];
    [itemsA addObject:[HBTabItem initWithTitle:localizedString(@"Bookmark") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(237, 165, 52) withSelect:YES]];
    [itemsA addObject:[HBTabItem initWithTitle:localizedString(@"Settings") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(163, 163, 163) withSelect:YES]];
    
    //a bit difference with notification
    int marginRight = 2;
    int heightOfLabel = 20;
    UILabel *notificatonLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 - heightOfLabel - marginRight, (35 - heightOfLabel)/2, heightOfLabel, heightOfLabel)];//100 is width of notification tab view, 35 is height of tabView
    notificatonLabel.backgroundColor = RGB(255, 150, 0);
    notificatonLabel.text = STRINGIFY_INT(SharedUserData.ntfCount);
    notificatonLabel.font = NORMAL_FONT_WITH_SIZE(12);
    notificatonLabel.textColor = [UIColor whiteColor];
    notificatonLabel.layer.cornerRadius = notificatonLabel.frame.size.width/2;
    notificatonLabel.layer.masksToBounds = YES;
    notificatonLabel.textAlignment = NSTextAlignmentCenter;
    notificatonLabel.adjustsFontSizeToFitWidth = YES;
    
    HBTabItem *notificationItem = [HBTabItem initWithTitle:localizedString(@"Notifications") type:ENUM_TAP_TYPE_ADVANCE contentView:notificatonLabel withColor:RGB(81, 178, 255) withSelect:YES];
    notificationItem.widthItem = 100;
    [itemsA addObject:notificationItem];
    
    itemsTempA =[NSMutableArray new];
    itemsTempB =[NSMutableArray new];
    for(int i= 0;i<itemsA.count;i++)
    {
        HBTabItem *item =[itemsA objectAtIndex:i];
        if(item.selected)
            [itemsTempA addObject:item];
    }
    
    hbTabBarA = [[HBTabBar alloc] initWithWithFrame:self.tabContainerView.bounds items:itemsTempA];
    hbTabBarA.delegate = self;
    [self.tabContainerView addSubview:hbTabBarA];
    
    
    
    itemsB = [NSMutableArray array];
    [itemsB addObject:[HBTabItem initWithTitle:localizedString(@"Company\nInformation") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(81, 178, 255) withSelect:YES]];
    for(int i =0;i<_arrayItemRecruit.count;i++)
    {
        UIColor *color;
        if(i==0) color = RGB(111, 203, 28);
        else if(i==1) color = RGB(237, 165, 52);
        else if(i==2) color = RGB(238, 106, 106);
        else if(i==3) color = RGB(165, 108, 218);
        else if(i==4) color = RGB(81, 178, 255);
        else if(i==5) color = RGB(111, 203, 28);
        else if(i==6) color = RGB(237, 165, 52);
        else if(i==7) color = RGB(238, 106, 106);
        else if(i==8) color = RGB(165, 108, 218);
        else if(i==9) color = RGB(81, 178, 255);
        else color =RGB(81, 178, 255);
        
        [itemsB addObject:[HBTabItem initWithTitle:[[_arrayItemRecruit objectAtIndex:i] objectForKey:@"name"] type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:color withSelect:[[[_arrayItemRecruit objectAtIndex:i] objectForKey:@"select"] boolValue]]];
        
    }
    [itemsB addObject:[HBTabItem initWithTitle:@"+" type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(165, 108, 218) withSelect:YES]];
    [itemsB addObject:[HBTabItem initWithTitle:localizedString(@"Bookmark") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(81, 178, 255) withSelect:YES]];
    [itemsB addObject:[HBTabItem initWithTitle:localizedString(@"Settings") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(163, 163, 163) withSelect:YES]];
    
    //a bit difference with notification
    int marginRightB = 2;
    int heightOfLabelB = 20;
    UILabel *notificatonLabelB = [[UILabel alloc] initWithFrame:CGRectMake(100 - heightOfLabelB - marginRightB, (35 - heightOfLabelB)/2, heightOfLabelB, heightOfLabelB)];//100 is width of notification tab view, 35 is height of tabView
    notificatonLabelB.backgroundColor = RGB(255, 150, 0);
    notificatonLabelB.text = STRINGIFY_INT(SharedUserData.ntfCount);
    notificatonLabelB.font = NORMAL_FONT_WITH_SIZE(12);
    notificatonLabelB.textColor = [UIColor whiteColor];
    notificatonLabelB.layer.cornerRadius = notificatonLabelB.frame.size.width/2;
    notificatonLabelB.layer.masksToBounds = YES;
    notificatonLabelB.textAlignment = NSTextAlignmentCenter;
    notificatonLabelB.adjustsFontSizeToFitWidth = YES;
    
    
    HBTabItem *notificationItemB = [HBTabItem initWithTitle:localizedString(@"Notifications") type:ENUM_TAP_TYPE_ADVANCE contentView:notificatonLabelB withColor:RGB(81, 178, 255) withSelect:YES];
    notificationItemB.widthItem = 100;
    [itemsB addObject:notificationItemB];
    
    
    for(int i= 0;i<itemsB.count;i++)
    {
        HBTabItem *item =[itemsB objectAtIndex:i];
        if(item.selected)
            [itemsTempB addObject:item];
    }
    
    hbTabBarB = [[HBTabBar alloc] initWithWithFrame:self.tabContainerView.bounds items:itemsTempB];
    hbTabBarB.delegate = self;
    [self.tabContainerView addSubview:hbTabBarB];

    
    
    hbTabBarB.hidden = YES;
    [hbTabBarA reloadData];
    [hbTabBarB reloadData];
    
    
    
    
    
    
    // set list vc
    for (NSInteger i = 0; i < [itemsTempA count]; i++) {
        [self.listVC addObject:[NSNull null]];
    }
    for (NSInteger i = 0; i < [itemsTempB count]; i++) {
        [self.listVCB addObject:[NSNull null]];
    }
    
//    
    //add swipe view
    self.swipeView = [[SwipeView alloc] initWithFrame:self.contentView.bounds];
    self.swipeView.backgroundColor = [UIColor whiteColor];
    self.swipeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    [self.contentView addSubview:self.swipeView];
    [self.contentView bringSubviewToFront:self.swipeView];
    
    self.swipeViewB = [[SwipeView alloc] initWithFrame:self.contentView.bounds];
    self.swipeViewB.backgroundColor = [UIColor whiteColor];
    self.swipeViewB.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
    self.swipeViewB.dataSource = self;
    self.swipeViewB.delegate = self;
    [self.contentView addSubview:self.swipeViewB];
    [self.contentView bringSubviewToFront:self.swipeViewB];
    self.swipeViewB.hidden =YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCountChanged:) name:PUSH_NOTIFICATION_NOTIFICATION_COUNT_CHANGED object:nil];
}

- (IBAction)smcValueChanged:(id)sender
{
    SharedUserData.curFilterJobType = self.smcMain.selectedSegmentIndex + 1;        
    
    if(self.smcMain.selectedSegmentIndex == 0)
    {
        [self.swipeView reloadData];
        
        hbTabBarA.hidden =NO;
        self.swipeView.hidden=NO;
        hbTabBarB.hidden =YES;
        self.swipeViewB.hidden =YES;
        
        UIView *currentView = [self.swipeView currentItemView];
        for (UIViewController *viewController in self.listVC)
        {
            if (viewController && ![viewController isMemberOfClass:[NSNull class]])
            {
            if (viewController.view == currentView) {
//                if ([viewController isMemberOfClass:[ArticleViewController class]])
//                {
//                    self.smcMain.enabled = NO;
//                    [(ArticleViewController*)viewController reloadData];
//                }
                if ([viewController isMemberOfClass:[ArticleViewController class]] && ((ArticleViewController*)viewController).isNeedReloadData)
                {
                    self.smcMain.enabled = NO;
                    [(ArticleViewController*)viewController setIsNeedReloadData:NO];
                    [(ArticleViewController*)viewController reloadData];
                }
                break;
            }
            }
        }
    }
    else if(self.smcMain.selectedSegmentIndex == 1)
    {
        [self.swipeViewB reloadData];
        
        hbTabBarB.hidden =NO;
        self.swipeViewB.hidden =NO;
        hbTabBarA.hidden =YES;
        self.swipeView.hidden =YES;
        
        UIView *currentView = [self.swipeViewB currentItemView];
            for (UIViewController *viewController in self.listVCB)
            {
                if (viewController && ![viewController isMemberOfClass:[NSNull class]])
                {
                if (viewController.view == currentView) {
//                    if ([viewController isMemberOfClass:[ArticleViewController class]]) {
//                        self.smcMain.enabled = NO;
//                        [(ArticleViewController*)viewController reloadData];
//                    }
                    if ([viewController isMemberOfClass:[ArticleViewController class]] && ((ArticleViewController*)viewController).isNeedReloadData)
                    {
                        self.smcMain.enabled = NO;
                        [(ArticleViewController*)viewController setIsNeedReloadData:NO];
                        [(ArticleViewController*)viewController reloadData];
                    }
                    break;
                }
                }
            }
        
    }
    
    
 }

-(void)showOpeningWalkThrough:(BOOL)animated
{
    if (!_walkthoughView) {
        NSArray *bgImages = OPENING_WALKTHROUGH_BG;
        NSArray *iconImages = OPENING_WALKTHROUGH_ICON;
        NSArray *iconPosYs = OPENING_WALKTHROUGH_ICON_POSY;
//        BOOL is35Screen = NO;
//        if ([UIDevice currentDevice].resolution == UIDeviceResolution_iPhoneRetina35) {
//            bgImages = OPENING_WALKTHROUGH_BG_35;
//            iconImages = OPENING_WALKTHROUGH_ICON_35;
//            iconPosYs = OPENING_WALKTHROUGH_ICON_POSY_35;
//            is35Screen = YES;
//        }
        NSMutableArray *pages = [NSMutableArray arrayWithCapacity:[bgImages count]];
        for(int i = 0; i < [bgImages count]; i++)
        {
            EAIntroPage *page = [EAIntroPage page];
            page.bgImage = [UIImage imageNamed:bgImages[i]];
            page.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconImages[i]]];
            page.titleIconPositionY = [iconPosYs[i] floatValue];
            [pages addObject:page];
        }
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:pages];
        intro.delegate = self;
        intro.backgroundColor = [UIColor whiteColor];
        intro.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        intro.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:29.0f/255.0f green:161.0f/255.0f blue:247.0f alpha:1.0f];
        intro.pageControlY = 7.0f;
        // buttons
        [intro.skipButton setTitle:@"Skip >" forState:UIControlStateNormal];
        [intro.skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        for (NSLayoutConstraint *contraint in intro.constraints)
        {
            if (contraint.firstItem == intro.skipButton || contraint.secondItem == intro.skipButton) {
                [intro removeConstraint:contraint];
            }
        }
        [intro addConstraint:[NSLayoutConstraint constraintWithItem:intro.skipButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:intro attribute:NSLayoutAttributeRight multiplier:1 constant:-15]];
        [intro addConstraint:[NSLayoutConstraint constraintWithItem:intro.skipButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:intro attribute:NSLayoutAttributeBottom multiplier:1 constant:-9]];
        
        // mark
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50.0f, self.view.bounds.size.width, 50.0f)];
        maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        [intro insertSubview:maskView belowSubview:intro.pageControl];
//        // sign up
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:[UIImage imageNamed:@"sign_up_button.png"] forState:UIControlStateNormal];
//        [btn setTitle:[MCLocalization stringForKey:@"Sign Up"] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont fontWithName:FONT_GOTHAM_BOLD size:17.0f];
//        [btn setFrame:CGRectMake(20, is35Screen ? (HEIGHT_IPHONE - 52) : (HEIGHT_IPHONE - 73), 129, 38)];
//        [btn addTarget:self action:@selector(signUpBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//        [intro addSubview:btn];
//        // sign in
//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:[UIImage imageNamed:@"sign_in_button.png"] forState:UIControlStateNormal];
//        [btn setTitle:[MCLocalization stringForKey:@"Sign In"] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont fontWithName:FONT_GOTHAM_BOLD size:17.0f];
//        [btn setFrame:CGRectMake(WIDTH_IPHONE - 149, is35Screen ? (HEIGHT_IPHONE - 52) :  (HEIGHT_IPHONE - 73), 129, 38)];
//        [btn addTarget:self action:@selector(signInBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//        [intro addSubview:btn];
        
        _walkthoughView = intro;
    }
    
    [self.walkthoughView showInView:self.view animateDuration:0.3f];
}

#pragma mark - EAIntroDelegate
-(void)introDidFinish:(EAIntroView *)introView{
    SelectProvinceView *selectProvince = [[SelectProvinceView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:selectProvince];
}

#pragma mark - NOTIFICATION

- (void)notificationCountChanged:(NSNotification*)ntf
{
    if(self.smcMain.selectedSegmentIndex ==0)
        [hbTabBarA reloadNotificationTabWithValue:SharedUserData.ntfCount];
    else
        [hbTabBarB reloadNotificationTabWithValue:SharedUserData.ntfCount];
}

#pragma mark - HBTabBarDelegate

- (BOOL)HBTabBar:(HBTabBar*)tab shouldSelectAtIndex:(int)index
{
    if (tab == hbTabBarA)
        return YES;
    else
        return YES;
}

- (BaseViewController*)viewControllerAtIndex:(NSInteger)newIndex
{
    
        // init
        if(self.smcMain.selectedSegmentIndex ==0)
        {
            
            id tempVC = [self.listVC objectAtIndex:newIndex];
            if ([tempVC isKindOfClass:[NSNull class]])
            {
                if(newIndex ==0)
                {
                    tempVC = [[ListCompanyInfoViewController alloc] init];
                }
                else if(newIndex == itemsTempA.count -4 )
                {
                    tempVC = [[AddViewController alloc] init];
                    ((AddViewController*)tempVC).bNews = YES;
                    ((AddViewController*)tempVC).array = _arrayItemNews;
                    ((AddViewController*)tempVC).delegate = self;
                }
                else if(newIndex == itemsTempA.count -3 )
                {
                    tempVC = [[BookmarksViewController alloc] init];
                }
                else if(newIndex == itemsTempA.count -2 )
                {
                    tempVC = [[SettingViewController alloc] init];
                }
                else if(newIndex == itemsTempA.count -1 )
                {
                    tempVC = [NotificationViewController new];
                }
                else
                {
                    tempVC = [ArticleViewController new];
                }
                
            }
            if (tempVC)
            {
                ((ListCompanyInfoViewController*)tempVC).delegate = self;
            }
            [self.listVC replaceObjectAtIndex:newIndex withObject:tempVC];
            return tempVC;
        }
        else
        {
            id tempVCB = [self.listVCB objectAtIndex:newIndex];
            if ([tempVCB isKindOfClass:[NSNull class]])
            {
                if(newIndex ==0)
                {
                    tempVCB = [[ListCompanyInfoViewController alloc] init];
                }
                else if(newIndex == itemsTempB.count -4 )
                {
                    tempVCB = [[AddViewController alloc] init];
                    ((AddViewController*)tempVCB).bNews = YES;
                    ((AddViewController*)tempVCB).array = _arrayItemRecruit;
                    ((AddViewController*)tempVCB).delegate = self;
                }
                else if(newIndex == itemsTempB.count -3 )
                {
                    tempVCB = [[BookmarksViewController alloc] init];
                }
                else if(newIndex == itemsTempB.count -2 )
                {
                    tempVCB = [[SettingViewController alloc] init];
                }
                else if(newIndex == itemsTempB.count -1 )
                {
                    tempVCB = [NotificationViewController new];
                }
                else
                {
                    tempVCB = [ArticleViewController new];
                }
            
            }
            if (tempVCB)
            {
                ((ListCompanyInfoViewController*)tempVCB).delegate = self;
            }
            [self.listVCB replaceObjectAtIndex:newIndex withObject:tempVCB];
            return tempVCB;
    }
}

- (void)HBTabBar:(HBTabBar*)tab didChangeItemIndex:(int)newIndex fromIndex:(int)oldIndex
{
    if(tab == hbTabBarA)
        [self.swipeView scrollToItemAtIndex:newIndex duration:0.0f];
    else
        [self.swipeViewB scrollToItemAtIndex:newIndex duration:0.0f];
    return;
}
-(void)addController:(AddViewController *)add selectItemIndex:(NSInteger)index itemID:(NSString *)itemID itemSelect:(BOOL)select
{
    if(self.smcMain.selectedSegmentIndex == 0)
    {
        
        NSDictionary *item = [_arrayItemNews objectAtIndex:index];
        NSMutableDictionary *it = [item mutableCopy];
        [it setObject:[NSNumber numberWithBool:select] forKey:@"select"];
        [_arrayItemNews replaceObjectAtIndex:index withObject:it];
        [[NSUserDefaults standardUserDefaults] setValue:_arrayItemNews forKey:@"categoryNews"];
        
        
        [itemsA removeAllObjects];
        [itemsA addObject:[HBTabItem initWithTitle:localizedString(@"Company\nInformation") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(81, 178, 255) withSelect:YES]];
        for(int i =0;i<_arrayItemNews.count;i++)
        {
            UIColor *color;
            if(i==0) color = RGB(111, 203, 28);
            else if(i==1) color = RGB(237, 165, 52);
            else if(i==2) color = RGB(238, 106, 106);
            else if(i==3) color = RGB(165, 108, 218);
            else if(i==4) color = RGB(81, 178, 255);
            else if(i==5) color = RGB(111, 203, 28);
            else if(i==6) color = RGB(237, 165, 52);
            else if(i==7) color = RGB(238, 106, 106);
            else if(i==8) color = RGB(165, 108, 218);
            else if(i==9) color = RGB(81, 178, 255);
            else color =RGB(81, 178, 255);
            
            
            [itemsA addObject:[HBTabItem initWithTitle:[[_arrayItemNews objectAtIndex:i] objectForKey:@"name"] type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:color withSelect:[[[_arrayItemNews objectAtIndex:i] objectForKey:@"select"] boolValue]]];
            
        }
        [itemsA addObject:[HBTabItem initWithTitle:@"+" type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(111, 203, 28) withSelect:YES]];
        [itemsA addObject:[HBTabItem initWithTitle:localizedString(@"Bookmark") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(237, 165, 52) withSelect:YES]];
        [itemsA addObject:[HBTabItem initWithTitle:localizedString(@"Settings") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(163, 163, 163) withSelect:YES]];
        
        //a bit difference with notification
        int marginRight = 2;
        int heightOfLabel = 20;
        UILabel *notificatonLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 - heightOfLabel - marginRight, (35 - heightOfLabel)/2, heightOfLabel, heightOfLabel)];//100 is width of notification tab view, 35 is height of tabView
        notificatonLabel.backgroundColor = RGB(255, 150, 0);
        notificatonLabel.text = STRINGIFY_INT(SharedUserData.ntfCount);
        notificatonLabel.font = NORMAL_FONT_WITH_SIZE(12);
        notificatonLabel.textColor = [UIColor whiteColor];
        notificatonLabel.layer.cornerRadius = notificatonLabel.frame.size.width/2;
        notificatonLabel.layer.masksToBounds = YES;
        notificatonLabel.textAlignment = NSTextAlignmentCenter;
        notificatonLabel.adjustsFontSizeToFitWidth = YES;
        
        HBTabItem *notificationItem = [HBTabItem initWithTitle:localizedString(@"Notifications") type:ENUM_TAP_TYPE_ADVANCE contentView:notificatonLabel withColor:RGB(81, 178, 255) withSelect:YES];
        notificationItem.widthItem = 100;
        [itemsA addObject:notificationItem];
        
        [itemsTempA removeAllObjects];
        for(int i= 0;i<itemsA.count;i++)
        {
            HBTabItem *item =[itemsA objectAtIndex:i];
            if(item.selected)
                [itemsTempA addObject:item];
        }
        
        
        [hbTabBarA removeFromSuperview];
        hbTabBarA.delegate = nil;
        hbTabBarA.delegate = nil;
        
        hbTabBarA = [[HBTabBar alloc] initWithWithFrame:self.tabContainerView.bounds items:itemsTempA];
        hbTabBarA.delegate = self;
        [self.tabContainerView addSubview:hbTabBarA];
        
        [self.listVC removeAllObjects];
        for (NSInteger i = 0; i < [itemsTempA count]; i++) {
            [self.listVC addObject:[NSNull null]];
        }
        
        
        [self.swipeView reloadData];
        [hbTabBarA setCurrentItemIndex:itemsTempA.count-4];
        [hbTabBarA scrollToIndex:itemsTempA.count-4 withAnimate:NO];
        [hbTabBarA reloadData];
       
        
    }
    else
    {
        NSDictionary *item = [_arrayItemRecruit objectAtIndex:index];
        NSMutableDictionary *it = [item mutableCopy];
        [it setObject:[NSNumber numberWithBool:select] forKey:@"select"];
        [_arrayItemRecruit replaceObjectAtIndex:index withObject:it];
        [[NSUserDefaults standardUserDefaults] setValue:_arrayItemRecruit forKey:@"categoryRecruit"];
        
        [itemsB removeAllObjects];
        [itemsB addObject:[HBTabItem initWithTitle:localizedString(@"Company\nInformation") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(81, 178, 255) withSelect:YES]];
        for(int i =0;i<_arrayItemRecruit.count;i++)
        {
            UIColor *color;
            if(i==0) color = RGB(111, 203, 28);
            else if(i==1) color = RGB(237, 165, 52);
            else if(i==2) color = RGB(238, 106, 106);
            else if(i==3) color = RGB(165, 108, 218);
            else if(i==4) color = RGB(81, 178, 255);
            else if(i==5) color = RGB(111, 203, 28);
            else if(i==6) color = RGB(237, 165, 52);
            else if(i==7) color = RGB(238, 106, 106);
            else if(i==8) color = RGB(165, 108, 218);
            else if(i==9) color = RGB(81, 178, 255);
            else color =RGB(81, 178, 255);
            
            [itemsB addObject:[HBTabItem initWithTitle:[[_arrayItemRecruit objectAtIndex:i] objectForKey:@"name"] type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:color withSelect:[[[_arrayItemRecruit objectAtIndex:i] objectForKey:@"select"] boolValue]]];
            
        }
        [itemsB addObject:[HBTabItem initWithTitle:@"+" type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(165, 108, 218) withSelect:YES]];
        [itemsB addObject:[HBTabItem initWithTitle:localizedString(@"Bookmark") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(81, 178, 255) withSelect:YES]];
        [itemsB addObject:[HBTabItem initWithTitle:localizedString(@"Settings") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(163, 163, 163) withSelect:YES]];
        
        //a bit difference with notification
        int marginRightB = 2;
        int heightOfLabelB = 20;
        UILabel *notificatonLabelB = [[UILabel alloc] initWithFrame:CGRectMake(100 - heightOfLabelB - marginRightB, (35 - heightOfLabelB)/2, heightOfLabelB, heightOfLabelB)];//100 is width of notification tab view, 35 is height of tabView
        notificatonLabelB.backgroundColor = RGB(255, 150, 0);
        notificatonLabelB.text = STRINGIFY_INT(SharedUserData.ntfCount);
        notificatonLabelB.font = NORMAL_FONT_WITH_SIZE(12);
        notificatonLabelB.textColor = [UIColor whiteColor];
        notificatonLabelB.layer.cornerRadius = notificatonLabelB.frame.size.width/2;
        notificatonLabelB.layer.masksToBounds = YES;
        notificatonLabelB.textAlignment = NSTextAlignmentCenter;
        notificatonLabelB.adjustsFontSizeToFitWidth = YES;
        
        
        HBTabItem *notificationItemB = [HBTabItem initWithTitle:localizedString(@"Notifications") type:ENUM_TAP_TYPE_ADVANCE contentView:notificatonLabelB withColor:RGB(81, 178, 255) withSelect:YES];
        notificationItemB.widthItem = 100;
        [itemsB addObject:notificationItemB];
        
        [itemsTempB removeAllObjects];
        for(int i= 0;i<itemsB.count;i++)
        {
            HBTabItem *item =[itemsB objectAtIndex:i];
            if(item.selected)
                [itemsTempB addObject:item];
        }
        
       
        
        [hbTabBarB removeFromSuperview];
        hbTabBarB.delegate = nil;
        hbTabBarB.delegate = nil;
        
        hbTabBarB = [[HBTabBar alloc] initWithWithFrame:self.tabContainerView.bounds items:itemsTempB];
        hbTabBarB.delegate = self;
        [self.tabContainerView addSubview:hbTabBarB];
        
        [self.listVCB removeAllObjects];
        for (NSInteger i = 0; i < [itemsTempB count]; i++) {
            [self.listVCB addObject:[NSNull null]];
        }
        
        [hbTabBarB setCurrentItemIndex:itemsTempB.count-4];
        [hbTabBarB scrollToIndex:itemsTempB.count-4 withAnimate:NO];
        [hbTabBarB reloadData];
        
        [self.swipeViewB reloadData];
    }
}
-(void)addController:(AddViewController *)add moveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toInddex
{
    if(self.smcMain.selectedSegmentIndex == 0)
    {
        [itemsA exchangeObjectAtIndex:fromIndex+1 withObjectAtIndex:toInddex+1];
        [_arrayItemNews exchangeObjectAtIndex:fromIndex withObjectAtIndex:toInddex];
        [[NSUserDefaults standardUserDefaults] setValue:_arrayItemNews forKey:@"categoryNews"];
        
        

    }
    else
    {
        [itemsB exchangeObjectAtIndex:fromIndex withObjectAtIndex:toInddex];
        [_arrayItemRecruit exchangeObjectAtIndex:fromIndex withObjectAtIndex:toInddex];
        [[NSUserDefaults standardUserDefaults] setValue:_arrayItemRecruit forKey:@"categoryRecruit"];
        
        
    }
}
-(void)addControllerFinish:(AddViewController *)add
{
    if(self.smcMain.selectedSegmentIndex == 0)
    {
        [itemsA removeAllObjects];
        [itemsA addObject:[HBTabItem initWithTitle:localizedString(@"Company\nInformation") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(81, 178, 255) withSelect:YES]];
        for(int i =0;i<_arrayItemNews.count;i++)
        {
            UIColor *color;
            if(i==0) color = RGB(111, 203, 28);
            else if(i==1) color = RGB(237, 165, 52);
            else if(i==2) color = RGB(238, 106, 106);
            else if(i==3) color = RGB(165, 108, 218);
            else if(i==4) color = RGB(81, 178, 255);
            else if(i==5) color = RGB(111, 203, 28);
            else if(i==6) color = RGB(237, 165, 52);
            else if(i==7) color = RGB(238, 106, 106);
            else if(i==8) color = RGB(165, 108, 218);
            else if(i==9) color = RGB(81, 178, 255);
            else color =RGB(81, 178, 255);
            
            
            [itemsA addObject:[HBTabItem initWithTitle:[[_arrayItemNews objectAtIndex:i] objectForKey:@"name"] type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:color withSelect:[[[_arrayItemNews objectAtIndex:i] objectForKey:@"select"] boolValue]]];
            
        }
        [itemsA addObject:[HBTabItem initWithTitle:@"+" type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(111, 203, 28) withSelect:YES]];
        [itemsA addObject:[HBTabItem initWithTitle:localizedString(@"Bookmark") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(237, 165, 52) withSelect:YES]];
        [itemsA addObject:[HBTabItem initWithTitle:localizedString(@"Settings") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(163, 163, 163) withSelect:YES]];
        
        //a bit difference with notification
        int marginRight = 2;
        int heightOfLabel = 20;
        UILabel *notificatonLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 - heightOfLabel - marginRight, (35 - heightOfLabel)/2, heightOfLabel, heightOfLabel)];//100 is width of notification tab view, 35 is height of tabView
        notificatonLabel.backgroundColor = RGB(255, 150, 0);
        notificatonLabel.text = STRINGIFY_INT(SharedUserData.ntfCount);
        notificatonLabel.font = NORMAL_FONT_WITH_SIZE(12);
        notificatonLabel.textColor = [UIColor whiteColor];
        notificatonLabel.layer.cornerRadius = notificatonLabel.frame.size.width/2;
        notificatonLabel.layer.masksToBounds = YES;
        notificatonLabel.textAlignment = NSTextAlignmentCenter;
        notificatonLabel.adjustsFontSizeToFitWidth = YES;
       
        HBTabItem *notificationItem = [HBTabItem initWithTitle:localizedString(@"Notifications") type:ENUM_TAP_TYPE_ADVANCE contentView:notificatonLabel withColor:RGB(81, 178, 255) withSelect:YES];
        notificationItem.widthItem = 100;
        [itemsA addObject:notificationItem];
        
        [itemsTempA removeAllObjects];
        for(int i= 0;i<itemsA.count;i++)
        {
            HBTabItem *item =[itemsA objectAtIndex:i];
            if(item.selected)
                [itemsTempA addObject:item];
        }
        
        [hbTabBarA removeFromSuperview];
        hbTabBarA.delegate = nil;
        hbTabBarA.delegate = nil;
        
        hbTabBarA = [[HBTabBar alloc] initWithWithFrame:self.tabContainerView.bounds items:itemsTempA];
        hbTabBarA.delegate = self;
        [self.tabContainerView addSubview:hbTabBarA];
        
        [self.listVC removeAllObjects];
        for (NSInteger i = 0; i < [itemsTempA count]; i++) {
            [self.listVC addObject:[NSNull null]];
        }
        
        
        [self.swipeView reloadData];
        [hbTabBarA setCurrentItemIndex:itemsTempA.count-4];
        [hbTabBarA scrollToIndex:itemsTempA.count-4 withAnimate:NO];
        [hbTabBarA reloadData];
    }
    else
    {
        [itemsB removeAllObjects];
        [itemsB addObject:[HBTabItem initWithTitle:localizedString(@"Company\nInformation") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(81, 178, 255) withSelect:YES]];
        for(int i =0;i<_arrayItemRecruit.count;i++)
        {
            UIColor *color;
            if(i==0) color = RGB(111, 203, 28);
            else if(i==1) color = RGB(237, 165, 52);
            else if(i==2) color = RGB(238, 106, 106);
            else if(i==3) color = RGB(165, 108, 218);
            else if(i==4) color = RGB(81, 178, 255);
            else if(i==5) color = RGB(111, 203, 28);
            else if(i==6) color = RGB(237, 165, 52);
            else if(i==7) color = RGB(238, 106, 106);
            else if(i==8) color = RGB(165, 108, 218);
            else if(i==9) color = RGB(81, 178, 255);
            else color =RGB(81, 178, 255);
            
            [itemsB addObject:[HBTabItem initWithTitle:[[_arrayItemRecruit objectAtIndex:i] objectForKey:@"name"] type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:color withSelect:[[[_arrayItemRecruit objectAtIndex:i] objectForKey:@"select"] boolValue]]];
            
        }
        [itemsB addObject:[HBTabItem initWithTitle:@"+" type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(165, 108, 218) withSelect:YES]];
        [itemsB addObject:[HBTabItem initWithTitle:localizedString(@"Bookmark") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(81, 178, 255) withSelect:YES]];
        [itemsB addObject:[HBTabItem initWithTitle:localizedString(@"Settings") type:ENUM_TAP_TYPE_SIMPLE contentView:nil withColor:RGB(163, 163, 163) withSelect:YES]];
        
        //a bit difference with notification
        int marginRightB = 2;
        int heightOfLabelB = 20;
        UILabel *notificatonLabelB = [[UILabel alloc] initWithFrame:CGRectMake(100 - heightOfLabelB - marginRightB, (35 - heightOfLabelB)/2, heightOfLabelB, heightOfLabelB)];//100 is width of notification tab view, 35 is height of tabView
        notificatonLabelB.backgroundColor = RGB(255, 150, 0);
        notificatonLabelB.text = STRINGIFY_INT(SharedUserData.ntfCount);
        notificatonLabelB.font = NORMAL_FONT_WITH_SIZE(12);
        notificatonLabelB.textColor = [UIColor whiteColor];
        notificatonLabelB.layer.cornerRadius = notificatonLabelB.frame.size.width/2;
        notificatonLabelB.layer.masksToBounds = YES;
        notificatonLabelB.textAlignment = NSTextAlignmentCenter;
        notificatonLabelB.adjustsFontSizeToFitWidth = YES;
        
        
        HBTabItem *notificationItemB = [HBTabItem initWithTitle:localizedString(@"Notifications") type:ENUM_TAP_TYPE_ADVANCE contentView:notificatonLabelB withColor:RGB(81, 178, 255) withSelect:YES];
        notificationItemB.widthItem = 100;
        [itemsB addObject:notificationItemB];
        
        [itemsTempB removeAllObjects];
        for(int i= 0;i<itemsB.count;i++)
        {
            HBTabItem *item =[itemsB objectAtIndex:i];
            if(item.selected)
                [itemsTempB addObject:item];
        }
        
        [hbTabBarB removeFromSuperview];
        hbTabBarB.delegate = nil;
        hbTabBarB.delegate = nil;
        
        hbTabBarB = [[HBTabBar alloc] initWithWithFrame:self.tabContainerView.bounds items:itemsTempB];
        hbTabBarB.delegate = self;
        [self.tabContainerView addSubview:hbTabBarB];
        
        [self.listVCB removeAllObjects];
        for (NSInteger i = 0; i < [itemsTempB count]; i++) {
            [self.listVCB addObject:[NSNull null]];
        }
        
        [hbTabBarB setCurrentItemIndex:itemsTempB.count-4];
        [hbTabBarB scrollToIndex:itemsTempB.count-4 withAnimate:NO];
        [hbTabBarB reloadData];
        
        [self.swipeViewB reloadData];
    }
}
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    if(swipeView == self.swipeView)
        return [itemsTempA count];
    else
        return [itemsTempB count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(swipeView == self.swipeView)
    {
        BaseViewController *controller = [self viewControllerAtIndex:index];
        view = controller.view;
        //to force call viewDidLoad method
        controller.view.frame = swipeView.bounds;
        
        if ([hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_COMPANY_INFO ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_NEW_TOPIC ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_ECONOMY ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_IT_CREATING ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_MEDICAL_LINE ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_SERVICE ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_HUMAN_RESOURCES ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_SOCIAL ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_ENTERTAINMENT ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_FINANCIAL ||
            [hbTabBarA currentItemIndex] == ENUM_CAREER_CHANGE_JOB) {
            [controller addIMobileAddInController:controller];
        }
        if ([controller isMemberOfClass:[ArticleViewController class]])
        {
            //set category
            ArticleViewController *articleVC = (ArticleViewController*)controller;
            articleVC.isTopic = index == 1;
            
            [articleVC setCompleteRequest:^(BOOL  isSuccess) {
                self.smcMain.enabled = YES;
            }];
            
            HBTabItem *item = itemsTempA[index];
            ArticleCategoryModel *category = [ArticleCategoryModel new];
            category.categoryTitle = item.title;
            NSString *categoryId = [[_arrayItemNews objectAtIndex:index-1] objectForKey:@"id"];
            category.categoryID = categoryId;
            
            articleVC.category = category;
        }
        return view;
    }
    else
    {
        BaseViewController *controller = [self viewControllerAtIndex:index];
        view = controller.view;
        //to force call viewDidLoad method
        controller.view.frame = swipeView.bounds;
        
        if ([hbTabBarB currentItemIndex] == ENUM_CAREER_CHANGE_COMPANY_INFO ||
            [hbTabBarB currentItemIndex] == ENUM_CAREER_CHANGE_NEW_TOPIC ||
            [hbTabBarB currentItemIndex] == ENUM_CAREER_CHANGE_ECONOMY ||
            [hbTabBarB currentItemIndex] == ENUM_CAREER_CHANGE_IT_CREATING ||
            [hbTabBarB currentItemIndex] == ENUM_CAREER_CHANGE_MEDICAL_LINE ||
            [hbTabBarB currentItemIndex] == ENUM_CAREER_CHANGE_SERVICE ||
            [hbTabBarB currentItemIndex] == ENUM_CAREER_CHANGE_HUMAN_RESOURCES ||
            [hbTabBarB currentItemIndex] == ENUM_CAREER_CHANGE_SOCIAL ||
            [hbTabBarB currentItemIndex] == ENUM_CAREER_CHANGE_ENTERTAINMENT ){
            [controller addIMobileAddInController:controller];
        }
        if ([controller isMemberOfClass:[ArticleViewController class]]) {
            //set category
            ArticleViewController *articleVC = (ArticleViewController*)controller;
            articleVC.isTopic = NO;
            
            [articleVC setCompleteRequest:^(BOOL  isSuccess) {
                self.smcMain.enabled = YES;
            }];
            
            HBTabItem *item = itemsTempB[index];
            ArticleCategoryModel *category = [ArticleCategoryModel new];
            category.categoryTitle = item.title;
            NSString *categoryId =  [[_arrayItemRecruit objectAtIndex:index-1] objectForKey:@"id"];
            category.categoryID = categoryId;
            
            articleVC.category = category;
        }
        return view;
    }
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    if(swipeView == self.swipeView)
        return self.swipeView.bounds.size;
    else
        return self.swipeViewB.bounds.size;
}

- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView
{
    
    
    if(swipeView == self.swipeView)
    {
        if (!self.currentController) {
            BaseViewController *toViewController = (BaseViewController*)[[swipeView itemViewAtIndex:swipeView.currentItemIndex] parentViewController];
            self.currentController = toViewController;
        }
    }
    else
    {
        if (!self.currentControllerB) {
            BaseViewController *toViewController = (BaseViewController*)[[swipeView itemViewAtIndex:swipeView.currentItemIndex] parentViewController];
            self.currentControllerB = toViewController;
        }
    }
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    numberSwipeA++;
    if(numberSwipeA == 10)
    {
        numberSwipeA = 0;
        [self addIMobileAddInControllerPopup:self];
    }
    
    if(swipeView == self.swipeView)
    {
        if (!swipeView.scrolling)
        {
                [hbTabBarA layoutItemAtIndex:swipeView.currentItemIndex shouldChangeView:NO];
                self.currentController = (BaseViewController*)[[swipeView itemViewAtIndex:swipeView.currentItemIndex] parentViewController];
        }
        
        // check to reload data
        UIView *currentView = [self.swipeView currentItemView];
        for (UIViewController *viewController in self.listVC)
        {
            if (viewController && ![viewController isMemberOfClass:[NSNull class]]) {
                if (viewController.view == currentView) {
                    if ([viewController isMemberOfClass:[ArticleViewController class]] && ((ArticleViewController*)viewController).isNeedReloadData)
                    {
                        [(ArticleViewController*)viewController setIsNeedReloadData:NO];
                        [(ArticleViewController*)viewController reloadData];
                    }
                    break;
                }
            }
        }
    }
    else
    {
        if (!swipeView.scrolling) {
           
                [hbTabBarB layoutItemAtIndex:swipeView.currentItemIndex shouldChangeView:NO];
                self.currentControllerB = (BaseViewController*)[[swipeView itemViewAtIndex:swipeView.currentItemIndex] parentViewController];
            
        }
        
        // check to reload data
        UIView *currentView = [self.swipeViewB currentItemView];
        for (UIViewController *viewController in self.listVCB)
        {
            if (viewController && ![viewController isMemberOfClass:[NSNull class]])
            {
                if (viewController.view == currentView)
                {
                    if ([viewController isMemberOfClass:[ArticleViewController class]] && ((ArticleViewController*)viewController).isNeedReloadData)
                    {
                        [(ArticleViewController*)viewController setIsNeedReloadData:NO];
                        [(ArticleViewController*)viewController reloadData];
                    }
                    break;
                }
            }
        }
    }
    
}

- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
}

#pragma mark - Swipe gesture

#pragma mark - TabViewProtocol

-(UIViewController *)mainTabViewController
{
    return self;
}

@end


@implementation UIView (mxcl)
- (UIViewController *)parentViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
        return (UIViewController*)responder;
    return nil;
}
@end