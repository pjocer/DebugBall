//
//  DBCrashHandlerController.m
//  AFNetworking
//
//  Created by Jocer on 2018/1/30.
//

#import "DBCrashHandlerController.h"
#import "DebugManager.h"
#import "DBToastAnimator.h"

static NSString *kIdentifier = @"crashInfoCell";

@interface DBCrashHandlerController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation DBCrashHandlerController

- (void)initDataSource {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearHistoricalRecords)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    self.dataSource = [NSMutableArray array];
    __weak typeof(self)wSelf = self;
    [DebugManager fetchDeviceCrashAssert:^(NSArray<NSDictionary *> *sources) {
        __strong typeof(wSelf)self = wSelf;
        [self.dataSource addObjectsFromArray:sources];
        [self.tableView reloadData];
    }];
}

- (void)clearHistoricalRecords {
    [DebugManager clearDeviceCrashSnifferInfoWithCompeletion:^{
        [self.dataSource removeAllObjects];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableString *stacks = [[NSMutableString alloc] init];
    [(NSArray *)self.dataSource[indexPath.row][@"callStackSymbols"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [stacks appendFormat:@"\n*-*%@",obj];
    }];
    NSMutableString *infos = [[NSMutableString alloc] init];
    [(NSDictionary *)self.dataSource[indexPath.row][@"user_info"] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [infos appendFormat:@"\n*-*%@ : %@",key, obj];
    }];
    [DebugManager showTipsWithType:TipsDisplayTypeInfo text:infos detailText:stacks inView:self.view];
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
    NSString *text = [NSString stringWithFormat:@"Name : %@",info[@"name"]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [info[@"name"] length])];
    cell.textLabel.attributedText = attr;
    cell.detailTextLabel.text = info[@"reason"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

@end
