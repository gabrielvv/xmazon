//
//  JZUser.h
//  xmazon
//
//  Created by ZEREN on 27/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZUser : NSObject{
    NSString* uid_;
    NSString* email_;
    NSString* username_;
    NSString* password_;
    NSString* lastname_;
    NSString* firstname_;
}

@property(nonatomic, strong) NSString* uid;
@property(nonatomic, strong) NSString* email;
@property(nonatomic, strong) NSString* username;
@property(nonatomic, strong) NSString* password;
@property(nonatomic, strong) NSString* lastname;
@property(nonatomic, strong) NSString* firstname;

+(id)sharedUser;
-(void) updateProperties:(NSDictionary*) dict andStore:(BOOL)store;
- (NSDictionary*) getPropertiesDict;
- (void) storeProperties;
- (void) eraseProperties;
@end
