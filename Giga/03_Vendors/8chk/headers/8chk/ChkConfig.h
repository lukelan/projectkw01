//
//  ChkConfig.h
//  8chk
//
//  Ver 5.4.0
//
//  Created by Tatsuya Uemura on 11/08/19.
//  Copyright 2011 8crops inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

@interface ChkConfig : NSObject {
}

@property (nonatomic, retain) NSString  *suid;
@property (nonatomic, retain) NSString  *sad;
@property (nonatomic, retain) NSString  *plistFileName;

- (id) init;

@end
