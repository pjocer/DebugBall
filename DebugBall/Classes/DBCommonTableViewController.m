//
//  DBCommonTableViewController.m
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import "DBCommonTableViewController.h"
#import "QDThemeManager.h"

@implementation DBCommonTableViewController

- (void)didInitialized {
    [super didInitialized];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeChangedNotification:) name:QDThemeChangedNotification object:nil];
}

- (void)handleThemeChangedNotification:(NSNotification *)notification {
    NSObject<QDThemeProtocol> *themeBeforeChanged = notification.userInfo[QDThemeBeforeChangedName];
    themeBeforeChanged = [themeBeforeChanged isKindOfClass:[NSNull class]] ? nil : themeBeforeChanged;
    
    NSObject<QDThemeProtocol> *themeAfterChanged = notification.userInfo[QDThemeAfterChangedName];
    themeAfterChanged = [themeAfterChanged isKindOfClass:[NSNull class]] ? nil : themeAfterChanged;
    
    [self themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
}

#pragma mark - <QDChangingThemeDelegate>

- (void)themeBeforeChanged:(NSObject<QDThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<QDThemeProtocol> *)themeAfterChanged {
    [self.tableView reloadData];
}

- (void)didInitializedWithStyle:(UITableViewStyle)style {
    [super didInitializedWithStyle:style];
    [self initDataSource];
}

#pragma mark - <QMUITableViewDataSource,QMUITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSMutableArray *)self.dataSource[section][kSectionSourceKey] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierNormal = @"cellNormal";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierNormal];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierNormal];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self keyNameAtIndexPath:indexPath];
    cell.detailTextLabel.text = [self detailTextAtIndexPath:indexPath];
    
    cell.textLabel.font = UIFontMake(15);
    cell.detailTextLabel.font = UIFontMake(13);
    
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyName = [self keyNameAtIndexPath:indexPath];
    [self didSelectCellWithTitle:keyName];
    [self.tableView qmui_clearsSelection];
}

#pragma mark - DataSource

- (NSString *)titleForSection:(NSInteger)section {
    return nil;
}

- (NSString *)detailTextAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString *)keyNameAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end


@implementation DBCommonTableViewController (UISubclassingHooks)

- (void)initDataSource {
}


- (void)didSelectCellWithTitle:(NSString *)title {
}

@end
