//
//  DBCommonTableViewController.h
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import <QMUIKit/QMUIKit.h>

@interface DBCommonTableViewController : UIViewController <QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) NSArray <NSString *>*sectionTitles;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;
@end

@interface DBCommonTableViewController (UISubclassingHooks)
- (void)initDataSource;
@end

