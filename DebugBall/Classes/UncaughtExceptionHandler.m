//
//  UncaughtExceptionHandler.m
//  UncaughtExceptionDemo
//
//  Created by  tomxiang on 15/8/28.
//  Copyright (c) 2015年  tomxiang. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import "ExceptionModel.h"
#import "DebugManager.h"

@implementation UncaughtExceptionHandler

+(void)saveCrash:(NSDictionary *)exceptionInfo {
    NSString * _libPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OCCrash"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_libPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSString * savePath = [_libPath stringByAppendingFormat:@"/error%@.log",timeString];
    BOOL success = [exceptionInfo writeToFile:savePath atomically:YES];
    NSLog(@"YES sucess:%d",success);
}

@end




void HandleException(NSException *exception) {
    [DebugManager registerCrashReport:exception];
}


void InstallUncaughtExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(&HandleException);
}

