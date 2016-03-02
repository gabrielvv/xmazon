//
//  JZUser.m
//  xmazon
//
//  Created by ZEREN on 27/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "JZUser.h"

@implementation JZUser

@synthesize uid = uid_;
@synthesize email = email_;
@synthesize password = password_;
@synthesize firstname = firstname_;
@synthesize lastname = lastname_;
@synthesize username = username_;

+(id)sharedUser{
    static JZUser *sharedUser = nil;
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
        NSDictionary* user = [userDefaults objectForKey:@"user"];
        if(user){
            self.uid = [user objectForKey:@"uid"];
            self.email = [user objectForKey:@"email"];
            self.password = [user objectForKey:@"password"];
            self.firstname = [user objectForKey:@"firstname"];
            self.lastname = [user objectForKey:@"lastname"];
            self.username = [user objectForKey:@"username"];
        }else{
            self.uid = @"";
            self.email = @"";
            self.password = @"";
            self.firstname = @"";
            self.lastname = @"";
            self.username = @"";
        }
    }
    return self;
}

- (void) updateProperties:(NSDictionary*) dict andStore:(BOOL)store{
//    NSLog(@"updateAndStore %@", dict);
    self.uid = [dict objectForKey:@"uid"];
    self.username = [dict objectForKey:@"username"];
    self.email = [dict objectForKey:@"email"];
//    self.firstname = [dict objectForKey:@"firstname"] ? [dict objectForKey:@"firstname"] : @""; //le test ne marche pas on récupère "<null>"
//    self.lastname = [dict objectForKey:@"lastname"] ? [dict objectForKey:@"lastname"] : @""; //le test ne marche pas on récupère "<null>"
    self.firstname = @"";
    self.lastname = @"";

    //Le password n'est pas renvoyé avec auth/subscribe!!
    self.password = [dict objectForKey:@"password"] ? [dict objectForKey:@"password"] : @"";
    if(store)[self storeProperties];
}

- (NSDictionary*) getPropertiesDict{
    return @{@"uid": self.uid, @"password": self.password, @"username": self.username, @"lastname": self.lastname, @"email": self.email, @"firstname":self.firstname};
}

- (void) storeProperties{
//    NSLog(@"storeProperties %@", [self getPropertiesDict]);
    //On stocke les valeurs dans la mémoire
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self getPropertiesDict] forKey:@"user"];
}

- (void) eraseProperties{
    self.uid = @"";
    self.email = @"";
    self.password = @"";
    self.firstname = @"";
    self.lastname = @"";
    self.username = @"";
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self getPropertiesDict] forKey:@"user"];
}

@end
