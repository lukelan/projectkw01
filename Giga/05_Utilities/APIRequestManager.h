//
//  APIRequestManager.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define SharedAPIRequestManager                     [APIRequestManager sharedManager]

@interface APIRequestManager : AFHTTPRequestOperationManager

+ (APIRequestManager*)sharedManager;

- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type
                            andPostMethodKind:(BOOL)methodKind
                                    andParams:(NSMutableDictionary *)params
                                       inView:(UIView *)view
                shouldCancelAllCurrentRequest:(BOOL)shouldCancel
                                completeBlock:(void (^)(id responseObject))block
                                 failureBlock:(void (^)(NSError *error))failureBlock;

- (void)cancelAllOperations;

@end

@interface AFURLConnectionOperation (Extention)
/**
 Adds content types to the set of acceptable MIME types returned by `+acceptableContentTypes` in subsequent calls by this class and its descendants.
 
 @param contentTypes The content types to be added to the set of acceptable MIME types
 */
+ (void)addAcceptableContentTypes:(NSSet *)contentTypes;

@end