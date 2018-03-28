    //
//  DBActionMenuController.m
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import "DBActionMenuController.h"
#import "DBDeviceHardwareController.h"
#import "DBNetworkSnifferController.h"
#import "DBCrashHandlerController.h"

@interface DBActionMenuController ()
@property (assign, nonatomic, readonly) NSInteger normalSelectedIndex;
@property (assign, nonatomic, readonly) NSInteger h5SelectedIndex;
@end

@implementation DBActionMenuController

- (void)initDataSource {
    QMUIStaticTableViewCellDataSource *dataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[@[({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 1;
        d.style = UITableViewCellStyleSubtitle;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeNone;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(displayAPIDomainList);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"API Domain";
        d.detailText = [DebugManager currentDomainWithType:APIDomainTypeDefault]?:@"Not Set";
        d;
    }),
                                                                                                                              ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 2;
        d.style = UITableViewCellStyleSubtitle;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeNone;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(displayH5APIDomainList);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"H5-API Domain";
        d.detailText = [DebugManager currentDomainWithType:APIDomainTypeH5]?:@"Not Set";
        d;
    })],
                                                                                                                          @[({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 3;
        d.style = UITableViewCellStyleSubtitle;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(displayDeviceHardwareDetails);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"Device Hardware";
        d.detailText = @"Click to view details";
        d;
    })],
                                                                                                                          @[({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 4;
        d.style = UITableViewCellStyleDefault;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
        d.accessoryValueObject = @([DebugManager isDisplayBorderEnabled]);
        d.accessoryTarget = self;
        d.accessoryAction = @selector(displayBorderForAllVisibleViews:);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"Display border for all visible views";
        d;
    }),
                                                                                                                              ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 5;
        d.style = UITableViewCellStyleSubtitle;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
        d.didSelectAction = @selector(displayNetworkSniffer);
        d.didSelectTarget = self;
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"Display network sniffer";
        d.detailText = @"Keep the latest 50 historical records";
        d;
    }),
                                                                                                                            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 5;
        d.style = UITableViewCellStyleSubtitle;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeDisclosureIndicator;
        d.didSelectAction = @selector(displayCrashHandler);
        d.didSelectTarget = self;
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"Display crash asserts & stacks";
        d.detailText = @"Keep the latest 50 historical records";
        d;
    }),
                                                                                                                            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 6;
        d.style = UITableViewCellStyleDefault;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeNone;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(displayH5TestFiled);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"Test Custom H5-WebView";
        d;
    })],
                                                                                                                          @[({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 7;
        d.style = UITableViewCellStyleDefault;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
        d.accessoryValueObject = @([DebugManager isDebugBallAutoHidden]);
        d.accessoryTarget = self;
        d.accessoryAction = @selector(enableDebugBallAutoHidden:);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"Enable auto-hidden for the DebugBall";
        d;
    }),
                                                                                                                            ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 8;
        d.style = UITableViewCellStyleDefault;
        d.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
        d.accessoryValueObject = @([DebugManager isDebugBallAutoHidden]);
        d.accessoryTarget = self;
        d.accessoryValueObject = @(NO);
        d.accessoryAction = @selector(dimissDebugBallUntilRelaunch:);
        d.height = TableViewCellNormalHeight + 6;
        d.text = @"Dismiss debug-ball until application relaunch";
        d;
    })]]];
    self.tableView.qmui_staticCellDataSource = dataSource;
    self.sectionTitles = @[@"API Configuration", @"Device Hardware", @"Tools", @"DebugBall Configuration"];
}

- (NSInteger)normalSelectedIndex {
    NSArray *list = [DebugManager domainListWithType:APIDomainTypeDefault];
    NSString *domain = [DebugManager currentDomainWithType:APIDomainTypeDefault];
    if (!domain || list.count==0) {
        return -1;
    } else if ([list containsObject:domain]) {
        return [list indexOfObject:domain];
    }
    return -1;
}

- (NSInteger)h5SelectedIndex {
    NSArray *list = [DebugManager domainListWithType:APIDomainTypeH5];
    NSString *domain = [DebugManager currentDomainWithType:APIDomainTypeH5];
    if (!domain || list.count==0) {
        return -1;
    } else if ([list containsObject:domain]) {
        return [list indexOfObject:domain];
    }
    return -1;
}

- (void)displayAPIDomainListWithType:(APIDomainType)type {
    NSIndexPath *currentIdx = [NSIndexPath indexPathForRow:type inSection:0];
    NSMutableArray *list = [[DebugManager domainListWithType:type] mutableCopy];
    [list addObject:type == APIDomainTypeDefault ? @"Add an new domain" : @"Add an new h5-domain"];
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = type == APIDomainTypeDefault ? @"API Domain List" : @"H5 API Domain List";
    dialogViewController.tableView;
    dialogViewController.items = list;
    dialogViewController.selectedItemIndex = type == APIDomainTypeDefault ? self.normalSelectedIndex : self.h5SelectedIndex;
    [dialogViewController addCancelButtonWithText:@"Cancel" block:nil];
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *dialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        if (itemIndex == dialogViewController.items.count-1) {
            cell.textLabel.textColor = cell.textLabel.textColor = UIColorMake(93, 100, 110);
            cell.textLabel.font = UIFontBoldMake(15);
        } else {
            cell.textLabel.textColor = cell.textLabel.textColor = UIColorMake(133, 140, 150);
            cell.textLabel.font = UIFontMake(15);
        }
    };
    [dialogViewController addSubmitButtonWithText:@"Confirm" block:^(QMUIDialogViewController *aDialogViewController) {
        QMUIDialogSelectionViewController *d = (QMUIDialogSelectionViewController *)aDialogViewController;
        WEAK_SELF
        if (d.selectedItemIndex == QMUIDialogSelectionViewControllerSelectedItemIndexNone) {
            [QMUITips showError:@"Select at least one domain please" inView:d.modalPresentedViewController.view hideAfterDelay:1.2];
            return;
        } else if (d.selectedItemIndex == d.items.count-1) {
            [d hideWithAnimated:YES completion:^(BOOL finished) {
                QMUIDialogTextFieldViewController *newAddDialog = [[QMUIDialogTextFieldViewController alloc] init];
                newAddDialog.title = type == APIDomainTypeDefault ? @"Enter an new domain here" : @"Enter an new h5-domain here";
                newAddDialog.textField.placeholder = list[d.selectedItemIndex];
                [newAddDialog addCancelButtonWithText:@"Cancel" block:nil];
                [newAddDialog addSubmitButtonWithText:@"Confirm" block:^(QMUIDialogViewController *newAddDialog) {
                    STRONG_SELF
                    QMUIDialogTextFieldViewController *nd = (QMUIDialogTextFieldViewController *)newAddDialog;
                    [DebugManager addNewDomain:nd.textField.text domainType:type];
                    NSMutableDictionary *info = [@{kAPIHostDidChangedNewValue:nd.textField.text} mutableCopy];
                    if (type == APIDomainTypeDefault && self.normalSelectedIndex!=-1) {
                        info[kAPIHostDidChangedOldValue] = d.items[self.normalSelectedIndex];
                    } else if (self.h5SelectedIndex!=-1) {
                        info[kAPIHostDidChangedOldValue] = d.items[self.h5SelectedIndex];
                    }
                    [DebugManager setNeedpushNoticationWithData:@{type==APIDomainTypeDefault?kAPIHostDidChangedNotification:kH5APIHostDidChangedNotification:info}];
                    [DebugManager setCurrentDomain:nd.textField.text type:type];
                    self.tableView.qmui_staticCellDataSource.cellDataSections[0][type].detailText = nd.textField.text;
                    [self reloadIndexPaths:@[currentIdx]];
                    [nd hide];
                }];
                [newAddDialog show];
            }];
        } else {
            STRONG_SELF
            NSString *domain = d.items[d.selectedItemIndex];
            NSMutableDictionary *info = [@{kAPIHostDidChangedNewValue:domain} mutableCopy];
            if (type == APIDomainTypeDefault && self.normalSelectedIndex!=-1) {
                info[kAPIHostDidChangedOldValue] = d.items[self.normalSelectedIndex];
            } else if (self.h5SelectedIndex!=-1) {
                info[kAPIHostDidChangedOldValue] = d.items[self.h5SelectedIndex];
            }
            [DebugManager setNeedpushNoticationWithData:@{type==APIDomainTypeDefault?kAPIHostDidChangedNotification:kH5APIHostDidChangedNotification:info}];
            [DebugManager setCurrentDomain:domain type:type];
            WEAK_SELF
            [aDialogViewController hideWithAnimated:YES completion:^(BOOL finished) {
                STRONG_SELF
                self.tableView.qmui_staticCellDataSource.cellDataSections[0][type].detailText = domain;
                [self reloadIndexPaths:@[currentIdx]];
            }];
        }
    }];
    [dialogViewController show];
}

#pragma mark -- Action Handler

- (void)displayAPIDomainList {
    [self displayAPIDomainListWithType:APIDomainTypeDefault];
}

- (void)displayH5APIDomainList {
    [self displayAPIDomainListWithType:APIDomainTypeH5];
}

- (void)displayDeviceHardwareDetails {
    DBDeviceHardwareController *vc = [[DBDeviceHardwareController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.navigationItem.title = @"Device Hardware";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)displayBorderForAllVisibleViews:(UISwitch *)view {
    [DebugManager saveDisplayBorderEnabled:view.isOn];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayBorderEnabled object:@(view.isOn)];
}

- (void)displayNetworkSniffer {
    DBNetworkSnifferController *controller = [[DBNetworkSnifferController alloc] initWithStyle:UITableViewStylePlain];
    controller.title = @"Network Sniffer";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)displayCrashHandler {
    DBCrashHandlerController *controller = [[DBCrashHandlerController alloc] initWithStyle:UITableViewStylePlain];
    controller.title = @"Crash Sniffer";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)displayH5TestFiled {
    QMUIDialogTextFieldViewController *newAddDialog = [[QMUIDialogTextFieldViewController alloc] init];
    newAddDialog.title = @"Enter an new web url here";
    newAddDialog.textField.placeholder = @"e.g.https://m.azazie.com/";
    [newAddDialog addCancelButtonWithText:@"Cancel" block:nil];
    WEAK_SELF
    [newAddDialog addSubmitButtonWithText:@"Confirm" block:^(QMUIDialogViewController *newAddDialog) {
        STRONG_SELF
        QMUIDialogTextFieldViewController *nd = (QMUIDialogTextFieldViewController *)newAddDialog;
        if (self.webViewAction) self.webViewAction(nd.textField.text);
        [nd hide];
    }];
    [newAddDialog show];
}

- (void)enableDebugBallAutoHidden:(UISwitch *)view {
    [DebugManager setDebugBallAutoHidden:view.isOn];
    [DebugManager resetDebugBallAutoHidden];
}

- (void)dimissDebugBallUntilRelaunch:(UISwitch *)view {
    [DebugManager uninstallDebugView];
}

- (void)dealloc {
    
}

#pragma mark -- Private Method

- (void)reloadIndexPaths:(NSArray <NSIndexPath *> *)indexPaths {
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark -- Override Method

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [tableView.qmui_staticCellDataSource cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = UIColorMake(93, 100, 110);
    cell.detailTextLabel.textColor = UIColorMake(133, 140, 150);
    cell.textLabel.font = UIFontMake(15);
    cell.detailTextLabel.font = UIFontMake(13);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView.qmui_staticCellDataSource didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
