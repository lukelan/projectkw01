//
//  BaseModel.m
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
@implementation BaseModel

- (NSString *)description
{
    return [BaseModel autoDescribe:self];
}

+ (NSString*)autoDescribe:(id)instance
{
    @try {
        NSString *headerString = [NSString stringWithFormat:@"%@:%p:: ",[instance class], instance];
        return [headerString stringByAppendingString:[self autoDescribe:instance classType:[instance class]]];
    }
    @catch (NSException *exception){
        return [instance description];
    }
    @finally {
        
    }
}

// Finds all properties of an object, and prints each one out as part of a string describing the class.
+ (NSString*)autoDescribe:(id)instance classType:(Class)classType
{
    unsigned int count;
    objc_property_t *propList = class_copyPropertyList(classType, &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableString *propPrint = [NSMutableString string];
    for ( int i = 0; i < count; i++ )
    {
        objc_property_t property = propList[i];
        
        const char *propName = property_getName(property);
        NSString *propNameString =[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        
        if(propName)
        {
            id value = [instance valueForKey:propNameString];
            if (!value) {
                value = @"";
            }
            [dict setObject:value forKey:propNameString];
        }
    }
    free(propList);
    [propPrint appendString:dict.description];
    
    // Now see if we need to map any superclasses as well.
    Class superClass = class_getSuperclass( classType );
    if ( superClass != nil && ! [superClass isEqual:[NSObject class]] )
    {
        NSString *superString = [self autoDescribe:instance classType:superClass];
        if (![superString isEqualToString:@"{\n}"]) {
            [propPrint appendString:superString];
        }
    }
    
    return propPrint;
}

- (void)prepareObject
{
    [BaseModel prepare:self classType:[self class]];
}

+ (void)prepare:(id)instance classType:(Class)classType
{
    unsigned int count;
    objc_property_t *propList = class_copyPropertyList(classType, &count);
    for ( int i = 0; i < count; i++ )
    {
        objc_property_t property = propList[i];
        
        const char *propName = property_getName(property);
        NSString *propNameString =[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        
        if(propName)
        {
            id value = [instance valueForKey:propNameString];
            if (!value || [value isKindOfClass:[NSNull class]]) {
                value = @"";
            }
            [instance setValue:value forKey:propNameString];
        }
    }
    free(propList);
    
    
    // Now see if we need to map any superclasses as well.
    Class superClass = class_getSuperclass( classType );
    if ( superClass != nil && ! [superClass isEqual:[NSObject class]] )
    {
        [self prepare:instance classType:superClass];
    }
}
@end
