//
//  DBActionMenuController.m
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import "DBActionMenuController.h"
#import "UIDevice+Hardware.h"

@interface DBActionMenuController ()

@end

@implementation DBActionMenuController

- (void)initDataSource {
    self.dataSource = [@[[@{kSectionTitleKey:@"API Configuration",kSectionSourceKey:@[
                               [@{kSectionTextKey:@"API Domain",kSectionDetailKey:@"Current API Domain"} mutableCopy],
                               [@{kSectionTextKey:@"H5-API Domain",kSectionDetailKey:@"Current API Domain"} mutableCopy]]} mutableCopy],
                        [@{kSectionTitleKey:@"Device Hardware",kSectionSourceKey:@[
                               [@{kSectionTextKey:@"Operation System",kSectionDetailKey:[[UIDevice currentDevice] getOperationSystem]} mutableCopy],
                               [@{kSectionTextKey:@"App Version",kSectionDetailKey:[[UIDevice currentDevice] getAppVersion]} mutableCopy],
                               [@{kSectionTextKey:@"Mac Address",kSectionDetailKey:[[UIDevice currentDevice] getMacAddress]} mutableCopy],
                               [@{kSectionTextKey:@"IP Address",kSectionDetailKey:[[UIDevice currentDevice] getIPAddress]} mutableCopy],
                               [@{kSectionTextKey:@"IMEI",kSectionDetailKey:[[UIDevice currentDevice] getIMEI]} mutableCopy],
                               [@{kSectionTextKey:@"Device Type",kSectionDetailKey:[[UIDevice currentDevice] getDeviceType]} mutableCopy],
                               [@{kSectionTextKey:@"Device OS Version",kSectionDetailKey:[[UIDevice currentDevice] getDeviceOSVersion]} mutableCopy],
                               [@{kSectionTextKey:@"System Language",kSectionDetailKey:[[UIDevice currentDevice] getSystemLanguage]} mutableCopy],
                               [@{kSectionTextKey:@"System Area",kSectionDetailKey:[[UIDevice currentDevice] getSystemArea]} mutableCopy],
                               [@{kSectionTextKey:@"System Time Zone",kSectionDetailKey:[[UIDevice currentDevice] getSystemTimeZone]} mutableCopy],
                               [@{kSectionTextKey:@"Network Type",kSectionDetailKey:[[UIDevice currentDevice] getNetworkType]} mutableCopy],
                               [@{kSectionTextKey:@"Wifi Mac Address",kSectionDetailKey:[[UIDevice currentDevice] getWifiMacAddress]} mutableCopy],
                               [@{kSectionTextKey:@"APNS Token",kSectionDetailKey:[[UIDevice currentDevice] getAPNSToken]} mutableCopy],
                               [@{kSectionTextKey:@"Root Status",kSectionDetailKey:[[UIDevice currentDevice] deviceIsRoot]} mutableCopy],
                               [@{kSectionTextKey:@"IDFV",kSectionDetailKey:[[UIDevice currentDevice] getIDFV]} mutableCopy],
                               [@{kSectionTextKey:@"IDFA",kSectionDetailKey:[[UIDevice currentDevice] getIDFA]} mutableCopy],
                               [@{kSectionTextKey:@"Location",kSectionDetailKey:[[UIDevice currentDevice] getLocation]} mutableCopy]]} mutableCopy],
                        [@{kSectionTitleKey:@"Small Tools",kSectionSourceKey:@[
                               [@{kSectionTextKey:@"Display border with color red ",kSectionDetailKey:@""} mutableCopy]]} mutableCopy],
                        [@{kSectionTitleKey:@"API Configuration",kSectionSourceKey:@[
                               @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                               @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                               @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                               @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"}]} mutableCopy],
                        [@{kSectionTitleKey:@"API Configuration",kSectionSourceKey:@[
                               @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                               @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                               @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                               @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"}]} mutableCopy]] mutableCopy];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"API Domain"]) {
        [self handleCurrentAPIDomain];
    } else if ([title isEqualToString:@"H5-API Domain"]) {
        [self handleCurrentH5APIDomain];
    }
//    } else if ([title isEqualToString:@"animationStyle"]) {
//        [self handleAnimationStyle];
//    } else if ([title isEqualToString:@"dimmingView"]) {
//        [self handleCustomDimmingView];
//    } else if ([title isEqualToString:@"layoutBlock"]) {
//        [self handleLayoutBlockAndAnimation];
//    } else if ([title isEqualToString:@"keyboard"]) {
//        [self handleKeyboard];
//    } else if ([title isEqualToString:@"showWithAnimated"]) {
//        [self handleWindowShowing];
//    } else if ([title isEqualToString:@"presentViewController"]) {
//        [self handlePresentShowing];
//    } else if ([title isEqualToString:@"showInView"]) {
//        [self handleShowInView];
//    }
}

- (void)handleCurrentAPIDomain {
    
}

- (void)handleCurrentH5APIDomain {
    
}

- (NSString *)titleForSection:(NSInteger)section {
    return self.dataSource[section][kSectionTitleKey];
}

- (NSString *)detailTextAtIndexPath:(NSIndexPath *)indexPath {
    return [(NSMutableArray *)self.dataSource[indexPath.section][kSectionSourceKey] objectAtIndex:indexPath.row][kSectionDetailKey];
}

- (NSString *)keyNameAtIndexPath:(NSIndexPath *)indexPath {
    return [(NSMutableArray *)self.dataSource[indexPath.section][kSectionSourceKey] objectAtIndex:indexPath.row][kSectionTextKey];
}

@end
