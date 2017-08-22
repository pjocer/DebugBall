//
//  DebugView+PanGesturer.m
//  mobile
//
//  Created by Jocer on 2017/7/25.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "DebugView+PanGesturer.h"
#import "DebugViewMacros.h"
#import <objc/runtime.h>



@interface DebugView (Hidden)
@property (nonatomic, assign) BOOL hidden;
@end

@implementation DebugView (PanGesturer)

static CGPoint origin;

- (void)gestureRecognizersConfig {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
    pan.delaysTouchesBegan = NO;
    [self addGestureRecognizer:pan];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
    [self addGestureRecognizer:tap];
    origin = self.center;
    [self changeStatus];
    if ([[self valueForKey:@"_autoHidden"] boolValue]) {
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
    }
}

- (void)tapViewAction:(UITapGestureRecognizer *)tap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
    if (self.hidden) {
        if (self.tapAction) {
            self.tapAction();
        }
    } else {
        [self changeStatus];
    }
    if ([[self valueForKey:@"_autoHidden"] boolValue]) {
        [self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration];
    }
}

- (void)changeStatus {
    [UIView animateWithDuration:animateDuration animations:^{
        self.alpha = self.hidden?sleepAlpha:1;
    }];
    [UIView animateWithDuration:animateDuration animations:^{
        CGFloat x = self.center.x < 20+WIDTH/2 ? 0 :  self.center.x > SCREEN_WIDTH - 20 -WIDTH/2 ? SCREEN_WIDTH : self.center.x;
        CGFloat y = self.center.y < 40 + HEIGHT/2 ? 0 : self.center.y > SCREEN_HEIGHT - 40 - HEIGHT/2 ? SCREEN_HEIGHT : self.center.y;
        if((x == 0 && y ==0) || (x == SCREEN_WIDTH && y == 0) || (x == 0 && y == SCREEN_HEIGHT) || (x == SCREEN_WIDTH && y == SCREEN_HEIGHT)){
            y = self.center.y;
        }
        CGPoint hd = CGPointMake(x, y);
        self.center = self.hidden?hd:origin;
    }];
    self.hidden = !self.hidden;
}

- (void)locationChange:(UIPanGestureRecognizer*)p
{
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateBegan)
    {
        self.hidden = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeStatus) object:nil];
        self.alpha = normalAlpha;
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        [[self valueForKey:@"_autoHidden"] boolValue]?[self performSelector:@selector(changeStatus) withObject:nil afterDelay:statusChangeDuration]:nil;
        if(panPoint.x <= SCREEN_WIDTH/2)
        {
            if(panPoint.y <= 40+HEIGHT/2 && panPoint.x >= 20+WIDTH/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, HEIGHT/2+gap);
                }];
            }
            else if(panPoint.y >= SCREEN_HEIGHT-HEIGHT/2-40 && panPoint.x >= 20+WIDTH/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, SCREEN_HEIGHT-HEIGHT/2-gap);
                }];
            }
            else if (panPoint.x < WIDTH/2+20 && panPoint.y > SCREEN_HEIGHT-HEIGHT/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(WIDTH/2+gap, SCREEN_HEIGHT-HEIGHT/2-gap);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y < HEIGHT/2 ? HEIGHT/2+gap :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(WIDTH/2+gap, pointy);
                }];
            }
        }
        else if(panPoint.x > SCREEN_WIDTH/2)
        {
            if(panPoint.y <= 40+HEIGHT/2 && panPoint.x < SCREEN_WIDTH-WIDTH/2-20 )
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, HEIGHT/2+gap);
                }];
            }
            else if(panPoint.y >= SCREEN_HEIGHT-40-HEIGHT/2 && panPoint.x < SCREEN_WIDTH-WIDTH/2-20)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(panPoint.x, SCREEN_HEIGHT-HEIGHT/2-gap);
                }];
            }
            else if (panPoint.x > SCREEN_WIDTH-WIDTH/2-20 && panPoint.y < HEIGHT/2)
            {
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(SCREEN_WIDTH-WIDTH/2-gap, HEIGHT/2+gap);
                }];
            }
            else
            {
                CGFloat pointy = panPoint.y > SCREEN_HEIGHT-HEIGHT/2 ? SCREEN_HEIGHT-HEIGHT/2-gap :panPoint.y;
                [UIView animateWithDuration:animateDuration animations:^{
                    self.center = CGPointMake(SCREEN_WIDTH-WIDTH/2-gap, pointy);
                }];
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animateDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            origin = self.center;
        });
    }
}

- (BOOL)hidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(hidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
