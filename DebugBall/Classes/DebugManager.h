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

// Include an NSNumber object,post when status of enable displaying border changed.
FOUNDATION_EXTERN NSNotificationName const kDisplayBorderEnabled;
// Include an NSNumber object,post when status of DebugBall's auto-hidden did changed.
FOUNDATION_EXTERN NSNotificationName const kDebugBallAutoHidden;

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

+ (BOOL)isDebugBallAutoHidden;

+ (BOOL)setDebugBallAutoHidden:(BOOL)enabled;

@end

/** Intialize the data to display */
typedef void(^FetchCompeletion)(NSDictionary <NSString *, NSDictionary <NSString *, NSString *> *> *info);
typedef void(^NetworkSnifferCompeletion)(NSArray <NSDictionary <NSString *, NSString *> *>* sources);

@interface DebugManager (DataRegistry)

+ (void)registerPushToken:(NSString *)token;

+ (void)registerUserDataWithUserID:(NSString *)userID userName:(NSString *)userName userToken:(NSString *)userToken;
/** Will post kAPIHostDidChangedNotification and kH5APIHostDidChangedNotification after compeletion block */
+ (void)registerDefaultAPIHosts:(NSArray <Domain *>*)domains andH5APIHosts:(NSArray <Domain *>*)h5Domains;

+ (void)registerNetworkRequest:(NSURLRequest *)request type:(APIDomainType)type;

+ (void)fetchDeviceHardwareInfo:(FetchCompeletion)compeletion;

+ (void)fetchDeviceNetworkSnifferInfo:(NetworkSnifferCompeletion)compeletion snifferring:(void(^)(NSDictionary <NSString *, NSString *> *info))snifferring;

+ (void)clearDeviceNetworkSnifferInfoWithCompeletion:(dispatch_block_t)compeletion;

@end

/** Display or hidden DebugView by default settings */
@interface DebugManager (DebugView)

+ (void)installDebugView;

+ (void)uninstallDebugView;

+ (void)resetDebugBallAutoHidden;

@end

