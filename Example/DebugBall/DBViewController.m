//
//  DBViewController.m
//  DebugBall
//
//  Created by pjocer on 07/27/2017.
//  Copyright (c) 2017 pjocer. All rights reserved.
//

#import "DBViewController.h"
#import <DebugBall/DebugView.h>
#import <DebugBall/DebugViewMacros.h>

@interface DBViewController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DebugView.debugView.autoHidden(NO).commitTapAction(kDebugViewTapActionDisplayActionMenu).show();
    });
    [[NSNotificationCenter defaultCenter] addObserverForName:kAPIHostDidChangedNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@",note.userInfo);
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kH5APIHostDidChangedNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"%@",note.userInfo);
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
