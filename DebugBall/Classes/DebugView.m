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
#import "Common.h"
#import "DebugManager.h"

Action * const kDebugViewTapActionDisplayBorder = @"kDebugViewTapActionDisplayBorder";
Action * const kDebugViewTapActionDisplayActionMenu = @"kDebugViewTapActionDisplayActionMenu";

@interface DebugView ()
@property (nonatomic, assign) BOOL _autoHidden;
@property(nonatomic, assign)CGFloat _waterDepth;
@property (nonatomic, assign) CGFloat _speed;
@property (nonatomic, assign) CGFloat _amplitude;
@property (nonatomic, assign) CGFloat _angularVelocity;
@property (nonatomic, assign) CGFloat _phase;
@property (nonatomic, assign) BOOL _showDebugViewOnTapAction;
@property (nonatomic, strong) NSMutableDictionary *_tapActionDic;
@end

@implementation DebugView

- (instancetype)_initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self commitSubviews];
    return self;
}

- (void)commitSubviews {
    
}

- (NSMutableDictionary *)_tapActionDic {
    if (!__tapActionDic) {
        dispatch_block_t displayBorderAction = ^{
            static BOOL show = YES;
            displayAllSubviewsBorder(getCurrentController().view, show);
            show = !show;
        };
        dispatch_block_t displayActionMenu = ^{
            static BOOL show = YES;
            show?[DebugManager presentDebugActionMenuController]:nil;
            show = !show;
        };
        __tapActionDic = [NSMutableDictionary dictionary];
        [__tapActionDic setValue:[displayBorderAction copy] forKey:kDebugViewTapActionDisplayBorder];
        [__tapActionDic setValue:[displayActionMenu copy] forKey:kDebugViewTapActionDisplayActionMenu];
    }
    return __tapActionDic;
}

+ (instancetype)debugView {
    static dispatch_once_t onceToken;
    static DebugView *view = nil;
    dispatch_once(&onceToken, ^{
        view = [[DebugView alloc] _initWithFrame:CGRectMake(kScreenWidth-40, 150, 30, 30)];
        [view generalConfiguration:nil];
    });
    return view;
}

- (DebugView *(^)(BOOL))autoHidden {
    return ^(BOOL hidden) {
        self._autoHidden = hidden;
        return self;
    };
}

- (DebugView *(^)(CGFloat))waterDepth {
    return ^(CGFloat waterDepth) {
        self._waterDepth = waterDepth;
        return self;
    };
}

- (DebugView *(^)(CGFloat))speed {
    return ^(CGFloat speed) {
        self._speed = speed;
        return self;
    };
}

- (DebugView *(^)(CGFloat))amplitude {
    return ^(CGFloat amplitude) {
        self._amplitude = amplitude;
        return self;
    };
}

- (DebugView *(^)(CGFloat))angularVelocity {
    return ^(CGFloat angularVelocity) {
        self._angularVelocity = angularVelocity;
        return self;
    };
}

- (DebugView *(^)(CGFloat))phase {
    return ^(CGFloat phase) {
        self._phase = phase;
        return self;
    };
}

- (void)generalConfiguration:(dispatch_block_t)action {
    self.autoHidden(YES).waterDepth(0.5).speed(0.05f).angularVelocity(10.f).phase(0).amplitude(1.f);
    self.tapAction = action;
    self.layer.cornerRadius = self.frame.size.width/2.f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
}

- (DebugView *(^)())show {
    return ^{
        [self gestureRecognizersConfig];
        [self generalRippleConfiguration];
        UIWindow *window = getLevelNormalWindow();
        NSAssert(window, @"Application's key window can not be nil before showing debug view");
        [window addSubview:self];
        return self;
    };
}

- (DebugView *(^)())dismiss {
    return ^{
        [UIView animateWithDuration:animateDuration animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) [self removeFromSuperview];
        }];
        return self;
    };
}

@end

@implementation DebugView (TapAction)

- (DebugView *(^)(Action *))commitTapAction {
    return ^(Action *action) {
        self.tapAction = self._tapActionDic[action];
        return self;
    };
}

@end
