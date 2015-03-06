//
//  NSString+Utilities.m
//  Giga
//
//  Created by CX MAC on 12/3/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)
- (NSString*)validString
{
    if (!self) {
        return @"";
    }
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
