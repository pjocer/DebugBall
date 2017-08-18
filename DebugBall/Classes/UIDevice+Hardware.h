//
//  UIDevice+Hardware.h
//  mobile
//
//  Created by Jocer on 2017/7/26.
//  Copyright © 2017年 azazie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)
/**
 *  获取可用内存
 *
 *  @return 可用内存
 */
- (double)getAvailableMemory;
/**
 *  获取已用内存
 *
 *  @return 已用内存
 */
- (double)getUsedMemory;
/**
 *  获取操作系统平台
 *
 *  @return 操作系统平台
 */
-(NSString *)getOperationSystem;

/**
 *  获取与设备无关的时间戳
 *
 *  @return 中时区时间戳
 */
-(void)getTime;

/**
 *  获取应用程序版本
 *
 *  @return 应用程序版本
 */
-(NSString *)getAppVersion;

/**
 *  获取开放性独立设备标志符
 *
 *  @return Open UDID
 */
-(NSString *)getOpenUDID;

/**
 *  获取网卡地址
 *
 *  @return Mac Address
 */
-(NSString *)getMacAddress;

/**
 *  获取 IP 地址
 *
 *  @return IP Address
 */
-(NSString *)getIPAddress;

/**
 *  获取设备国际移动设备识别码
 *
 *  @return IMEI
 */
-(NSString *)getIMEI;

/**
 *  获取设备型号
 *
 *  @return 设备型号
 */
-(NSString *)getDeviceType;

/**
 *  获取设备操作系统版本
 *
 *  @return 操作系统版本
 */
-(NSString *)getDeviceOSVersion;

/**
 *  获取系统语言
 *
 *  @return 语言代号
 */
-(NSString *)getSystemLanguage;

/**
 *  获取设备所在地
 *
 *  @return 所在地
 */
-(NSString *)getSystemArea;

/**
 *  获取设备所在时区
 *
 *  @return 时区
 */
-(NSString *)getSystemTimeZone;

/**
 *  获取设备网络状态
 *
 *  @return 设备网络状态
 */
-(NSString *)getNetworkType;

/**
 *  获取 WI-FI Mac Address
 *
 *  @return WI-FI Mac 地址
 */
-(NSString *)getWifiMacAddress;

/**
 *  获取设备令牌
 *
 *  @return device token
 */
-(NSString *)getAPNSToken;

/**
 *  判断设备是否越狱
 *
 *  @return 是否越狱
 */
-(NSString *)deviceIsRoot;


/**
 *  获取设备广告标识符
 *
 *  @return IDFA
 */
-(NSString *)getIDFV;

/**
 *  获取设备广告标识符
 *
 *  @return IDFA
 */
-(NSString *)getIDFA;

/**
 *  获取设备地理位置
 *
 *  @return 地理位置
 */
-(NSString *)getLocation;
@end
