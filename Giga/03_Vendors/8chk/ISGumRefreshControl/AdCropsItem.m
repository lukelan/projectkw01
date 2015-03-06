//
// Created by Tetsuyak on 2014/05/30.
// Copyright (c) 2014 8crops. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "AdCropsItem.h"
#import "ChkRecordData.h"
#import "AdCropsConstants.h"

@interface AdCropsItem()<SKStoreProductViewControllerDelegate>

@property(nonatomic, strong) UIImageView *adIconImage;
@property(nonatomic, strong) UILabel *adTitle;
@property(nonatomic, strong) UILabel *adDescription;
@property(nonatomic, strong) UIButton *adInstallButton;

-(void)create;
-(void)renderItem;

@end

@implementation AdCropsItem

+(AdCropsItem *)createItem:(ChkRecordData *)chkRecordData itemWidth:(CGFloat)itemWidth
{
	if (!chkRecordData) return nil;

	AdCropsItem *item = [[AdCropsItem alloc] initWithFrame:CGRectMake(0, 0, itemWidth, kAdCropsItemHeight)];
	item.chkRecordData = chkRecordData;
	[item create];
	[item renderItem];
	return item;

}

-(void)renderItem
{
	if (!_chkRecordData) return ;

	if (_chkRecordData) {

		_adTitle.text = _chkRecordData.category;
		//_adTitle.text = _chkRecordData.title;
		_adDescription.text = _chkRecordData.description;

		// 画像リソース読み込み
		__block __weak UIImageView *blockAdIconImageView = _adIconImage;
		NSURL *url = [NSURL URLWithString:_chkRecordData.imageIcon];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
		[NSURLConnection sendAsynchronousRequest:request
										   queue:[[NSOperationQueue alloc] init]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

								   if (error) {
									   // エラー処理を行う。
									   blockAdIconImageView.image = nil;
								   } else {
									   NSInteger httpStatusCode = ((NSHTTPURLResponse *) response).statusCode;
									   if (httpStatusCode == 404) {
										   NSLog(@"%s 404 NOT FOUND ERROR. targetURL=%@", __PRETTY_FUNCTION__, url);
										   blockAdIconImageView.image = nil;
									   } else {
										   UIImage *img = [[UIImage alloc] initWithData:data];
										   dispatch_async(dispatch_get_main_queue(), ^{
											   blockAdIconImageView.image = img;
										   });
									   }
								   }
							   }];

	}



}

-(void)create
{
	if (!_chkRecordData) return ;

	// アイコン画像
	_adIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 60, 60)];
	_adIconImage.backgroundColor = [UIColor clearColor];
	[self addSubview:_adIconImage];

	// タイトルorカテゴリ
	_adTitle = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, 155, 20)];
	_adTitle.font = [UIFont systemFontOfSize:9];
	_adTitle.textColor = AC_RGB(169, 169, 169);
	_adTitle.textAlignment = NSTextAlignmentLeft;
	_adTitle.backgroundColor = [UIColor whiteColor];
	[self addSubview:_adTitle];

	// 詳細
	_adDescription = [[UILabel alloc] initWithFrame:CGRectMake(90, 13 , 200, 35)];
	_adDescription.font = [UIFont systemFontOfSize:13];
	_adDescription.textColor = AC_RGB(0, 0, 0);
	_adDescription.textAlignment = NSTextAlignmentLeft;
	_adDescription.numberOfLines = 2;
	_adDescription.lineBreakMode = NSLineBreakByTruncatingTail;
	_adDescription.backgroundColor = [UIColor whiteColor];
	[self addSubview:_adDescription];

	// インストールボタン
	UIColor *btnColor = AC_RGB(102, 179, 78);
	_adInstallButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_adInstallButton.frame = CGRectMake(205, 50, 98, 26);
	[_adInstallButton setTitle:@"インストール" forState:UIControlStateNormal];
	_adInstallButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
	_adInstallButton.titleLabel.textColor = btnColor;
	[_adInstallButton setTitleColor:btnColor forState:UIControlStateNormal];
	[_adInstallButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

	_adInstallButton.layer.borderColor = btnColor.CGColor;
	_adInstallButton.layer.borderWidth = 1.0f;
	_adInstallButton.layer.cornerRadius = 5.5f;


	[_adInstallButton addTarget:self action:@selector(installButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_adInstallButton];


}

/*
インストールボタンが押された
*/
- (void)installButtonPushed:(id)sender {

	UIApplication *application = [UIApplication sharedApplication];
	NSURL *url = [NSURL URLWithString:_chkRecordData.linkUrl];

	//入稿URLが計測URLの場合Safari起動
	if (_chkRecordData.isMeasuring) {

		if ([application canOpenURL:url]) {
			[application openURL:url];
		} else {
			NSLog(@"%s openUrl error.", __PRETTY_FUNCTION__);
		}

	} else {

		if (NSClassFromString(@"SKStoreProductViewController")) { //ios6のバージョンの処理

			__block AdCropsItem *blockSelf = self;
			NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
			[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

				if (error) {
					// エラー処理を行う。
					if (error.code == -1003) {
						NSLog(@"%s not found hostname. targetURL=%@", __PRETTY_FUNCTION__, url);
					} else if (error.code == -1019) {
						NSLog(@"%s auth error. reason=%@", __PRETTY_FUNCTION__, error);
					} else {
						NSLog(@"%s unknown error occurred. reason = %@", __PRETTY_FUNCTION__, error);
					}

				} else {
					NSInteger httpStatusCode = ((NSHTTPURLResponse *) response).statusCode;
					if (httpStatusCode == 404) {
						NSLog(@"%s 404 NOT FOUND ERROR. targetURL=%@", __PRETTY_FUNCTION__, url);
						// } else if (・・・) {
						// 他にも処理したいHTTPステータスがあれば書く。

					} else {

						NSDictionary *productParameters = @{SKStoreProductParameterITunesItemIdentifier : blockSelf.chkRecordData.appStoreId};

						SKStoreProductViewController *storeviewController = [[SKStoreProductViewController alloc] init];
						storeviewController.delegate = blockSelf;

						[storeviewController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *sterror) {
							if (result) {

								UIWindow *window = [UIApplication sharedApplication].keyWindow;
								if (window == nil) {
									window = [[UIApplication sharedApplication].windows objectAtIndex:0];
								}
								UIViewController *viewController = window.rootViewController;
								[viewController presentViewController:storeviewController animated:YES completion:nil];

							}

						}];

					}
				}
			}];

		} else { //ios6以前のバージョンの処理

			if ([application canOpenURL:url]) {
				[application openURL:url];
			} else {
				NSLog(@"%s , openUrl error." , __PRETTY_FUNCTION__ );
			}
		}
	}


}


- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
	[viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
	NSLog(@"%s", __func__);
}

@end