//
//  DBViewController.m
//  DebugBall
//
//  Created by pjocer on 07/27/2017.
//  Copyright (c) 2017 pjocer. All rights reserved.
//

#import "DBViewController.h"
#import "DebugView.h"

@interface DBViewController ()

@end

@implementation DBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DebugView showWithClickAction:^{
            NSLog(@"Clicked Action");
        }];
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
