//
//  DBActionMenuController.h
//  Pods
//
//  Created by Jocer on 2017/8/17.
//
//

#import "DBCommonTableViewController.h"

@interface DBActionMenuController : DBCommonTableViewController
@property (nonatomic, copy) void(^webViewAction)(id data);
@property (nonatomic, copy) void(^loginAction)(NSString *email, NSString *password);
@property (nonatomic, copy) dispatch_block_t logoutAction;
@property (nonatomic, copy) dispatch_block_t invalidateTokenAction;
@property (nonatomic, copy) void(^invalidateTokenAfterLoginAction)(NSString *email, NSString *password);
@end
