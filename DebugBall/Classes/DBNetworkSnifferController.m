//
//  DBNetworkSnifferController.m
//  Pods
//
//  Created by Jocer on 2017/9/12.
//
//

#import "DBNetworkSnifferController.h"
#import "DebugManager.h"

static NSString *kIdentifier = @"networkInfoCell";

@interface DBNetworkSnifferController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation DBNetworkSnifferController

- (void)initDataSource {
    self.dataSource = [NSMutableArray array];
    __weak typeof(self)wSelf = self;
    [DebugManager fetchDeviceNetworkSnifferInfo:^(NSArray<NSDictionary<NSString *,NSString *> *> *sources) {
        __strong typeof(wSelf)self = wSelf;
        [self.dataSource addObjectsFromArray:sources];
        [self.tableView reloadData];
    } snifferring:^(NSDictionary<NSString *,NSString *> *info) {
        __strong typeof(wSelf)self = wSelf;
        [self.dataSource insertObject:info atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [QMUITips showInfo:self.dataSource[indexPath.row][@"Type"] detailText:self.dataSource[indexPath.row][@"URL"] inView:self.view hideAfterDelay:5];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:kIdentifier];
        cell.textLabel.textColor = UIColorMake(93, 100, 110);
        cell.detailTextLabel.textColor = UIColorMake(133, 140, 150);
        cell.textLabel.font = UIFontMake(15);
        cell.detailTextLabel.font = UIFontMake(13);
    }
    NSDictionary *info = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",info[@"Type"],info[@"Method"]];
    cell.detailTextLabel.text = info[@"URL"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


@end