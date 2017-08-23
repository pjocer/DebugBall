//
//  DBViewController.m
//  DebugBall
//
//  Created by pjocer on 07/27/2017.
//  Copyright (c) 2017 pjocer. All rights reserved.
//

#import "DBViewController.h"
#import <DebugBall/DebugManager.h>

@interface DBViewController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DebugManager installDebugViewByDefault];
    [DebugManager registerNotification:kAPIHostDidChangedNotification byHandler:^(NSDictionary *info) {
        NSLog(@"%@",info);
        self.tableView = [UITableView new];
    }];
    [DebugManager registerNotification:kH5APIHostDidChangedNotification byHandler:^(NSDictionary *info) {
        NSLog(@"%@",info);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushAction:(UIButton *)sender {
    DBViewController *vc = [DBViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
