//
//  DebugTableView.m
//  DebugBall
//
//  Created by Jocer on 2017/8/17.
//  Copyright © 2017年 pjocer. All rights reserved.
//

#import "DebugTableView.h"
#import "DebugViewMacros.h"
#import "Common.h"


static NSString *const kSectionTitleKey = @"kSectionTitleKey";
static NSString *const kSectionSourceKey = @"kSectionSourceKey";
static NSString *const kSectionTextKey = @"kSectionTextKey";
static NSString *const kSectionDetailKey = @"kSectionDetailKey";

@interface DebugTableViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray <NSDictionary <NSString *, id>*> *dataSource;
@end

@implementation DebugTableViewDelegate


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [@[@{kSectionTitleKey:@"API Configuration",kSectionSourceKey:@[
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Current H5-API Domain",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"}]},
                        @{kSectionTitleKey:@"Device Hardware",kSectionSourceKey:@[
                                   @{kSectionTextKey:@"Operation System",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"App Version",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Mac Address",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"IP Address",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"IMEI",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Device Type",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Device OS Version",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"System Language",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"System Area",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"System Time Zone",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Network Type",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Wifi Mac Address",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Device Token",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Root Status",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"IDFA",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Location",kSectionDetailKey:@"Need Permisson"}]},
                        @{kSectionTitleKey:@"Small Tools",kSectionSourceKey:@[
                                   @{kSectionTextKey:@"Display border with color red ",kSectionDetailKey:@""}]},
                        @{kSectionTitleKey:@"API Configuration",kSectionSourceKey:@[
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"}]},
                        @{kSectionTitleKey:@"API Configuration",kSectionSourceKey:@[
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"},
                                   @{kSectionTextKey:@"Current API Domain",kSectionDetailKey:@"Current API Domain"}]},] mutableCopy];
    }
    return _dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.dataSource[section][kSectionSourceKey] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataSource[section][kSectionTitleKey];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const kCellIdentifier = @"kCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryCheckmark-2;
    }
    cell.textLabel.text = self.dataSource[indexPath.section][kSectionSourceKey][indexPath.row][kSectionTextKey];
    cell.detailTextLabel.text = self.dataSource[indexPath.section][kSectionSourceKey][indexPath.row][kSectionDetailKey];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* castView = (UITableViewHeaderFooterView*) view;
        castView.textLabel.textColor = [UIColor redColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1/[UIScreen mainScreen].scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

@end

@interface DebugTableView ()
@property (nonatomic, strong) DebugTableViewDelegate *debugTableViewDelegate;
@end

@implementation DebugTableView

+ (instancetype)tableView {
    DebugTableView *instance = [[DebugTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    instance.alpha = 0;
    instance.separatorStyle = UITableViewCellSeparatorStyleNone;
    instance.delegate = instance.debugTableViewDelegate;
    instance.dataSource = instance.debugTableViewDelegate;
    return instance;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DebugTableView *view = nil;
    dispatch_once(&onceToken, ^{
        view = [DebugTableView tableView];
    });
    return view;
}

- (void)show {
    UIWindow *window = getLevelNormalWindow();
    [window insertSubview:self atIndex:window.subviews.count-1];
    [UIView animateWithDuration:animateDuration animations:^{
        self.alpha = 1;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:animateDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (DebugTableViewDelegate *)debugTableViewDelegate {
    if (!_debugTableViewDelegate) {
        _debugTableViewDelegate = [DebugTableViewDelegate new];
    }
    return _debugTableViewDelegate;
}

@end
