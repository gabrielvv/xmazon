//
//  myOAuthManager.m
//  xmazon
//
//  Created by VAUTRIN on 27/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "myOAuthManager.h"
#import "GVUser.h"

@interface myOAuthManager ()

//Private methods
- (void) getAndSetOAuthTokenForUser:(BOOL)refresh;
- (void) getAndSetOAuthTokenForApp:(BOOL)refresh;
- (void) getAndSetOAuthTokenWithGrantType:(NSString*)type andParams:(nullable NSDictionary*) params andCallback:(void (^)(NSDictionary*))block;
- (void) execRequestWithMethod:(NSString*)method Url:(NSString*)url params:(id)params auth:(NSString*)appOrUser callback:(nullable void ( ^ )(NSDictionary*))c needToken:(BOOL)need_token;

@end

@implementation myOAuthManager

@synthesize oauthTokens = oauthTokens_;
@synthesize credentials = credentials_;

#pragma mark Singleton Methods

/************************************  SHARED MANAGER ******************************************/

+ (id)sharedManager{
    static myOAuthManager *sharedOAuthManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedOAuthManager = [[self alloc] init];
    });
    return sharedOAuthManager;
}

/*************************************  INIT  ***************************************************************/

- (id)init{
    self = [super initWithBaseURL:[NSURL URLWithString:@"http://xmazon.appspaces.fr/"]];
    //initWithBaseURL:sessionConfiguration is also available
    
    if(self){
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.credentials = @{@"client_id": @"7ca51914-8590-4069-af62-f657887c4dc0", @"client_secret": @"a8e2713d651840870e9d18d6cd4ebc5ebe03ca08"};
        self.oauthTokens = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc{
    //Should never be called, but just here for clarity.
}

/**************************************  EXEC REQUEST *******************************************************/

- (void) execRequestWithMethod:(NSString*)method Url:(NSString*)url params:(id)params auth:(NSString*)appOrUser callback:(nullable void ( ^ )(NSDictionary*))c needToken:(BOOL)need_token{

    NSString* access_token = [[self.oauthTokens objectForKey:appOrUser] objectForKey:@"access_token"];
    if(!access_token && need_token){
        NSLog(@"need_token");
        return;
//        [self getAndSetOAuthTokenForApp:false];
    }
    
    NSString* authHeader = [NSString stringWithFormat:@"Bearer %@",[[self.oauthTokens objectForKey:appOrUser] objectForKey:@"access_token"]];
    [self.requestSerializer setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"url : %@", url);
    __block BOOL fail = false;
    __block NSDictionary* response = nil;
    //If we fail, we repeat the request X times until we decide it's too much
    __block int count = 0;
    ;
    NSLog(@"execRequestWithMethod");
    if([method isEqualToString:@"POST"]){
        [self POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            response = (NSDictionary *)responseObject;
            NSLog(@"POST server response: %@", response);
            
            //Appel Callback
            if(c) c(response);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"POST server error: %@", error);
            count++;
        }];
    }
    
    if([method isEqualToString:@"GET"]){
        [self GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            response = (NSDictionary *)responseObject;
            NSLog(@"GET server response: %@", response);
            
            //Appel Callback
            if(c) c(response);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"GET server error: %@", error);
//            count++;
            fail = true;
        }];
    }
    
    sleep(3);
    NSLog(@"reponse %@", response);
//    if(!need_token){
//        while(!response || fail){
//            //Keep waiting
//            NSLog(@"Keep Waiting response:%@ or fail:%d", response, fail);
//        }
//    }
    

}

/*******************************************************************************************************************/

- (void) getAndSetOAuthTokenWithGrantType:(NSString*)type andParams:(nullable NSDictionary*)additionalParams andCallback:(void (^)(NSDictionary*))block{
    NSLog(@"getAndSetOAuthTokenWithGrantType");
    NSMutableDictionary* params;
    NSString* client_id;
    NSString* client_secret;
    
    /**
     *  Method: POST
     *  Body:
     *  client_id : credentials forKey client_id
     *  client_secret: credentials forKey client_secret
     *  x-www-form-urlencoded
     *  Pas de headers/authorization fields
     */
    if((client_id = [self.credentials objectForKey:@"client_id"]) && (client_secret = [self.credentials objectForKey:@"client_secret"])){
        
        params = additionalParams ? [[NSMutableDictionary alloc] initWithDictionary:additionalParams] : [NSMutableDictionary new];

        [params setValue:type forKey:@"grant_type"];
        [params setValue:client_id forKey: @"client_id"];
        [params setValue:client_secret forKey: @"client_secret"];

    }else{
//        return nil;
    }

    NSString* url = [[NSURL URLWithString:@"oauth/token" relativeToURL:self.baseURL] absoluteString];
    [self execRequestWithMethod:@"POST" Url:url params:params auth:nil callback:block needToken:false];
//    return [self execRequestWithMethod:@"POST" Url:url params:params auth:nil callback:];

}

/*******************************************************************************************************************/

- (void) getAndSetOAuthTokenForApp:(BOOL)refresh{
    NSLog(@"getAndSetOAuthTokenForApp");
    NSString* grant_type = refresh ? @"refresh_token" : @"client_credentials";
    
    [self getAndSetOAuthTokenWithGrantType:grant_type andParams:nil andCallback:^(NSDictionary* response){
        NSLog(@"My Block");
        [self.oauthTokens setObject:response forKey:@"app"];
        NSLog(@"\t oauthTokens %@", [self.oauthTokens objectForKey:@"app"]);
    }];
    
//    return [self.oauthTokens objectForKey:@"app"];
}

/*******************************************************************************************************************/

- (void) getAndSetOAuthTokenForUser:(BOOL)refresh{
    
    NSDictionary* additionalParams = nil;
    NSString* grant_type = refresh ? @"refresh_token" : @"password";

    if(!refresh){
        
        GVUser *user = [GVUser sharedUser];
        if(user.username && user.password){
            additionalParams = @{@"username": user.username, @"password": user.password};
        }else{
//            return nil;
        }
    }

//    [self.oauthTokens setObject:[self getAndSetOAuthTokenWithGrantType:grant_type andParams: additionalParams] forKey:@"user"];
    
//    return [self.oauthTokens objectForKey:@"user"];
}

/*******************************************************************************************************************/

- (void) authSubscribeWithMail:(NSString*)email andPassword:(NSString*)password callback:(nullable void ( ^ )(NSDictionary*))c{
    NSLog(@"authSubscribeWithMail");
//    NSDictionary* response;
    NSString* url = [[NSURL URLWithString:@"auth/subscribe" relativeToURL:self.baseURL] absoluteString];
    
    void (^myBlock)(NSDictionary*) = ^(NSDictionary* response){
        NSLog(@"\tmyBlock");
        
        //On stocke les valeurs dans la mémoire
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
        GVUser *user = [GVUser sharedUser];
        [user updateProperties:response];
        [userDefaults setObject:response forKey:@"user"];
        
        c(response);
    };
    
    
    //Authorization Bearer + app token
    [self execRequestWithMethod:@"POST" Url:url params:@{@"email":email, @"password":password} auth:@"app" callback:myBlock needToken:true];

}

/*******************************************************************************************************************/

- (void) getCategoryListForStore:(NSString*)store_uid search:(nullable NSString*)q limit:(NSInteger)lim offset:(NSInteger)offset{

    NSString* url = [[NSURL URLWithString:@"category/list" relativeToURL:self.baseURL] absoluteString];
    
    //Authorization Bearer + app token
//    return [self execRequestWithMethod:@"GET" Url:url params:@{@"search":q, @"store_uid":store_uid, @"limit":[NSNumber numberWithInteger:lim], @"offset":[NSNumber numberWithInteger:offset]} auth:@"app"];;

}

- (void) getStoreList{
    
    NSString* url = [[NSURL URLWithString:@"store/list" relativeToURL:self.baseURL] absoluteString];
    [self getAndSetOAuthTokenForApp:false];
    //Authorization Bearer + app token
//    return [self execRequestWithMethod:@"GET" Url:url params:nil auth:@"app"];

}

- (void) getProductList{

    NSString* url = [[NSURL URLWithString:@"product/list" relativeToURL:self.baseURL] absoluteString];
    
    //Authorization Bearer + user token
//    return [self execRequestWithMethod:@"GET" Url:url params:nil auth:@"user"];
}

//- (BOOL) cartRemove{
//    
//}
//- (BOOL) cartAdd{
//    
//}

//- (NSDictionary*) getUser{
//    
//}

//- (NSDictionary*) getOrderList{
//    
//}
//- (BOOL) orderCreate{
//    
//}

@end
