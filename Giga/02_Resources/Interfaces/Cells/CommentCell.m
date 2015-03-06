//
//  CommentCell.m
//  Giga
//
//  Created by vandong on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
#import "ArticleModel.h"
#import "AppDelegate.h"

#define height_title            25
#define height_button_bar       47;

#define Max100Percent                  120
#define MaxBlue                        200.0f

@interface CommentCell()<UIAlertViewDelegate>

@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code    
    self.lbName.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbPostDate.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbPostText.font = BOLD_FONT_WITH_SIZE(14);
    self.lbBtReportTitle.font = NORMAL_FONT_WITH_SIZE(13);
    self.btExpandColapse.titleLabel.font =  BOLD_FONT_WITH_SIZE(13);
    self.btCountReply.titleLabel.font = NORMAL_FONT_WITH_SIZE(12);
//    self.btLike.titleLabel.font = NORMAL_FONT_WITH_SIZE(12);
//    self.btDisLike.titleLabel.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbLike.font = NORMAL_FONT_WITH_SIZE(10);
    self.lbDisLike.font = NORMAL_FONT_WITH_SIZE(10);
    self.lbSeparateLine.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbRatioLike.font = NORMAL_FONT_WITH_SIZE(12);
    self.lbSumVote.font = NORMAL_FONT_WITH_SIZE(12);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initForComment {
    NSArray *ar = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    self = ar[0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
    
}
-(instancetype)initForReply {
    NSArray *ar = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil];
    CommentCell *cell = ar[0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.btExpandColapse.hidden = YES;
    cell.btCountReply.hidden = YES;
    cell.lbName.frame = RECT_ADD_X(cell.lbName.frame, 31);
    cell.lbPostDate.frame = RECT_ADD_X(cell.lbPostDate.frame, 31);
    cell.vBtReport.frame = RECT_ADD_X(cell.vBtReport.frame, 31);
    cell.lbSeparateLine.frame = RECT_ADD_X(cell.lbSeparateLine.frame, 25);
    CGRect rect = RECT_WITH_X(cell.lbPostText.frame, 29);
    rect.size.width -= 29;
    cell.lbPostText.frame = rect;
    
    rect = RECT_ADD_X(cell.lbName.frame, -16);
    rect.size = CGSizeMake(11, 11);
    rect.origin.y = 8;
    UIImageView *imvReplyIcon = [[UIImageView alloc] initWithFrame:rect];
    imvReplyIcon.image = [UIImage imageNamed:@"icon_reply.png"];
    [cell addSubview:imvReplyIcon];
    
    cell.backgroundColor = RGB(242, 242, 242);
    return cell;
}


+(float)heightWithItem:(CommentModel *)item {
    float height = 0;
    height += height_title;// title height
    CGSize size;
    if (item.isReply) {
        size = [item.comment sizeWithFont: [CommentCell fontForTextWithLike:item.numLike AndDisLike:item.numDisLike numReply:item.arReply.count] constrainedToSize: CGSizeMake(275, 10000)];
    } else {
        size = [item.comment sizeWithFont: [CommentCell fontForTextWithLike:item.numLike AndDisLike:item.numDisLike numReply:item.arReply.count] constrainedToSize: CGSizeMake(304, 10000)];
    }
    
    height += size.height +2;
    
    height += height_button_bar;

    item.cellHeight = height;
    item.commentTextHeight = size.height + 2;
    return height;
}

+ (UIFont *)fontForTextWithLike:(NSInteger )numLike AndDisLike:(NSInteger )numDislike numReply:(NSInteger )replies {
    return  (replies > 0)? BOLD_FONT_WITH_SIZE(14) : NORMAL_FONT_WITH_SIZE(13);
    
//    return  (numLike >= numDislike)? BOLD_FONT_WITH_SIZE(14) : NORMAL_FONT_WITH_SIZE(13);
}

+ (UIColor *)colorForTextWithLike:(NSInteger )numLike AndDisLike:(NSInteger )numDislike numReply:(NSInteger )replies{
    if (replies > 0) {
        if(numLike + numDislike > 100) return RGB(72, 175, 239);

//        return RGB(102, 102, 102);
    }

    return RGB(149, 149, 149);

    
//    if (numLike > numDislike) {
//        return ((numLike - numDislike) >= 100)? RGB(72, 175, 239) : RGB(102, 102, 102);
//    }
//    return RGB(149, 149, 149);
}

+ (UIColor *)colorForTexNumbertWithLike:(NSInteger )numLike AndDisLike:(NSInteger )numDislike {

        return ((numLike - numDislike) > 0)? RGB(72, 175, 239) : RGB(102, 102, 102);
}


- (void)setContentWithItem:(CommentModel *)item {
    self.data = item;
    
    self.lbPostDate.text = item.modified_at;
    
    self.lbPostText.font = [CommentCell fontForTextWithLike:item.numLike AndDisLike:item.numDisLike numReply:item.arReply.count];
    self.lbPostText.textColor = [CommentCell colorForTextWithLike:item.numLike AndDisLike:item.numDisLike numReply:item.arReply.count];
    self.lbPostText.text = item.comment;
    self.lbPostText.frame = RECT_WITH_HEIGHT(self.lbPostText.frame, item.commentTextHeight);
    self.vButtonContainer.frame = RECT_WITH_Y(self.vButtonContainer.frame, self.lbPostText.frame.origin.y + item.commentTextHeight +2);
    [self.btCountReply setTitle:[NSString stringWithFormat:@"%i", item.arReply.count] forState: UIControlStateNormal];
    // calculate ratio
    float total = item.numLike + item.numDisLike;
    float result = item.numLike - item.numDisLike;
    
    self.lbSumVote.text = result >=0?[NSString stringWithFormat:@"+%.0f", result] : [NSString stringWithFormat:@"%.0f", result];
//    self.lbSumVote.font = self.lbPostText.font;
    self.lbSumVote.textColor = [CommentCell colorForTexNumbertWithLike:item.numLike AndDisLike:item.numDisLike];
    
    if (total <= 10) {
        CGRect rect = self.vRatio.frame;
        rect.size.width = Max100Percent / 10;
        rect.origin.x = self.frame.size.width - 45 - rect.size.width;
        self.vRatio.frame = rect;
        
        if (total == 0) {
            self.lbRatioLike.frame = RECT_WITH_WIDTH(self.lbRatioLike.frame,0 );
        } else {
            self.lbRatioLike.frame = RECT_WITH_WIDTH(self.lbRatioLike.frame,(float)item.numLike  / total  * rect.size.width );
        }
    }
    else if (total < MaxBlue) {
        CGRect rect = self.vRatio.frame;
        rect.size.width = total / MaxBlue * Max100Percent;
        rect.origin.x = self.frame.size.width - 45 - rect.size.width;
        self.vRatio.frame = rect;
        
        self.lbRatioLike.frame = RECT_WITH_WIDTH(self.lbRatioLike.frame,(float)item.numLike  / total  * rect.size.width );
    } else {
        CGRect rect = self.vRatio.frame;
        rect.size.width = Max100Percent;
        rect.origin.x = self.frame.size.width - 45 - rect.size.width;
        self.vRatio.frame = rect;

        self.lbRatioLike.frame = RECT_WITH_WIDTH(self.lbRatioLike.frame, (float)item.numLike  / total  * rect.size.width );
    }
}

- (void)makeLike {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue: self.data.comment_id forKey:@"comment_id"];
    [params setValue:SharedUserData.userID forKey: @"client_id"];
    [params setValue: @(1) forKey: @"type"];
    
    AppDelegate *app  = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_MAKE_LIKE_DISKLIKE_COMMENT andPostMethodKind:YES andParams:params inView:    app.window.rootViewController.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        if ([responseObject isKindOfClass:[NSNumber class]]) {
            NSInteger result = [(NSNumber *)responseObject integerValue];
            if (result == 1) {
                self.data.numLike++;
                self.data.like_type = 1;
                //        self.lbSumVote.text = [NSString stringWithFormat:@"%i", self.lbSumVote.text.intValue + 1];
                //need recalculate ratio
                [self setContentWithItem:self.data];
            }
        }
       
    } failureBlock:^(NSError *error) {
        DLog(@"error: %@", error);
    }];

}

- (void)makeDisLike {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue: self.data.comment_id forKey:@"comment_id"];
    [params setValue:SharedUserData.userID forKey: @"client_id"];
    [params setValue: @(2) forKey: @"type"];
    
    AppDelegate *app  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_MAKE_LIKE_DISKLIKE_COMMENT andPostMethodKind:YES andParams:params inView:    app.window.rootViewController.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        if ([responseObject isKindOfClass:[NSNumber class]]) {
            NSInteger result = [(NSNumber *)responseObject integerValue];
            if (result == 2) {
                self.data.numDisLike++;
                self.data.like_type = 2;
                //        self.lbSumVote.text = [NSString stringWithFormat:@"%i", self.lbSumVote.text.intValue + 1];
                //need recalculate ratio
                [self setContentWithItem:self.data];
                
            }
        }
        
    } failureBlock:^(NSError *error) {
        DLog(@"error: %@", error);        
    }];
}

- (void)makeReport {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue: self.data.comment_id forKey:@"comment_id"];
    [params setValue:SharedUserData.userID forKey: @"client_id"];
    
    AppDelegate *app  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_MAKE_REPORT_COMMENT andPostMethodKind:YES andParams:params inView:    app.window.rootViewController.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        DLog(@"response: %@", responseObject);
        
        
    } failureBlock:^(NSError *error) {
    }];
}

#pragma mark - IBActions

-(IBAction)btReport_Touched:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:localizedString(@"This comment is inappropriate") delegate:self cancelButtonTitle:localizedString(@"NO") otherButtonTitles:localizedString(@"OK"), nil];
    [alert show];
}
-(IBAction)btExpandColapse_Touched:(id)sender {
    if (self.delegate) {
        [self.delegate didTouchedExpandColapseForCell:self];
    }
}

-(IBAction)btLike_Touched:(id)sender {
    if (self.data.like_type == 0) {
        [self makeLike];
    }
}
-(IBAction)btDisLike_Touched:(id)sender {
    if (self.data.like_type == 0) {
        [self makeDisLike];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self makeReport];
    }
}
@end
