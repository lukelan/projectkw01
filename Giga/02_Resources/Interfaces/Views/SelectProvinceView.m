//
//  SelectProvinceView.m
//  Giga
//
//  Created by VisiKardMacBookPro on 12/12/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "SelectProvinceView.h"

#define Max_select_item             3

@implementation SelectProvinceView

- (instancetype)initWithFrame:(CGRect)frame {
    self =[[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] firstObject];
    self.frame = frame;
    self.btAccept.layer.cornerRadius = 5;
    self.btAccept.layer.borderColor = RGB(26, 178, 255).CGColor;
    self.btAccept.layer.borderWidth = 1;
    self.vBorder.layer.cornerRadius = 8;
    
    [self initData];
    [self showButtonsOnView];
    return self;
}

- (void)initData
{
    arGroups = [NSMutableArray new];
    arSelected = [NSMutableArray new];
    
    NSMutableArray *items = [NSMutableArray array];
    //group 1 - 7 items
    [items addObject:[CityItem initWithCityName:@"北海道" cityID:@"1"]];
    [items addObject:[CityItem initWithCityName:@"青森県" cityID:@"2"]];
    [items addObject:[CityItem initWithCityName:@"岩手県" cityID:@"3"]];
    [items addObject:[CityItem initWithCityName:@"宮城県" cityID:@"4"]];
    [items addObject:[CityItem initWithCityName:@"秋田県" cityID:@"5"]];
    [items addObject:[CityItem initWithCityName:@"山形県" cityID:@"6"]];
    [items addObject:[CityItem initWithCityName:@"福島県" cityID:@"7"]];
    [arGroups addObject:items];
    
    //group 2 - 7 items
    items = [NSMutableArray array];
    [items addObject:[CityItem initWithCityName:@"茨城県" cityID:@"8"]];
    [items addObject:[CityItem initWithCityName:@"栃木県" cityID:@"9"]];
    [items addObject:[CityItem initWithCityName:@"群馬県" cityID:@"10"]];
    [items addObject:[CityItem initWithCityName:@"埼玉県" cityID:@"11"]];
    [items addObject:[CityItem initWithCityName:@"千葉県" cityID:@"12"]];
    [items addObject:[CityItem initWithCityName:@"東京都" cityID:@"13"]];
    [items addObject:[CityItem initWithCityName:@"神奈川県" cityID:@"14"]];
    [arGroups addObject:items];
    
    //groupd 3 - 6 items
    items = [NSMutableArray array];
    [items addObject:[CityItem initWithCityName:@"新潟県" cityID:@"15"]];
    [items addObject:[CityItem initWithCityName:@"富山件" cityID:@"16"]];
    [items addObject:[CityItem initWithCityName:@"石川県" cityID:@"17"]];
    [items addObject:[CityItem initWithCityName:@"福井県" cityID:@"18"]];
    [items addObject:[CityItem initWithCityName:@"山梨県" cityID:@"19"]];
    [items addObject:[CityItem initWithCityName:@"長野県" cityID:@"20"]];
    [arGroups addObject:items];
    
    //group 4 - 4 items
    items = [NSMutableArray array];
    [items addObject:[CityItem initWithCityName:@"岐阜県" cityID:@"21"]];
    [items addObject:[CityItem initWithCityName:@"静岡県" cityID:@"22"]];
    [items addObject:[CityItem initWithCityName:@"愛知県" cityID:@"23"]];
    [items addObject:[CityItem initWithCityName:@"三重県" cityID:@"24"]];
    [arGroups addObject:items];
    
    //group 5 - 6 items
    items = [NSMutableArray array];
    [items addObject:[CityItem initWithCityName:@"滋賀県" cityID:@"25"]];
    [items addObject:[CityItem initWithCityName:@"京都府" cityID:@"26"]];
    [items addObject:[CityItem initWithCityName:@"大阪府" cityID:@"27"]];
    [items addObject:[CityItem initWithCityName:@"兵庫県" cityID:@"28"]];
    [items addObject:[CityItem initWithCityName:@"奈良県" cityID:@"29"]];
    [items addObject:[CityItem initWithCityName:@"和歌山県" cityID:@"30"]];
    [arGroups addObject:items];
    
    //group 6 - 8 items
    items = [NSMutableArray array];
    [items addObject:[CityItem initWithCityName:@"鳥取県" cityID:@"31"]];
    [items addObject:[CityItem initWithCityName:@"島根県" cityID:@"32"]];
    [items addObject:[CityItem initWithCityName:@"岡山県" cityID:@"33"]];
    [items addObject:[CityItem initWithCityName:@"広島県" cityID:@"34"]];
    [items addObject:[CityItem initWithCityName:@"山口県" cityID:@"35"]];
    [items addObject:[CityItem initWithCityName:@"徳島県" cityID:@"36"]];
    [items addObject:[CityItem initWithCityName:@"香川県" cityID:@"37"]];
    [items addObject:[CityItem initWithCityName:@"愛媛県" cityID:@"38"]];
    [arGroups addObject:items];
    
    //group 7 - 9 items
    items = [NSMutableArray array];
    [items addObject:[CityItem initWithCityName:@"高知県" cityID:@"39"]];
    [items addObject:[CityItem initWithCityName:@"福岡県" cityID:@"40"]];
    [items addObject:[CityItem initWithCityName:@"佐賀県" cityID:@"41"]];
    [items addObject:[CityItem initWithCityName:@"長崎県" cityID:@"42"]];
    [items addObject:[CityItem initWithCityName:@"熊本県" cityID:@"43"]];
    [items addObject:[CityItem initWithCityName:@"大分県" cityID:@"44"]];
    [items addObject:[CityItem initWithCityName:@"宮崎県" cityID:@"45"]];
    [items addObject:[CityItem initWithCityName:@"鹿児島県" cityID:@"46"]];
    [items addObject:[CityItem initWithCityName:@"沖縄県" cityID:@"47"]];
    [arGroups addObject:items];
    
    //group 8 - 1 item (others)
    items = [NSMutableArray array];
    [items addObject:[CityItem initWithCityName:@"その他" cityID:@"99"]];
    [arGroups addObject:items];
}


- (IBAction)btProvince_Touched:(id)sender {
    UIButton *bt = (UIButton *)sender;
    if (bt.isSelected == NO) {
        if (arSelected.count == Max_select_item) {
            ALERT(@"", localizedString(@"You reached limit number selection"));
            return;
        }
    }
    [bt setSelected: !bt.isSelected];
    
    CityItem *item = nil;
    for (NSArray *subItems in arGroups) {
        for (CityItem *obj in subItems) {
            if (obj.cityID.intValue == bt.tag) {
                item = obj;
                break;
            }
        }
        if (item) {
            break;
        }
    }
    if (item) {
        if (bt.isSelected) {
            [arSelected addObject:item];
        } else {
            [arSelected removeObject:item];
        }
    }
}

- (IBAction)btAccept_Touched:(id)sender {
    //if (arSelected.count == 0) {
    //    ALERT(@"", localizedString(@"Please select province"));
    //    return;
    //}
    
    //[SharedUserData.listProvinces removeAllObjects];
    //if (SharedUserData.listProvinces == nil) {
    //    SharedUserData.listProvinces = [NSMutableArray new];
    //}
    //[SharedUserData.listProvinces addObjectsFromArray: arSelected];
    //[SharedUserData save];
    //[self removeFromSuperview];
    
    if(_currentPage == ENUM_PAGE_PROVINCE)
    {
        if (arSelected.count == 0) {
            ALERT(@"", localizedString(@"Please select province"));
            return;
        }
        
        [SharedUserData.listProvinces removeAllObjects];
        if (SharedUserData.listProvinces == nil) {
            SharedUserData.listProvinces = [NSMutableArray new];
        }
        [SharedUserData.listProvinces addObjectsFromArray: arSelected];
        [SharedUserData save];
        
        [self.vMainContent removeFromSuperview];
        
        [self showAge];
    }
    else if (_currentPage == ENUM_PAGE_AGE)
    {
        if (arSelectedJob.count == 0) {
            ALERT(@"", localizedString(@"Please select job"));
            return;
        }
        if (arSelectedEmployment.count == 0) {
            ALERT(@"", localizedString(@"Please select employment status"));
            return;
        }
        if (arSelectedSex.count == 0) {
            ALERT(@"", localizedString(@"Please select sex"));
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:arSelectedJob forKey:@"keyJob"];
        [[NSUserDefaults standardUserDefaults] setValue:arSelectedEmployment forKey:@"keyEmployment"];
        [[NSUserDefaults standardUserDefaults] setValue:arSelectedSex forKey:@"keySex"];
        [[NSUserDefaults standardUserDefaults] setValue:_btAge.titleLabel.text forKey:@"keyAge"];
        
        [self removeFromSuperview];
    }
    
    
    
}

- (void)showButtonsOnView {
    if (arSelected == nil) arSelected = [NSMutableArray new];

    NSArray *curSelectedProvince = SharedUserData.listProvinces;
    float padding_top = self.lbInformChange.frame.origin.y + self.lbInformChange.frame.size.height + 10;
    float width = 68;
    float height = 30;
    
    for (int i =0; i < arGroups.count; i++) {
        NSArray *ar = arGroups[i];
        float padding_left = 8;
        float horizonGap = 5;
        float verticelGap = 5;
        for (int j = 0; j < ar.count; j++) {
            CityItem *city = ar[j];
            UIButton *bt = [[UIButton alloc] initWithFrame: CGRectMake(padding_left, padding_top, width, height)];
            bt.titleLabel.font = BOLD_FONT_WITH_SIZE(10);
            [bt setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
            [bt setTitleColor:[UIColor whiteColor] forState: UIControlStateSelected];
            bt.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0,0);
            [bt setTitle:city.cityName forState: UIControlStateNormal];
            [bt setTitle:city.cityName forState: UIControlStateSelected];
            [bt setBackgroundImage:[UIImage imageNamed:@"bt_province.png"] forState:UIControlStateNormal];
            [bt setBackgroundImage:[UIImage imageNamed:@"bt_province_selected.png"]  forState:UIControlStateSelected];
            
            bt.tag = city.cityID.intValue;

            [bt addTarget:self action:@selector(btProvince_Touched:) forControlEvents:UIControlEventTouchUpInside];
            
            BOOL selected = NO;
            for (CityItem *obj in curSelectedProvince) {
                if ([city.cityID isEqualToString: obj.cityID]) {
                    selected = YES;
                    break;
                }
            }
            if (selected) {
                [bt setSelected:YES];
                [arSelected addObject:city];
            }
            [self.vMainContent addSubview:bt];
            padding_left += width + horizonGap;
            
            if ((j + 1) %4 == 0 && j < ar.count-1) {
                padding_left = 8;
                padding_top += height + verticelGap;
            }
        }
        padding_top += height + 15;
    }
    
    
    self.vMainContent.frame = RECT_WITH_HEIGHT(self.vMainContent.frame, padding_top + 10);
    self.srvContent.contentSize = self.vMainContent.frame.size;
    
    [self.srvContent addSubview: self.vMainContent];
    
    _currentPage =ENUM_PAGE_PROVINCE;
    [_btAccept setTitle:@"次へ" forState:UIControlStateNormal];
}

#pragma mark - Are And Job

-(void)showAge
{
    [self initDataJob];
    [self initDataAge];
    [self showButtonsOnViewJob];
    
    [self.srvContent setContentOffset:CGPointZero];
    self.srvContent.contentSize = self.vAgeAndJob.frame.size;
    [self.srvContent addSubview: self.vAgeAndJob];
    
    _currentPage =ENUM_PAGE_AGE;
    [_btAccept setTitle:@"決定" forState:UIControlStateNormal];
}
- (void)initDataJob
{
    arGroupsJob = [NSMutableArray new];
    arSelectedJob = [NSMutableArray new];
    
    NSMutableArray *items = [NSMutableArray array];
    //group 1 - 7 items
    [items addObject:[JobItem initWithJobName:@"IT" jobID:@"3"]];
    [items addObject:[JobItem initWithJobName:@"福祉•介護" jobID:@"4"]];
    [items addObject:[JobItem initWithJobName:@"医療系" jobID:@"4"]];
    [items addObject:[JobItem initWithJobName:@"食•サービス" jobID:@"5"]];
    [items addObject:[JobItem initWithJobName:@"HR・人事" jobID:@"6"]];
    [items addObject:[JobItem initWithJobName:@"営業系" jobID:@"2"]];
    [items addObject:[JobItem initWithJobName:@"その他" jobID:@"13"]];
    [arGroupsJob addObject:items];
    
    
    
    arGroupsEmployment = [NSMutableArray new];
    arSelectedEmployment = [NSMutableArray new];
    
    NSMutableArray *itemsEmployment = [NSMutableArray array];
    //group 1 - 7 items
    [itemsEmployment addObject:[JobItem initWithJobName:@"正社員" jobID:@"1"]];
    [itemsEmployment addObject:[JobItem initWithJobName:@"派遣社員" jobID:@"2"]];
    [itemsEmployment addObject:[JobItem initWithJobName:@"アルバイト" jobID:@"3"]];
    [arGroupsEmployment addObject:itemsEmployment];
    
    
    arGroupsSex= [NSMutableArray new];
    arSelectedSex = [NSMutableArray new];
    
    NSMutableArray *itemsSex = [NSMutableArray array];
    //group 1 - 7 items
    [itemsSex addObject:[JobItem initWithJobName:@"男性" jobID:@"1"]];
    [itemsSex addObject:[JobItem initWithJobName:@"女性" jobID:@"2"]];
    [arGroupsSex addObject:itemsSex];
}
-(void)initDataAge
{
    arGroupsAgeTitle = [[NSMutableArray alloc]initWithObjects:@"  選択してください",@"  20歳代〜30歳代 ",@"  30歳代〜40歳代",@"  40歳代〜50歳代",@"  50歳代〜60歳以上", nil];
    arGroupsAgeAgeID = [[NSMutableArray alloc] initWithObjects:@"",@"20〜30",@"30〜40",@"40〜50",@"50〜60", nil];
}
- (void)showButtonsOnViewJob {
    if (arSelectedJob == nil) arSelectedJob = [NSMutableArray new];
    if (arSelectedEmployment == nil) arSelectedEmployment = [NSMutableArray new];
    if (arSelectedSex == nil) arSelectedSex = [NSMutableArray new];
    
    NSArray *curSelectedJob = [[NSUserDefaults standardUserDefaults] valueForKey:@"keyJob"];
    float padding_top = self.lbJob.frame.origin.y + self.lbJob.frame.size.height + 10;
    float width = 90;
    float height = 35;
    
    for (int i =0; i < arGroupsJob.count; i++)
    {
        NSArray *ar = arGroupsJob[i];
        float padding_left = 8;
        float horizonGap = 5;
        float verticelGap = 5;
        for (int j = 0; j < ar.count; j++) {
            JobItem *job = ar[j];
            UIButton *bt = [[UIButton alloc] initWithFrame: CGRectMake(padding_left, padding_top, width, height)];
            bt.titleLabel.font = BOLD_FONT_WITH_SIZE(10);
            [bt setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
            [bt setTitleColor:[UIColor whiteColor] forState: UIControlStateSelected];
            bt.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0,0);
            [bt setTitle:job.jobName forState: UIControlStateNormal];
            [bt setTitle:job.jobName forState: UIControlStateSelected];
            [bt setBackgroundImage:[UIImage imageNamed:@"bt_province.png"] forState:UIControlStateNormal];
            [bt setBackgroundImage:[UIImage imageNamed:@"bt_province_selected.png"]  forState:UIControlStateSelected];
            
            bt.tag = job.jobID.intValue;
            
            [bt addTarget:self action:@selector(btJob_Touched:) forControlEvents:UIControlEventTouchUpInside];
            
            BOOL selected = NO;
            for (NSString *obj in curSelectedJob) {
                if ([job.jobID isEqualToString: obj]) {
                    selected = YES;
                    break;
                }
            }
            if (selected) {
                [bt setSelected:YES];
                [arSelectedJob addObject:job.jobID];
            }
            [self.vAgeAndJob addSubview:bt];
            padding_left += width + horizonGap;
            
            if ((j + 1) %3 == 0 && j < ar.count-1) {
                padding_left = 8;
                padding_top += height + verticelGap;
            }
        }
        padding_top += height + 15;
    }
    
    //Employment
    self.lbEmployment.frame =CGRectMake(self.lbEmployment.frame.origin.x, padding_top, self.lbEmployment.frame.size.width, self.lbEmployment.frame.size.height);
    padding_top = self.lbEmployment.frame.origin.y + self.lbEmployment.frame.size.height + 10;
    NSArray *curSelectedEmployment = [[NSUserDefaults standardUserDefaults] valueForKey:@"keyEmployment"];
    for (int i =0; i < arGroupsEmployment.count; i++)
    {
        NSArray *ar = arGroupsEmployment[i];
        float padding_left = 8;
        float horizonGap = 5;
        float verticelGap = 5;
        for (int j = 0; j < ar.count; j++) {
            JobItem *job = ar[j];
            UIButton *bt = [[UIButton alloc] initWithFrame: CGRectMake(padding_left, padding_top, width, height)];
            bt.titleLabel.font = BOLD_FONT_WITH_SIZE(10);
            [bt setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
            [bt setTitleColor:[UIColor whiteColor] forState: UIControlStateSelected];
            bt.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0,0);
            [bt setTitle:job.jobName forState: UIControlStateNormal];
            [bt setTitle:job.jobName forState: UIControlStateSelected];
            [bt setBackgroundImage:[UIImage imageNamed:@"bt_province.png"] forState:UIControlStateNormal];
            [bt setBackgroundImage:[UIImage imageNamed:@"bt_province_selected.png"]  forState:UIControlStateSelected];
            
            bt.tag = job.jobID.intValue;
            
            [bt addTarget:self action:@selector(btEmployment_Touched:) forControlEvents:UIControlEventTouchUpInside];
            
            BOOL selected = NO;
            for (NSString *obj in curSelectedEmployment) {
                if ([job.jobID isEqualToString: obj]) {
                    selected = YES;
                    break;
                }
            }
            if (selected) {
                [bt setSelected:YES];
                [arSelectedEmployment addObject:job.jobID];
            }
            [self.vAgeAndJob addSubview:bt];
            padding_left += width + horizonGap;
            
            if ((j + 1) %3 == 0 && j < ar.count-1) {
                padding_left = 8;
                padding_top += height + verticelGap;
            }
        }
        padding_top += height + 15;
    }
    
    //age
    NSString *strAge = [[NSUserDefaults standardUserDefaults] valueForKey:@"keyAge"];
    if(strAge.length>0)
        [self.btAge setTitle:strAge forState:UIControlStateNormal];
    self.lbAge.frame =CGRectMake(self.lbAge.frame.origin.x, padding_top, self.lbAge.frame.size.width, self.lbAge.frame.size.height);
    self.btAge.frame =CGRectMake(self.btAge.frame.origin.x, padding_top, self.btAge.frame.size.width, self.btAge.frame.size.height);
    
    padding_top += height + 15;
    
    //sex
    self.lbSex.frame =CGRectMake(self.lbSex.frame.origin.x, padding_top, self.lbSex.frame.size.width, self.lbSex.frame.size.height);
    padding_top = self.lbSex.frame.origin.y + self.lbSex.frame.size.height + 10;
    NSArray *curSelectedSex = [[NSUserDefaults standardUserDefaults] valueForKey:@"keySex"];
    for (int i =0; i < arGroupsSex.count; i++)
    {
        NSArray *ar = arGroupsSex[i];
        float padding_left = 8;
        float horizonGap = 5;
        float verticelGap = 5;
        for (int j = 0; j < ar.count; j++) {
            JobItem *job = ar[j];
            UIButton *bt = [[UIButton alloc] initWithFrame: CGRectMake(padding_left, padding_top, width, height)];
            bt.titleLabel.font = BOLD_FONT_WITH_SIZE(10);
            [bt setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
            [bt setTitleColor:[UIColor whiteColor] forState: UIControlStateSelected];
            bt.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0,0);
            [bt setTitle:job.jobName forState: UIControlStateNormal];
            [bt setTitle:job.jobName forState: UIControlStateSelected];
            [bt setBackgroundImage:[UIImage imageNamed:@"bt_province.png"] forState:UIControlStateNormal];
            [bt setBackgroundImage:[UIImage imageNamed:@"bt_province_selected.png"]  forState:UIControlStateSelected];
            
            bt.tag = job.jobID.intValue;
            
            [bt addTarget:self action:@selector(btSex_Touched:) forControlEvents:UIControlEventTouchUpInside];
            
            BOOL selected = NO;
            for (NSString *obj in curSelectedSex) {
                if ([job.jobID isEqualToString: obj]) {
                    selected = YES;
                    break;
                }
            }
            if (selected) {
                [bt setSelected:YES];
                [arSelectedSex addObject:job.jobID];
            }
            [self.vAgeAndJob addSubview:bt];
            padding_left += width + horizonGap;
            
            if ((j + 1) %3 == 0 && j < ar.count-1) {
                padding_left = 8;
                padding_top += height + verticelGap;
            }
        }
        padding_top += height + 15;
    }
    
    
    _menuDrop = [[SAMenuDropDown alloc] initWithSource:self.btAge itemNames:arGroupsAgeTitle itemImagesName:nil itemSubtitles:nil];
    _menuDrop.delegate = self;

    self.vAgeAndJob.frame = CGRectMake(self.vAgeAndJob.frame.origin.x, self.vAgeAndJob.frame.origin.y, self.vAgeAndJob.frame.size.width,self.vAgeAndJob.frame.size.height);
    self.srvContent.contentSize = self.vAgeAndJob.frame.size;
}

-(void)btJob_Touched:(UIButton *)sender
{
    
    [sender setSelected: !sender.isSelected];
    
    JobItem *item = nil;
    for (NSArray *subItems in arGroupsJob) {
        for (JobItem *obj in subItems) {
            if (obj.jobID.intValue == sender.tag) {
                item = obj;
                break;
            }
        }
        if (item) {
            break;
        }
    }
    if (item)
    {
        if (sender.isSelected) {
            [arSelectedJob addObject:item.jobID];
        } else {
            [arSelectedJob removeObject:item.jobID];
        }
    }
}
-(void)btEmployment_Touched:(UIButton *)sender
{
    
    [sender setSelected: !sender.isSelected];
    
    JobItem *item = nil;
    for (NSArray *subItems in arGroupsEmployment) {
        for (JobItem *obj in subItems) {
            if (obj.jobID.intValue == sender.tag) {
                item = obj;
                break;
            }
        }
        if (item) {
            break;
        }
    }
    if (item)
    {
        if (sender.isSelected) {
            [arSelectedEmployment addObject:item.jobID];
        } else {
            [arSelectedEmployment removeObject:item.jobID];
        }
    }
}
-(void)btSex_Touched:(UIButton *)sender
{
    if (sender.isSelected == NO) {
        if (arSelectedSex.count == 1) {
            ALERT(@"", localizedString(@"You reached limit number selection"));
            return;
        }
    }
    [sender setSelected: !sender.isSelected];
    
    JobItem *item = nil;
    for (NSArray *subItems in arGroupsSex) {
        for (JobItem *obj in subItems) {
            if (obj.jobID.intValue == sender.tag) {
                item = obj;
                break;
            }
        }
        if (item) {
            break;
        }
    }
    if (item)
    {
        if (sender.isSelected) {
            [arSelectedSex addObject:item.jobID];
        } else {
            [arSelectedSex removeObject:item.jobID];
        }
    }
}

-(IBAction)btAgeTouched:(id)sender
{
    [_menuDrop showSADropDownMenuWithAnimation:kSAMenuDropAnimationDirectionBottom];
    
    
    
    [_menuDrop menuItemSelectedBlock:^(SAMenuDropDown *menu, NSInteger index) {
        
        NSLog(@"Block: Item = %i", index);
    }];
}
- (void)saDropMenu:(SAMenuDropDown *)menuSender didClickedAtIndex:(NSInteger)buttonIndex
{
    
   
}

@end

@implementation CityItem
+ (instancetype)initWithCityName:(NSString*)name cityID:(NSString*)cityID
{
    CityItem *obj = [[CityItem alloc] init];
    if (obj) {
        obj.cityName = name;
        obj.cityID = cityID;
    }
    return obj;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.cityID forKey:@"cityID"];
    [aCoder encodeBool:self.selected forKey:@"selected"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
    self.cityID = [aDecoder decodeObjectForKey:@"cityID"];
    self.selected = [aDecoder decodeBoolForKey:@"selected"];
    return self;
}

@end



@implementation JobItem
+ (instancetype)initWithJobName:(NSString*)name jobID:(NSString*)jobID
{
    JobItem *obj = [[JobItem alloc] init];
    if (obj) {
        obj.jobName = name;
        obj.jobID = jobID;
    }
    return obj;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.jobName forKey:@"jobName"];
    [aCoder encodeObject:self.jobID forKey:@"jobID"];
    [aCoder encodeBool:self.selected forKey:@"selected"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.jobName = [aDecoder decodeObjectForKey:@"jobName"];
    self.jobID = [aDecoder decodeObjectForKey:@"jobID"];
    self.selected = [aDecoder decodeBoolForKey:@"selected"];
    return self;
}

@end


@implementation AgeItem
+ (instancetype)initWithAgeName:(NSString*)name ageID:(NSString*)ageID
{
    AgeItem *obj = [[AgeItem alloc] init];
    if (obj) {
        obj.ageName = name;
        obj.ageID = ageID;
    }
    return obj;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ageName forKey:@"ageName"];
    [aCoder encodeObject:self.ageID forKey:@"ageID"];
    [aCoder encodeBool:self.selected forKey:@"selected"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.ageName = [aDecoder decodeObjectForKey:@"ageName"];
    self.ageID = [aDecoder decodeObjectForKey:@"ageID"];
    self.selected = [aDecoder decodeBoolForKey:@"selected"];
    return self;
}

@end
