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
@end
