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
    [DebugManager registerUserDataWithUserID:@"1835724623" userName:@"ghji@i9i8.com" userToken:@"1351-5t5y-326-63423"];
    
    [DebugManager registerPushToken:@"XXXX-XXXX-XXXX-XXXX-XXXX"];
    
    [DebugManager registerNotification:kAPIHostDidChangedNotification byHandler:^(NSDictionary *info) {
        NSLog(@"%@",info);
        self.tableView = [UITableView new];
    }];
    
    [DebugManager registerNotification:kH5APIHostDidChangedNotification byHandler:^(NSDictionary *info) {
        NSLog(@"%@",info);
    }];
    [DebugManager registerDefaultAPIHosts:@[@"www.ww.ww"] andH5APIHosts:@[@"xxx.xxx.xxx"]];
    
    [DebugManager installDebugViewByDefault];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
