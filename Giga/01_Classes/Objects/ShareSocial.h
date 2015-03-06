//
//  ShareSocial.h
//  Giga
//
//  Created by vandong on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareSocial : NSObject 
+ (ShareSocial *)share;

- (void)showShareSelectionInView:(UIView *)view withObject:(NSObject *)shareObject;
@end
