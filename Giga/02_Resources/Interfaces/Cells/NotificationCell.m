//
//  NotificationCell.m
//  Giga
//
//  Created by Hoang Ho on 12/2/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "NotificationCell.h"
#import "NotificationModel.h"
#import "NSDate+Utilities.h"

@implementation NotificationCell

+ (CGFloat)getCellHeight
{
    return 80;
}

- (void)applyStyleIfNeed
{
    if (isAppliedStyle) return;
    isAppliedStyle = YES;
    
    self.lbTime.font = BOLD_FONT_WITH_SIZE(14);
    self.lbTime.font = NORMAL_FONT_WITH_SIZE(12);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setObject:(id)obj
{
    [super setObject:obj];
    NotificationModel *ntf = obj;
    
    NSMutableString *str = [NSMutableString string];
    switch (ntf.notifType.intValue) {
        case ENUM_NOTIFICATION_TYPE_COMMENT:
            [str appendString:@"あなたのコメントに返信がありました。"];
            break;
        case ENUM_NOTIFICATION_TYPE_LIKE:
            [str appendString:@"あなたのコメントがいいねされました。"];
            break;
        case ENUM_NOTIFICATION_TYPE_DISLIKE:
            [str appendString:@"あなたのコメントがよくないねされました。"];
            break;
        case ENUM_NOTIFICATION_TYPE_WAS_BOOKMARK:
            [str appendString:@"あなたのブックマークした記事にコメントがありました。"];
            break;
    }
    
    if (str.length > 0) {
        if (ntf.notifTitle) [str appendFormat:@" %@",ntf.notifTitle];
        self.lbTitle.text = str;
        self.lbTime.text = [self getTimeAgoForDate:ntf.createdDate];
    }
    
    if (ntf.isRead.boolValue) {
        self.lbTitle.font = NORMAL_FONT_WITH_SIZE(14);
        self.lbTitle.textColor = [UIColor lightGrayColor];
    }else{
        self.lbTitle.font = BOLD_FONT_WITH_SIZE(14);
        self.lbTitle.textColor = [UIColor blackColor];
    }
}

- (NSString*)getTimeAgoForDate:(NSDate*)createDate
{
    int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate *serverDate = [NSDate date];
    
    NSDateComponents *dateComponents = [calendar components:flags
                                                   fromDate:createDate
                                                     toDate:serverDate
                                                    options:0];
    
    NSString *result = @"";
    if ([createDate isToday]) {
        if (dateComponents.hour > 0)
        {
            result = [NSString stringWithFormat:@"%d時間前", dateComponents.hour];
        }else{
            result = [NSString stringWithFormat:@"1時間前"];
        }
    }else if([createDate isYesterday]){
        result = localizedString(@"昨日");
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM dd";
        NSArray *temp = [[formatter stringFromDate:createDate] componentsSeparatedByString:@" "];
        result = [NSString stringWithFormat:@"%@月%@日", temp[0], temp[1]];
    }

    return result;
}

@end
