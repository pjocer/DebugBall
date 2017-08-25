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

#ifndef WEAK_SELF
#define WEAK_SELF __weak typeof(self)wSelf = self;
#endif
#ifndef STRONG_SELF
#define STRONG_SELF __strong typeof(wSelf)self = wSelf;
#endif

#ifndef UserDefaultsSetObjectForKey
#define UserDefaultsSetObjectForKey(obj,key)\
        ({[[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]; \
        [[NSUserDefaults standardUserDefaults] synchronize];})
#endif

#ifndef UserDefaultsObjectForKey
#define UserDefaultsObjectForKey(key)\
        ({[[NSUserDefaults standardUserDefaults] objectForKey:key];})
#endif


#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

#define animateDuration 0.3
#define statusChangeDuration  5.0
#define normalAlpha  0.8
#define sleepAlpha  0.3
#define gap 10

#endif /* DebugViewMacros_h */
