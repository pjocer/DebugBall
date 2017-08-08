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

@property (nonatomic, copy) dispatch_block_t tapAction;
/** 自动隐藏, 默认开启 */
- (DebugView* (^)(BOOL))autoHidden;
/** 水深占比，0 to 1; */
- (DebugView* (^)(CGFloat))waterDepth;
/** 波浪速度，默认 0.05f */
- (DebugView* (^)(CGFloat))speed;
/** 波浪幅度，默认1 */
- (DebugView* (^)(CGFloat))amplitude;
/** 波浪紧凑程度（角速度），默认 10.0 */
- (DebugView* (^)(CGFloat))angularVelocity;
/** 相位，默认0 */
- (DebugView* (^)(CGFloat))phase;

+ (instancetype)debugView;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (void)show;
- (void)dismiss;
@end

typedef NSString Action;
FOUNDATION_EXTERN Action * const kDebugViewTapActionDisplayBorder;

@interface DebugView (TapAction)

- (DebugView * (^)(Action *action))commitTapAction;

@end
