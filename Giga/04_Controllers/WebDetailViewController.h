//
//  WebDetailViewController.h
//  Giga
//
//  Created by vandong on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseViewController.h"

@interface WebDetailViewController : BaseViewController

@property(weak, nonatomic) IBOutlet UIButton            *btBack;
@property(weak, nonatomic) IBOutlet UIImageView         *imvCompanyIcon;
@property(weak, nonatomic) IBOutlet UIWebView           *wvContent;

@property(weak, nonatomic) IBOutlet UILabel            *lbBtShareTitle;

@property(strong, nonatomic) NSString                   *pageLink;

@property(strong, nonatomic) NSObject                   *objForShare;

- (IBAction)btBack_Touched:(id)sender;
- (IBAction)btShare_Touched:(id)sender;



@end
