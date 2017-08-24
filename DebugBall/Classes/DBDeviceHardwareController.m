//
//  DBDeviceHardwareController.m
//  Pods
//
//  Created by Jocer on 2017/8/24.
//
//

#import "DBDeviceHardwareController.h"
#import "DBUser.h"
#import "UIDevice+Hardware.h"

@interface DBDeviceHardwareController ()

@end

@implementation DBDeviceHardwareController

- (void)initDataSource {
    NSArray *dataSource = [DebugManager getDeviceHardwareInfo];
    NSMutableArray *sectionSources = [NSMutableArray array];
    for (int i = 0; i < dataSource.count; i++) {
        NSDictionary *info = dataSource[i];
        NSMutableArray *sectionSource = [NSMutableArray array];
        for (int j = 0; j < info.allKeys.count; j++) {
            QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
            d.identifier = 10*i+j;
            d.style = UITableViewCellStyleValue1;
            d.accessoryType = QMUIStaticTableViewCellAccessoryTypeNone;
            d.didSelectTarget = self;
            d.didSelectAction = @selector(displayPopupView:);
            d.height = TableViewCellNormalHeight + 6;
            d.text = info.allKeys[j];
            d.detailText = info[info.allKeys[j]];
            [sectionSource addObject:d];
        }
        [sectionSources addObject:sectionSource];
    }
    self.tableView.qmui_staticCellDataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:sectionSources];
    self.sectionTitles = @[@"User Info",@"Identifier",@"Network",@"Memory Usage",@"System Info",@"App Info"];
}

- (void)displayPopupView:(QMUIStaticTableViewCellData *)data {
    
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
