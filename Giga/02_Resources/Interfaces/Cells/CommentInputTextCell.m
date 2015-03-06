//
//  CommentInputTextCell.m
//  Giga
//
//  Created by vandong on 11/28/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CommentInputTextCell.h"

@interface CommentInputTextCell()

@end

@implementation CommentInputTextCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil][0];
    self.tfInputReply.placeholder = localizedString(@"Type to reply");
    self.tfInputReply.layer.borderColor = RGB(182, 180, 182).CGColor;
    self.tfInputReply.layer.borderWidth = 1;
    return self;
}

- (IBAction)btAddReply_Touched:(id)sender {
    if (self.onTouchedAddReplyBlock) {
        self.onTouchedAddReplyBlock(self.indexPath);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

@end
