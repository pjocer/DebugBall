//
//  DebugView.m
//  mobile
//
//  Created by Jocer on 2017/7/25.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "DebugView.h"
#import "DebugViewMacros.h"
#import "DebugView+PanGesturer.h"
#import "DebugView+Ripple.h"

@interface DebugView ()
@property (nonatomic, copy, readwrite) dispatch_block_t tapAction;
@end

@implementation DebugView

+ (instancetype)showWithClickAction:(dispatch_block_t)action {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSAssert(window, @"Application's key window can not be nil before showing debug view");
    DebugView *view = [[DebugView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 150, 30, 30)];
    [view generalConfiguration:action];
    [window addSubview:view];
    return view;
}

- (void)generalConfiguration:(dispatch_block_t)action {
    self.layer.cornerRadius = self.frame.size.width/2.f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.tapAction = action;
    [self gestureRecognizersConfig];
    [self generalRippleConfiguration];
}

@end
