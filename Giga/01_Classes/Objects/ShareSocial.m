//
//  ShareSocial.m
//  Giga
//
//  Created by vandong on 11/27/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "ShareSocial.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import "Line.h"
#import "LKLineActivity.h"
#import "ArticleModel.h"
#import "UIImageView+WebCache.h"

#define Share_url @"http://giga-news.jp/teaser.html"

typedef NS_ENUM(NSInteger, LKLineActivityImageSharingType) {
    LKLineActivityImageSharingDirectType,
    LKLineActivityImageSharingActivityType
};
@interface ShareSocial() <UIActionSheetDelegate>
{
    NSMutableArray *lines;
    
    NSObject        *objForShare;
    
    UIImageView     *imv;
}

@end

@implementation ShareSocial

+ (ShareSocial *)share {
    static ShareSocial  *_instance;
    static dispatch_once_t dispatch_one;
        dispatch_once(&dispatch_one, ^{
            _instance = [ShareSocial new];
             _instance->lines = [[NSMutableArray alloc] initWithCapacity:1];
            _instance->imv = [[UIImageView alloc] init];
        });

    return _instance;
}

- (void)showShareSelectionInView:(UIView *)view withObject:(NSObject *)shareObject {
    objForShare = shareObject;
    UIActionSheet *actionSheet1 = [[UIActionSheet alloc]
                                   initWithTitle:@""
                                   delegate:self
                                   cancelButtonTitle: localizedString(@"Cancel")
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:localizedString(@"Facebook"),localizedString(@"Twitter"), localizedString(@"LINE"), localizedString(@"Copy Link"), nil];
    
//    AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    [actionSheet1 showInView: view];
}

#pragma mark - functions share
- (void)showFacebook:(NSString*)file
{
    AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = app.window.rootViewController;
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    NSString *title = @"";
    NSString *category = @"";
    NSString *article_id = @"";
    NSString *link = @"";
    if (objForShare && [objForShare isKindOfClass:[ArticleModel class]])
    {
        ArticleModel *article = (ArticleModel *)objForShare;
        title = article.title;
        category = article.categoryID;
        article_id = article.articleID;
        //link = article.sourceUrl;
        
        UIView *v = [[UIView alloc] initWithFrame:controller.view.bounds];
        v.backgroundColor = RGBA(128, 128, 128, 0.6);
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        indicator.center = v.center;
        [v addSubview:indicator];
        [indicator startAnimating];
        [controller.view addSubview:v];
        [imv sd_setImageWithURL: [NSURL URLWithString: article.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image)  [controller addImage:image];
            [indicator stopAnimating];
            [v removeFromSuperview];
            
        }];
        
        if(article.jobType.integerValue == 1)
        {
            link = [NSString stringWithFormat:@"http://giga-news.jp/news/%@",article_id];
        }
        else
        {
            link = [NSString stringWithFormat:@"http://giga-news.jp/recruits/%@",article_id];
        }

    }
    
    
   
    
    [controller setInitialText:[NSString stringWithFormat:@"%@", title]];
    [controller addURL:[NSURL URLWithString:link]];
    
    [vc presentViewController:controller animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            DLog(@"delete");
            
        }else if (result == SLComposeViewControllerResultDone) {
            //TODO : sent
            if ([article_id length] > 0) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:category forKey:@"category_id"];
                [params setObject:article_id forKey:@"article_id"];
                [params setObject:@"1" forKey:@"type"];
                
                [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_SHARE_INAPP andPostMethodKind:YES andParams:params inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
                    DLog(@"sent report share");
                } failureBlock:nil];
            }
        }
        else
            
        {
            DLog(@"post");
        }
    };
    controller.completionHandler =myBlock;
}


-(void)sendTwitter{
    AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = app.window.rootViewController;

    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *title = @"";
    NSString *category = @"";
    NSString *article_id = @"";
    NSString *link = @"";
    
    if (objForShare && [objForShare isKindOfClass:[ArticleModel class]])
    {
        ArticleModel *article = (ArticleModel *)objForShare;
        title = article.title;
        category = article.categoryID;
        article_id = article.articleID;
        //link = article.sourceUrl;
        
        UIView *v = [[UIView alloc] initWithFrame:composeController.view.bounds];
        v.backgroundColor = RGBA(128, 128, 128, 0.6);
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        indicator.center = v.center;
        [v addSubview:indicator];
        [indicator startAnimating];
        [composeController.view addSubview:v];
        [imv sd_setImageWithURL: [NSURL URLWithString: article.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image)  [composeController addImage:image];
            [indicator stopAnimating];
            [v removeFromSuperview];
            
        }];
        
        if(article.jobType.integerValue == 1)
        {
            link = [NSString stringWithFormat:@"http://giga-news.jp/news/%@",article_id];
        }
        else
        {
            link = [NSString stringWithFormat:@"http://giga-news.jp/recruits/%@",article_id];
        }

    }
    
    [composeController setInitialText:[NSString stringWithFormat:@"%@ %@", title, @") @giganews"]];
    [composeController addURL: [NSURL URLWithString:link]];
    
    [vc presentViewController:composeController
                       animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            DLog(@"delete");
            
        }else if (result == SLComposeViewControllerResultDone) {
            //TODO: sent
            if ([article_id length] > 0) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:category forKey:@"category_id"];
                [params setObject:article_id forKey:@"article_id"];
                [params setObject:@"1" forKey:@"type"];

                [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_SHARE_INAPP andPostMethodKind:YES andParams:params inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
                    DLog(@"sent report share");
                } failureBlock:nil];
            }
        }
        else
            
        {
            DLog(@"post");
        }
        
        //   [composeController dismissViewControllerAnimated:YES completion:Nil];
    };
    composeController.completionHandler =myBlock;
    
}

- (BOOL)checkIfLineInstalled {
    BOOL isInstalled = [Line isLineInstalled];
    
    if (!isInstalled) {
        [[[UIAlertView alloc] initWithTitle:@"Line is not installed." message:@"Please download Line from App Store, and try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    return isInstalled;
}

-(void)sendLine{
    
    if ([self checkIfLineInstalled]) {
        
        NSString *title = @"";
        NSString *category = @"";
        NSString *article_id = @"";
        NSString *link = @"";
        
        if (objForShare && [objForShare isKindOfClass:[ArticleModel class]]) {
            ArticleModel *article = (ArticleModel *)objForShare;
            title = article.title;
            category = article.categoryID;
            article_id = article.articleID;
            //link = article.sourceUrl;
            
            if(article.jobType.integerValue == 1)
            {
                link = [NSString stringWithFormat:@"http://giga-news.jp/news/%@",article_id];
            }
            else
            {
                link = [NSString stringWithFormat:@"http://giga-news.jp/recruits/%@",article_id];
            }

        }
        
        [Line shareText:[NSString stringWithFormat:@"%@　%@　#Giga_News", title, link]];
    }
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"selected index: %i", buttonIndex);
    if (buttonIndex == 0){
        [self showFacebook:@""];
    }else if (buttonIndex == 1){
        [self sendTwitter];
    }else if (buttonIndex == 2){
        [self sendLine];
    }else if (buttonIndex == 3)
    {
        
        NSString *title = @"";
        NSString *category = @"";
        NSString *article_id = @"";
        NSString *link = @"";
        if (objForShare && [objForShare isKindOfClass:[ArticleModel class]]) {
            ArticleModel *article = (ArticleModel *)objForShare;
            title = article.title;
            category = article.categoryID;
            article_id = article.articleID;
            link = article.sourceUrl;
        }
        
        UIPasteboard *userPasteBoard = [UIPasteboard generalPasteboard];
//        [UIPasteboard pasteboardWithName:@"UserDefined" create:YES];
        userPasteBoard.persistent=YES;
        [userPasteBoard setString: link];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"link ready to past" delegate:nil cancelButtonTitle: localizedString(@"OK") otherButtonTitles: nil];
        [alert show];
        
    }
}
@end
