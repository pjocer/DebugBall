//
//  DebugTableView.h
//  DebugBall
//
//  Created by Jocer on 2017/8/17.
//  Copyright © 2017年 pjocer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugTableView : UITableView

+ (instancetype)sharedInstance;

- (void)show;

- (void)dismiss;

@end
