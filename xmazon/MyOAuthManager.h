//
//  MyOAuthManager.h
//  xmazon
//
//  Created by VAUTRIN on 27/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "JZUser.h"

@interface MyOAuthManager : AFHTTPSessionManager {
    
    NSMutableDictionary* oauthTokens_;
    NSDictionary* urlDict_;
    NSDictionary* credentials_;
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

+ (id)sharedManager;

- (void) setOauthTokensObject:(NSObject *)object forKey:(NSString*)key;

// get Categories of a store specified by its uid. Additionnal parameters are available to narrow the research
- (void) getCategoryListForStore:(NSString*)store_uid search:(nullable NSString*)q limit:(nullable NSNumber*)lim offset:(nullable NSNumber*)offset successCallback:(nullable void ( ^ )(NSDictionary*))sc;

// get Products of a category specified by its uid. Additionnal parameters are available to narrow the research
- (void) getProductListForCat:(NSString*)category_uid search:(nullable NSString*)q limit:(nullable NSNumber*)lim offset:(nullable NSNumber*)offset successCallback:(nullable void ( ^ )(NSDictionary*))sc;

- (void) getStoreListWithSuccessCallback:(nullable void ( ^ )(NSDictionary*))sc errorCallback:(nullable void ( ^ )())ec;

- (void) authSubscribeWithMail:(NSString*)email andPassword:(NSString*)password successCallback:(nullable void ( ^ )(NSDictionary*))sc errorCallback:(nullable void ( ^ )())ec;

- (void) getAndSetOAuthTokenForUser:(BOOL)refresh username:(NSString*)username password:(NSString*)password successCallback:(void (^)())sc errorCallback:(void (^)())ec;

- (void) getAndSetOAuthTokenForApp:(BOOL)refresh successCallback:(nullable void (^)())sc;

- (void) eraseTokens;

- (BOOL) mustRefreshTokenFor:(NSString*)appOrUser;

//- (BOOL) cartRemove;
//- (BOOL) cartAdd;
//- (nullable NSDictionary*) getOrderList;
//- (BOOL) orderCreate;
//- (nullable NSDictionary*) getUser;

@end
