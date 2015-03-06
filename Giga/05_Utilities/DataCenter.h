//
//  DataCenter.h
//  Giga
//
//  Created by CX MAC on 12/2/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedDataCenter                [DataCenter shared]

@interface DataCenter : NSObject
+ (DataCenter*)shared;
- (void)resetDatabaseIfNeed;
//Core data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;

@end
