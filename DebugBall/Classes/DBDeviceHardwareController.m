//
//  DBDeviceHardwareController.m
//  Pods
//
//  Created by Jocer on 2017/8/24.
//
//

#import "DBDeviceHardwareController.h"
#import "UIDevice+Hardware.h"

@interface DBDeviceHardwareController ()
@property(nonatomic, strong) QMUIPopupMenuView *popupView;
@end

@implementation DBDeviceHardwareController

- (void)initDataSource {
    [DebugManager fetchDeviceHardwareInfo:^(NSDictionary<NSString *,NSDictionary<NSString *,NSString *> *> *info) {
        NSArray *titles = @[@"User Info",@"Identifiers",@"Network",@"Memory Used",@"System Info",@"App Info"];
        self.sectionTitles = [NSMutableArray array];
        NSMutableArray *sectionSources = [NSMutableArray array];
        for (int i = 0; i<titles.count; i++) {
            NSString *sectionTitle = titles[i];
            if (info[sectionTitle]) {
                [self.sectionTitles addObject:sectionTitle];
                NSMutableArray *sectionDatas = [NSMutableArray arrayWithCapacity:info[sectionTitle].allKeys.count];
                for (int j = 0; j < info[sectionTitle].allKeys.count; j++) {
                    QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
                    d.identifier = 10*i+j;
                    d.style = UITableViewCellStyleValue1;
                    d.accessoryType = QMUIStaticTableViewCellAccessoryTypeNone;
                    d.didSelectTarget = self;
                    d.didSelectAction = @selector(displayPopupView:);
                    d.height = TableViewCellNormalHeight + 6;
                    d.text = info[sectionTitle].allKeys[j];
                    d.detailText = info[sectionTitle][d.text];
                    [sectionDatas addObject:d];
                }
                [sectionSources addObject:sectionDatas];
            }
        }
        self.tableView.qmui_staticCellDataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:sectionSources];
    }];
}

- (QMUIPopupMenuView *)popupView {
    if (!_popupView) {
        _popupView = [[QMUIPopupMenuView alloc] init];
        _popupView.automaticallyHidesWhenUserTap = YES;
        _popupView.maskViewBackgroundColor = UIColorMaskWhite;
        _popupView.maximumWidth = 180;
        _popupView.shouldShowItemSeparator = YES;
        _popupView.separatorInset = UIEdgeInsetsMake(0, _popupView.padding.left, 0, _popupView.padding.right);
        _popupView.itemHighlightedBackgroundColor = [UIColor whiteColor];
    }
    return _popupView;
}

- (void)displayPopupView:(QMUIStaticTableViewCellData *)data {
    WEAK_SELF
    self.popupView.items = @[[QMUIPopupMenuItem itemWithImage:nil title:@"Copy The Value" handler:^{
        STRONG_SELF
        [self.popupView hideWithAnimated:YES];
        [[UIPasteboard generalPasteboard] setString:data.detailText];
        QMUITips *tips = [QMUITips createTipsToView:self.navigationController.view];
        QMUIToastAnimator *animator = [[QMUIToastAnimator alloc] initWithToastView:tips];
        animator.animationType = QMUIToastAnimationTypeSlide;
        tips.toastAnimator = animator;
        [tips showSucceed:@"Copied" hideAfterDelay:1];
    }]];
    QMUITableViewCell *cell = [self.tableView.qmui_staticCellDataSource cellForRowAtIndexPath:data.indexPath];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGRect frame = [self.tableView rectForRowAtIndexPath:data.indexPath];
    frame.origin.y = frame.origin.y+NavigationBarHeight+StatusBarHeight-self.tableView.contentOffset.y;
    frame.origin.x = cell.detailTextLabel.center.x-SCREEN_WIDTH/2.f+(SCREEN_WIDTH-cell.qmui_width);
    [self.popupView layoutWithTargetRectInScreenCoordinate:frame];
    [self.popupView showWithAnimated:YES];
}

- (void)dealloc {
    
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
