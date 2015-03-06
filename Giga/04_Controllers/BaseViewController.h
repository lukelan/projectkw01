//
//  BaseViewController.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TabViewProtocol <NSObject>

-(UIViewController*)mainTabViewController;

@end

@interface BaseViewController : UIViewController


- (void)addIMobileAddInController:(UIViewController*)vc;
- (void)addIMobileAddInControllerComment:(UIViewController*)vc;
- (void)addIMobileAddInControllerPopup:(UIViewController*)vc;
- (void)enablePopGesture:(BOOL)enable;

@end
