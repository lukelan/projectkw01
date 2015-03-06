//
//  CustomMBProgressHUD.m
//  Giga
//
//  Created by CX MAC on 12/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CustomMBProgressHUD.h"

@implementation CustomMBProgressHUD

+ (MB_INSTANCETYPE)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    CustomMBProgressHUD *instance = (CustomMBProgressHUD*)[view viewWithTag:12345];
    if (instance && [instance isKindOfClass:[MBProgressHUD class]]) {
        return instance;
    }
	CustomMBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.tag = 12345;
	[view addSubview:hud];
	[hud show:animated];
	return hud;
}

@end
