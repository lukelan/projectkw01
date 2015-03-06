

#define AC_RGB(r, g, b)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define AC_RGBA(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//static CGFloat const kAdCropsItemWidth =            300.f;   // 広告アイテムの幅   デバイスサイズ一杯に合わせる為不要
//static CGFloat const kAdCropsItemmPadding =          10.f;   // 広告アイテムの間隔
static NSUInteger const kAdCropsItemCount =           5;    // 広告アイテム表示件数
static CGFloat const kAdCropsItemHeight =             85.f;   // 広告アイテムの高さ

static CGFloat const kIndicatorViewSize =             10.0f;   // インジケータのサイズ（縦横同）
static CGFloat const kIndicatorAreaHeight =           25.0f;   // インジケータエリアの高さ
static CGFloat const kCloseButtonAreaHeight =         15.0f;   // 閉じるボタンエリアの高さ
static CGFloat const kIndicatorBottomPadding =        10.0f;   // インジケータの下padding
static CGFloat const kGumTopPadding =                 90.0f;   // GumViewの上padding
static CGFloat const kAdcropsViewHeight =             85.0f;   // adcrops広告エリアの縦幅

static CGFloat const kRefreshControlHeightNormal =    65.0f;   // リフレッシュコントロール高さ（adcropsからのデータ未取得時）
static CGFloat const kRefreshControlHeightFull   =   kAdCropsItemHeight + kCloseButtonAreaHeight + kIndicatorAreaHeight; // リフレッシュコントロール高さ（adcropsからのデータ取得時）




