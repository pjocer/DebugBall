//
//  DBToastAnimator.m
//  Pods
//
//  Created by Jocer on 2017/9/14.
//
//

#import "DBToastAnimator.h"

@implementation DBToastAnimator{
    BOOL _isShowing;
    BOOL _isAnimating;
}

- (void)showWithCompletion:(void (^)(BOOL))completion {
    _isShowing = YES;
    _isAnimating = YES;
    self.toastView.backgroundView.layer.transform = CATransform3DMakeTranslation(0, -30, 0);
    self.toastView.contentView.layer.transform = CATransform3DMakeTranslation(0, -30, 0);
    [UIView animateWithDuration:0.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.toastView.backgroundView.alpha = 1.0;
        self.toastView.contentView.alpha = 1.0;
        self.toastView.backgroundView.layer.transform = CATransform3DIdentity;
        self.toastView.contentView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        _isAnimating = NO;
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)hideWithCompletion:(void (^)(BOOL finished))completion {
    _isShowing = NO;
    _isAnimating = YES;
    [UIView animateWithDuration:0.25 delay:0.0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.toastView.backgroundView.alpha = 0.0;
        self.toastView.contentView.alpha = 0.0;
        self.toastView.backgroundView.layer.transform = CATransform3DMakeTranslation(0, -30, 0);
        self.toastView.contentView.layer.transform = CATransform3DMakeTranslation(0, -30, 0);
    } completion:^(BOOL finished) {
        _isAnimating = NO;
        self.toastView.backgroundView.layer.transform = CATransform3DIdentity;
        self.toastView.contentView.layer.transform = CATransform3DIdentity;
        if (completion) {
            completion(finished);
        }
    }];
}

- (BOOL)isShowing {
    return _isShowing;
}

- (BOOL)isAnimating {
    return _isAnimating;
}

@end
