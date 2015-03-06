//
//  UILabel+resizewithtext.m
//  Giga
//
//  Created by VisiKardMacBookPro on 12/22/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "UILabel+resizewithtext.h"

@implementation UILabel (sizewithtext)
-(float)newHeightWithContent:(NSString *)text {
    self.text = text;
    CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 10000)];
    CGRect rect = self.frame;
    rect.size.height = size.height;
    self.frame = rect;
    
    return size.height;
}

-(float)newHeightWithContent:(NSString *)text andFont:(UIFont *)font {
    self.font = font;
    self.text = text;
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width, 10000)];
    CGRect rect = self.frame;
    rect.size.height = size.height;
    self.frame = rect;
    
    return size.height;
}

@end