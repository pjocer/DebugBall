#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DebugView+PanGesturer.h"
#import "DebugView+Ripple.h"
#import "DebugView.h"
#import "DebugViewMacros.h"
#import "UIDevice+Hardware.h"

FOUNDATION_EXPORT double DebugBallVersionNumber;
FOUNDATION_EXPORT const unsigned char DebugBallVersionString[];

