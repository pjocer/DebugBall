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

@interface DebugManager ()
@property (class, nonatomic, strong) DBActionMenuController *menu;
@property (class, nonatomic, strong) UINavigationController *nav;
@end

@implementation DebugManager

static BOOL show = NO;

+ (void)uninstall {
    show = NO;
}

+ (void)presentDebugActionMenuController {
    if (!show) {
        [getCurrentController() presentViewController:self.nav animated:YES completion:^{
            show = YES;
        }];
    } else {
        [self dismissDebugActionMenuController];
    }
}

+ (void)dismissDebugActionMenuController {
    [self.nav dismissViewControllerAnimated:YES completion:^{
        [self uninstall];
    }];
}

+ (void)handleCloseButtonEvent:(UIBarButtonItem *)item {
    [self dismissDebugActionMenuController];
}

+ (UINavigationController *)nav {
    static dispatch_once_t onceToken;
    static UINavigationController *nav = nil;
    dispatch_once(&onceToken, ^{
        nav = [[UINavigationController alloc] initWithRootViewController:self.menu];
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

+ (DBActionMenuController *)menu {
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

@end
