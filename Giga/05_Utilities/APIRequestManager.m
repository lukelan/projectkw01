//
//  APIRequestManager.m
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "APIRequestManager.h"
#import <objc/runtime.h>
#import "AFNetworkActivityIndicatorManager.h"

@implementation APIRequestManager

+ (APIRequestManager*)sharedManager
{
    static APIRequestManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[APIRequestManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
//        sharedManager.securityPolicy.SSLPinningMode = AFSSLPinningModeCertificate;
    });
    
    return sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [Utils showNoInternetConnectionErrorIfNeed:NO];
                    break;
                    
                default:
                    [Utils showNoInternetConnectionErrorIfNeed:YES];
                    break;
            }
            
        }];
        [self.reachabilityManager startMonitoring];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    return self;
}

- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type
                            andPostMethodKind:(BOOL)methodKind
                                    andParams:(NSMutableDictionary *)params
                                       inView:(UIView *)view
                shouldCancelAllCurrentRequest:(BOOL)shouldCancel
                                completeBlock:(void (^)(id responseObject))block
                                 failureBlock:(void (^)(NSError *error))failureBlock
{
    if (shouldCancel) {
        DLog(@"Cancel operation");
        [self cancelAllOperations];
    }
    NSString *path = nil;
    AFHTTPRequestOperation *operation;
    
    switch (type) {
        case ENUM_API_REQUEST_TYPE_USER_ACCESS:
            path = STRING_API_REQUEST_USER_ACCESS;
            break;
        case ENUM_API_REQUEST_TYPE_GET_LIST_ARTICLE:
            path = STRING_API_REQUEST_GET_LIST_ARTICLE;
            break;
        case ENUM_API_REQUEST_TYPE_GET_NOTIFICATION_COUNT:
            path = STRING_API_REQUEST_GET_NOTIFICATION_COUNT;
            break;
        case ENUM_API_REQUEST_TYPE_GET_NOTIFICATION_LIST:
            path = STRING_API_REQUEST_GET_NOTIFICATION_LIST;
            break;
        case ENUM_API_REQUEST_TYPE_READ_NOTIFICATION:
            path = STRING_API_REQUEST_READ_NOTIFICATION;
            break;
        case ENUM_API_REQUEST_TYPE_SHARE_INAPP:
            path = STRING_API_REQUEST_SHARE_INAPP;
            break;
        case ENUM_API_REQUEST_TYPE_VIEW_ARTICLE:
            path = STRING_API_REQUEST_VIEW_ARTICLE;
            break;
        case ENUM_API_REQUEST_TYPE_GET_LIST_COMPANY:
            path = STRING_API_REQUEST_GET_LIST_COMPANY;
            break;
        case ENUM_API_REQUEST_TYPE_GET_ARTICLE_COMMENTS:
            path = STRING_API_REQUEST_GET_ARTICLE_COMMENTS;
            break;
        case ENUM_API_REQUEST_TYPE_GET_ARTICLE_DETAIL:
            path = STRING_API_REQUEST_GET_ARTICLE_DETAIL;
            break;
        case ENUM_API_REQUEST_TYPE_POST_ARTICLE_COMMENT:
            path = STRING_API_REQUEST_POST_ARTICLE_COMMENT;
            break;
        case ENUM_API_REQUEST_TYPE_GET_COMPANY_STOCK:
            path = STRING_API_REQUEST_GET_COMPANY_STOCK;
            break;
        case ENUM_API_REQUEST_TYPE_SEARCH_COMPANY_BY_NAME:
            path = STRING_API_REQUEST_SEARCH_COMPANY_BY_NAME;
            break;
        case ENUM_API_REQUEST_TYPE_MAKE_LIKE_DISKLIKE_COMMENT:
            path = STRING_API_REQUEST_MAKE_LIKE_DISLIKE_COMMENT;
            break;
        case ENUM_API_REQUEST_TYPE_MAKE_REPORT_COMMENT:
            path = STRING_API_REQUEST_MAKE_REPORT_COMMENT;
            break;
        case ENUM_API_REQUEST_TYPE_MAKE_BOOKMARK:
            path = STRING_API_REQUEST_MAKE_BOOKMARK;
            break;
        case ENUM_API_REQUEST_TYPE_MAKE_UN_BOOKMARK:
            path = STRING_API_REQUEST_MAKE_UN_BOOKMARK;
            break;
        case ENUM_API_REQUEST_TYPE_GET_COMPANY_INFO:
            path = STRING_API_REQUEST_GET_COMPANY_INFO;
            break;
        case ENUM_API_REQUEST_TYPE_GET_COMPANY_CATEGORIES:
            path = STRING_API_REQUEST_GET_COMPANY_CATEGORIES;
            break;
        case ENUM_API_REQUEST_TYPE_GET_COMPANY_BY_CATEGORY:
            path = STRING_API_REQUEST_GET_COMPANY_BY_CATEGORY;
            break;
        case ENUM_API_REQUEST_TYPE_GET_RELATIVE_NEWS:
            path = STRING_API_REQUEST_GET_RELATIVE_NEWS;
            break;
        case ENUM_API_REQUEST_TYPE_GET_RECRUIT_RELATIVE_NEWS:
            path = STRING_API_REQUEST_GET_RECRUIT_RELATIVE_NEWS;
            break;
        case ENUM_API_REQUEST_TYPE_GET_TOPICS:
            path = STRING_API_REQUEST_GET_TOPICS;
            break;
        case ENUM_API_REQUEST_TYPE_GET_TOP_TITLE:
            path = STRING_API_REQUEST_GET_TOP_TITLE;
            break;
        case ENUM_API_REQUEST_TYPE_GET_ARTICLES_BY_IDS:
            path = STRING_API_REQUEST_GET_ARTICLES_BY_IDS;
            break;
        case ENUM_API_REQUEST_TYPE_GET_CATEGORY:
            path = STRING_API_REQUEST_GET_CATEGORY;
            break;
        case ENUM_API_REQUEST_TYPE_GET_TOP_THREE_NEWS:
            path = STRING_API_REQUEST_GET_TOP_THREE_NEWS;
            break;
        case ENUM_API_REQUEST_TYPE_GET_STOCK_YAHOO:
            path = STRING_API_REQUEST_GET_STOCK_YAHOO;
            break;
    }
    [self executedOperation:&operation
                   withType:type
                 methodKind:methodKind
                       view:view
                       path:path
                     params:params
                      block:block
               failureBlock:failureBlock];
    return operation;
}

- (void)executedOperation:(AFHTTPRequestOperation **)operation
                 withType:(ENUM_API_REQUEST_TYPE)type
               methodKind:(BOOL)methodKind
                     view:(UIView *)view
                     path:(NSString *)path
                   params:(NSMutableDictionary *)params
                    block:(void (^)(id))block
             failureBlock:(void (^)(id))blockFailure
{
    NSMutableURLRequest *request;
    if (!methodKind) {
        request = [self.requestSerializer requestWithMethod:@"GET"
                                                  URLString:path
                                                 parameters:params
                                                      error:nil];
    } else {
        //add params
        [params setObject:API_REQUEST_APP_ID forKey:@"id"];
        [params setObject:API_REQUEST_APP_TYPE forKey:@"ap"];
        [params setObject:API_REQUEST_APP_SECRET_KEY forKey:@"secret"];
        
        request = [self.requestSerializer requestWithMethod:@"POST"
                                                  URLString:path
                                                 parameters:params
                                                      error:nil];
    }
    
    request.timeoutInterval = TIMER_REQUEST_TIMEOUT;
    
    *operation = [self constructOperationwithType:type
                                       andRequest:request
                                           inView:view
                                    completeBlock:block
                                     failureBlock:blockFailure];
    BOOL queue = NO;
    if (!queue) [self enqueueHTTPRequestOperation:*operation];
    
}

- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
    [self.operationQueue addOperation:operation];
}

- (AFHTTPRequestOperation *)constructOperationwithType:(ENUM_API_REQUEST_TYPE)type
                                            andRequest:(NSURLRequest *)request
                                                inView:(UIView *)view
                                         completeBlock:(void (^)(id))block
                                          failureBlock:(void (^)(id))blockFailure
{
    //don't need request at offline mode
    if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        [Utils showNoInternetConnectionErrorIfNeed:YES];
        if (blockFailure) {
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSError *error = [[NSError alloc] initWithDomain:@"giga.com" code:-1004 userInfo:nil];
                blockFailure(error.description);
            });
        }
        return nil;
    }
    if (view != nil) {
        [Utils showHUDForView:view];
    }
    
    AFHTTPRequestOperation *operation= [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [AFHTTPRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/javascript", @"text/html",nil]];
    
    operation.userInfo = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:type]] forKeys:@[@"type"]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"API Success %@", operation.request.URL.absoluteString);
        if (view) {
            [Utils hideHUDForView:view];
        }
        id result = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSError *error;
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error: &error];
            if (error == nil) {
                result = obj;
            }
            if([result objectForKey:@"data"])
                result = [result objectForKey:@"data"];
            if ([obj[@"message"] isEqualToString:@"Data not found"] &&
                ![result isKindOfClass:[NSArray class]]) {
                result = [NSArray array];
            }
        }
        
        DLog(@"Reponse \n:%@", result);
        block(result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (view) {
            [Utils hideHUDForView:view];
        }
        DLog(@"API failure %@", operation.request.URL.absoluteString);
        DLog(@"%@ %@",operation.responseString,error);
        [Utils handleRequestError:error from:nil withTitle:localizedString(@"Error")];
        if (blockFailure) {
            blockFailure(operation.responseString);
        }
        
    }];
    return operation;
}

- (void)cancelAllOperations
{
    if (self.operationQueue.operations.count > 0) {
        [self.operationQueue cancelAllOperations];
    }
}

@end


@implementation AFURLConnectionOperation (Extention)

// Workaround for change in imp_implementationWithBlock() with Xcode 4.5
#if defined(__IPHONE_6_0) || defined(__MAC_10_8)
#define AF_CAST_TO_BLOCK id
#else
#define AF_CAST_TO_BLOCK __bridge void *
#endif


static void AFSwizzleClassMethodWithClassAndSelectorUsingBlock(Class klass, SEL selector, id block) {
    Method originalMethod = class_getClassMethod(klass, selector);
    IMP implementation = imp_implementationWithBlock((AF_CAST_TO_BLOCK)block);
    class_replaceMethod(objc_getMetaClass([NSStringFromClass(klass) UTF8String]), selector, implementation, method_getTypeEncoding(originalMethod));
}

+ (NSSet *)acceptableContentTypes {
    return nil;
}

+ (void)addAcceptableContentTypes:(NSSet *)contentTypes {
    NSMutableSet *mutableContentTypes = [[NSMutableSet alloc] initWithSet:[self acceptableContentTypes] copyItems:YES];
    [mutableContentTypes unionSet:contentTypes];
    AFSwizzleClassMethodWithClassAndSelectorUsingBlock([self class], @selector(acceptableContentTypes), ^(__unused id _self) {
        return mutableContentTypes;
    });
}
@end