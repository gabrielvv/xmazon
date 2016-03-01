//
//  myOAuthManager.h
//  xmazon
//
//  Created by VAUTRIN on 27/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "GVUser.h"

@interface myOAuthManager : AFHTTPSessionManager {
    NSMutableDictionary* oauthTokens_;
    NSDictionary* urlDict_;
    NSDictionary* credentials_;
    //property héritée de AFHTTPSessionManager:
    //NSURL baseURL
    //AFHTTPRequestSerializer requestSerializer
    //AFHTTPResponseSerializer responseSerializer
}

@property(nonatomic, retain) NSMutableDictionary* oauthTokens;
@property(nonatomic, retain) NSDictionary* urlDict;
@property(nonatomic, retain) NSDictionary* credentials;

+ (id)sharedManager;
- (void) getCategoryListForStore:(NSString*)store_uid search:(nullable NSString*)q limit:(NSInteger)lim offset:(NSInteger)offset;
//- (BOOL) cartRemove;
//- (BOOL) cartAdd;
- (void) getProductList;
//- (nullable NSDictionary*) getUser;
- (void) getStoreList;
//- (nullable NSDictionary*) getOrderList;
//- (BOOL) orderCreate;
- (void) authSubscribeWithMail:(NSString*)email andPassword:(NSString*)password callback:(nullable void ( ^ )(NSDictionary*))c;

@end
