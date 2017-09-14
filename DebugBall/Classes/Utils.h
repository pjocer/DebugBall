//
//  Utils.h
//  Pods
//
//  Created by Jocer on 2017/8/24.
//
//

#ifndef Utils_h
#define Utils_h

#import <UIKit/UIKit.h>

NSBundle *DebugBallBundle(void) {
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"DebugView")];
    NSURL *bundleURL = [bundle URLForResource:@"DebugBall" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:bundleURL];
}

NSString * DebugBallPathForResource(NSString *name, NSString *ext) {
    return [DebugBallBundle() pathForResource:name ofType:ext];
}

UIImage * DebugBallImageWithNamed(NSString *name){
    return [UIImage imageNamed:name inBundle:DebugBallBundle() compatibleWithTraitCollection:nil];
}

void displayBorder (UIView *view, BOOL display, BOOL recursion) {
    if (![view isKindOfClass:UIView.class]) {
        return;
    }
    if (recursion) {
        if (view.superview) {
            displayBorder(view.superview, display, recursion);
        } else {
            displayBorder(view, display, !recursion);
        }
    } else {
        CALayer *layer = view.layer;
        if ([layer isMemberOfClass:CALayer.class]) {
            layer.borderColor = display?[UIColor redColor].CGColor:[UIColor clearColor].CGColor;
            layer.borderWidth = display?1/[UIScreen mainScreen].scale:0;
        }
        if (layer.animationKeys.count>0) {
            return;
        }
        if (view.subviews.count>0) {
            @autoreleasepool {
                [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    displayBorder(obj, display, recursion);
                }];
            }
        }
    }
}

#endif /* Utils_h */
