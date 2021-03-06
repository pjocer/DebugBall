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
#import "DBToastAnimator.h"
#import "UncaughtExceptionHandler.h"
#import "SignalHandler.h"
#import <QMUIKit/QMUICommonDefines.h>

NSNotificationName const kAPIHostDidChangedNotification     = @"kAPIHostDidChangedNotification";
NSNotificationName const kH5APIHostDidChangedNotification   = @"kH5APIHostDidChangedNotification";
NSNotificationName const kDisplayBorderEnabled              = @"kDisplayBorderEnabled";
NSNotificationName const kDebugBallAutoHidden               = @"kDebugBallAutoHidden";


NSString * const kAPIHostDidChangedNewValue = @"kAPIHostDidChangedNewValue";
NSString * const kAPIHostDidChangedOldValue = @"kAPIHostDidChangedOldValue";

static NSString * kDomainListKey            = @"kDomainListKey";
static NSString * kH5DomainListKey          = @"kH5DomainListKey";
static NSString * kCurrentDomainKey         = @"kCurrentDomainKey";
static NSString * kCurrentH5DomainKey       = @"kCurrentH5DomainKey";
static NSString * kHasInstalledDebugBall    = @"kHasInstalledDebugBall";

@interface DebugManager ()
@property (nonatomic, strong) DBActionMenuController *menu;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray<__kindof UIView *> *> *cachedRenderingViews;
@property (nonatomic, copy) dispatch_queue_t dataRegistryQueue;
@end

@implementation DebugManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static DebugManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [DebugManager new];
    });
    return manager;
}

static BOOL __show = NO;
static NSMutableDictionary<NSNotificationName,NSDictionary<NSString *,NSString *> *> * __data = nil;

+ (void)presentDebugActionMenuController {
    if (!__show) {
        UIViewController *vc = DebugSharedManager.nav;
        [[QMUIHelper visibleViewController] presentViewController:vc animated:YES completion:^{
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
    [[QMUIHelper visibleViewController] setNeedsStatusBarAppearanceUpdate];
    [DebugSharedManager.nav dismissViewControllerAnimated:YES completion:^{
        __show = NO;
    }];
}

- (void)handleCloseButtonEvent:(UIBarButtonItem *)item {
    [DebugManager dismissDebugActionMenuController];
}
- (UINavigationController *)nav {
    if (!_nav) {
        _nav = [[UINavigationController alloc] initWithRootViewController:self.menu];
        _nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationBar *bar = _nav.navigationBar;
        [bar.backItem.backBarButtonItem setTintColor:UIColorWhite];
        bar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorWhite};
        UIImage *backgroundImage = [DebugBallImageWithNamed(@"navigationbar_background") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
        [bar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        bar.shadowImage = [UIImage new];
        bar.barStyle = UIBarStyleBlack;
    }
    return _nav;
}
- (DBActionMenuController *)menu {
    if (!_menu) {
        _menu = [[DBActionMenuController alloc] initWithStyle:UITableViewStyleGrouped];
        _menu.title = @"Project Configuration";
        _menu.hidesBottomBarWhenPushed = YES;
        _menu.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_closeItemWithTarget:self action:@selector(handleCloseButtonEvent:)];
        _menu.navigationItem.leftBarButtonItem.tintColor = UIColorWhite;
    }
    return _menu;
}
- (NSMutableDictionary<NSString *,NSMutableArray<UIView *> *> *)cachedRenderingViews {
    if (!_cachedRenderingViews) {
        _cachedRenderingViews = [NSMutableDictionary dictionary];
    }
    return _cachedRenderingViews;
}
- (dispatch_queue_t)dataRegistryQueue {
    if (!_dataRegistryQueue) {
        _dataRegistryQueue = dispatch_queue_create("dataRegistryQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _dataRegistryQueue;
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
    return UserDefaultsObjectForKey(type==APIDomainTypeDefault?kCurrentDomainKey:kCurrentH5DomainKey);
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

+ (BOOL)isDebugBallAutoHidden {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kDebugBallAutoHidden];
}

+ (BOOL)setDebugBallAutoHidden:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kDebugBallAutoHidden];
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
#define DEVICE_NETWORK_SOURCE_KEY   @"DEVICE_NETWORK_SOURCE_KEY"
#define CRASH_EXCEPTION_SOURCE_KEY   @"CRASH_EXCEPTION_SOURCE_KEY"

static FetchCompeletion __comeletion = nil;
static NetworkSnifferCompeletion __networkCompeletion = nil;
static void (^__snifferring)(NSDictionary<NSString *,NSString *> *) = nil;
static void (^__crash_snifferring)(NSException *) = nil;

@implementation DebugManager (DataRegistry)

+ (void)asyncFetchDeviceHardwareInfo {
    dispatch_barrier_async(DebugSharedManager.dataRegistryQueue, ^{
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
        app_info[@"Build Number"] = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
        app_info[@"Bundle Identifier"] = [[NSBundle mainBundle] bundleIdentifier];
        dataSource[DEVICE_APPINFO_KEY] = app_info;
        UserDefaultsSetObjectForKey(dataSource, DEVICE_HARDWARE_SOURCE_KEY);
    });
}

+ (void)registerPushToken:(NSString *)token {
#ifdef DEBUG
    if (token) {
        dispatch_barrier_async(DebugSharedManager.dataRegistryQueue, ^{
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
    dispatch_barrier_async(DebugSharedManager.dataRegistryQueue, ^{
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

+ (void)registerAccountInfo:(NSString *)email password:(NSString *)password {
#ifdef DEBUG
    if (email) UserDefaultsSetObjectForKey(email, DBACCOUNT_EMAIL_KEY);
    if (password) UserDefaultsSetObjectForKey(password, DBACCOUNT_PASSWORD_KEY);
#endif
}

+ (void)registerNetworkRequest:(NSURLRequest *)request type:(APIDomainType)type {
#ifdef DEBUG
    NSMutableArray *requestInfos = [UserDefaultsObjectForKey(DEVICE_NETWORK_SOURCE_KEY)?:@[] mutableCopy];
    NSDictionary *requestInfo = @{@"URL":request.URL.absoluteString,
                                  @"Method":request.HTTPMethod,
                                  @"Type":type==APIDomainTypeH5?@"WebView Request":@"API Request"};
    [requestInfos insertObject:requestInfo atIndex:0];
    if (requestInfos.count > 50) {
        [requestInfos removeLastObject];
    }
    UserDefaultsSetObjectForKey(requestInfos, DEVICE_NETWORK_SOURCE_KEY);
    if (__snifferring) __snifferring(requestInfo);
#endif
}

+ (void)registerCrashReport:(NSException *)exception {
#ifdef DEBUG
    NSMutableArray *exceptions = [UserDefaultsObjectForKey(CRASH_EXCEPTION_SOURCE_KEY)?:@[] mutableCopy];
    NSMutableDictionary *exceptionInfo = [NSMutableDictionary dictionaryWithCapacity:4];
    exceptionInfo[@"name"] = exception.name;
    exceptionInfo[@"callStackSymbols"] = exception.callStackSymbols;
    exceptionInfo[@"reason"] = exception.reason;
    exceptionInfo[@"user_info"] = exception.userInfo;
    [exceptions insertObject:exceptionInfo atIndex:0];
    if (exceptions.count > 50) {
        [exceptions removeLastObject];
    }
    UserDefaultsSetObjectForKey(exceptions, CRASH_EXCEPTION_SOURCE_KEY);
    if (__crash_snifferring) __crash_snifferring(exceptionInfo);
#endif
}

+ (void)fetchDeviceHardwareInfo:(FetchCompeletion)compeletion {
    __comeletion = compeletion;
    if (__comeletion) __comeletion(UserDefaultsObjectForKey(DEVICE_HARDWARE_SOURCE_KEY));
    
}

+ (void)fetchDeviceNetworkSnifferInfo:(NetworkSnifferCompeletion)compeletion snifferring:(void (^)(NSDictionary<NSString *,NSString *> *))snifferring{
    __networkCompeletion = compeletion;
    __snifferring = snifferring;
    if (__networkCompeletion) __networkCompeletion(UserDefaultsObjectForKey(DEVICE_NETWORK_SOURCE_KEY));
}

+ (void)fetchDeviceCrashAssert:(CrashAssertsCompeletion)compeletion {
    if (compeletion) compeletion(UserDefaultsObjectForKey(CRASH_EXCEPTION_SOURCE_KEY));
}

+ (void)clearDeviceNetworkSnifferInfoWithCompeletion:(dispatch_block_t)compeletion {
    UserDefaultsSetObjectForKey(nil, DEVICE_NETWORK_SOURCE_KEY);
    if (compeletion) compeletion();
}

+ (void)clearDeviceCrashSnifferInfoWithCompeletion:(dispatch_block_t)compeletion {
    UserDefaultsSetObjectForKey(nil, CRASH_EXCEPTION_SOURCE_KEY);
    if (compeletion) compeletion();
}

+ (void)registerDefaultAPIHosts:(NSArray<Domain *> *)domains andH5APIHosts:(NSArray<Domain *> *)h5Domains {
    NSArray *domainList = [self domainListWithType:APIDomainTypeDefault];
    NSArray *h5DomainList = [self domainListWithType:APIDomainTypeH5];
    if (domains && ![domainList containsObject:domains[0]]) {
        [domains enumerateObjectsUsingBlock:^(Domain * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addNewDomain:obj domainType:APIDomainTypeDefault];
        }];
        [self setCurrentDomain:domains[0] type:APIDomainTypeDefault];
    }
    if (h5Domains && ![h5DomainList containsObject:h5Domains[0]]) {
        [h5Domains enumerateObjectsUsingBlock:^(Domain * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addNewDomain:obj domainType:APIDomainTypeH5];
        }];
        [self setCurrentDomain:h5Domains[0] type:APIDomainTypeH5];
    }
}

@end

@implementation DebugManager (DebugView)

+ (void)installDebugView {
#ifdef DEBUG
    if (![UserDefaultsObjectForKey(kHasInstalledDebugBall) boolValue]) {
        [self setDebugBallAutoHidden:YES];
        UserDefaultsSetObjectForKey(@(YES), kHasInstalledDebugBall);
    }
    DebugView.debugView.autoHidden([self isDebugBallAutoHidden]).commitTapAction(kDebugViewTapActionDisplayActionMenu).show();
    [self asyncFetchDeviceHardwareInfo];
    InstallUncaughtExceptionHandler();
    InstallSignalHandler();
    WEAK_SELF
    [[NSNotificationCenter defaultCenter] addObserverForName:kDisplayBorderEnabled object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        STRONG_SELF
        @autoreleasepool {
            [DebugSharedManager.cachedRenderingViews enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<__kindof UIView *> * _Nonnull objs, BOOL * _Nonnull stop) {
                [objs enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        displayBorder(obj, [note.object boolValue], YES);
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
#ifdef DEBUG
    dispatch_async(dispatch_get_main_queue(), ^{
        DebugView.debugView.dismiss();
        UserDefaultsSetObjectForKey(nil, DEVICE_HARDWARE_SOURCE_KEY);
        UserDefaultsSetObjectForKey(nil, DEVICE_NETWORK_SOURCE_KEY);
    });
#endif
}

+ (void)resetDebugBallAutoHidden {
#ifdef DEBUG
    DebugView.debugView.autoHidden([self isDebugBallAutoHidden]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kDebugBallAutoHidden object:@([self isDebugBallAutoHidden])];
#endif
}

@end

@implementation DebugManager (Helper)

+ (void)showTipsWithType:(TipsDisplayType)type text:(NSString *)text inView:(__kindof UIView *)view {
    [self showTipsWithType:type text:text detailText:nil inView:view];
}

+ (void)showTipsWithType:(TipsDisplayType)type text:(NSString *)text detailText:(NSString *)detailText inView:(__kindof UIView *)view {
    [self showTipsWithType:type text:text detailText:detailText afterDelay:0.5*[[text stringByAppendingString:detailText?:@""] length] inView:view];
}

+ (void)showTipsWithType:(TipsDisplayType)type text:(NSString *)text detailText:(NSString *)detailText afterDelay:(NSTimeInterval)delay inView:(__kindof UIView *)view {
    QMUITips *tips = [QMUITips createTipsToView:view];
    DBToastAnimator *customAnimator = [[DBToastAnimator alloc] initWithToastView:tips];
    tips.toastAnimator = customAnimator;
    tips.maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenToastView:)];
    [tips.maskView addGestureRecognizer:tap];
    if (type == TipsDisplayTypeInfo) {
        [tips showInfo:text detailText:detailText hideAfterDelay:delay];
    } else {
        [(QMUIToastContentView *)tips.contentView setDetailTextLabelAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:UIColorBlue,NSFontAttributeName: UIFontBoldMake(12), NSForegroundColorAttributeName: UIColorWhite, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight: 18]}];
        [tips showSucceed:text detailText:detailText hideAfterDelay:delay];
    }
}

+ (void)hiddenToastView:(UITapGestureRecognizer *)tap {
    QMUITips *tip = tap.view.superview;
    if (tip) {
        [tip hideAnimated:YES];
    }
}

@end

@implementation DebugManager (CustomAction)
+ (void)setCustomWebViewAction:(void(^)(id data))action {
    DebugSharedManager.menu.webViewAction = action;
}

+ (void)setLoginAction:(void(^)(NSString *email, NSString *password))action {
    DebugSharedManager.menu.loginAction = action;
}
+ (void)setLogoutAction:(dispatch_block_t)action {
    DebugSharedManager.menu.logoutAction = action;
}
+ (void)setInvalidateTokenAction:(dispatch_block_t)action {
    DebugSharedManager.menu.invalidateTokenAction = action;
}
+ (void)setInvalidateTokenAfterLoginAction:(void(^)(NSString *email, NSString *password))action {
    DebugSharedManager.menu.invalidateTokenAfterLoginAction = action;
}
@end


