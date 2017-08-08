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
	// Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor redColor];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DebugView *view = [DebugView debugView];
        view.autoHidden(NO).waterDepth(0.5).speed(0.05f).angularVelocity(10.f).phase(0).amplitude(1.f).commitTapAction(kDebugViewTapActionDisplayBorder);
        [view show];
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
