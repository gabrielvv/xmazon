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
    BOOL waitFlag_;
    /*
     property héritée de AFHTTPSessionManager:
        NSURL baseURL
        AFHTTPRequestSerializer requestSerializer
        AFHTTPResponseSerializer responseSerializer
     */
}

@property(nonatomic, retain) NSMutableDictionary* oauthTokens;
@property(nonatomic, retain) NSDictionary* urlDict;
@property(nonatomic, retain) NSDictionary* credentials;
@property(nonatomic) BOOL waitFlag;

+ (id)sharedManager;
- (void) getCategoryListForStore:(NSString*)store_uid search:(nullable NSString*)q limit:(nullable NSNumber*)lim offset:(nullable NSNumber*)offset successCallback:(nullable void ( ^ )(NSDictionary*))sc;

- (void) getProductListForCat:(NSString*)category_uid search:(nullable NSString*)q limit:(nullable NSNumber*)lim offset:(nullable NSNumber*)offset successCallback:(nullable void ( ^ )(NSDictionary*))sc;

- (void) getStoreListWithSuccessCallback:(nullable void ( ^ )(NSDictionary*))sc errorCallback:(nullable void ( ^ )())ec;

- (void) authSubscribeWithMail:(NSString*)email andPassword:(NSString*)password successCallback:(nullable void ( ^ )(NSDictionary*))c errorCallback:(nullable void ( ^ )())e;

- (void) getAndSetOAuthTokenForUser:(BOOL)refresh username:(NSString*)username password:(NSString*)password successCallback:(void (^)())block errorCallback:(void (^)())ec;

- (void) getAndSetOAuthTokenForApp:(BOOL)refresh successCallback:(nullable void (^)())block;
- (void) eraseTokens;
- (BOOL) mustRefreshTokenFor:(NSString*)appOrUser;

//- (BOOL) cartRemove;
//- (BOOL) cartAdd;
//- (nullable NSDictionary*) getOrderList;
//- (BOOL) orderCreate;
//- (nullable NSDictionary*) getUser;

@end
