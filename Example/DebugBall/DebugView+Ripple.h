//
//  DebugView+Ripple.h
//  mobile
//
//  Created by Jocer on 2017/7/25.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import "DebugView.h"

@interface DebugView (Ripple)

@property (nonatomic, strong, readonly) CADisplayLink *rippleDL;

@property (nonatomic, strong, readonly) CADisplayLink *fpsDL;

@property (nonatomic, strong, readonly) CALayer *ripple;

@property (nonatomic, strong, readonly) UILabel *fpsLabel;

- (void)generalRippleConfiguration;

@end
