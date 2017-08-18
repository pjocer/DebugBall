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
#import "QDThemeManager.h"
#import "QMUIConfigurationTemplate.h"

@implementation DebugManager

+ (void)renderGlobalAppearances {
    [QDThemeManager sharedInstance].currentTheme = [[QMUIConfigurationTemplate alloc] init];
}

+ (void)presentDebugActionMenuController {
    [self renderGlobalAppearances];
    DBActionMenuController *vc = [[DBActionMenuController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.title = @"Project Configuration";
    vc.hidesBottomBarWhenPushed = YES;
    QMUINavigationController *nav = [[QMUINavigationController alloc] initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [getCurrentController() presentViewController:nav animated:YES completion:nil];
}

@end
