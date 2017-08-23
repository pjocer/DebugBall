//
//  DebugViewMacros.h
//  mobile
//
//  Created by Jocer on 2017/7/26.
//  Copyright © 2017年 azazie. All rights reserved.
//

#ifndef DebugViewMacros_h
#define DebugViewMacros_h

#import <QMUIKit/QMUICommonDefines.h>

#define WEAK_SELF __weak typeof(self)wSelf = self;
#define STRONG_SELF __strong typeof(wSelf)self = wSelf;

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

#define animateDuration 0.3
#define statusChangeDuration  5.0
#define normalAlpha  0.8
#define sleepAlpha  0.3
#define gap 10

#endif /* DebugViewMacros_h */
