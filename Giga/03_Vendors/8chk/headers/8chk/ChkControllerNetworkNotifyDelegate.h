//
//  ChkControllerNetworkNotifyDelegate.h
//  8chk
//
//  Ver 5.4.0
//
//  Created by Tatsuya Uemura on 11/09/09.
//  Copyright 2011 8crops inc. All rights reserved.
//

@protocol ChkControllerNetworkNotifyDelegate <NSObject>

- (void) chkControllerInitNotReachableStatusError:(NSError *)error;
- (void) chkControllerRequestNotReachableStatusError:(NSError *)error;
- (void) chkControllerNetworkNotReachable:(NSError *)error;
- (void) chkControllerNetworkReachable:(NSUInteger)networkType;

@end

