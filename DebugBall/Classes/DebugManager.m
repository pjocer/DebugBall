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

NSNotificationName const kAPIHostDidChangedNotification = @"kAPIHostDidChangedNotification";
NSNotificationName const kH5APIHostDidChangedNotification = @"kH5APIHostDidChangedNotification";

NSString * const kAPIHostDidChangedNewValue = @"kAPIHostDidChangedNewValue";
NSString * const kAPIHostDidChangedOldValue = @"kAPIHostDidChangedOldValue";

static NSString * kDomainListKey = @"kDomainListKey";
static NSString * kH5DomainListKey = @"kH5DomainListKey";
static NSString *kCurrentDomainKey = @"kCurrentDomainKey";
static NSString *kCurrentH5DomainKey = @"kCurrentH5DomainKey";


@interface DebugManager ()
#ifdef DEBUG
@property (class, nonatomic, strong, readonly) DBActionMenuController *__menu;
@property (class, nonatomic, strong, readonly) UINavigationController *__nav;
@property (class, nonatomic, strong, readonly) NSMutableDictionary <NSString *, NSMutableArray<__kindof UIView *> *> *__cachedRenderingViews;
@property (class, nonatomic, copy, readonly) dispatch_queue_t __dataRegistryQueue;
#endif
@property (class, nonatomic, strong, readonly) NSMutableDictionary *__cachedObservers;
@end

@implementation DebugManager

static BOOL __show = NO;

static NSMutableDictionary<NSNotificationName,NSDictionary<NSString *,NSString *> *> * __data = nil;

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
        __show = NO;
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

+ (NSMutableDictionary<NSString *,NSMutableArray<UIView *> *> *)__cachedRenderingViews {
    static dispatch_once_t onceToken;
    static NSMutableDictionary<NSString *,NSMutableArray<UIView *> *> *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [NSMutableDictionary dictionary];
    });
    return instance;
}

+ (NSMutableDictionary *)__cachedObservers {
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
        [__data addEntriesFromDictionary:data];
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
#define DEVICE_USERINFO_KEY     @"User Info"
#define DEVICE_IDENTIFIERS_KEY  @"Identifiers"
#define DEVICE_NETWORK_KEY      @"Network"
#define DEVICE_MEMORY_KEY       @"Memory Used"
#define DEVICE_SYSYEM_KEY       @"System"
#define DEVICE_APPINFO_KEY      @"App Info"

static FetchCompeletion __comeletion = nil;

@implementation DebugManager (DataRegistry)

+ (void)asyncFetchDeviceHardwareInfo {
    dispatch_barrier_async(self.__dataRegistryQueue, ^{
        NSMutableDictionary *dataSource = [UserDefaultsObjectForKey(DEVICE_HARDWARE_SOURCE_KEY)?:@{} mutableCopy];
        NSMutableDictionary *identiders = [NSMutableDictionary dictionary];
        identiders[@"IDFA"] = [[UIDevice currentDevice] getIDFA]?:@"Unable To Get";
        identiders[@"IDFV"] = [[UIDevice currentDevice] getIDFV]?:@"Unable To Get";
        dataSource[DEVICE_IDENTIFIERS_KEY] = identiders;
        NSMutableDictionary *network = [NSMutableDictionary dictionary];
        network[@"Network Type"] = [[UIDevice currentDevice] getNetworkType]?:@"Unable To Get";
        network[@"Wifi Mac Address"] = [[UIDevice currentDevice] getWifiMacAddress]?:@"Unable To Get";
        network[@"IP Address"] = [[UIDevice currentDevice] getIPAddress];
        network[@"Mac Address"] = [[UIDevice currentDevice] getMacAddress]?:@"Unable To Get";
        dataSource[DEVICE_NETWORK_KEY] = network;
        NSMutableDictionary *memory_usage = [NSMutableDictionary dictionary];
        memory_usage[@"Memory Used"] = [NSString stringWithFormat:@"%f",[[UIDevice currentDevice] getUsedMemory]];
        memory_usage[@"Avalible Memory"] = [NSString stringWithFormat:@"%f",[[UIDevice currentDevice] getAvailableMemory]];
        dataSource[DEVICE_MEMORY_KEY] = memory_usage;
        NSMutableDictionary *system = [NSMutableDictionary dictionary];
        system[@"Operation System"] = [[UIDevice currentDevice] systemName];
        system[@"Device Type"] = [[UIDevice currentDevice] model];
        system[@"Device Is Root"] = [[UIDevice currentDevice] deviceIsRoot];
        system[@"System Version"] = [[UIDevice currentDevice] systemVersion];
        system[@"System Area"] = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        system[@"System Timezone"] = [NSTimeZone systemTimeZone].description;
        system[@"System Language"] = [[UIDevice currentDevice] getSystemLanguage];
        dataSource[DEVICE_SYSYEM_KEY] = system;
        NSMutableDictionary *app_info = [NSMutableDictionary dictionary];
        app_info[@"App Version"] = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
        app_info[@"Bundle Identifier"] = [[NSBundle mainBundle] bundleIdentifier];
        dataSource[DEVICE_APPINFO_KEY] = app_info;
        UserDefaultsSetObjectForKey(dataSource, DEVICE_HARDWARE_SOURCE_KEY);
    });
}

+ (void)registerPushToken:(NSString *)token {
#ifdef DEBUG
    if (token) {
        dispatch_barrier_async(self.__dataRegistryQueue, ^{
            NSMutableDictionary *source = [UserDefaultsObjectForKey(DEVICE_HARDWARE_SOURCE_KEY)?:@{} mutableCopy];
            NSMutableDictionary *identifers = [source[DEVICE_IDENTIFIERS_KEY]?:@{} mutableCopy];
            identifers[@"Push Token"] = token;
            source[DEVICE_IDENTIFIERS_KEY] = identifers;
            UserDefaultsSetObjectForKey(source, DEVICE_HARDWARE_SOURCE_KEY);
        });
    }
#endif
}

+ (void)registerUserDataWithUserID:(NSString *)userID userName:(NSString *)userName userToken:(NSString *)userToken {
#ifdef DEBUG
    dispatch_barrier_async(self.__dataRegistryQueue, ^{
        NSMutableDictionary *source = [UserDefaultsObjectForKey(DEVICE_HARDWARE_SOURCE_KEY)?:@{} mutableCopy];
        NSMutableDictionary *user_info = [NSMutableDictionary dictionary];
        user_info[@"User Token"] = userToken?:@"Not Set";
        user_info[@"User Name"] = userName?:@"Not Set";
        user_info[@"User ID"] = userID?:@"Not Set";
        source[DEVICE_USERINFO_KEY] = user_info;
        UserDefaultsSetObjectForKey(source, DEVICE_HARDWARE_SOURCE_KEY);
    });
#endif
}

+ (void)fetchDeviceHardwareInfo:(FetchCompeletion)compeletion {
    __comeletion = compeletion;
    if (__comeletion) __comeletion(UserDefaultsObjectForKey(DEVICE_HARDWARE_SOURCE_KEY));
    
}

+ (void)registerDefaultAPIHosts:(NSArray<Domain *> *)domains andH5APIHosts:(NSArray<Domain *> *)h5Domains compeletion:(dispatch_block_t)compeletion {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *domainList = [self domainListWithType:APIDomainTypeDefault];
        NSArray *h5DomainList = [self domainListWithType:APIDomainTypeH5];
        if (domains) {
            [domains enumerateObjectsUsingBlock:^(Domain * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self addNewDomain:obj domainType:APIDomainTypeDefault];
            }];
            [self setCurrentDomain:domains[0] type:APIDomainTypeDefault];
        }
        if (h5Domains) {
            [h5Domains enumerateObjectsUsingBlock:^(Domain * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self addNewDomain:obj domainType:APIDomainTypeH5];
            }];
            [self setCurrentDomain:domains[0] type:APIDomainTypeH5];
        }
    });
    if (compeletion) compeletion();
    [[NSNotificationCenter defaultCenter] postNotificationName:kAPIHostDidChangedNotification object:@{kAPIHostDidChangedNewValue:[self currentDomainWithType:APIDomainTypeDefault]}];
    [[NSNotificationCenter defaultCenter] postNotificationName:kH5APIHostDidChangedNotification object:@{kAPIHostDidChangedNewValue:[self currentDomainWithType:APIDomainTypeH5]}];
}

@end

@implementation DebugManager (DebugView)

+ (void)installDebugViewByDefault {
#ifdef DEBUG
    DebugView.debugView.commitTapAction(kDebugViewTapActionDisplayActionMenu).show();
    [self asyncFetchDeviceHardwareInfo];
    WEAK_SELF
    [[NSNotificationCenter defaultCenter] addObserverForName:kDisplayBorderEnabled object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        STRONG_SELF
        @autoreleasepool {
            [self.__cachedRenderingViews enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<__kindof UIView *> * _Nonnull objs, BOOL * _Nonnull stop) {
                [objs enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        displayAllSubviewsBorder(obj, [note.object boolValue]);
                    });
                }];
            }];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        STRONG_SELF
        UserDefaultsSetObjectForKey(nil, DEVICE_HARDWARE_SOURCE_KEY);
    }];
#endif
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
    if (![self.__cachedObservers.allKeys containsObject:notification]) {
        WEAK_SELF
        [[NSNotificationCenter defaultCenter] addObserverForName:notification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
            STRONG_SELF
            NSArray *__handlers = self.__cachedObservers[notification];
            for (ActionHandler cached in __handlers) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cached(note.userInfo);
                });
            }
        }];
    }
    NSMutableArray *__handlers = [self.__cachedObservers[notification] mutableCopy];
    if (__handlers) {
        [__handlers addObject:[handler copy]];
        self.__cachedObservers[notification] = [__handlers copy];
    } else {
        self.__cachedObservers[notification] = @[[handler copy]];
    }
}

@end


#ifdef DEBUG
@interface UIView (DisplayBorder)

@end

@implementation UIView (DisplayBorder)

+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReplaceMethod(self, @selector(init), @selector(swizlle_init));
        ReplaceMethod(self, @selector(initWithCoder:), @selector(swizlle_initWithCoder:));
        ReplaceMethod(self, @selector(initWithFrame:), @selector(swizzle_initWithFrame:));
        ReplaceMethod(self, @selector(removeFromSuperview), @selector(swizlle_removeFromSuperview));
    });
}

- (void)swizlle_removeFromSuperview {
    [self swizlle_removeFromSuperview];
    __weak UIView *view = self;
    if ([(NSMutableArray *)DebugManager.__cachedRenderingViews[NSStringFromClass(self.class)] containsObject:view]) {
        [(NSMutableArray *)DebugManager.__cachedRenderingViews[NSStringFromClass(self.class)] removeObject:view];
    }
}

- (instancetype)swizzle_initWithFrame:(CGRect)frame {
    UIView *view = [self swizzle_initWithFrame:frame];
    __weak typeof(view)wView = view;
    [wView cachedIfNeeded];
    __strong typeof(wView)sView = wView;
    return sView;
}

- (instancetype)swizlle_initWithCoder:(NSCoder *)aDecoder {
    UIView *view = [self swizlle_initWithCoder:aDecoder];
    __weak typeof(view)wView = view;
    [wView cachedIfNeeded];
    __strong typeof(wView)sView = wView;
    return sView;
}

- (instancetype)swizlle_init {
    UIView *view = [self swizlle_init];
    __weak typeof(view)wView = view;
    [wView cachedIfNeeded];
    __strong typeof(wView)sView = wView;
    return sView;
}
- (void)cachedIfNeeded {
    if (![DebugManager.__cachedRenderingViews.allKeys containsObject:NSStringFromClass(self.class)]) {
        DebugManager.__cachedRenderingViews[NSStringFromClass(self.class)] = [NSMutableArray array];
    }
    NSMutableArray *cachedViews = DebugManager.__cachedRenderingViews[NSStringFromClass(self.class)];
    if (cachedViews && ![cachedViews containsObject:self]) {
        [cachedViews addObject:self];
        DebugManager.__cachedRenderingViews[NSStringFromClass(self.class)] = cachedViews;
        displayAllSubviewsBorder(self, DebugManager.isDisplayBorderEnabled);
    }
}
@end
#endif
