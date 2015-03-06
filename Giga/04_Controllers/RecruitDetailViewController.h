//
//  RecruitDetailViewController.h
//  Giga
//
//  Created by vandong on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"
#import "HPGrowingTextView.h"

@class RecruitArticleModel;

@interface RecruitDetailViewController : BaseViewController

/// View Recruit detail
@property(strong, nonatomic) IBOutlet UIView                *vContentDetail; // view contain Recruit info
@property(weak, nonatomic) IBOutlet UILabel                 *lbEmployeeType;
@property(weak, nonatomic) IBOutlet UILabel                 *lbFeature;
@property(weak, nonatomic) IBOutlet UILabel                 *lbNew;
@property(weak, nonatomic) IBOutlet UIImageView             *imvLogo;
@property(weak, nonatomic) IBOutlet UILabel                 *lbCompanyName;
@property(weak, nonatomic) IBOutlet UILabel                 *lbCompanyTitle;
@property(weak, nonatomic) IBOutlet UILabel                 *lbJobContentTitle;
@property(weak, nonatomic) IBOutlet UILabel                 *lbJobContentDetail;
@property(weak, nonatomic) IBOutlet UILabel                 *lbRecruitTargetTitle;
@property(weak, nonatomic) IBOutlet UILabel                 *lbRecruitTargetDetail;
@property(weak, nonatomic) IBOutlet UILabel                 *lbLocationTitle;
@property(weak, nonatomic) IBOutlet UILabel                 *lbLocationDetail;

// view contain Salary info
@property(strong, nonatomic) IBOutlet UIView                *vSalaryInfo;
@property(weak, nonatomic) IBOutlet UILabel                 *lbSalaryTitle;
@property(weak, nonatomic) IBOutlet UILabel                 *lbSalaryDescription;

// view contain company intro
@property(strong, nonatomic) IBOutlet UIView                *vCompanyIntro;
@property(weak, nonatomic) IBOutlet UIImageView             *imvCompanyImage;
@property(weak, nonatomic) IBOutlet UILabel                 *lbCompanyIntroTitle;
@property(weak, nonatomic) IBOutlet UILabel                 *lbCompanyIntro;

@property(weak, nonatomic) IBOutlet UIButton                *btOpenWebDetail;
@property(weak, nonatomic) IBOutlet UIButton                *btBookmark;
@property(weak, nonatomic) IBOutlet UIButton                *btRelativeInfo;
@property(weak, nonatomic) IBOutlet UILabel                 *lbCommentSection;
@property(weak, nonatomic) IBOutlet UILabel                 *lbCommentSection2;
@property(weak, nonatomic) IBOutlet UILabel                 *lbBtPostCommentTitle;
@property(weak, nonatomic) IBOutlet UILabel                 *lbBtShareTitle;
/// View Recruit detail
@property(strong, nonatomic) IBOutlet UIView                *vNewsDetail; // view contain news info
@property(weak, nonatomic) IBOutlet UILabel                 *lbNewsTitle;
@property(weak, nonatomic) IBOutlet UILabel                 *lbNewsCategory;
@property(weak, nonatomic) IBOutlet UILabel                 *lbNewContent;
@property(weak, nonatomic) IBOutlet UIButton                *btBookmarkShort;
@property(weak, nonatomic) IBOutlet UIButton                *btOpenWebDetailShort;
////
@property(strong,nonatomic) NSObject                        *recruitItem;
@property(weak, nonatomic) IBOutlet UITableView             *tbv;
@property(strong, nonatomic) NSMutableArray                 *arComment;

// comment
@property (nonatomic, strong) IBOutlet UIView               *vComment;
@property (nonatomic, strong) IBOutlet HPGrowingTextView    *tvComment;
@property (nonatomic, strong) IBOutlet UIButton             *btComment;
@property (nonatomic, strong) IBOutlet UIButton             *btSend;

@property (nonatomic, strong) IBOutlet UIImageView          *imgLogo;
@property (nonatomic, strong) UIView                        *vBigBanner;

@property(copy, nonatomic) void(^updateCommentCount)(int additionCount);


- (IBAction)btOpenWebDetail_Touched:(id)sender;
- (IBAction)btBookmark_Touched:(id)sender;
- (IBAction)btRelativeInfo_Touched:(id)sender;
- (IBAction)btShare_Touched:(id)sender;
- (IBAction)btPostComment_Touched:(id)sender;
- (IBAction)btBack_Touched:(id)sender;

- (IBAction)btComment:(id)sender;
@end
