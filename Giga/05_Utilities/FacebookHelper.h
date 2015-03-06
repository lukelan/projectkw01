//
//  FacebookHelper.h
//  VISIKARD
//
//  Created by Hoang Ho on 5/30/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef enum
{
    ENUM_LOGIN_FACEBOOK_STEP_LOGIN = 1,
    ENUM_LOGIN_FACEBOOK_STEP_SIGN_UP,
    ENUM_LOGIN_FACEBOOK_STEP_FAIL
}ENUM_LOGIN_FACEBOOK_STEP;

#define kFBLargeImageKey @"LargeImage"
#define kFBSmallImageKey @"SmallImage"
#define kFBMediumImageKey @"MediumImage"
@interface FacebookHelper : NSObject

@property(strong, nonatomic) CLLocation *userLocation;

+ (FacebookHelper*)shared;



- (void)closeAndClearToken;
//Get user info contains: emails, profile picture, age, date of birth...
- (void)getFacebookUserInfoOnComplete:(void(^)(id result))completionBlock
                              onError:(void(^)(NSError *error))errorBlock;

//Get list friend (FBGraphUser*) and list invited friend id (an array of facebook id)
- (void)getListFriendsOnComplete:(void(^)(NSMutableArray *arrFriends))completionBlock
                                    onError:(void(^)(NSError *error))errorBlock;

//Check if session is active
- (BOOL)isActive;

//Check whether the session has publish permission
- (BOOL)hasPublishPermission;


//Request publish permission
- (void)requestForPublishPermissionOnComplete:(void(^)(BOOL success))completionBlock
                                    onError:(void(^)(NSError *error))errorBlock;


//Get list album

- (void)getListAlbumsOnComplete:(void(^)(id result))completionBlock
                        onError:(void(^)(NSError *error))errorBlock;
//Get list photo from album

- (void)getListPhotosInAlbum:(NSString*)albumId
                  onComplete:(void(^)(id result))completionBlock
                     onError:(void(^)(NSError *error))errorBlock;

//Get list photo from profile picture album
- (void)getProfilePicturesOnComplete:(void(^)(id result))completionBlock
                             onError:(void(^)(NSError *error))errorBlock;

//Invite
- (void)inviteFriend:(NSString*)fbId OnComplete:(void(^)(BOOL success))completionBlock
             onError:(void(^)(NSError *error))errorBlock;
- (void)inviteListsFriend:(NSArray*)fbIdFriends OnComplete:(void(^)(int numberInvited))completionBlock
             onError:(void(^)(NSError *error))errorBlock;
- (void)resetTempData;

//Post status
- (void)postStatus:(NSString *)text;

- (void)postLink:(NSString *)link imageLink:(NSString *)imageLink message:(NSString *)message OnComplete:(void(^)(BOOL success))completionBlock
         onError:(void(^)(NSError *error))errorBlock;
- (void)postStatus:(NSString*)message withFriends:(NSArray*)friends OnComplete:(void(^)(BOOL success))completionBlock
           onError:(void(^)(NSError *error))errorBlock;

@end
