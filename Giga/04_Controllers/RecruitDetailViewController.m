//
//  RecruitDetailViewController.m
//  Giga
//
//  Created by vandong on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "RecruitDetailViewController.h"
#import "WebDetailViewController.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "ShareSocial.h"
#import "recruitArticleModel.h"
#import "ArticleModel.h"
#import "CommentInputTextCell.h"
#import "InputCommentView.h"
#import "RecruitRelativeNewsViewController.h"
#import "UIImageView+WebCache.h"
#import "UILabel+resizewithtext.h"



#import "AFNetworking.h"
#define CellIdentifierRecruitInfo       @"CellIdentifierRecruitInfo"
#define CellIdentifierNewsInfo          @"CellIdentifierNewsInfo"

#define CellIdentifierComment           @"CellIdentifierComment"
#define CellIdentifierReply             @"CellIdentifierReply"
#define CellIdentifierInputReply        @"CellIdentifierInputReply"


#import "ImobileSdkAds/ImobileSdkAds.h"

#define IMOBILE_SDK_ADS_PUBLISHER_ID_3	@"34560"
#define IMOBILE_SDK_ADS_MEDIA_ID_3	@"132964"
#define IMOBILE_SDK_ADS_SPOT_ID_3	@"375470"


@interface RecruitDetailViewController ()<UITableViewDataSource, UITableViewDelegate, CommentCellDelegate,IMobileSdkAdsDelegate>
{
    NSMutableArray      *arExpandingSection;
    BOOL                isBookmark;
    
    NSString            *article_link;
    
}
@end

@implementation RecruitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arExpandingSection = [NSMutableArray new];
    _arComment = [NSMutableArray new];
    
    [self loadData];
    
    [self loadInterface];
//    [self updateHeaderTable];
    
    [self.tbv registerNib:[UINib nibWithNibName: @"CommentCell" bundle:nil]  forCellReuseIdentifier:CellIdentifierComment];
    [self.tbv registerNib:[UINib nibWithNibName: @"ReplyCell" bundle:nil]  forCellReuseIdentifier:CellIdentifierReply];
    
    // for sample demo
//    [self createTestData];
//    [self.tbv reloadData];
    
    [self loadComments];
    [self.tbv setContentInset:UIEdgeInsetsMake(0, 0, 95, 0)];
    [self addIMobileAddInControllerComment:self];
    
}

- (void)setValueForContent {
    // set value for label in detail
}

- (void)loadInterface {
    // set font
    _lbEmployeeType.font = NORMAL_FONT_WITH_SIZE(11);
    _lbFeature.font = NORMAL_FONT_WITH_SIZE(11);
    _lbNew.font = NORMAL_FONT_WITH_SIZE(11);
    _lbCompanyName.font = BOLD_FONT_WITH_SIZE(16);
    _lbCompanyTitle.font = BOLD_FONT_WITH_SIZE(12);
    _lbJobContentTitle.font = BOLD_FONT_WITH_SIZE(14);
    _lbJobContentDetail.font = NORMAL_FONT_WITH_SIZE(13);
    _lbRecruitTargetTitle.font = BOLD_FONT_WITH_SIZE(14);
    _lbRecruitTargetDetail.font = NORMAL_FONT_WITH_SIZE(13);
    _lbLocationTitle.font = BOLD_FONT_WITH_SIZE(14);
    _lbLocationDetail.font = NORMAL_FONT_WITH_SIZE(13);
    _lbSalaryTitle.font = BOLD_FONT_WITH_SIZE(15);
    _lbSalaryDescription.font = BOLD_FONT_WITH_SIZE(13);
    _lbCompanyIntroTitle.font = BOLD_FONT_WITH_SIZE(15);
    _lbCompanyIntro.font = NORMAL_FONT_WITH_SIZE(12);
    _lbCommentSection.font = BOLD_FONT_WITH_SIZE(15);

    // bottom buttons
    _lbBtPostCommentTitle.font = NORMAL_FONT_WITH_SIZE(14);
    _lbBtShareTitle.font = NORMAL_FONT_WITH_SIZE(14);

    
    _btOpenWebDetail.titleLabel.font = BOLD_FONT_WITH_SIZE(13);
    _btBookmark.titleLabel.font = BOLD_FONT_WITH_SIZE(13);
    _btRelativeInfo.titleLabel.font = BOLD_FONT_WITH_SIZE(13);

    /// article detail
    _lbNewsTitle.font = BOLD_FONT_WITH_SIZE(13);
    _lbNewsCategory.font = NORMAL_FONT_WITH_SIZE(15);
    _lbNewContent.font = NORMAL_FONT_WITH_SIZE(15);
    [_btBookmarkShort.titleLabel setFont:BOLD_FONT_WITH_SIZE(15)];
    [_btOpenWebDetailShort.titleLabel setFont:BOLD_FONT_WITH_SIZE(15)];

    _lbCommentSection2.font = BOLD_FONT_WITH_SIZE(15);
    
    self.lbEmployeeType.layer.masksToBounds = YES;
    self.lbEmployeeType.layer.cornerRadius = 3;
    
    self.btBookmark.layer.cornerRadius = 8;
    self.btBookmarkShort.layer.cornerRadius = 8;
    
    self.lbJobContentTitle.text = localizedString(@"Job Content");
    self.lbRecruitTargetTitle.text = localizedString(@"Recruit Target");
    self.lbLocationTitle.text = localizedString(@"Location");
    self.lbSalaryTitle.text = localizedString(@"Salary");

    self.tbv.tableFooterView = [[UIView alloc] initWithFrame:RECT_WITH_HEIGHT(self.view.frame, 45)];
}

- (void)updateHeaderTable {
    if ([_recruitItem isMemberOfClass:[ArticleModel class]]) {
        ArticleModel *article = (ArticleModel *)_recruitItem;
        isBookmark = article.isBookmark.boolValue;
        article_link = article.sourceUrl;
        if (article.news_type.integerValue == 1) {
            self.lbNewsTitle.text = article.title;
            self.lbNewsCategory.text = article.siteName;
            self.lbNewContent.text = article.overview;
            
            if(article.imageUrl.length>0)
            {
                [self.imgLogo sd_setImageWithURL:[NSURL URLWithString:article.imageUrl] placeholderImage:[UIImage imageNamed:@"GIGA_place_holder1.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
            }
            
            // set tableview header
//            float oldHeight = self.lbNewContent.frame.size.height;
//            float newHeight = [self.lbNewContent newHeightWithContent: article.overview];
//            float delta = newHeight - oldHeight;
//            for (UIView *v in self.vNewsDetail.subviews) {
//                if (v.frame.origin.y > self.lbNewContent.frame.origin.y) {
//                    v.frame = RECT_ADD_Y(v.frame, delta);
//                }
//            }
            
//            self.vNewsDetail.frame = RECT_ADD_HEIGHT(self.vNewsDetail.frame, delta + 5);
            // set tableview header
            
            _vBigBanner = [[UIView alloc] initWithFrame:CGRectMake(0,_lbCommentSection2.frame.origin.y, 320, 100)];
            _vBigBanner.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_vBigBanner];
            [ImobileSdkAds showBySpotID:IMOBILE_SDK_ADS_SPOT_ID_3 View:_vBigBanner];
            [self.vNewsDetail addSubview:_vBigBanner];
            _vNewsDetail.frame = CGRectMake(_vNewsDetail.frame.origin.x, _vNewsDetail.frame.origin.y, _vNewsDetail.frame.size.width, _vNewsDetail.frame.size.height+100);
            
            self.tbv.tableHeaderView = self.vNewsDetail;
            
            //update bookmark buttons
            self.btBookmark.backgroundColor = !isBookmark ? [UIColor whiteColor] : RGB(0, 179, 255);
            [self.btBookmark setTitleColor: !isBookmark ? RGB(0, 179, 255):[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.btBookmarkShort.backgroundColor = !isBookmark ? [UIColor whiteColor] : RGB(0, 179, 255);
            [self.btBookmarkShort setTitleColor: !isBookmark ? RGB(0, 179, 255):[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            //version 1.2
            [self designViewComment];
            self.tbv.tableFooterView = self.vComment;
            
        
        }

        if (article.news_type.integerValue == 2) {
            self.lbEmployeeType.text = article.employee;
            self.lbFeature.text = article.features;
            self.lbNew.text = article.is_new;
            
//            self.lbCompanyName.text = article.company_name;
            self.lbCompanyTitle.text = article.title;
            
//            self.lbCompanyIntroTitle.text = article.employee;
//            self.lbCompanyIntro.text = @"";

            // update company name
            float oldHeight = self.lbCompanyName.frame.size.height;
            float newHeight = [self.lbCompanyName newHeightWithContent:article.company_name];
            float delta = newHeight - oldHeight;
            if (delta > 0) {
//                self.vCompanyIntro.frame = RECT_ADD_HEIGHT(self.vCompanyIntro.frame, delta);
                for (UIView *v in self.vContentDetail.subviews) {
                    if (v.frame.origin.y > self.lbCompanyName.frame.origin.y) {
                        v.frame = RECT_ADD_Y(v.frame, delta);
                    }
                }
            }
            
            // update salary text
            oldHeight = self.lbSalaryDescription.frame.size.height;
            newHeight = [self.lbSalaryDescription newHeightWithContent:article.salary];
            delta = newHeight - oldHeight;
            if (delta > 0) {
                self.vSalaryInfo.frame = RECT_ADD_HEIGHT(self.vSalaryInfo.frame, delta);
                for (UIView *v in self.vContentDetail.subviews) {
                    if (v.frame.origin.y > self.vSalaryInfo.frame.origin.y) {
                        v.frame = RECT_ADD_Y(v.frame, delta);
                    }
                }
            }
            
            // update company intro intro text
            oldHeight = self.lbCompanyIntro.frame.size.height;
            newHeight = [self.lbCompanyIntro newHeightWithContent:article.company_introduction];
            delta = newHeight - oldHeight;
            if (delta > 0) {
                self.vCompanyIntro.frame = RECT_ADD_HEIGHT(self.vCompanyIntro.frame, delta);
                for (UIView *v in self.vContentDetail.subviews) {
                    if (v.frame.origin.y > self.vCompanyIntro.frame.origin.y) {
                        v.frame = RECT_ADD_Y(v.frame, delta);
                    }
                }
            }

            
            
            // job content
            oldHeight = self.lbJobContentDetail.frame.size.height;
            newHeight = [self.lbJobContentDetail newHeightWithContent:article.job_content];
            delta = newHeight - oldHeight;
            for (UIView *v in self.vContentDetail.subviews) {
                if (v.frame.origin.y > self.lbJobContentDetail.frame.origin.y) {
                    v.frame = RECT_ADD_Y(v.frame, delta);
                }
            }
            
            // recruit target
            oldHeight = self.lbRecruitTargetDetail.frame.size.height;
            newHeight = [self.lbRecruitTargetDetail newHeightWithContent:article.recruiting_target];
            delta = newHeight - oldHeight;
            for (UIView *v in self.vContentDetail.subviews) {
                if (v.frame.origin.y > self.lbRecruitTargetDetail.frame.origin.y) {
                    v.frame = RECT_ADD_Y(v.frame, delta);
                }
            }
            
            // location
            oldHeight = self.lbLocationDetail.frame.size.height;
            newHeight = [self.lbLocationDetail newHeightWithContent:article.location];
            delta = newHeight - oldHeight;
            for (UIView *v in self.vContentDetail.subviews) {
                if (v.frame.origin.y > self.lbLocationDetail.frame.origin.y) {
                    v.frame = RECT_ADD_Y(v.frame, delta);
                }
            }
            
            self.vContentDetail.frame = RECT_WITH_HEIGHT(self.vContentDetail.frame, self.lbCommentSection.frame.origin.y + self.lbCommentSection.frame.size.height);
            // set tableview header
            self.tbv.tableHeaderView = self.vContentDetail;
            
            //update bookmark buttons
            self.btBookmark.backgroundColor = !isBookmark ? [UIColor whiteColor] : RGB(0, 179, 255);
            [self.btBookmark setTitleColor: !isBookmark ? RGB(0, 179, 255):[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.btBookmarkShort.backgroundColor = !isBookmark ? [UIColor whiteColor] : RGB(0, 179, 255);
            [self.btBookmarkShort setTitleColor: !isBookmark ? RGB(0, 179, 255):[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            // update comapny intro image
            [self.imvCompanyImage sd_setImageWithURL:[NSURL URLWithString: article.imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (error != nil || image == nil) {
                    self.lbCompanyIntroTitle.frame = RECT_WITH_X_WIDTH(self.lbCompanyIntroTitle.frame, self.imvCompanyImage.frame.origin.x, self.lbCompanyIntroTitle.frame.size.width + self.imvCompanyImage.frame.size.width);
                    self.lbCompanyIntro.frame = RECT_WITH_X_WIDTH(self.lbCompanyIntro.frame, self.imvCompanyImage.frame.origin.x, self.lbCompanyIntro.frame.size.width + self.imvCompanyImage.frame.size.width);
                    self.imvCompanyImage.hidden = YES;
                    
                    // move below view if need
//                    float oldHeight = self.lbCompanyIntro.frame.size.height;
//                    float newHeight = [self.lbCompanyIntro newHeightWithContent:article.company_name];
//                    float delta = newHeight - oldHeight;
//                    if (delta < 0) {
//                        self.vCompanyIntro.frame = RECT_ADD_HEIGHT(self.vCompanyIntro.frame, delta);
//                        for (UIView *v in self.vContentDetail.subviews) {
//                            if (v.frame.origin.y > self.vCompanyIntro.frame.origin.y) {
//                                v.frame = RECT_ADD_Y(v.frame, delta);
//                            }
//                        }
//                    }
                    
                    
                }
            }];
            
            if (article.logo_site.length > 0) {
                [self.imvLogo sd_setImageWithURL:[NSURL URLWithString: article.logo_site] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    DLoga(@"logo: %@", imageURL);
                }];
            }

        }
    }
}

-(void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ArticleModel *obj = (ArticleModel *)self.recruitItem;
    [params setValue: obj.articleID forKey:@"article_id"];
    if (SharedUserData.userID) [params setValue: SharedUserData.userID forKey:@"client_id"];
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_ARTICLE_DETAIL andPostMethodKind:YES andParams:params inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        if ([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0) {
            NSDictionary *dict = responseObject[0];
            [obj updateDataFromJsonData:dict jobType:0];
            // update UI
            [self updateHeaderTable];
        }
        
        
    } failureBlock:^(NSError *error) {
    }];
}

- (void)loadComments {
    if([self.recruitItem isMemberOfClass:[ArticleModel class]]) {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ArticleModel *obj = (ArticleModel *)self.recruitItem;
    [params setValue: obj.articleID forKey:@"article_id"];
    if (SharedUserData.userID) [params setObject:SharedUserData.userID  forKey: @"client_id"];

    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_ARTICLE_COMMENTS andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        if ([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0) {
            [_arComment removeAllObjects];
            for (NSDictionary *dict in responseObject) {
                CommentModel *comment = [CommentModel commentByDict:dict];
                [_arComment addObject:comment];
            }
            [self.tbv reloadData];
        }
        
    } failureBlock:^(NSError *error) {
    }];
    }
}

- (void)postComment:(NSString *)text {
    if (text.length == 0) return;
    if(![self.recruitItem isMemberOfClass:[ArticleModel class]]) return;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ArticleModel *obj = (ArticleModel *)self.recruitItem;
    [params setObject: obj.articleID forKey:@"article_id"];
    [params setValue: text forKey:@"content"];
    [params setValue: @(0) forKey:@"parent_id"];
    if (SharedUserData.userID) [params setObject:SharedUserData.userID  forKey: @"client_id"];
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_POST_ARTICLE_COMMENT andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        if ([responseObject isKindOfClass:[NSString class]] ) {
            NSString *num = (NSString *)responseObject;
            if (num.integerValue > 0) {
                
                [self loadComments];
                
                if (self.updateCommentCount) {
                    self.updateCommentCount(1);
                }
            }
        }
        
//        CommentModel *newComment = [CommentModel new];
//        newComment.comment_id = responseObject;
//        newComment.comment = text;
//        newComment.numLike = 0;
//        newComment.numDisLike = 0;
//        newComment.arReply = [NSMutableArray new];
//        NSDateFormatter *dateFormat = [NSDateFormatter new];
//        dateFormat.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd%@ hh:mm", localizedString(@"年"), localizedString(@"月"), localizedString(@"日")];
//        newComment.created_at = [dateFormat stringFromDate:[NSDate date]];
//        
//        [_arComment addObject:newComment];
//        [self.tbv reloadData];
//        
//        if (self.updateCommentCount) {
//            self.updateCommentCount(1);
//        }

    } failureBlock:^(NSError *error) {
    }];

}

- (void)postReply:(NSString *)text toComment:(CommentModel *)comment atIndex:(NSIndexPath *)indexPath {
    if (text.length == 0) return;
    if(![self.recruitItem isMemberOfClass:[ArticleModel class]]) return;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    ArticleModel *obj = (ArticleModel *)self.recruitItem;
    [params setObject: obj.articleID forKey:@"article_id"];
    [params setValue: text forKey:@"content"];
    [params setValue: comment.comment_id forKey:@"parent_id"];
    if (SharedUserData.userID) [params setObject:SharedUserData.userID  forKey: @"client_id"];
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_POST_ARTICLE_COMMENT andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        if ([responseObject isKindOfClass:[NSString class]] ) {
            NSString *num = (NSString *)responseObject;
            if (num.integerValue > 0) {
                [self loadComments];
                if (self.updateCommentCount) {
                    self.updateCommentCount(1);
                }
            }
        }
        
//        CommentModel *newReply = [CommentModel new];
//        newReply.comment_id = responseObject;
//        newReply.isReply = YES;
//        newReply.comment = text;
//        newReply.numLike = 0;
//        newReply.numDisLike = 0;
//        NSDateFormatter *dateFormat = [NSDateFormatter new];
//        dateFormat.dateFormat = [NSString stringWithFormat:@"yyyy%@MM%@dd%@ hh:mm", localizedString(@"年"), localizedString(@"月"), localizedString(@"日")];
//        newReply.modified_at = [dateFormat stringFromDate:[NSDate date]];
//        
//        CommentModel *comment =_arComment[indexPath.section];
//        [comment.arReply addObject: newReply];
//        
//        [self.tbv beginUpdates];
//        [self.tbv reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:100];
//        [self.tbv endUpdates];
//        
//        if (self.updateCommentCount) {
//            self.updateCommentCount(1);
//        }
        
    } failureBlock:^(NSError *error) {
    }];
}

- (void)makeBookmarkCompletion:(void(^)(bool success))completion
{
    if(![self.recruitItem isMemberOfClass:[ArticleModel class]]) return;
    ArticleModel *obj = (ArticleModel *)self.recruitItem;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue: obj.articleID forKey:@"article_id"];
    [params setValue:SharedUserData.userID forKey: @"client_id"];
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_MAKE_BOOKMARK andPostMethodKind:YES andParams:params inView: self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        if (responseObject) {//a string
            //update in core data
            obj.isBookmark = @(YES);
            [SharedDataCenter saveContext];
            if (completion) {
                completion(YES);
            }
        }else{
            if (completion) {
                completion(NO);
            }
        }
    } failureBlock:^(NSError *error) {
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)makeUnBookmarkCompletion:(void(^)(bool success))completion
{
    if(![self.recruitItem isMemberOfClass:[ArticleModel class]]) return;
    ArticleModel *obj = (ArticleModel *)self.recruitItem;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue: obj.articleID forKey:@"article_id"];
    [params setValue:SharedUserData.userID forKey: @"client_id"];
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_MAKE_UN_BOOKMARK andPostMethodKind:YES andParams:params inView: self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        if (responseObject) {//a string
            //update in core data
            obj.isBookmark = @(NO);
            [SharedDataCenter saveContext];
            if (completion) {
                completion(YES);
            }
        }else{
            if (completion) {
                completion(NO);
            }
        }
    } failureBlock:^(NSError *error) {
        if (completion) {
            completion(NO);
        }
    }];
}


#pragma mark - IBActions

- (IBAction)btOpenWebDetail_Touched:(id)sender {
    WebDetailViewController *vc = [WebDetailViewController new];
    vc.pageLink = article_link;
    vc.objForShare = self.recruitItem;
    [self.navigationController pushViewController:vc animated: YES];
}

- (IBAction)btBookmark_Touched:(UIButton*)sender {
    if (!isBookmark)
        [self makeBookmarkCompletion:^(bool success) {
            if (success) {
                sender.backgroundColor = (isBookmark == YES)? [UIColor whiteColor] : RGB(0, 179, 255);
                [sender setTitleColor: (isBookmark == NO)? [UIColor whiteColor] : RGB(0, 179, 255) forState:UIControlStateNormal];
                isBookmark = !isBookmark;
            }
        }];
    else
        [self makeUnBookmarkCompletion:^(bool success) {
            if (success) {
                sender.backgroundColor = (isBookmark == YES)? [UIColor whiteColor] : RGB(0, 179, 255);
                [sender setTitleColor: (isBookmark == NO)? [UIColor whiteColor] : RGB(0, 179, 255) forState:UIControlStateNormal];
                isBookmark = !isBookmark;
            }
        }];
}

- (IBAction)btRelativeInfo_Touched:(id)sender {
    RecruitRelativeNewsViewController *vc = [RecruitRelativeNewsViewController new];
    ArticleModel *obj = (ArticleModel *)self.recruitItem;
    vc.articleId = obj.articleID;
    [self.navigationController pushViewController:vc animated: YES];
}

- (IBAction)btShare_Touched:(id)sender {
    [[ShareSocial share] showShareSelectionInView:self.view withObject: self.recruitItem];
}

- (IBAction)btPostComment_Touched:(id)sender {
    
    InputCommentView *v = [[InputCommentView alloc] initWithFrame:self.view.frame andCompleteBlock:^(NSString *text, BOOL isTwitterEnable, BOOL isFacebookEnable) {
        
        [self postComment:text];
        
    }];
    if ([self.recruitItem isKindOfClass:[ArticleModel class]]) {
        v.article =(ArticleModel *) self.recruitItem;
        v.articleID = v.article.articleID;
    }
    [self.view addSubview:v];
    
  
}

-(IBAction)btBack_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    
    return _arComment.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CommentModel *comment = _arComment[section];
    if ([arExpandingSection indexOfObject: comment] != NSNotFound) {
        return comment.arReply.count + 2; // first cell is comment, last cell is input text for new reply
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _arComment.count) {
        return 42;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.row == 0) {
         CommentModel *cellData = _arComment[indexPath.section];
         return [CommentCell heightWithItem:cellData];
     } else {
         CommentModel *item = _arComment[indexPath.section];
         if (item.arReply.count +1 == indexPath.row) {
             return CommentInputTextCellHeight;
         }
         CommentModel *cellData = item.arReply[indexPath.row-1];
         return [CommentCell heightWithItem:cellData];
     }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel  *cellData;
    if (indexPath.row == 0) {
        cellData = _arComment[indexPath.section];
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierComment];
        if (cell == nil) {
            cell = [[CommentCell alloc] initForComment];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell setContentWithItem:cellData];
        
        if ([arExpandingSection indexOfObject: cellData] == NSNotFound) {
            cell.btExpandColapse.selected = NO;
        } else {
            cell.btExpandColapse.selected = YES;
        }
        return cell;
    } else {
        CommentModel *item = _arComment[indexPath.section];
        if (item.arReply.count + 1 == indexPath.row) {
            // cell input new reply
            CommentInputTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierInputReply];
            if (cell == nil) {
                cell = [CommentInputTextCell new];
                [cell setOnTouchedAddReplyBlock:^(NSIndexPath *index) {
                    InputCommentView *v = [[InputCommentView alloc] initWithFrame:self.view.frame andCompleteBlock:^(NSString *text, BOOL isTwitterEnable, BOOL isFacebookEnable) {
                        CommentModel *parentComment = _arComment[indexPath.section];
                        [self postReply:text toComment:parentComment atIndex:indexPath];
                    }];
                    [self.view addSubview:v];
                }];
            }
            cell.indexPath = indexPath;
            return cell;
        } else {
            cellData = item.arReply[indexPath.row - 1];
            CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierReply];
            if (cell == nil) {
                cell = [[CommentCell alloc] initForReply];
                cell.delegate = self;
            }
            cell.indexPath = indexPath;
            [cell setContentWithItem:cellData];
            return cell;
        }

    }
    return nil;
}

#pragma mark - CommentCellDelegate
- (void)didTouchedExpandColapseForCell:(CommentCell *)cell {
    NSIndexPath *indexPath = cell.indexPath;
    if([arExpandingSection indexOfObject:cell.data] != NSNotFound) {
        // collapse
        [arExpandingSection removeObject:cell.data];
        [self.tbv beginUpdates];
        [self.tbv reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:100];
        [self.tbv endUpdates];

    } else {
        //expand
        [arExpandingSection addObject:cell.data];
        [self.tbv beginUpdates];
        [self.tbv reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:100];
        [self.tbv endUpdates];
    }
}

////
#pragma mark - Comment
-(void)designViewComment
{
    self.btSend.layer.cornerRadius = 5;
    
    self.tvComment.isScrollable = NO;
    self.tvComment.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.tvComment.minNumberOfLines = 1;
    self.tvComment.maxNumberOfLines = 4;
    self.tvComment.returnKeyType = UIReturnKeyDefault; //just as an example
    self.tvComment.font = [UIFont systemFontOfSize:15.0f];
    self.tvComment.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.tvComment.backgroundColor = [UIColor whiteColor];
    self.tvComment.font = NORMAL_FONT_WITH_SIZE(14);
    self.tvComment.placeholder = localizedString(@"Input comment");
    self.tvComment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tvComment.layer.cornerRadius = 5;
    self.tvComment.layer.borderColor = RGB(102, 102, 102).CGColor;
    self.tvComment.layer.borderWidth = 1;
    self.tvComment.textColor = RGB(141, 141, 141);
}
- (IBAction)btComment:(id)sender
{
    [self btPostComment_Touched:nil];
}
-(void)imobileSdkAdsSpot:(NSString *)spotId didFailWithValue:(ImobileSdkAdsFailResult)value
{
    _vBigBanner.hidden = YES;
}

-(void)imobileSdkAdsSpot:(NSString *)spotId didReadyWithValue:(ImobileSdkAdsReadyResult)value
{
    _vBigBanner.hidden = NO;
    //_lbCommentSection2.frame = CGRectMake(0, CGRectGetMaxY(_vBigBanner.frame), _lbCommentSection2.frame.size.width, _lbCommentSection2.frame.size.height);
    
    
    self.tbv.tableHeaderView = nil;
    self.tbv.tableHeaderView = self.vNewsDetail;
}

@end
