//
//  CommentCell.h
//  Giga
//
//  Created by vandong on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@class CommentModel;
@class CommentCell;

@protocol CommentCellDelegate <NSObject>
- (void)didTouchedExpandColapseForCell:(CommentCell *)cell;
@end

@interface CommentCell : BaseCell
@property(weak, nonatomic) IBOutlet UILabel         *lbName;
@property(weak, nonatomic) IBOutlet UILabel         *lbPostDate;
@property(weak, nonatomic) IBOutlet UIView          *vBtReport;
@property(weak, nonatomic) IBOutlet UILabel         *lbPostText;
@property(weak, nonatomic) IBOutlet UILabel         *lbBtReportTitle;
@property(weak, nonatomic) IBOutlet UIView          *vButtonContainer;
@property(weak, nonatomic) IBOutlet UIButton        *btExpandColapse;
@property(weak, nonatomic) IBOutlet UIButton        *btCountReply;
@property(weak, nonatomic) IBOutlet UIButton        *btLike;
@property(weak, nonatomic) IBOutlet UIButton        *btDisLike;
@property(weak, nonatomic) IBOutlet UILabel         *lbLike;
@property(weak, nonatomic) IBOutlet UILabel         *lbDisLike;
@property(weak, nonatomic) IBOutlet UILabel         *lbSeparateLine;

// view ratio
@property(weak, nonatomic) IBOutlet  UIView         *vRatio;
@property(weak, nonatomic) IBOutlet UILabel         *lbRatioLike;
@property(weak, nonatomic) IBOutlet UILabel         *lbSumVote;

@property(weak, nonatomic) id<CommentCellDelegate>  delegate;
@property (strong, nonatomic) CommentModel           *data;
@property (strong, nonatomic) NSIndexPath           *indexPath;

+(float)heightWithItem:(CommentModel *)item;
- (void)setContentWithItem:(CommentModel *)item;

-(instancetype)initForComment;
-(instancetype)initForReply;

-(IBAction)btReport_Touched:(id)sender;
-(IBAction)btExpandColapse_Touched:(id)sender;
-(IBAction)btLike_Touched:(id)sender;
-(IBAction)btDisLike_Touched:(id)sender;
@end
