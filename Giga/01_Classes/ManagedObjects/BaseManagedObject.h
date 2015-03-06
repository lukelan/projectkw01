//
//  BaseManagedObject.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseManagedObject : NSManagedObject

+ (id)insertNewObject;

+ (NSArray*)getItemsWithPredicate:(NSPredicate*)pre
                             sorts:(NSArray*)sorts;

+ (NSArray*)getItemsWithPredicate:(NSPredicate*)pre
                            sorts:(NSArray*)sorts
                       numberItem:(NSInteger)numberItem;

+ (id)getOneItemWithPredicate:(NSPredicate*)pre;

+ (NSString*)entityName;

+ (NSMutableArray*)getAllObjects;

+ (id)insertFromJsonData:(NSDictionary*)jsonData jobType:(NSInteger)type;

+ (void)deleteAllObjects;
@end
