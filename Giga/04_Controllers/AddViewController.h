//
//  AddViewController.h
//  Giga
//
//  Created by Le Trung Hai on 1/24/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddControllerDelegate;


@interface AddViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_arrayItem;
}
@property (weak, nonatomic) id<AddControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tbvAdd;
@property (nonatomic, assign) BOOL bNews;
@property (nonatomic, strong) NSArray *array;
@end


@protocol AddControllerDelegate <NSObject>

@optional
-(void)addController:(AddViewController *)add selectItemIndex:(NSInteger)index itemID:(NSString *)itemID itemSelect:(BOOL)select;
-(void)addController:(AddViewController *)add moveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toInddex;
-(void)addControllerFinish:(AddViewController *)add;

@end


@interface NewsItem : NSObject<NSCoding>
@property (copy, nonatomic) NSString *newsName;
@property (copy, nonatomic) NSString *newsID;
@property (assign, nonatomic) BOOL selected;
+ (instancetype)initWithNewsName:(NSString*)name newsID:(NSString*)newsID selected:(BOOL)select;

@end