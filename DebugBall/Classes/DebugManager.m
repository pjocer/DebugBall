//
//  DebugManager.m
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import "DebugManager.h"
#import "DebugView.h"
#import "Utils.h"
#import "DBActionMenuController.h"
#import <QMUIKit/QMUIKit.h>
#import "DBUser.h"

NSNotificationName const kAPIHostDidChangedNotification = @"kAPIHostDidChangedNotification";
NSNotificationName const kH5APIHostDidChangedNotification = @"kH5APIHostDidChangedNotification";

NSString * const kAPIHostDidChangedNewValue = @"kAPIHostDidChangedNewValue";
NSString * const kAPIHostDidChangedOldValue = @"kAPIHostDidChangedOldValue";

static NSString * kDomainListKey = @"kDomainListKey";
static NSString * kH5DomainListKey = @"kH5DomainListKey";
static NSString *kCurrentDomainKey = @"kCurrentDomainKey";
static NSString *kCurrentH5DomainKey = @"kCurrentH5DomainKey";


@interface DebugManager ()
@property (class, nonatomic, strong) DBActionMenuController *__menu;
@property (class, nonatomic, strong) UINavigationController *__nav;
@property (class, nonatomic, strong) NSMutableDictionary *__cachedClasses;
@property (class, nonatomic, copy)dispatch_queue_t __dataRegistryQueue;
@end

@implementation DebugManager

static BOOL __show = NO;
static NSMutableDictionary<NSNotificationName,NSDictionary<NSString *,NSString *> *> * __data = nil;

+ (void)uninstall {
    __show = NO;
}

+ (void)presentDebugActionMenuController {
    if (!__show) {
        [[QMUIHelper visibleViewController] presentViewController:self.__nav animated:YES completion:^{
            __show = YES;
        }];
    } else {
        [self dismissDebugActionMenuController];
    }
}

+ (void)dismissDebugActionMenuController {
    if (__data != nil) {
        for (NSNotificationName name in __data.allKeys) {
            [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:__data[name]];
        }
        __data = nil;
    }
    [self.__nav dismissViewControllerAnimated:YES completion:^{
        [self uninstall];
    }];
}

+ (void)handleCloseButtonEvent:(UIBarButtonItem *)item {
    [self dismissDebugActionMenuController];
}

+ (UINavigationController *)__nav {
    static dispatch_once_t onceToken;
    static UINavigationController *nav = nil;
    dispatch_once(&onceToken, ^{
        nav = [[UINavigationController alloc] initWithRootViewController:self.__menu];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationBar *bar = nav.navigationBar;
        bar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        UIImage *backgroundImage = [DebugBallImageWithNamed(@"navigationbar_background") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
        [bar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        bar.shadowImage = [UIImage new];
        bar.tintColor = UIColorWhite;
    });
    return nav;
}

+ (DBActionMenuController *)__menu {
    static dispatch_once_t onceToken;
    static DBActionMenuController *menu = nil;
    dispatch_once(&onceToken, ^{
        menu = [[DBActionMenuController alloc] initWithStyle:UITableViewStyleGrouped];
        menu.title = @"Project Configuration";
        menu.hidesBottomBarWhenPushed = YES;
        menu.navigationItem.leftBarButtonItem = [QMUINavigationButton closeBarButtonItemWithTarget:self action:@selector(handleCloseButtonEvent:)];
    });
    return menu;
}

+ (NSMutableDictionary *)__cachedClasses {
    static dispatch_once_t onceToken;
    static NSMutableDictionary *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [NSMutableDictionary dictionary];
    });
    return instance;
}

+ (dispatch_queue_t)__dataRegistryQueue {
    static dispatch_once_t onceToken;
    static dispatch_queue_t t = nil;
    dispatch_once(&onceToken, ^{
        t = dispatch_queue_create("dataRegistryQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return t;
}

+ (BOOL)addNewDomain:(Domain *)domain domainType:(APIDomainType)type{
    NSArray *domainList = [self domainListWithType:type];
    if (domainList.count==0) {
        return UserDefaultsSetObjectForKey(@[domain], type==APIDomainTypeDefault?kDomainListKey:kH5DomainListKey);
    } else {
        NSMutableArray *newList = [domainList mutableCopy];
        [newList addObject:domain];
        return UserDefaultsSetObjectForKey(newList, type==APIDomainTypeDefault?kDomainListKey:kH5DomainListKey);
    }
}

+ (NSArray <NSString *> *)domainListWithType:(APIDomainType)type {
    NSArray *domainList = nil;
    if (type == APIDomainTypeDefault) {
        domainList = UserDefaultsObjectForKey(kDomainListKey)?:@[];
    }
    if (type == APIDomainTypeH5) {
        domainList = UserDefaultsObjectForKey(kH5DomainListKey)?:@[];
    }
    return domainList;
}

+ (Domain *)currentDomainWithType:(APIDomainType)type {
    return UserDefaultsObjectForKey(type==APIDomainTypeDefault?kCurrentDomainKey:kCurrentH5DomainKey)?:@"Not Set";
}

+ (BOOL)setCurrentDomain:(Domain *)domain type:(APIDomainType)type {
    return UserDefaultsSetObjectForKey(domain, type==APIDomainTypeDefault?kCurrentDomainKey:kCurrentH5DomainKey);
}

+ (void)setNeedpushNoticationWithData:(NSDictionary<NSNotificationName,NSDictionary<NSString *,NSString *> *> *)data {
    if (__data) {
        [__data setValue:data[data.allKeys.firstObject] forKey:data.allKeys.firstObject];
    } else {
        __data = [data mutableCopy];
    }
}

+ (BOOL)isDisplayBorderEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kDisplayBorderEnabled];
}

+ (BOOL)saveDisplayBorderEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kDisplayBorderEnabled];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

#define DEVICE_HARDWARE_SOURCE_KEY @"DEVICE_HARDWARE_SOURCE_KEY"

static FetchCompeletion __comeletion = nil;

@implementation DebugManager (DataRegistry)

+ (void)registerPushToken:(NSString *)token {
    if (token) {
        dispatch_barrier_async(self.__dataRegistryQueue, ^{
            NSMutableArray *source = [UserDefaultsObjectForKey(DEVICE_HARDWARE_SOURCE_KEY)?:@[] mutableCopy];
            NSMutableDictionary *temp = [[source firstObject] mutableCopy];
            temp[@"Push Token"] = token;
            [source replaceObjectAtIndex:0 withObject:temp];
            UserDefaultsSetObjectForKey(source, DEVICE_HARDWARE_SOURCE_KEY);
        });
    }
}

+ (void)registerUserDataWithUserID:(NSString *)userID userName:(NSString *)userName userToken:(NSString *)userToken {
    dispatch_barrier_async(self.__dataRegistryQueue, ^{
        NSMutableArray *source = [UserDefaultsObjectForKey(DEVICE_HARDWARE_SOURCE_KEY)?:@[] mutableCopy];
        NSMutableDictionary *user_info = [NSMutableDictionary dictionary];
        user_info[@"User Token"] = userToken?:@"Not Set";
        user_info[@"User Name"] = userName?:@"Not Set";
        user_info[@"User ID"] = userID?:@"Not Set";
        [source insertObject:user_info atIndex:0];
        UserDefaultsSetObjectForKey(source, DEVICE_HARDWARE_SOURCE_KEY);
    });
}

+ (void)fetchDeviceHardwareInfo:(FetchCompeletion)compeletion {
    __comeletion = compeletion;
    if (__comeletion)__comeletion(UserDefaultsObjectForKey(DEVICE_HARDWARE_SOURCE_KEY));
}

+ (void)asyncFetchDeviceHardwareInfo {
    dispatch_barrier_async(self.__dataRegistryQueue, ^{
        NSMutableArray *dataSource = [UserDefaultsObjectForKey(DEVICE_HARDWARE_SOURCE_KEY)?:@[] mutableCopy];
        NSMutableDictionary *identiders = [NSMutableDictionary dictionary];
        identiders[@"IDFA"] = [[UIDevice currentDevice] getIDFA]?:@"Unable To Get";
        identiders[@"IDFV"] = [[UIDevice currentDevice] getIDFV]?:@"Unable To Get";
        [dataSource addObject:identiders];
        NSMutableDictionary *network = [NSMutableDictionary dictionary];
        network[@"Network Type"] = [[UIDevice currentDevice] getNetworkType]?:@"Unable To Get";
        network[@"Wifi Mac Address"] = [[UIDevice currentDevice] getWifiMacAddress]?:@"Unable To Get";
        network[@"IP Address"] = [[UIDevice currentDevice] getIPAddress];
        network[@"Mac Address"] = [[UIDevice currentDevice] getMacAddress]?:@"Unable To Get";
        [dataSource addObject:network];
        NSMutableDictionary *memory_usage = [NSMutableDictionary dictionary];
        memory_usage[@"Memory Used"] = [NSString stringWithFormat:@"%f",[[UIDevice currentDevice] getUsedMemory]];
        memory_usage[@"Avalible Memory"] = [NSString stringWithFormat:@"%f",[[UIDevice currentDevice] getAvailableMemory]];
        [dataSource addObject:memory_usage];
        NSMutableDictionary *system = [NSMutableDictionary dictionary];
        system[@"Operation System"] = [[UIDevice currentDevice] systemName];
        system[@"Device Type"] = [[UIDevice currentDevice] model];
        system[@"Device Is Root"] = [[UIDevice currentDevice] deviceIsRoot];
        system[@"System Version"] = [[UIDevice currentDevice] systemVersion];
        system[@"System Area"] = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        system[@"System Timezone"] = [NSTimeZone systemTimeZone].description;
        system[@"System Language"] = [[UIDevice currentDevice] getSystemLanguage];
        [dataSource addObject:system];
        NSMutableDictionary *app_info = [NSMutableDictionary dictionary];
        app_info[@"App Version"] = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
        app_info[@"Bundle Identifier"] = [[NSBundle mainBundle] bundleIdentifier];
        [dataSource addObject:app_info];
        UserDefaultsSetObjectForKey(dataSource, DEVICE_HARDWARE_SOURCE_KEY);
    });
}

@end

@implementation DebugManager (DebugView)

+ (void)installDebugViewByDefault {
    DebugView.debugView.commitTapAction(kDebugViewTapActionDisplayActionMenu).show();
    [self asyncFetchDeviceHardwareInfo];
    WEAK_SELF
    [[NSNotificationCenter defaultCenter] addObserverForName:kDisplayBorderEnabled object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        STRONG_SELF
        [self.__cachedClasses enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            displayAllSubviewsBorder(obj, [note.object boolValue]);
        }];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        STRONG_SELF
        UserDefaultsSetObjectForKey(nil, DEVICE_HARDWARE_SOURCE_KEY);
    }];
}

+ (void)uninstallDebugView {
    dispatch_async(dispatch_get_main_queue(), ^{
        DebugView.debugView.dismiss();
        UserDefaultsSetObjectForKey(nil, DEVICE_HARDWARE_SOURCE_KEY);
    });
}

@end

NSNotificationName const kDisplayBorderEnabled = @"kDisplayBorderEnabled";

@implementation DebugManager (ActionHandler)

+ (void)registerNotification:(NSNotificationName)notification byHandler:(ActionHandler)handler {
    WEAK_SELF
    [[NSNotificationCenter defaultCenter] addObserverForName:notification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        STRONG_SELF
        if (handler) handler(note.userInfo);
    }];
}

@end



@interface UIView (DisplayBorder)

@end

@implementation UIView (DisplayBorder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReplaceMethod(self, @selector(didMoveToSuperview), @selector(swizzled_didMoveToSuperview));
    });
}

- (void)swizzled_didMoveToSuperview {
    if (![DebugManager.__cachedClasses.allKeys containsObject:NSStringFromClass(self.class)]) {
        __weak UIView *view = self;
        DebugManager.__cachedClasses[NSStringFromClass(view.class)] = view;
        displayAllSubviewsBorder(view, DebugManager.isDisplayBorderEnabled);
    }
    [self swizzled_didMoveToSuperview];
}

@end
