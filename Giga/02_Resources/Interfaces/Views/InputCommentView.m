//
//  InputCommentView.m
//  Giga
//
//  Created by VisiKardMacBookPro on 11/28/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "InputCommentView.h"
#import "FHSTwitterEngine.h"
#import "AppDelegate.h"
#import "FacebookHelper.h"
#import "ArticleModel.h"

@interface InputCommentView()<FHSTwitterEngineAccessTokenDelegate>

@end

@implementation InputCommentView
@synthesize containerView;
@synthesize textView;

- (instancetype)initWithFrame:(CGRect)frame andCompleteBlock:(void (^)(NSString *text, BOOL isTwitterEnable, BOOL isFacebookEnable))block {
    self = [self initWithFrame:frame];
    completeBlock = block;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] firstObject];
    self.frame = frame;
    
    loginView = [[FBLoginView alloc] init]; //FB
    
    self.btSend.layer.cornerRadius = 5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 4;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = NORMAL_FONT_WITH_SIZE(14);
    textView.placeholder = localizedString(@"Input comment");
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textView.layer.cornerRadius = 5;
    textView.layer.borderColor = RGB(102, 102, 102).CGColor;
    textView.layer.borderWidth = 1;
    textView.textColor = RGB(141, 141, 141);
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose:)];
    [self addGestureRecognizer:tapGesture];
    
    //SHARE TWITER
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey: TWITTER_CONSUMERKEY andSecret: TWITTER_SECRET];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePushNotificaitonFacebook:) name:infoPlist[@"FacebookAppID"] object:nil];
    
    [textView becomeFirstResponder];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handlePushNotificaitonFacebook:(NSNotification *)info {
    self.btFacebook.selected = !isFacebookEnable;
    isFacebookEnable = !isFacebookEnable;
    [textView becomeFirstResponder];
}

- (void)tapToClose:(UIGestureRecognizer *) gesture
{
    [self removeFromSuperview];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

#pragma mark - IBActions
-(IBAction)btTwitter_Touched:(id)sender {
    
    if (!FHSTwitterEngine.sharedEngine.isAuthorized) {
        [self loginOAuth];
        
    }else{
        ((UIButton *)sender).selected = !isTwitterEnable;
        isTwitterEnable = !isTwitterEnable;
    }
    
}

-(IBAction)btFacebook_Touched:(id)sender {
    if([[FacebookHelper shared] hasPublishPermission]) {
        ((UIButton *)sender).selected = !isFacebookEnable;
        isFacebookEnable = !isFacebookEnable;
    } else {
        
        [[FacebookHelper shared] requestForPublishPermissionOnComplete:^(BOOL success) {
            ((UIButton *)sender).selected = !isFacebookEnable;
            isFacebookEnable = YES;
        } onError:^(NSError *error) {
            
        }];
        [textView resignFirstResponder];
    }
}

-(IBAction)btSend_Touched:(id)sender {
    if(textView.text.length == 0){
        [self removeFromSuperview];
        return;
    }
    
    // FB first time login -> update article object
//    if (!self.article.articleID) {
//        self.article = [ArticleModel getArticleByID:self.articleID];
//    }
    
    if (!self.article.articleID) {
        [self tapToClose:nil];
        return;
    }
        
    if (isFacebookEnable) {
        
        //FB
        //login
        [self facebookLogin];
        
        
        
        
        // post fb
        //        NSString *postText = [NSString stringWithFormat:@"%@ %@ %@", textView.text,self.article == nil? @"" : self.article.title, @"http://giga-news.jp/teaser.html"];
        //        [[FacebookHelper shared] postStatus: postText];
        //        [[FacebookHelper shared] postStatus: postText link: @"http://giga-news.jp/teaser.html"];
    }
    
    if (isTwitterEnable) {
        // post twitter
        NSString *postText =  [NSString stringWithFormat:@"%@ %@ %@", self.article == nil? @"" : self.article.title, @"http://giga-news.jp/teaser.html",  @"@giganews"];
        if (postText.length < 140) {
            NSRange range;
            range.location = 0;
            range.length =  140 - postText.length;
            if (textView.text.length > range.length) {
                postText = [NSString stringWithFormat:@"%@ %@", [textView.text substringWithRange:range],  postText];
            } else {
                postText = [NSString stringWithFormat:@"%@ %@", textView.text,  postText];
            }
            
        }
        [[FHSTwitterEngine sharedEngine] postTweet: postText];
    }
    
    
    if (completeBlock) {
        completeBlock(textView.text, isTwitterEnable, isFacebookEnable);
    }
    [self removeFromSuperview];
}

#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = textView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    textView.frame = r;
}

- (void)loginOAuth {
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        //        DLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        if (success) {
            //            imgBG.hidden = YES;
            //            loginTwiter.hidden = YES;
            //            loginView.hidden = YES;
            
            
            //            [self.btTwitter setBackgroundImage:[UIImage imageNamed:@"twiter.png"] forState:UIControlStateNormal];
            [self.btTwitter setSelected:YES];
            isTwitterEnable = YES;
        }
    }];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:loginController animated:YES completion:nil];
}
-(void)postTweet:(NSString*)tweet{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            id returned = [[FHSTwitterEngine sharedEngine]postTweet:tweet];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSString *title = nil;
            NSString *message = nil;
            
            if ([returned isKindOfClass:[NSError class]]) {
                NSError *error = (NSError *)returned;
                title = [NSString stringWithFormat:@"Error %ld",(long)error.code];
                message = error.localizedDescription;
            } else {
                DLog(@"%@",returned);
                title = @"Tweet Posted";
                message = tweet;
                
                
            }
            DLog(@"%@", message);
        }
    });
}

#pragma mark - FHSTwitterEngineAccessTokenDelegate
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}


#pragma mark -Facebook
- (void)facebookLogin {
    if (!isLoggedinFB) {
        
        if (!FBSession.activeSession.isOpen) {
            // if the session is closed, then we open it here, and establish a handler for state changes
            [FBSession openActiveSessionWithReadPermissions:@[@"publish_actions"]
                                               allowLoginUI:YES
                                          completionHandler:^(FBSession *session,
                                                              FBSessionState state,
                                                              NSError *error) {
                                              if (error) {
                                                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                      message:error.localizedDescription
                                                                                                     delegate:nil
                                                                                            cancelButtonTitle:@"OK"
                                                                                            otherButtonTitles:nil];
                                                  [alertView show];
                                              } else if (session.isOpen) {
                                                  isFacebookEnable = YES;
                                              }
                                          }];
            return;
        } else {
            if (isFacebookEnable) {
                isFacebookEnable = NO;
            }else{
                isFacebookEnable = YES;
            }
        }
        
        
        
    }else{
        if (isFacebookEnable) {
            isFacebookEnable = NO;
        }else{
            isFacebookEnable = YES;
        }
    }
    
    
    if (isFacebookEnable) { //FBログインOK
        [self ShareLinkWithAPICalls];
    } else {
        [self facebookLogin];
    }
}


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // If the user is logged in, they can post to Facebook using API calls, so we show the buttons
    NSLog(@"loginViewShowingLoggedInUser");
    isLoggedinFB = YES;
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // If the user is NOT logged in, they can't post to Facebook using API calls, so we show the buttons
    NSLog(@"loginViewShowingLoggedOutUser");
    isLoggedinFB = NO;
}

- (void)ShareLinkWithAPICalls {
    NSLog(@"ShareLinkWithAPICalls");
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:@[@"publish_actions"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                              
                                              
                                          } else if (session.isOpen) {
                                              
                                              [self fbPost];
                                              
                                          }
                                      }];
        return;
    } else {
        [self fbPost];
    }
    
}

- (void)fbPost {
    NSLog(@"fbPost");
    //    NSString *postText = [NSString stringWithFormat:@"%@ %@ %@", textView.text,self.article == nil? @"" : self.article.title, @"http://giga-news.jp/teaser.html"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"ギガニュース", @"name",
                            self.article.title, @"caption",
                            self.article.overview, @"description",
                            @"http://giga-news.jp/teaser.html", @"link",
                            textView.text, @"message",
                            nil
                            ];
    /* make the API call */
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                          }];
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                   @"ギガニュース", @"name",
    //                                   self.article.title, @"caption",
    //                                   self.article.title, @"description",
    //                                   @"http://giga-news.jp/teaser.html", @"link", //link は記事のURLに変更
    ////                                   @"https://b-ambitious.jp/static/common/images/ogp.png", @"picture",
    ////                                   textView.text, @"message",
    //                                   nil];
    //
    //    [FBRequestConnection startWithGraphPath:@"/me/feed"
    //                                 parameters:params
    //                                 HTTPMethod:@"POST"
    //                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    //                              if (!error) {
    //                                  // Link posted successfully to Facebook
    //                                  NSLog(@"result: %@", result);
    //
    //
    //                              } else {
    //                                  // An error occurred, we need to handle the error
    //                                  NSLog(@"%@", error.description);
    //                              }
    //                              
    //                          }];
    
}

@end
