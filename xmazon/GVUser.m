//
//  GVUser.m
//  xmazon
//
//  Created by VAUTRIN on 27/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "GVUser.h"

@implementation GVUser

@synthesize uid = uid_;
@synthesize email = email_;
@synthesize password = password_;
@synthesize firstname = firstname_;
@synthesize lastname = lastname_;
@synthesize username = username_;

+(id)sharedUser{
    static GVUser *sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUser = [[self alloc] init];
    });
    return sharedUser;
}

- (instancetype) init{
    self = [super init];
    if(self){
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        GVUser* user = [userDefaults objectForKey:@"user"];
        if(user) self = user;
    }
    return self;
}

- (void) updateProperties:(NSDictionary*) dict{
    self.uid = [dict objectForKey:@"uid"];
    self.username = [dict objectForKey:@"username"];
    self.email = [dict objectForKey:@"email"];
    self.lastname = [dict objectForKey:@"lastname"];
    self.firstname = [dict objectForKey:@"firstname"];
    self.password = [dict objectForKey:@"password"];
}

@end
