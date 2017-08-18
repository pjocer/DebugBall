//
//  DBCommonTableViewController.h
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import <QMUIKit/QMUIKit.h>
#import "QDThemeProtocol.h"

static NSString *const kSectionTitleKey = @"kSectionTitleKey";
static NSString *const kSectionSourceKey = @"kSectionSourceKey";
static NSString *const kSectionTextKey = @"kSectionTextKey";
static NSString *const kSectionDetailKey = @"kSectionDetailKey";

@interface DBCommonTableViewController : QMUICommonTableViewController <QDChangingThemeDelegate>
@property(nonatomic, strong) NSMutableArray *dataSource;
- (NSString *)titleForSection:(NSInteger)section;
- (NSString *)detailTextAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)keyNameAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface DBCommonTableViewController (UISubclassingHooks)
- (void)initDataSource;
- (void)didSelectCellWithTitle:(NSString *)title;
@end

