//
//  CustomNavigationView.h
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
   ENUM_NAVIGATION_TYPE_BACK,
    ENUM_NAVIGATION_TYPE_NONE
    
}ENUM_NAVIGATION_TYPE;

typedef enum
{
    ENUM_NAVIGATION_ACTION_TYPE_BACK,
    ENUM_NAVIGATION_ACTION_TYPE_RIGHT_ACTION//or something like that
    
}ENUM_NAVIGATION_ACTION_TYPE;

@interface CustomNavigationView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)btnBackTouchUpInside:(id)sender;
- (instancetype)initWithType:(ENUM_NAVIGATION_TYPE)type frame:(CGRect)frame;
- (void)addActionHandler:(void(^)(ENUM_NAVIGATION_ACTION_TYPE actionType))action;
@end
