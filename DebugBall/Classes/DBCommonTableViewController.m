//
//  DBCommonTableViewController.m
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import "DBCommonTableViewController.h"

@interface DBCommonTableViewController ()
@property (nonatomic, assign) UITableViewStyle *style;
@end

@implementation DBCommonTableViewController

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
    [[QMUIConfiguration sharedInstance] setTableViewCellNormalHeight:44];
    _tableView = [[QMUITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBarHeight-StatusBarHeight) style:self.style];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0.1f;
    _tableView.sectionFooterHeight = 0.1f;
    [self.view addSubview:_tableView];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end


@implementation DBCommonTableViewController (UISubclassingHooks)

- (void)initDataSource {
    NSCAssert(![self isMemberOfClass:self.class], @"%@ is an abstract class, you should not instantiate it directly.", NSStringFromClass(self.class));
}

@end
