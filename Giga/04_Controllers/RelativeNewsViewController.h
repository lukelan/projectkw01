//
//  RelativeNewsViewController.h
//  Giga
//
//  Created by vandong on 11/29/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"
#import "MNMBottomPullToRefreshManager.h"

@class CompanyModel;

@interface RelativeNewsViewController : BaseViewController <MNMBottomPullToRefreshManagerClient>
{
    NSMutableArray                  *tableData;
    
    //load more
    NSUInteger offset;
    BOOL loadingMore;
    MNMBottomPullToRefreshManager *_loadMoreFooterView;
}
@property (strong, nonatomic) id stockData;//response from server
@property (strong, nonatomic) CompanyModel *company;//response from server

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyName;

//in blue box
@property (weak, nonatomic) IBOutlet UILabel *lbCategory;
@property (weak, nonatomic) IBOutlet UILabel *lbIndustry;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;


@property(weak,nonatomic) IBOutlet UITableView              *tbArticles;
- (IBAction)btBack_Touched:(id)sender;
-(void)doneLoadMoreData;
@end
