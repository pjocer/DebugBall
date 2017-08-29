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

void displayAllSubviewsBorder (UIView *view, BOOL display) {
    if ([view isKindOfClass:[UISwitch class]]) {
        return;
    }
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

#endif /* Utils_h */
