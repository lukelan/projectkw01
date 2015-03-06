//
//  WebDetailViewController.m
//  Giga
//
//  Created by vandong on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "WebDetailViewController.h"
#import "ShareSocial.h"

@interface WebDetailViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView     *indicator;
}
@end

@implementation WebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicator];
    indicator.frame = RECT_WITH_WIDTH_HEIGHT(indicator.frame, 60, 60);
    indicator.center = self.view.center;
    indicator.backgroundColor = RGBA(102, 102, 102, 0.6);
    indicator.layer.cornerRadius = 8;
    [indicator startAnimating];
    
    self.lbBtShareTitle.text = localizedString(@"Share");
 
    if (self.pageLink.length > 0) {
        [self.wvContent loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pageLink]]];
    } else {
        [self.wvContent loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
    }
    [self addIMobileAddInControllerComment:self];
}

-(void)dealloc
{
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    indicator = nil;
    [self.wvContent stopLoading];
    self.wvContent.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btBack_Touched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btShare_Touched:(id)sender {
    [[ShareSocial share] showShareSelectionInView:self.view withObject:self.objForShare];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
    [indicator removeFromSuperview];
}


@end
