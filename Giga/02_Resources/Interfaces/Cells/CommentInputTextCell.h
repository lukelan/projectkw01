//
//  CommentInputTextCell.h
//  Giga
//
//  Created by vandong on 11/28/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CommentInputTextCellHeight  53
@interface CommentInputTextCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField                *tfInputReply;
@property (strong, nonatomic) NSIndexPath                       *indexPath;

@property (copy, nonatomic) void (^onTouchedAddReplyBlock)(NSIndexPath *);

- (IBAction)btAddReply_Touched:(id)sender;
@end
