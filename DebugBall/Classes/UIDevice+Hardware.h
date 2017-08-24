//
//  UIDevice+Hardware.h
//  mobile
//
//  Created by Jocer on 2017/7/26.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)
- (double)getAvailableMemory;
- (double)getUsedMemory;
-(NSString *)getOperationSystem;
-(NSString *)getAppVersion;
-(NSString *)getMacAddress;
-(NSString *)getIPAddress;
-(NSString *)getDeviceType;
-(NSString *)getDeviceOSVersion;
-(NSString *)getSystemLanguage;
-(NSString *)getSystemArea;
-(NSString *)getSystemTimeZone;
-(NSString *)getNetworkType;
-(NSString *)getWifiMacAddress;
-(NSString *)deviceIsRoot;
-(NSString *)getIDFV;
-(NSString *)getIDFA;
@end
