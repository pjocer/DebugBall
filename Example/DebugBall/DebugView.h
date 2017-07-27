//
//  DebugView.h
//  mobile
//
//  Created by Jocer on 2017/7/25.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 DebugView,默认情况下，已用内存/(可用内存+已用内存)<=0.2f或FPS<=50时高亮显示
 */

@interface DebugView : UIView
/** 水深占比，0 to 1; */
@property(nonatomic, assign)CGFloat waterDepth;

/** 波浪速度，默认 0.05f */
@property (nonatomic, assign) CGFloat speed;

/** 波浪幅度，默认1 */
@property (nonatomic, assign) CGFloat amplitude;

/** 波浪紧凑程度（角速度），默认 6.0 */
@property (nonatomic, assign) CGFloat angularVelocity;

/** 相位，默认0 */
@property (nonatomic, assign) CGFloat phase;

@property (nonatomic, copy, readonly) dispatch_block_t tapAction;

+ (instancetype)showWithClickAction:(dispatch_block_t)action;

@end
