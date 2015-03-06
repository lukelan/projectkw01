//
//  PolicyViewController.h
//  Giga
//
//  Created by Tai Truong on 11/29/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    enumPolicyViewType_TermOfUse = 0,
    enumPolicyViewType_Policy,
    enumPolicyViewType_Num
}enumPolicyViewType;

@interface PolicyViewController : BaseViewController
@property (assign, nonatomic) enumPolicyViewType type;
@end
