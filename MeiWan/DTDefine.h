//
//  DTDefine.h
//  DTUtils
//  常用宏定义
//  Created by zhaojh on 16/7/14.
//  Copyright (c) 2014年 zjh. All rights reserved.
//

/*手机物理宽高*/
#define dtScreenWidth            ([UIScreen mainScreen].bounds.size.width)
#define dtScreenHeight           ([UIScreen mainScreen].bounds.size.height)
#define dtScreenHeightScale      (dtScreenHeight / 480.0)

/*应用程序宽高*/
#define dtAppWidth               ([[UIScreen mainScreen] applicationFrame].size.width)
#define dtAppHeight              ([[UIScreen mainScreen] applicationFrame].size.height)
#define dtAppHeightScale         (dtAppHeight / 480.0)

//系统版本
#define dtSystemVersion          [UIDevice currentDevice].systemVersion//String类型
#define dtIOSVersion             [UIDevice currentDevice].systemVersion.doubleValue
#define dtIOS7UP                 (dtIOSVersion >= 7.0)
#define dtIOS8UP                 (dtIOSVersion >= 8.0)

/*navbar默认高度和tabbar默认高度*/
#define dtNavBarDefaultHeight    64
#define dtTabBarDefaultHeight    49

/*设备相关信息*/
#define dtIsScreenSize(aSize)    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(aSize, [[UIScreen mainScreen] currentMode].size) : NO)
#define dtIsPhone35              dtIsScreenSize(CGSizeMake(320, 480))// 3.5英寸非视网膜屏
#define dtIsPhoneRetina35        dtIsScreenSize(CGSizeMake(640, 960))  //4S
#define dtIsPhoneRetina4         dtIsScreenSize(CGSizeMake(640, 1136)) //5,5C,5S
#define dtIsPhoneRetina47        dtIsScreenSize(CGSizeMake(750, 1334)) //6
#define dtIsPhoneRetina55        dtIsScreenSize(CGSizeMake(1242, 2208))//6Plus @3x
#define dtIsPad                  dtIsScreenSize(CGSizeMake(768, 1024))
#define dtIsPadRetina            dtIsScreenSize(CGSizeMake(1536, 2048))

#define dtIsDevicePhone          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define dtIsDevicePad            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

/*键盘固定高度*/
#define dtKeyboardHeight         (dtIsDevicePad ? 264 : 216)

/*判断对象是否属于某个类或者是某个类的成员*/
#define dtIsKindOf(obj, Class)   [obj isKindOfClass:[Class class]]
#define dtIsMemberOf(obj, Class) [obj isMemberOfClass:[Class class]]

/*颜色转换*/
#define dtRGBColor(r, g, b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define dtRGBAColor(r, g, b, a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
/*rgb颜色转换（16进制->10进制）*/
#define dtRGBToColor(rgb)        [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]
#define dtClearColor             [UIColor clearColor] //透明色

/* 字体 */
#define dtSystemFont(size)       [UIFont systemFontOfSize:size]
#define dtBoldSystemFont(size)   [UIFont boldSystemFontOfSize:size]
#define dtFont(name, size)       [UIFont fontWithName:name size:size]

/*GCD常用方式*/
#define dtGCDBackThread(block)    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  block)
#define dtGCDMainThread(block)    dispatch_async(dispatch_get_main_queue(), block)

/*角度弧度相互转换*/
#define dtDegreesToRadian(x)      (M_PI * (x) / 180.0)
#define dtRadianToDegrees(radian) (radian * 180.0) / (M_PI)

/*id对象与NSData之间转换-->coding协议本地存储*/
#define dtObjectToData(object)    [NSKeyedArchiver archivedDataWithRootObject:object]
#define dtDataToObject(data)      [NSKeyedUnarchiver unarchiveObjectWithData:data]

/*读取xib文件的类*/
#define dtViewByNib(Class, owner) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] lastObject]

/*读取故事板*/
#define dtStoryboard             [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define dtViewController(identy) [dtStoryboard instantiateViewControllerWithIdentifier:identy]

/*文件路径*/
#define dtPathHome                NSHomeDirectory()
#define dtPathTemp                NSTemporaryDirectory()
#define dtPathBundle(name, ext)   [[NSBundle mainBundle] pathForResource:name ofType:ext]
#define dtPathDocument            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define dtPathDocumentAppend(f)   [dtPathDocument stringByAppendingPathComponent:f]

/*加载图片*/
#define dtImageByName(name)       [UIImage imageNamed:name]
#define dtImageByPath(path)       [UIImage imageWithContentsOfFile:path]
#define dtImageByRPath(name, ext) [UIImage imageWithContentsOfFile:dtPathBundle(name, ext)]

/*常用方法简写*/
#define dtAppDelegate             (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define dtRootNavVCtl             (UINavigationController*)[[dtAppDelegate window] rootViewController]
#define dtWindow                  [[[UIApplication sharedApplication] windows] lastObject]
#define dtKeyWindow               [[UIApplication sharedApplication] keyWindow]
#define dtUserDefaults            [NSUserDefaults standardUserDefaults]
#define dtNotificationCenter      [NSNotificationCenter defaultCenter]

#define dtInitObject(obj, Class)  Class *obj = [[Class alloc] init]
#define dtInit(contents)          \
- (instancetype)init {            \
    if (self = [super init]) {    \
        contents                  \
    }                             \
    return self;                  \
}

/*本地化方法简写*/
#define dtLStr(key)               NSLocalizedString(key, nil)
#define dtEmptyString             @""

//当前设置的语言
#define dtCurrentLanguage          [[NSLocale preferredLanguages] objectAtIndex:0]
//当前APP的版本
#define dtAPPVersion               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//当前APP的名称
#define dtAPPName                  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//属性
#define dtAPPIdentifier            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
//以系统版本来判断是否是第一次启动，包括升级后是否为第一次启动。
#define dtFirstLaunch              dtAPPVersion
//判断是否为第一次运行，升级后启动不算是第一次运行
#define dtFirstRun                 @"FirstRun"

// block self
#define dtWeakSelf                 typeof(self) __weak weakSelf = self;
#define dtStrongSelf               typeof(weakSelf) __strong strongSelf = weakSelf;

/*调试相关*/

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
#define dtSafeRelease(object) { if(object) { [object release]; object = nil; } }
#endif

/*调试模式下输入NSLog，发布后不再输入*/
#ifndef __OPTIMIZE__
#define NSLog(format, ...) do {                                                                             \
                                fprintf(stderr, "<%s : %d> %s\n",                                           \
                                [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
                                __LINE__, __func__);                                                        \
                                (NSLog)((format), ##__VA_ARGS__);                                           \
                                fprintf(stderr, "-------\n");                                               \
                            } while (0)

#define NSLogPoint(p) NSLog(@"%.2f, %.2f", p.x, p.y)
#define NSLogSize(p)  NSLog(@"%.2f, %.2f", p.width, p.height)
#define NSLogRect(p)  NSLog(@"%.2f, %.2f, %.2f, %.2f", p.origin.x, p.origin.y, p.size.width, p.size.height)

#else
#define NSLog(...) {}

#define NSLogPoint(p)
#define NSLogSize(p)
#define NSLogRect(p)

#endif

/*计算两点之间的距离*/
#define dtDistanceFloat(PointA, PointB) sqrtf((PointA.x - PointB.x) * (PointA.x - PointB.x) + (PointA.y - PointB.y) * (PointA.y - PointB.y))

/*区分模拟机和真机*/
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


/******断言******/
#define dtAssert2(condition, desc, returnValue) \
if ((condition) == NO) { \
NSString *file = [NSString stringWithUTF8String:__FILE__]; \
NSLog(@"\n警告文件：%@\n警告行数：第%d行\n警告方法：%s\n警告描述：%@", file, __LINE__,  __FUNCTION__, desc); \
return returnValue; \
}

#define dtAssert(condition, desc) dtAssert2(condition, desc, )

#define dtAssertParamNotNil2(param, returnValue) \
dtAssert2(param, [[NSString stringWithFormat:@#param] stringByAppendingString:@"参数不能为nil"], returnValue)

#define dtAssertParamNotNil(param) dtAssertParamNotNil2(param, )


/********************************/



// 命名声明, 用于当前类的唯一名称, 通知的时候用此来命名
#define AS_Static_Property( __name ) \
- (NSString *)__name; \
+ (NSString *)__name;

// 命名实现
#define DEF_Static_Property( __name ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
return [NSString stringWithFormat:@"%s", #__name]; \
}

#define DEF_Static_Property2( __name, __prefix ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
return [NSString stringWithFormat:@"%@.%s", __prefix, #__name]; \
}

#define DEF_Static_Property3( __name, __prefix, __prefix2 ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
return [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name]; \
}





