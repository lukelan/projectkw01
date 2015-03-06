//
//  UILabel+resizewithtext.h
//  Giga
//
//  Created by VisiKardMacBookPro on 12/22/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (sizewithtext)
-(float)newHeightWithContent:(NSString *)text;
-(float)newHeightWithContent:(NSString *)text andFont:(UIFont *)font;
@end

