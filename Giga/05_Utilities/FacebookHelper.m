//
//  FacebookHelper.m
//  VISIKARD
//
//  Created by Hoang Ho on 5/30/14.
//
//

#import "FacebookHelper.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Define.h"
#import <objc/runtime.h>

#define INVITATION_MESSAGE @"Please join with us."
#define DEFAULT_THIRDPARTY_PASSWORD                         @""
#define FACEBOOK_APP_READ_PERMISSION                                    [NSArray arrayWithObjects: @"email", @"user_photos", @"user_friends", @"user_birthday", nil]
#define FACEBOOK_APP_PUBLIC_PERMISSION                          [NSArray arrayWithObjects: @"publish_actions", nil]

//#define FACEBOOK_TEST   1

static char const * const locationUpdateFinishedTag = "locationUpdateFinishedTag";

@interface FacebookHelper()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@end

@implementation FacebookHelper

+ (FacebookHelper *)shared
{
    static FacebookHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FacebookHelper new];
    });
    return instance;
}

- (void)closeAndClearToken
{
    [[FBSession activeSession] closeAndClearTokenInformation];
}
int maxTryTime = 5;
int tryTime = 1;//To avoid loop circle
- (void)getFacebookUserInfoOnComplete:(void(^)(id result))completionBlock
                              onError:(void(^)(NSError *error))errorBlock
{
    void (^finishTask)(id, NSError*) = ^(id finalResult, NSError *finalError){
        //reset tryTime
        tryTime = 1;
        if (finalError) {
            errorBlock(finalError);
        }else{
            completionBlock(finalResult);
        }
    };
    
    //Retry when receive error
    void (^retryTask)(NSError*) = ^(NSError *tempError){
        if ([self isSessionError:tempError] && tryTime <= maxTryTime) {
            //increase try time
            tryTime++;
            [self requestToGetNewSession:nil OnComplete:^(FBSession *newSession) {
                //request read permission again
                [self getFacebookUserInfoOnComplete:^(id result) {
                    finishTask(result, nil);
                } onError:^(NSError *error) {
                    finishTask(nil, error);
                }];
            } onError:^(NSError *error) {
                finishTask(nil, error);
            }];
            
        }else{
            finishTask(nil, tempError);
        }
    };
    [self closeAndClearToken];
    __block BOOL requestSuccess = NO;
    // HoangH: 23/04/14 : request read permissions for login or sign up via fb
    [FBSession openActiveSessionWithReadPermissions:FACEBOOK_APP_READ_PERMISSION
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      //Check request success to avoid request again when closeAndClearTokenInformation invoke
                                      if (!requestSuccess) {
                                          if (error) {
                                              retryTask(error);
                                          } else {
                                              if (status == FBSessionStateOpen) {
                                                  FBRequest *request = [FBRequest requestForMe];
                                                  request.session = [FBSession activeSession];
                                                  [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                      DLog(@"%@", result);
                                                      if (error) {
                                                          retryTask(error);
                                                      } else {
                                                          requestSuccess = YES;
                                                          finishTask(result, nil);
                                                      }
                                                  }];
                                              }
                                          }
                                      }
                                  }];
}

- (void)getListFriendsOnComplete:(void(^)(NSMutableArray *arrFriends ))completionBlock
                         onError:(void(^)(NSError *error))errorBlock;
{
    void (^finishTask)(id, NSError*) = ^(id arr,NSError *finalError){
        //reset tryTime
        tryTime = 1;
        if (finalError) {
            errorBlock(finalError);
        }else{
            completionBlock(arr);
        }
    };
    FBRequest* friendsRequest = [FBRequest  requestForMyFriends];
    
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        if (error) {
            if ([self isSessionError:error] && tryTime <= maxTryTime) {
                //This is most common error when logined with facebook
                
                //increase try time
                tryTime++;
                
                //Request to get a new session
                [self requestToGetNewSession:nil OnComplete:^(FBSession *newSession) {
                    //get list friend again
                    [self getListFriendsOnComplete:^(NSMutableArray *arrFacebookIds) {
                        finishTask(arrFacebookIds, nil);
                    } onError:^(NSError *error) {
                        finishTask(nil, error);
                    }];
                } onError:^(NSError *error) {
                    finishTask(nil, error);
                }];
            }else
                finishTask(nil,error);
        } else {
            NSMutableArray *arrFriends = [NSMutableArray array];
            NSArray* friends = [result objectForKey:@"data"];
            for (NSDictionary<FBGraphUser>* friend in friends) {
                
                [arrFriends addObject:friend];
            }
            finishTask(arrFriends, nil);
        }
    }];
}

- (void)requestForPublishPermissionOnComplete:(void(^)(BOOL success))completionBlock
                                      onError:(void(^)(NSError *error))errorBlock
{
    void (^finishTask)(BOOL, NSError*) = ^(BOOL finalResult, NSError *finalError){
        //reset tryTime
        tryTime = 1;
        if (finalError) {
            errorBlock(finalError);
        }else{
            completionBlock(finalResult);
        }
    };
    //Retry when receive error
    void (^retryTask)(NSError*) = ^(NSError *tempError){
        if ([self isSessionError:tempError] && tryTime <= maxTryTime) {//Error session
            //This is most common error when logined with facebook
            //Request to get a new session
            
            //increase try time
            tryTime++;
            [self requestToGetNewSession:nil OnComplete:^(FBSession *newSession) {
                [self requestForPublishPermissionOnComplete:^(BOOL success) {
                    finishTask(success,nil);
                } onError:^(NSError *error) {
                    finishTask(NO,error);
                }];
            } onError:^(NSError *error) {
                finishTask(NO,error);
            }];
        }else
            finishTask(NO,tempError);
    };
    
    void (^requestPermissionTask)() = ^(){
        [[FBSession activeSession] requestNewPublishPermissions:FACEBOOK_APP_PUBLIC_PERMISSION defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
            if (error) {
                retryTask(error);
            } else {
                //if user doesn't accept publish permission, facebook api won't raise any error
                //=> must check if has publish_actions permission
                if ([session.permissions indexOfObject:@"publish_actions"] != NSNotFound) {
                    finishTask(YES, nil);
                }else
                    finishTask(NO,nil);
            }
        }];
    };
    
    
    //Check if session is active
    if (self.isActive) {
        //Check if the session has publish actions
        if (self.hasPublishPermission) {
            finishTask(YES,nil);
        }else{//Request for publish permission
            requestPermissionTask();
        }
    }else{//There is not active session
        //Request for a new session
        [self requestToGetNewSession:nil OnComplete:^(FBSession *newSession) {
            requestPermissionTask();
        } onError:^(NSError *error) {
            retryTask(error);
        }];
    }
}

- (void)getListAlbumsOnComplete:(void(^)(id result))completionBlock
                        onError:(void(^)(NSError *error))errorBlock
{
    //Retry when receive error
    void (^retryTask)(NSError*) = ^(NSError *tempError){
        if ([self isSessionError:tempError] && tryTime <= maxTryTime) {//Error session
            //This is most common error when logined with facebook
            //Request to get a new session
            
            //increase try time
            tryTime++;
            [self requestToGetNewSession:nil OnComplete:^(FBSession *newSession) {
                [self getListAlbumsOnComplete:^(id result) {
                    completionBlock(result);
                } onError:^(NSError *error) {
                    errorBlock(error);
                }];
            } onError:^(NSError *error) {
                errorBlock(error);
            }];
        }else
            errorBlock(tempError);
    };
    
    FBRequest *request = [FBRequest requestForGraphPath:@"me/albums"];
    request.session = [FBSession activeSession];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            retryTask(error);
        }else{
            if (result) {
                tryTime = 1;
                completionBlock(result[@"data"]);
            }
        }
    }];
}

- (void)getListPhotosInAlbum:(NSString*)albumId
                  onComplete:(void(^)(id result))completionBlock
                     onError:(void(^)(NSError *error))errorBlock
{
    //Retry when receive error
    void (^retryTask)(NSError*) = ^(NSError *tempError){
        if ([self isSessionError:tempError] && tryTime <= maxTryTime) {//Error session
            //This is most common error when logined with facebook
            //Request to get a new session
            
            //increase try time
            tryTime++;
            [self requestToGetNewSession:nil OnComplete:^(FBSession *newSession) {
                [self getListPhotosInAlbum:albumId onComplete:^(id result) {
                    completionBlock(result);
                } onError:^(NSError *error) {
                    errorBlock(error);
                }];
            } onError:^(NSError *error) {
                errorBlock(error);
            }];
        }else
            errorBlock(tempError);
    };
    
    
    [FBSession openActiveSessionWithReadPermissions:FACEBOOK_APP_READ_PERMISSION allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (error) {
            retryTask(error);
        } else {
            if (status == FBSessionStateOpen) {
                FBRequest *request = [FBRequest requestForGraphPath:[NSString stringWithFormat:@"%@/photos",albumId]];
                request.session = [FBSession activeSession];
                
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (error) {
                        retryTask(error);
                    }else{
                        NSMutableArray *photosResult = [NSMutableArray array];
                        NSArray *photos = result[@"data"];
                        for (FBGraphObject *photo in photos) {
                            NSString *urlPicture = [photo objectForKey:@"picture"];
                            NSString *urlSource = [photo objectForKey:@"source"];
                            
                            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:urlPicture, kFBSmallImageKey,urlPicture, kFBMediumImageKey,
                                                  urlSource, kFBLargeImageKey, nil];
                            [photosResult addObject:dict];
                        }
                        tryTime = 1;
                        completionBlock (photosResult);
                    }
                }];
            }
        }
    }];
}

- (void)getProfilePicturesOnComplete:(void(^)(id result))completionBlock
                             onError:(void(^)(NSError *error))errorBlock
{
    static NSString *albumName = @"Profile Pictures";
    //        static NSString *albumName = @"Mobile Uploads";
    __block NSString *albumId = nil;
    [[FacebookHelper shared] getListAlbumsOnComplete:^(id listAlbumResult) {
        for (FBGraphObject *album in listAlbumResult) {
            if ([[album objectForKey:@"name"] isEqualToString:albumName]) {
                albumId = [album objectForKey:@"id"];
                break;
            }
        }
        if (albumId) {
            [[FacebookHelper shared] getListPhotosInAlbum:albumId onComplete:^(NSMutableArray* result) {
                completionBlock(result);
            } onError:^(NSError *error) {
                errorBlock(error);
            }];
        }else{
            //No profile picture
            completionBlock(nil);
        }
    } onError:^(NSError *error) {
        errorBlock(error);
    }];
}


- (void)inviteFriend:(NSString*)fbId OnComplete:(void(^)(BOOL success))completionBlock
             onError:(void(^)(NSError *error))errorBlock
{
    NSArray *fbIdFriends = [NSArray arrayWithObject:fbId];
    [self inviteListFacebookId:fbIdFriends OnComplete:^(BOOL success) {
        completionBlock(success);
    } onError:^(NSError *error) {
        errorBlock(error);
    }];
}

- (void)inviteListFacebookId:(NSArray*)fbIdFriends OnComplete:(void(^)(BOOL success))completionBlock
                     onError:(void(^)(NSError *error))errorBlock
{
    //Retry when receive error
    void (^retryTask)(NSError*) = ^(NSError *tempError){
        if ([self isSessionError:tempError] && tryTime <= maxTryTime) {//Error session
            //This is most common error when logined with facebook
            //Request to get a new session
            
            //increase try time
            tryTime++;
            [self requestToGetNewSession:nil OnComplete:^(FBSession *newSession) {
                [self inviteListFacebookId:fbIdFriends OnComplete:^(BOOL result) {
                    completionBlock(result);
                } onError:^(NSError *error) {
                    errorBlock(error);
                }];
            } onError:^(NSError *error) {
                errorBlock(error);
            }];
        }else
            errorBlock(tempError);
    };
    // login to FB
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              retryTask(error);
                                          } else if (session.isOpen) {
                                              [self inviteListFacebookId:fbIdFriends OnComplete:^(BOOL result) {
                                                  completionBlock(result);
                                              } onError:^(NSError *error) {
                                                  errorBlock(error);
                                              }];
                                          }
                                      }];
        return;
    }
    
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [fbIdFriends componentsJoinedByString:@","], @"to",
                                     @"http://www.facebook.com/pages/VisiKard/317328321631555",@"link",
                                     nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:[NSString stringWithFormat:INVITATION_MESSAGE]
                                                    title:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          retryTask(error);
                                                      } else {
                                                          tryTime = 1;
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              DLog(@"User canceled request.");
                                                              tryTime = 1;
                                                              // finish invite via FB
                                                              completionBlock(NO);
                                                          } else {
                                                              completionBlock(YES);
                                                          }
                                                      }}];
    
}

int numberInvited = 0;
int perItemForRequest = 50;
NSArray *totalArray;

- (void)resetTempData
{
    numberInvited = 0;
    totalArray = nil;
    tryTime = 1;
}

- (void)inviteListsFriend:(NSArray*)fbIdFriends OnComplete:(void(^)(int numberInvited))completionBlock
                  onError:(void(^)(NSError *error))errorBlock
{
    if (!totalArray) {
        totalArray = fbIdFriends;
    }
    if (fbIdFriends.count > perItemForRequest) {
        NSArray *firstArray = [totalArray subarrayWithRange:NSMakeRange(numberInvited, perItemForRequest)];
        [self inviteListFacebookId:firstArray OnComplete:^(BOOL success) {
            if (success) {
                numberInvited += firstArray.count;
                if (numberInvited >= totalArray.count) {
                    completionBlock(YES);
                }else{
                    NSArray *tempArray = [totalArray subarrayWithRange:NSMakeRange(numberInvited, totalArray.count - numberInvited)];
                    [self inviteListsFriend:tempArray OnComplete:^(int result) {
                        completionBlock(result);
                    } onError:^(NSError *error) {
                        errorBlock(error);
                    }];
                }
            }else{
                completionBlock(numberInvited);
            }
        } onError:^(NSError *error) {
            errorBlock(error);
        }];
    }else{
        [self inviteListFacebookId:fbIdFriends OnComplete:^(BOOL success) {
            if (success) {
                numberInvited += fbIdFriends.count;
            }
            completionBlock(numberInvited);
        } onError:^(NSError *error) {
            errorBlock(error);
        }];
    }
}

//Post status
- (void)postStatus:(NSString *)text {
    NSString *status = text;
    
    FBRequest *request = [FBRequest requestForPostStatusUpdate:status];
    
    FBRequestConnection *requestConnection = [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    }];
    [requestConnection cancel];
    
    NSMutableURLRequest *urlRequest = requestConnection.urlRequest;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Do your success callback.
        DLog(@"response post status: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do your failure callback.
        DLog(@"response post status error: %@", error);
    }];
    
    [operation start];

}

- (void)postLink:(NSString *)link imageLink:(NSString *)imageLink message:(NSString *)message OnComplete:(void(^)(BOOL success))completionBlock
         onError:(void(^)(NSError *error))errorBlock
{
    FBShareDialogParams *param = [[FBShareDialogParams alloc] init];
    param.link = [NSURL URLWithString: link];
    __block BOOL isShowDialog = NO;
    
    void (^postTask)(NSDictionary*) = ^(NSDictionary *params){
        if(isShowDialog == YES) return;
        isShowDialog = YES;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: link, @"link",imageLink, @"picture", @"message", @"caption",  nil];
        [FBWebDialogs presentDialogModallyWithSession:[FBSession activeSession] dialog:@"feed" parameters:dict handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
            if (error) {
                errorBlock(error);
            }else
                completionBlock(YES);
        }];
    };
    
    [self requestForPublishPermissionOnComplete:^(BOOL success) {
        if (success) {
            postTask(nil);
            
        }else{
            completionBlock(success);
        }
    } onError:^(NSError *error) {
        errorBlock(error);
    }];
}

- (void)postStatus:(NSString*)message withFriends:(NSArray*)friends OnComplete:(void(^)(BOOL success))completionBlock
           onError:(void(^)(NSError *error))errorBlock
{
    static NSString *pictureUrl = @"https://lh4.ggpht.com/uQBQ46WJX17XU3PZqBgBq4r8Rm8AfZjtaPiepaDtN7Zp9n5ver4H0eA2OrmXGAj4DZU8=w300";
    static NSString *linkUrl = @"http://www.visikard.vn/";
    static NSString *descriptionString = @"The social media kard";
    void (^postTask)(NSDictionary*) = ^(NSDictionary *params){
        [FBRequestConnection startWithGraphPath:@"/me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
                                  if (error) {
                                      errorBlock(error);
                                  }else
                                      completionBlock(YES);
                              }];
    };
    
    NSMutableArray *friendIds = [NSMutableArray array];
    for (NSDictionary<FBGraphUser>* friend in friends) {
        [friendIds addObject:friend.id];
    }
    
    if([self hasPublishPermission]) {
        [self getPlaceIdOnCompletion:^(id responseObject) {
            NSString *placeId = responseObject;
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           message, @"message",
                                           descriptionString, @"description",
                                           linkUrl, @"link",
                                           pictureUrl, @"picture",
                                           placeId, @"place",
                                           [friendIds componentsJoinedByString:@","], @"tags",
                                           nil];
            postTask(params);
        } onError:^(NSError *error) {
            errorBlock(error);
        }];

    }
    
//    [self requestForPublishPermissionOnComplete:^(BOOL success) {
//        if (success) {
//            [self getPlaceIdOnCompletion:^(id responseObject) {
//                NSString *placeId = responseObject;
//                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                               message, @"message",
//                                               descriptionString, @"description",
//                                               linkUrl, @"link",
//                                               pictureUrl, @"picture",
//                                               placeId, @"place",
//                                               [friendIds componentsJoinedByString:@","], @"tags",
//                                               nil];
//                postTask(params);
//            } onError:^(NSError *error) {
//                errorBlock(error);
//            }];
//        }else{
//            completionBlock(success);
//        }
//    } onError:^(NSError *error) {
//        errorBlock(error);
//    }];
}

#pragma mark - Check

- (BOOL)isActive
{
    return FBSession.activeSession.isOpen;
}

- (BOOL)hasPublishPermission
{
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        return NO;
    }
    return YES;
}

- (BOOL)isSessionError:(NSError*)error
{
    if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession||
        error.code == 5)
        return YES;
    return NO;
}

#pragma mark - Error Handlers

//objc_setAssociatedObject(alertView, alertCompletionBlockTag, completionBlock, OBJC_ASSOCIATION_COPY);
- (void)getUserLocationOnCompletion:(void (^)(id responseObject))completionBlock
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 10;
    objc_setAssociatedObject(_locationManager, locationUpdateFinishedTag, completionBlock, OBJC_ASSOCIATION_COPY);
    if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager performSelector:@selector(requestAlwaysAuthorization)];
    }
    
    [_locationManager startUpdatingLocation];
}

- (void)getPlaceIdOnCompletion:(void (^)(id responseObject))completionBlock
                       onError:(void (^)(NSError *error))errorBlock
{
    void (^getPlaceIdTask)() = ^{
        NSString *accessToken = [FBSession activeSession].accessTokenData.accessToken;
        float lat = self.userLocation.coordinate.latitude;
        float lng = self.userLocation.coordinate.longitude;
        if (lat == 0.0 || lng == 0.0) {
//            VKLog(@"Can not get user location");
        }
        NSString *requestString = [NSString stringWithFormat:@"https://graph.facebook.com/search?&type=place&center=%f,%f&distance=1000&limit=1&access_token=%@",lat,lng,accessToken];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        [AFHTTPRequestOperation addAcceptableContentTypes: [NSSet setWithObjects:@"application/json", nil]];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Do your success callback.
            NSError *error;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                errorBlock(error);
            }else{
                if (responseDict && [responseDict objectForKey:@"data"] && [[responseDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    NSArray *places = [responseDict objectForKey:@"data"];
                    if (places.count > 0) {
                        NSDictionary *firstPlace = places[0];
                        NSString *placeId = [firstPlace objectForKey:@"id"];
                        completionBlock(placeId);
                    }else{
                        completionBlock(nil);
                    }
                }else{
                    completionBlock(nil);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            errorBlock(error);
        }];
        [operation start];
    };
    
    float lat = self.userLocation.coordinate.latitude;
    float lng = self.userLocation.coordinate.longitude;
    if (lat == 0.0 || lng == 0.0) {
        [self getUserLocationOnCompletion:^(id responseObject) {
            getPlaceIdTask();
        }];
    }else{
        getPlaceIdTask();
    }
}

//#define APP_ID @"535724323227034" //@"868123946553210" //
#define APP_ID @"868123946553210"
FBSession *aSession;//Keep a strong session to avoid crash
- (void)requestToGetNewSession:(FBSession*)oldSession
                    OnComplete:(void(^)(FBSession *newSession))completionBlock
                       onError:(void(^)(NSError *error))errorBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        FBSession *session = [[FBSession alloc] initWithAppID:APP_ID permissions:nil defaultAudience:FBSessionDefaultAudienceEveryone urlSchemeSuffix:nil tokenCacheStrategy:nil];
        [FBSettings setDefaultAppID: APP_ID];
        [FBSession setActiveSession:session];
        [FBSession openActiveSessionWithReadPermissions:FACEBOOK_APP_READ_PERMISSION allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error) {
                errorBlock(error);
            }else{
                //a new session
                //Set active session
                if (status == FBSessionStateOpen) {
                    [FBSession setActiveSession:session];
                    completionBlock(session);
                }
            }
        }];
    });
}


#pragma mark - Location Manger

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    id completion = objc_getAssociatedObject(manager, locationUpdateFinishedTag);
    [self complete:completion didUpdateLocations:locations];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
        id completion = objc_getAssociatedObject(manager, locationUpdateFinishedTag);
        [self complete:completion didUpdateLocations:nil];
    }
}

- (void) complete:(void (^)(NSArray *obj))block  didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        CLLocation *location = [locations objectAtIndex:0];
        self.userLocation = location;
    }
    [_locationManager stopUpdatingLocation];
    _locationManager = nil;
    block(locations);
    objc_removeAssociatedObjects(block);
}


@end
