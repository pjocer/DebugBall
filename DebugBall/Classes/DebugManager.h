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

@interface DebugManager : NSObject

+ (void)presentDebugActionMenuController;

+ (void)dismissDebugActionMenuController;

+ (BOOL)addNewDomain:(Domain *)domain domainType:(APIDomainType)type;

+ (NSArray <NSString *> *)domainListWithType:(APIDomainType)type;

+ (Domain *)currentDomainWithType:(APIDomainType)type;

+ (BOOL)setCurrentDomain:(Domain *)domain type:(APIDomainType)type;

+ (void)setNeedpushNoticationWithData:(NSDictionary <NSNotificationName, NSDictionary <NSString *, NSString *> *> *)data;

@end
