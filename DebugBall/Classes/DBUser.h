//
//  DBUser.h
//  Pods
//
//  Created by Jocer on 2017/8/24.
//
//

#import <Foundation/Foundation.h>

@interface DBUser : NSObject <NSCoding>
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_token;
@end
