//
//  DebugManager.m
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import "DebugManager.h"
#import "DebugView.h"
#import "Common.h"
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
@property (class, nonatomic, strong) DBActionMenuController *__menu;
@property (class, nonatomic, strong) UINavigationController *__nav;
@property (class, nonatomic, strong) NSMutableDictionary *__cachedClasses;
@end

@implementation DebugManager

static BOOL __show = NO;
static NSMutableDictionary<NSNotificationName,NSDictionary<NSString *,NSString *> *> * __data = nil;

+ (void)uninstall {
    __show = NO;
}

+ (void)presentDebugActionMenuController {
    if (!__show) {
        [getCurrentController() presentViewController:self.__nav animated:YES completion:^{
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

+ (BOOL)addNewDomain:(Domain *)domain domainType:(APIDomainType)type{
    NSArray *domainList = [self domainListWithType:type];
    if (domainList.count==0) {
        [[NSUserDefaults standardUserDefaults] setObject:@[domain] forKey:type==APIDomainTypeDefault?kDomainListKey:kH5DomainListKey];
    } else {
        NSMutableArray *newList = [domainList mutableCopy];
        [newList addObject:domain];
        [[NSUserDefaults standardUserDefaults] setObject:newList forKey:type==APIDomainTypeDefault?kDomainListKey:kH5DomainListKey];
    }
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray <NSString *> *)domainListWithType:(APIDomainType)type {
    NSArray *domainList = nil;
    if (type == APIDomainTypeDefault) {
        domainList = [[NSUserDefaults standardUserDefaults] arrayForKey:kDomainListKey]?:@[];
    }
    if (type == APIDomainTypeH5) {
        domainList = [[NSUserDefaults standardUserDefaults] arrayForKey:kH5DomainListKey]?:@[];
    }
    return domainList;
}

+ (Domain *)currentDomainWithType:(APIDomainType)type {
    return [[NSUserDefaults standardUserDefaults] stringForKey:type==APIDomainTypeDefault?kCurrentDomainKey:kCurrentH5DomainKey]?:@"Not Set";
}

+ (BOOL)setCurrentDomain:(Domain *)domain type:(APIDomainType)type {
    [[NSUserDefaults standardUserDefaults] setObject:domain forKey:type==APIDomainTypeDefault?kCurrentDomainKey:kCurrentH5DomainKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
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

@implementation DebugManager (DebugView)

+ (void)installDebugViewByDefault {
    DebugView.debugView.commitTapAction(kDebugViewTapActionDisplayActionMenu).show();
    WEAK_SELF
    [[NSNotificationCenter defaultCenter] addObserverForName:kDisplayBorderEnabled object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        STRONG_SELF
        [self.__cachedClasses enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            displayAllSubviewsBorder(obj, [note.object boolValue]);
        }];
    }];
}

+ (void)uninstallDebugView {
    DebugView.debugView.dismiss();
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
        DebugManager.__cachedClasses[NSStringFromClass(self.class)] = view;
        displayAllSubviewsBorder(self, DebugManager.isDisplayBorderEnabled);
    }
    [self swizzled_didMoveToSuperview];
}

@end
