//
//  DBCommonTableViewController.h
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import <QMUIKit/QMUIKit.h>

FOUNDATION_EXTERN NSString *const kSectionTitleKey;
FOUNDATION_EXTERN NSString *const kSectionSourceKey;
FOUNDATION_EXTERN NSString *const kSectionTextKey;
FOUNDATION_EXTERN NSString *const kSectionDetailKey;

@interface DBCommonTableViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <NSString *>*sectionTitles;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;
- (NSString *)titleForSection:(NSInteger)section;
@end

@interface DBCommonTableViewController (UISubclassingHooks)
- (void)initDataSource;
@end

