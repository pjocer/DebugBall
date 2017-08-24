//
//  DBUser.m
//  Pods
//
//  Created by Jocer on 2017/8/24.
//
//

#import "DBUser.h"

@implementation DBUser
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.user_token = [aDecoder decodeObjectForKey:@"user_token"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.user_token forKey:@"user_token"];
}

@end
