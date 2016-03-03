
#import "UIColor+Extensions.h"
#import "CMAPI.h"
#import "CMTool.h"
#import "SVProgressHUD.h"
#import "CMDefault.h"
#import "CMData.h"
#import "UIImageView+WebCache.h"
#import "UIDefaultImage+Puyun.h"

#ifdef DEBUG
#define PYLog(...) NSLog(__VA_ARGS__)
#else
#define PYLog(...)
#endif

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES :NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? NO : YES)
#define StatusBarHeight (IOS7==YES ? 0 : 20)
#define BackHeight      (IOS7==YES ? 0 : 15)

#define fNavBarHeigth (IOS7==YES ? 64 : 44)

#define fDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define fDeviceHeight ([UIScreen mainScreen].bounds.size.height-StatusBarHeight)

/** 宽度比例*/
#define rateW fDeviceWidth / 320.0f
/** 高度比例*/
#define rateH fDeviceHeight / 568.0f
/** 通知*/
#define PYNotificationCenter [NSNotificationCenter defaultCenter]

/** 颜色*/
#define PYColor(a) [UIColor colorWithHexString:(a)]

/** 字体*/
#define PYSysFont(a) [UIFont systemFontOfSize:(a)]
#define PYBoldSysFont(a) [UIFont boldSystemFontOfSize:(a)]
#define PYFontWithName(a,b)  [UIFont fontWithName:(a) size:(b)]

/** view背景色*/
#define viewBackgroundColor [UIColor colorWithHexString:@"bababa"]
/** 分割线颜色*/
#define dividingLineColor [UIColor colorWithHexString:@"cccccc"]

#define PYSpaceX 15 *rateW
