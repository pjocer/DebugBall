//
//  DebugManager.h
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import <Foundation/Foundation.h>

typedef NSString Domain;

typedef NS_ENUM(NSInteger, APIDomainType) {
    APIDomainTypeDefault,
    APIDomainTypeH5,
};

// kAPIHostDidChangedNotification or kH5APIHostDidChangedNotification include a nil object and a userInfo dictionary containing the
// old and new API-Host value.
FOUNDATION_EXTERN NSNotificationName const kAPIHostDidChangedNotification;
FOUNDATION_EXTERN NSNotificationName const kH5APIHostDidChangedNotification;

FOUNDATION_EXTERN NSString * const kAPIHostDidChangedNewValue;
FOUNDATION_EXTERN NSString * const kAPIHostDidChangedOldValue;

@interface DebugManager : NSObject

+ (void)presentDebugActionMenuController;

+ (void)dismissDebugActionMenuController;

+ (BOOL)addNewDomain:(Domain *)domain domainType:(APIDomainType)type;

+ (NSArray <NSString *> *)domainListWithType:(APIDomainType)type;

+ (Domain *)currentDomainWithType:(APIDomainType)type;

+ (BOOL)setCurrentDomain:(Domain *)domain type:(APIDomainType)type;

+ (void)setNeedpushNoticationWithData:(NSDictionary <NSNotificationName, NSDictionary <NSString *, NSString *> *> *)data;

+ (BOOL)isDisplayBorderEnabled;

+ (BOOL)saveDisplayBorderEnabled:(BOOL)enabled;

@end

#define DEVICE_USERINFO_KEY     @"User Info"
#define DEVICE_IDENTIFIERS_KEY  @"Identifiers"
#define DEVICE_NETWORK_KEY      @"Network"
#define DEVICE_MEMORY_KEY       @"Memory Used"
#define DEVICE_SYSYEM_KEY       @"System"
#define DEVICE_APPINFO_KEY      @"App Info"

/** Intialize the data to display */
typedef void(^FetchCompeletion)(NSDictionary <NSString *, NSDictionary <NSString *, NSString *> *> *info);

@interface DebugManager (DataRegistry)

+ (void)registerPushToken:(NSString *)token;

+ (void)registerUserDataWithUserID:(NSString *)userID userName:(NSString *)userName userToken:(NSString *)userToken;

+ (void)registerDefaultAPIHost:(Domain *)domain andH5APIHost:(Domain *)h5Domain;

+ (void)fetchDeviceHardwareInfo:(FetchCompeletion)compeletion;

@end

/** Display or hidden DebugView by default settings */
@interface DebugManager (DebugView)

+ (void)installDebugViewByDefault;

+ (void)uninstallDebugView;

@end

typedef void (^ActionHandler)(NSDictionary *info);

// Include an NSNumber object,post when status of enable displaying border changed.
FOUNDATION_EXTERN NSNotificationName const kDisplayBorderEnabled;

/** Handle actions if user registered */
@interface DebugManager (ActionHandler)

+ (void)registerNotification:(NSNotificationName)notification byHandler:(ActionHandler)handler;

@end
