//
//  Common.h
//  DebugBall
//
//  Created by Jocer on 2017/8/7.
//  Copyright © 2017年 pjocer. All rights reserved.
//

#ifndef Common_h
#define Common_h

#import <UIKit/UIKit.h>

static inline NSBundle *DebugBallBundle(void) {
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"DebugView")];
    NSURL *bundleURL = [bundle URLForResource:@"DebugBall" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:bundleURL];
}

static inline NSString * DebugBallPathForResource(NSString *name, NSString *ext) {
    return [DebugBallBundle() pathForResource:name ofType:ext];
}

static inline UIImage * DebugBallImageWithNamed(NSString *name){
    return [UIImage imageNamed:name inBundle:DebugBallBundle() compatibleWithTraitCollection:nil];
}

static inline UIWindow * getLevelNormalWindow() {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                return tmpWin;
            }
        }
    }
    return window;
}

static inline UIViewController * getVisibleController (UIViewController *viewController) {
    UIViewController *result;
    if ([viewController presentedViewController]) {
        UIViewController *controller = viewController.presentedViewController;
        result = getVisibleController(controller);
    }else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc  = (UINavigationController *)viewController;
        UIViewController *controller = nvc.topViewController;
        result = getVisibleController(controller);
    }else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)viewController;
        UIViewController *controller = tab.selectedViewController;
        result = getVisibleController(controller);
    }else {
        result = viewController;
    }
    return result;
}

static inline UIViewController * getCurrentController() {
    UIWindow *window = getLevelNormalWindow();
    UIViewController *controller = window.rootViewController;
    UIViewController *visibleController = getVisibleController(controller);
    return visibleController;
}

static inline void displayAllSubviewsBorder (UIView *view, BOOL display) {
    CALayer *layer = view.layer;
    if (![layer isKindOfClass:NSClassFromString(@"CATransformLayer")]) {
        view.layer.borderColor = display?[UIColor redColor].CGColor:[UIColor clearColor].CGColor;
        view.layer.borderWidth = display?1/[UIScreen mainScreen].scale:0;
    }
    if (view.subviews.count > 0 && ![view isKindOfClass:[UISwitch class]]) {
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            displayAllSubviewsBorder(obj, display);
        }];
    } else {
        return ;
    }
}

#endif /* Common_h */
