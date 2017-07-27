//
//  DebugView+Ripple.m
//  mobile
//
//  Created by Jocer on 2017/7/25.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "DebugView+Ripple.h"
#import "UIDevice+Hardware.h"
#import <objc/runtime.h>
#import "DebugView+PanGesturer.h"

@implementation DebugView (Ripple)

@dynamic ripple,rippleDL,fpsDL,fpsLabel;

- (void)generalRippleConfiguration {
    self.amplitude = 1.f;
    self.phase = 0;
    self.speed = 0.05f;
    self.angularVelocity = 10.f;
    self.waterDepth = 0.5;
    [self.layer addSublayer:self.ripple];
    [self addSubview:self.fpsLabel];
    [self.rippleDL addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.fpsDL addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    [self.rippleDL invalidate];
    objc_setAssociatedObject(self, @selector(rippleDL), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.fpsDL invalidate];
    objc_setAssociatedObject(self, @selector(fpsDL), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)tick:(CADisplayLink *)link {
    static int count = 0;
    static float lastTime = 0;
    UIFont *font = [UIFont fontWithName:@"Menlo" size:9];
    UIFont *subFont = nil;
    if (font) {
        subFont = [UIFont fontWithName:@"Menlo" size:9];
    } else {
        font = [UIFont fontWithName:@"Courier" size:9];
        subFont = [UIFont fontWithName:@"Courier" size:9];
    }
    count++;
    NSTimeInterval delta = link.timestamp - lastTime;
    if (delta < 1) return;
    lastTime = link.timestamp;
    float fps = count / delta;
    count = 0;
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%dFPS",(int)round(fps)]];
    [text addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length-3)];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(text.length-3, 3)];
    [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length-3)];
    [text addAttribute:NSFontAttributeName value:subFont range:NSMakeRange(text.length-3, 3)];
    self.fpsLabel.attributedText = text;
}

-(void)waving {
    double available = [[UIDevice currentDevice] getAvailableMemory];
    double used = [[UIDevice currentDevice] getUsedMemory];
    double percent = available/(available+used);
    UIColor *color = [UIColor colorWithRed:1-percent green:percent blue:0 alpha:1];
    self.ripple.backgroundColor = color.CGColor;
    self.waterDepth = 1-percent;
    self.phase += self.speed;
    [self createPath];
}

- (void)createPath {
    UIBezierPath * path = [[UIBezierPath alloc] init];
    CGFloat  waterDepthY = (1 - (self.waterDepth > 1.f? 1.f : self.waterDepth)) * self.frame.size.height;
    CGFloat y = waterDepthY;
    [path moveToPoint:CGPointMake(0, y)];
    path.lineWidth = 1;
    
    for (double x = 0; x <= self.frame.size.width; x++) {
        y = self.amplitude * sin(x / 180 * M_PI * self.angularVelocity + self.phase / M_PI * 4) + waterDepthY;
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [path addLineToPoint:CGPointMake(self.frame.size.width, y)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = path.CGPath;
    self.ripple.mask = maskLayer;
}

- (CALayer *)ripple {
    CALayer *ripple = objc_getAssociatedObject(self, _cmd);
    if (ripple) {
        return ripple;
    }
    ripple = [CALayer layer];
    ripple.frame = self.bounds;
    objc_setAssociatedObject(self, _cmd, ripple, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return ripple;
}

- (CADisplayLink *)rippleDL {
    CADisplayLink *rippleDL = objc_getAssociatedObject(self, _cmd);
    if (rippleDL) {
        return rippleDL;
    }
    rippleDL = [CADisplayLink displayLinkWithTarget:self selector:@selector(waving)];;
    rippleDL.frameInterval = 0.05;
    objc_setAssociatedObject(self, _cmd, rippleDL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return rippleDL;
}

- (UILabel *)fpsLabel {
    UILabel *fpsLabel = objc_getAssociatedObject(self, _cmd);
    if (fpsLabel) {
        return fpsLabel;
    }
    fpsLabel = [[UILabel alloc] initWithFrame:self.bounds];
    fpsLabel.text = @"0FPS";
    fpsLabel.textColor = [UIColor whiteColor];
    fpsLabel.textAlignment = 1;
    fpsLabel.numberOfLines = 1;
    objc_setAssociatedObject(self, _cmd, fpsLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return fpsLabel;
    
}

- (CADisplayLink *)fpsDL {
    CADisplayLink *fpsDL = objc_getAssociatedObject(self, _cmd);
    if (fpsDL) {
        return fpsDL;
    }
    fpsDL = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];;
    fpsDL.frameInterval = 0.05;
    objc_setAssociatedObject(self, _cmd, fpsDL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return fpsDL;
}

@end
