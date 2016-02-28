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
    NSMutableDictionary* oauthDict_;
    NSDictionary* urlDict_;
    NSDictionary* credentials_;
    //property héritée de AFHTTPSessionManager:
    //NSURL baseURL
    //AFHTTPRequestSerializer requestSerializer
    //AFHTTPResponseSerializer responseSerializer
}

@property(nonatomic, retain) NSMutableDictionary *oauthTokens;
@property(nonatomic, retain) NSDictionary *urlDict;
@property(nonatomic, retain) NSDictionary *credentials;

+ (id)sharedManager;
- (NSDictionary*) getCategoryList;
- (BOOL) cartRemove;
- (BOOL) cartAdd;
- (NSDictionary*) getProductList;
- (NSDictionary*) getUser;
- (NSDictionary*) getStoreList;
- (NSDictionary*) getOrderList;
- (BOOL) orderCreate;
- (GVUser*) authSubscribeWithMail:(NSString*)email andPassword:(NSString*)password;

@end
