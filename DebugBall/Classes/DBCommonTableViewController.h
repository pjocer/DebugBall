//
//  DBCommonTableViewController.h
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import <QMUIKit/QMUIKit.h>
#import "UIDevice+Hardware.h"
#import "DebugManager.h"
#import "DebugViewMacros.h"

@interface DBCommonTableViewController : UIViewController <QMUITableViewDataSource, QMUITableViewDelegate>
@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSString *>*sectionTitles;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;
@end

@interface DBCommonTableViewController (UISubclassingHooks)
- (void)initDataSource;
@end

