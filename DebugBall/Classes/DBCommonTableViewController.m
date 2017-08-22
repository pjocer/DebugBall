//
//  DBCommonTableViewController.m
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import "DBCommonTableViewController.h"
#import "Common.h"
#import "DebugManager.h"

@interface DBCommonTableViewController () <QMUITableViewDelegate, QMUITableViewDataSource>
@property (nonatomic, assign) UITableViewStyle *style;
@end

@implementation DBCommonTableViewController

const NSInteger kSectionHeaderLabelTag = 1024;

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        self.style = style;
        [self configureTableView];
        [self initDataSource];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configureTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:self.style];
    [_tableView qmui_styledAsQMUITableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.qmui_staticCellDataSource.cellDataSections[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView.qmui_staticCellDataSource.cellDataSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = [tableView.qmui_staticCellDataSource cellForRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView.qmui_staticCellDataSource heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView.qmui_staticCellDataSource didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [tableView.qmui_staticCellDataSource accessoryButtonTappedForRowWithIndexPath:indexPath];
}

@end


@implementation DBCommonTableViewController (UISubclassingHooks)

- (void)initDataSource {
    
}

@end
