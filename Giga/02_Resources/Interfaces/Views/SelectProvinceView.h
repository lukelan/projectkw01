//
//  SelectProvinceView.h
//  Giga
//
//  Created by VisiKardMacBookPro on 12/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMenuDropDown.h"

typedef enum
{
    ENUM_PAGE_PROVINCE,
    ENUM_PAGE_AGE,
    ENUM_PAGE_JOB
    
}ENUM_PAGE;


@interface SelectProvinceView : UIView<SAMenuDropDownDelegate>
{
    NSMutableArray *arGroups;
    NSMutableArray *arButtons;
    NSMutableArray      *arSelected;
    
    
    NSMutableArray *arGroupsJob;
    NSMutableArray *arButtonsJob;
    NSMutableArray  *arSelectedJob;
    
    
    NSMutableArray *arGroupsEmployment;
    NSMutableArray *arButtonsEmployment;
    NSMutableArray  *arSelectedEmployment;
    
    NSMutableArray *arGroupsSex;
    NSMutableArray *arButtonSex;
    NSMutableArray  *arSelectedSex;
    
    
    NSMutableArray *arGroupsAgeTitle;
    NSMutableArray *arGroupsAgeAgeID;

    
    ENUM_PAGE  _currentPage;
    
    
}

@property(strong, nonatomic) IBOutlet UIView            *vBorder;
@property(strong, nonatomic) IBOutlet UIScrollView      *srvContent;
@property(strong, nonatomic) IBOutlet UIView            *vMainContent;
@property(weak, nonatomic) IBOutlet UILabel             *lbInformChange;
@property(weak, nonatomic) IBOutlet UIButton            *btAccept;

@property (strong, nonatomic) IBOutlet UIView           *vAgeAndJob;
@property (nonatomic, strong) IBOutlet UILabel          *lbJob;
@property (strong , nonatomic) IBOutlet UILabel         *lbAge;
@property (strong , nonatomic) IBOutlet UIButton        *btAge;
@property (nonatomic, strong) SAMenuDropDown            *menuDrop;
@property (nonatomic, strong) IBOutlet UILabel          *lbEmployment;
@property (nonatomic, strong) IBOutlet UILabel          *lbSex;

- (IBAction)btProvince_Touched:(id)sender;
- (IBAction)btAccept_Touched:(id)sender;

-(IBAction)btAgeTouched:(id)sender;

@end

@interface CityItem : NSObject<NSCoding>
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *cityID;
@property (assign, nonatomic) BOOL selected;
+ (instancetype)initWithCityName:(NSString*)name cityID:(NSString*)cityID;
@end


@interface JobItem : NSObject<NSCoding>
@property (copy, nonatomic) NSString *jobName;
@property (copy, nonatomic) NSString *jobID;
@property (assign, nonatomic) BOOL selected;
+ (instancetype)initWithJobName:(NSString*)name jobID:(NSString*)jobID;
@end



@interface AgeItem : NSObject<NSCoding>
@property (copy, nonatomic) NSString *ageName;
@property (copy, nonatomic) NSString *ageID;
@property (assign, nonatomic) BOOL selected;
+ (instancetype)initWithAgeName:(NSString*)name ageID:(NSString*)ageID;
@end