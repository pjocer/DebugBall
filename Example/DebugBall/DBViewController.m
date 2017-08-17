//
//  DBViewController.m
//  DebugBall
//
//  Created by pjocer on 07/27/2017.
//  Copyright (c) 2017 pjocer. All rights reserved.
//

#import "DBViewController.h"
#import <DebugBall/DebugView.h>

@interface DBViewController ()

@end

@implementation DBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DebugView.debugView.autoHidden(NO).commitTapAction(kDebugViewTapActionDisplayActionMenu).show();
    });
    
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
