//
//  Define.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#define _AFNETWORKING_PIN_SSL_CERTIFICATES_
#define TIMER_REQUEST_TIMEOUT                                                           60.0

#define DEFAULT_PAGE_SIZE                       20

#define DB_VERSION                              @"1.6"

typedef enum
{
    ENUM_API_REQUEST_TYPE_USER_ACCESS,
    ENUM_API_REQUEST_TYPE_GET_LIST_ARTICLE,
    ENUM_API_REQUEST_TYPE_GET_NOTIFICATION_COUNT,
    ENUM_API_REQUEST_TYPE_GET_NOTIFICATION_LIST,
    ENUM_API_REQUEST_TYPE_READ_NOTIFICATION,
    ENUM_API_REQUEST_TYPE_SHARE_INAPP,
    ENUM_API_REQUEST_TYPE_VIEW_ARTICLE,
    ENUM_API_REQUEST_TYPE_GET_LIST_COMPANY,
    ENUM_API_REQUEST_TYPE_GET_ARTICLE_COMMENTS,
    ENUM_API_REQUEST_TYPE_GET_ARTICLE_DETAIL,
    ENUM_API_REQUEST_TYPE_MAKE_LIKE_DISKLIKE_COMMENT,
    ENUM_API_REQUEST_TYPE_MAKE_REPORT_COMMENT,
    ENUM_API_REQUEST_TYPE_POST_ARTICLE_COMMENT,
    ENUM_API_REQUEST_TYPE_MAKE_BOOKMARK,
    ENUM_API_REQUEST_TYPE_MAKE_UN_BOOKMARK,
    ENUM_API_REQUEST_TYPE_GET_COMPANY_STOCK,
    ENUM_API_REQUEST_TYPE_SEARCH_COMPANY_BY_NAME,
    ENUM_API_REQUEST_TYPE_GET_COMPANY_INFO,
    ENUM_API_REQUEST_TYPE_GET_COMPANY_CATEGORIES,
    ENUM_API_REQUEST_TYPE_GET_COMPANY_BY_CATEGORY,
    ENUM_API_REQUEST_TYPE_GET_RELATIVE_NEWS,
    ENUM_API_REQUEST_TYPE_GET_RECRUIT_RELATIVE_NEWS,
    ENUM_API_REQUEST_TYPE_GET_TOPICS,
    ENUM_API_REQUEST_TYPE_GET_TOP_TITLE,
    ENUM_API_REQUEST_TYPE_GET_ARTICLES_BY_IDS,
    ENUM_API_REQUEST_TYPE_GET_CATEGORY,
    ENUM_API_REQUEST_TYPE_GET_TOP_THREE_NEWS,
    ENUM_API_REQUEST_TYPE_GET_STOCK_YAHOO,
}ENUM_API_REQUEST_TYPE;


typedef enum
{
    ENUM_CAREER_CHANGE_COMPANY_INFO,
    ENUM_CAREER_CHANGE_NEW_TOPIC,
    ENUM_CAREER_CHANGE_ECONOMY,
    ENUM_CAREER_CHANGE_SOCIAL,
    ENUM_CAREER_CHANGE_IT_CREATING,
    ENUM_CAREER_CHANGE_ENTERTAINMENT,
    ENUM_CAREER_CHANGE_MEDICAL_LINE,
    ENUM_CAREER_CHANGE_SERVICE,
    ENUM_CAREER_CHANGE_HUMAN_RESOURCES,

    
    ENUM_CAREER_CHANGE_FINANCIAL,
    ENUM_CAREER_CHANGE_JOB,
    
    ENUM_CAREER_CHANGE_ADD,
    ENUM_CAREER_CHANGE_BOOK_MARK,
    ENUM_CAREER_CHANGE_SETTINGS,
    ENUM_CAREER_CHANGE_NOTIFICATION
}ENUM_CAREER_CHANGE_INDEX;

typedef enum
{
    ENUM_NOTIFICATION_TYPE_COMMENT = 1,
    ENUM_NOTIFICATION_TYPE_LIKE,
    ENUM_NOTIFICATION_TYPE_DISLIKE,
    ENUM_NOTIFICATION_TYPE_WAS_BOOKMARK,
}ENUM_NOTIFICATION_TYPE;

typedef enum
{
    ENUM_ARTICLE_TYPE_NORMAL = 1,
    ENUM_ARTICLE_TYPE_NOTIFICATION,
    ENUM_ARTICLE_TYPE_BOOKMARK,
    ENUM_ARTICLE_TYPE_RECRUIT,
    ENUM_ARTICLE_TYPE_ADVS_ADS,
}ENUM_ARTICLE_TYPE;


typedef enum
{
    ENUM_ARTICLE_CELL_TYPE_NORMAL = 1,
    ENUM_ARTICLE_CELL_TYPE_LARGE
}ENUM_ARTICLE_CELL_TYPE;

#define PUSH_NOTIFICATION_FACEBOOK                          @"PUSH_NOTIFICATION_FACEBOOK"
#define PUSH_NOTIFICATION_NOTIFICATION_COUNT_CHANGED        @"PUSH_NOTIFICATION_NOTIFICATION_COUNT_CHANGED"
#define PUSH_NOTIFICATION_COMPANY_BOOKMARK_CHANGE        @"PUSH_NOTIFICATION_COMPANY_BOOKMARK_CHANGE"

#define API_REQUEST_APP_ID                                              @"giganews"
#define API_REQUEST_APP_TYPE                                            @"1"
#define API_REQUEST_APP_SECRET_KEY                                      @"UCzCRQAAAIBVDBPwLuaV8o9mu"

#define API_ROOT                                            @"http://giga-news.jp/api"
//#define API_ROOT                                            @"http://girlspicks.co/api"

#define STRING_API_REQUEST_USER_ACCESS                      [NSString stringWithFormat:@"%@/user_access", API_ROOT]
#define STRING_API_REQUEST_GET_LIST_ARTICLE                 [NSString stringWithFormat:@"%@/get_article_by_cat", API_ROOT]
#define STRING_API_REQUEST_GET_NOTIFICATION_COUNT           [NSString stringWithFormat:@"%@/get_notif_count", API_ROOT]
#define STRING_API_REQUEST_GET_NOTIFICATION_LIST            [NSString stringWithFormat:@"%@/get_notif_list", API_ROOT]
#define STRING_API_REQUEST_READ_NOTIFICATION                [NSString stringWithFormat:@"%@/set_read_notif", API_ROOT]
#define STRING_API_REQUEST_SHARE_INAPP                      [NSString stringWithFormat:@"%@/set_sharet_inapp", API_ROOT]
#define STRING_API_REQUEST_VIEW_ARTICLE                     [NSString stringWithFormat:@"%@/set_article_view", API_ROOT]
#define STRING_API_REQUEST_GET_LIST_COMPANY                 [NSString stringWithFormat:@"%@/get_company_list", API_ROOT]
#define STRING_API_REQUEST_GET_ARTICLE_COMMENTS             [NSString stringWithFormat:@"%@/get_article_comment", API_ROOT]
#define STRING_API_REQUEST_GET_ARTICLE_DETAIL               [NSString stringWithFormat:@"%@/get_article_by_id", API_ROOT]
#define STRING_API_REQUEST_POST_ARTICLE_COMMENT             [NSString stringWithFormat:@"%@/set_comment", API_ROOT]
#define STRING_API_REQUEST_MAKE_LIKE_DISLIKE_COMMENT        [NSString stringWithFormat:@"%@/set_like", API_ROOT]
#define STRING_API_REQUEST_MAKE_REPORT_COMMENT              [NSString stringWithFormat:@"%@/set_report", API_ROOT]
#define STRING_API_REQUEST_MAKE_BOOKMARK                    [NSString stringWithFormat:@"%@/set_bookmark", API_ROOT]
#define STRING_API_REQUEST_MAKE_UN_BOOKMARK                 [NSString stringWithFormat:@"%@/remove_bookmark", API_ROOT]
#define STRING_API_REQUEST_GET_COMPANY_STOCK                [NSString stringWithFormat:@"%@/get_company_stock", API_ROOT]
#define STRING_API_REQUEST_SEARCH_COMPANY_BY_NAME           [NSString stringWithFormat:@"%@/search_company", API_ROOT]
#define STRING_API_REQUEST_GET_COMPANY_INFO                 [NSString stringWithFormat:@"%@/get_company_info", API_ROOT]
#define STRING_API_REQUEST_GET_COMPANY_CATEGORIES                 [NSString stringWithFormat:@"%@/get_company_categories", API_ROOT]
#define STRING_API_REQUEST_GET_COMPANY_BY_CATEGORY                 [NSString stringWithFormat:@"%@/get_company_by_category", API_ROOT]
#define STRING_API_REQUEST_GET_RELATIVE_NEWS                 [NSString stringWithFormat:@"%@/get_article_by_company_name", API_ROOT]
#define STRING_API_REQUEST_GET_RECRUIT_RELATIVE_NEWS                 [NSString stringWithFormat:@"%@/get_related_articles", API_ROOT]
#define STRING_API_REQUEST_GET_TOPICS                 [NSString stringWithFormat:@"%@/get_topics", API_ROOT]
#define STRING_API_REQUEST_GET_TOP_TITLE                 [NSString stringWithFormat:@"%@/get_top_title", API_ROOT]
#define STRING_API_REQUEST_GET_ARTICLES_BY_IDS                 [NSString stringWithFormat:@"%@/get_article_by_ids", API_ROOT]
#define STRING_API_REQUEST_GET_CATEGORY                 [NSString stringWithFormat:@"%@/get_category", API_ROOT]
#define STRING_API_REQUEST_GET_TOP_THREE_NEWS                 [NSString stringWithFormat:@"%@/get_top_three_news", API_ROOT]
#define STRING_API_REQUEST_GET_STOCK_YAHOO                 [NSString stringWithFormat:@"%@/get_stock_yahoo", API_ROOT]

//FONT

//#define FONT_BOLD                   @"HelveticaNeue-Bold"
//#define FONT_NORMAL                 @"HelveticaNeue"
#define FONT_BOLD                   @"HiraKakuProN-W6"
#define FONT_NORMAL                 @"HiraKakuProN-W3"

//#define FONT_BOLD                   @"Zapfino"
//#define FONT_NORMAL                 @"Zapfino"

#define TWITTER_CONSUMERKEY         @"FzNRpTaQ0pxMp0lQtI4D4W6Pv" //@"Xg3ACDprWAH8loEPjMzRg"
#define TWITTER_SECRET              @"XwwH5H30XtKIcqx8Zctb3cxly65wJF7brMhgwqCPxbioBUcAa3" //@"9LwYDxw1iTc6D9ebHdrYCZrJP4lJhQv5uf4ueiPHvJ0"

#define LPSDK_API_KEY @"uxa740ltbsbrmn7pamyxsxhvas33q43293pthybx320ltxmd"//@"ewjb22bo8xqghre2wkq9333rb50of30uswrrcmzy9hjl1c6w"//@"evoieyije3my74mcwozq2y3p9jnn42a85jc7npjps4fzj85o"//@"uxa740ltbsbrmn7pamyxsxhvas33q43293pthybx320ltxmd"
#define LPSDK_SECRET_KEY @"4o0k0kpgxejtbc9a35wxglxsumagbpzl"//@"d0be4w6ur300ar779y5mgae9299v4htd"//@"d9wd0p6txhk5vxhpzzooeairbbzdn44i"//@"4o0k0kpgxejtbc9a35wxglxsumagbpzl"


// segue
#define SEGUE_TAB_TO_POLICY_CONTROLLER @"segueTabToPolicyController"

#define REMOVE_COMPANY_NAME_STRING_1 @"(株)"
#define REMOVE_COMPANY_NAME_STRING_2 @"株式会社"

#define APP_URL_SCHEMA_OPEN_ARTICLE @"://article"

#define STRING_NOTIFICATION_APP_ACTIVE @"STRING_NOTIFICATION_APP_ACTIVE"

