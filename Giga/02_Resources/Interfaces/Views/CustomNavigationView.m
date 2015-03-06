//
//  CustomNavigationView.m
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CustomNavigationView.h"
#import <objc/runtime.h>

static char const * const navigationActionBlockTag = "navigationActionBlockTag";

@implementation CustomNavigationView

- (instancetype)initWithType:(ENUM_NAVIGATION_TYPE)type frame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomNavigationView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.lbTitle.font = BOLD_FONT_WITH_SIZE(17);
    }
    return self;
}

- (instancetype)initWithType:(ENUM_NAVIGATION_TYPE)type
{
    return [self initWithType:type frame:CGRectMake(0, 0, 320, 64)];
}

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomNavigationView" owner:self options:nil] lastObject];
    self.lbTitle.font = BOLD_FONT_WITH_SIZE(17);
    return self;
}

- (IBAction)btnBackTouchUpInside:(id)sender {
    void(^actionBlock)(ENUM_NAVIGATION_ACTION_TYPE) = objc_getAssociatedObject(self, navigationActionBlockTag);
    if (actionBlock) {
        actionBlock(ENUM_NAVIGATION_ACTION_TYPE_BACK);
    }
}

- (void)addActionHandler:(void(^)(ENUM_NAVIGATION_ACTION_TYPE actionType))action
{
    objc_setAssociatedObject(self, navigationActionBlockTag, action, OBJC_ASSOCIATION_COPY);
}

@end
