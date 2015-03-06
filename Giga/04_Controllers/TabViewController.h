//
//  TabViewController.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface TabViewController : BaseViewController
//header
@property (weak, nonatomic) IBOutlet UISegmentedControl *smcMain;
- (IBAction)smcValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbHeader;

@property (weak, nonatomic) IBOutlet UIView *tabContainerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end


@interface UIView (mxcl)
- (UIViewController *)parentViewController;
@end