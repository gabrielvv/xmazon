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

//- (void) getAndSetOAuthTokenForApp:(BOOL)refresh successCallback:(nullable void (^)())block;
- (void) getAndSetOAuthTokenWithGrantType:(NSString*)type andParams:(nullable NSDictionary*) params successCallback:(void (^)(NSDictionary*))block errorCallback:(nullable void (^)())ec;
- (void) execRequestWithMethod:(NSString*)method url:(NSString*)url params:(id)params auth:(NSString*)appOrUser successCallback:(nullable void ( ^ )(NSDictionary*))c errorCallback:(nullable void ( ^ )())e needAuth:(BOOL)need_auth;

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
        self.oauthTokens = [NSMutableDictionary new];
        NSDictionary* oauthTokens =  [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokens"];
        if(oauthTokens){
            NSDictionary* appTokens = [oauthTokens objectForKey:@"app"];
            NSDictionary* userTokens = [oauthTokens objectForKey:@"user"];
            if(userTokens){
                NSMutableDictionary* newUserTokens = [NSMutableDictionary new];
                [newUserTokens setObject:[userTokens objectForKey:@"access_token"] forKey:@"access_token"];
                [newUserTokens setObject:[userTokens objectForKey:@"token_type"] forKey:@"token_type"];
                [newUserTokens setObject:[userTokens objectForKey:@"expires_in"] forKey:@"expires_in"];
                [newUserTokens setObject:[userTokens objectForKey:@"refresh_token"] forKey:@"refresh_token"];
                [self.oauthTokens setObject:newUserTokens forKey:@"user"];
                if([oauthTokens objectForKey:@"userDate"]) [self.oauthTokens setObject:[oauthTokens objectForKey:@"userDate"] forKey:@"userDate"];
            }
            if(appTokens){
                NSMutableDictionary* newAppTokens = [NSMutableDictionary new];
                [newAppTokens setObject:[appTokens objectForKey:@"access_token"] forKey:@"access_token"];
                [newAppTokens setObject:[appTokens objectForKey:@"token_type"] forKey:@"token_type"];
                [newAppTokens setObject:[appTokens objectForKey:@"expires_in"] forKey:@"expires_in"];
                [newAppTokens setObject:[appTokens objectForKey:@"refresh_token"] forKey:@"refresh_token"];
                [self.oauthTokens setObject:newAppTokens forKey:@"app"];
                if([oauthTokens objectForKey:@"appDate"]) [self.oauthTokens setObject:[oauthTokens objectForKey:@"appDate"] forKey:@"appDate"];
            }
        }
    }
    return self;
}

- (void)dealloc{
    //Should never be called, but just here for clarity.
}

- (void) eraseTokens{
    self.oauthTokens = [NSMutableDictionary new];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"oauthTokens"];
}

/**************************************  EXEC REQUEST *******************************************************/

- (void) execRequestWithMethod:(NSString*)method url:(NSString*)url params:(id)params auth:(NSString*)appOrUser successCallback:(nullable void ( ^ )(NSDictionary*))c errorCallback:(nullable void ( ^ )())e needAuth:(BOOL)need_auth{
    
    NSString* access_token = [[self.oauthTokens objectForKey:appOrUser] objectForKey:@"access_token"];
    
    NSString* authHeader = [NSString stringWithFormat:@"Bearer %@",access_token];
    [self.requestSerializer setValue:(need_auth ? authHeader : nil) forHTTPHeaderField:@"Authorization"];

    __block NSDictionary* response = nil;

    NSLog(@"execRequestWithMethod");
    if([method isEqualToString:@"POST"]){
        [self POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            response = (NSDictionary *)responseObject;
//            NSLog(@"POST server response: %@", response);
            
            //HTTP CODE CHECK
            NSNumber* httpCode = [response objectForKey:@"code"];
            if([httpCode isEqualToNumber:[NSNumber numberWithInt:401]]){
                NSLog(@"\tCode 401");
            }
            
            if([httpCode isEqualToNumber:[NSNumber numberWithInt:500]]){
                NSLog(@"\tCode 500");
            }
            
            if(![httpCode isEqualToNumber:[NSNumber numberWithInt:401]] && ![httpCode isEqualToNumber:[NSNumber numberWithInt:500]]){
                //Appel Callback
                if(c) c(response);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"POST server error: %@", error);
            if(e){
                NSLog(@"error callback");
                e();
            }
        }];
    }
    
    if([method isEqualToString:@"GET"]){
        [self GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            response = (NSDictionary *)responseObject;
//            NSLog(@"GET server response: %@", response);
            
            //HTTP CODE CHECK
            NSNumber* httpCode = [response objectForKey:@"code"];
            if(![httpCode isEqualToNumber:[NSNumber numberWithInt:401]] && ![httpCode isEqualToNumber:[NSNumber numberWithInt:500]]){
                //Appel Callback
                if(c) c(response);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"GET server error: %@", error);
            if(e){
                NSLog(@"error callback");
                e();
            }
        }];
    }
    
}

/*******************************************************************************************************************/

- (void) getAndSetOAuthTokenWithGrantType:(NSString*)type andParams:(nullable NSDictionary*)additionalParams successCallback:(void (^)(NSDictionary*))block errorCallback:(nullable void (^)())ec{
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

    }

    NSString* url = [[NSURL URLWithString:@"oauth/token" relativeToURL:self.baseURL] absoluteString];
    [self execRequestWithMethod:@"POST" url:url params:params auth:nil successCallback:block errorCallback:ec needAuth:false];

}

/*******************************************************************************************************************/

- (void) getAndSetOAuthTokenForApp:(BOOL)refresh successCallback:(nullable void (^)())block{
    NSLog(@"getAndSetOAuthTokenForApp");
    NSString* grant_type = refresh ? @"refresh_token" : @"client_credentials";
    
    [self getAndSetOAuthTokenWithGrantType:grant_type andParams:(refresh ? @{@"refresh_token": [[self.oauthTokens objectForKey:@"app"] objectForKey:@"refresh_token"]} : nil) successCallback:^(NSDictionary* response){
        NSLog(@"My Block");
        
        // ATTENTION response IMMUTABLE
        [self.oauthTokens setObject:response forKey:@"app"];
        [self.oauthTokens setObject:[NSDate date] forKey:@"appDate"];
        NSLog(@"oauthTokens app %@", [self.oauthTokens objectForKey:@"app"]);
        [[NSUserDefaults standardUserDefaults] setObject:self.oauthTokens forKey:@"oauthTokens"];
//        NSLog(@"\t oauthTokens %@", [self.oauthTokens objectForKey:@"app"]);
        if(block) block();
    } errorCallback:nil];
    
}

/*******************************************************************************************************************/

- (void) getAndSetOAuthTokenForUser:(BOOL)refresh username:(NSString*)username password:(NSString*)password successCallback:(void (^)())block errorCallback:(void (^)())ec{
    
    NSLog(@"getAndSetOAuthForUser");
    NSString* grant_type = refresh ? @"refresh_token" : @"password";
    NSDictionary* additionalParams = (refresh ? @{@"refresh_token": [[self.oauthTokens objectForKey:@"user"] objectForKey:@"refresh_token"]} : @{@"username": username, @"password": password});
    
    [self getAndSetOAuthTokenWithGrantType:grant_type andParams:additionalParams successCallback:^(NSDictionary* response){
        NSLog(@"My Block");
        [self.oauthTokens setObject:response forKey:@"user"];
        [self.oauthTokens setObject:[NSDate date] forKey:@"userDate"];
        [[NSUserDefaults standardUserDefaults] setObject:self.oauthTokens forKey:@"oauthTokens"];
        NSLog(@"\t oauthTokens %@", [self.oauthTokens objectForKey:@"user"]);
        GVUser *user = [GVUser sharedUser];
        [user updateProperties:@{@"uid": @"", @"password": password, @"username": username, @"lastname": @"", @"email": @"", @"firstname":@""} andStore:true];
        block();
    } errorCallback:ec];
    
}

/*******************************************************************************************************************/

- (void) authSubscribeWithMail:(NSString*)email andPassword:(NSString*)password successCallback:(nullable void ( ^ )(NSDictionary*))c errorCallback:(nullable void ( ^ )())e{
    
    NSLog(@"authSubscribeWithMail");
    NSString* url = [[NSURL URLWithString:@"auth/subscribe" relativeToURL:self.baseURL] absoluteString];
    
    NSString* access_token = [[self.oauthTokens objectForKey:@"app"] objectForKey:@"access_token"];
    
    //Si le token n'est pas disponible, on lance une requête de token
    if(!access_token){
        
        NSLog(@"need_auth");
        
        void (^sc)() = ^(){
        
            void (^myBlock)(NSDictionary*) = ^(NSDictionary* response){
                NSLog(@"\tmyBlock");
                
                GVUser *user = [GVUser sharedUser];
                [user updateProperties:[response objectForKey:@"result"] andStore:false];
                
                c(response);
            };

            //Authorization Bearer + app token
            [self execRequestWithMethod:@"POST" url:url params:@{@"email":email, @"password":password} auth:@"app" successCallback:myBlock errorCallback:e needAuth:true];
        
        };
        
        [self getAndSetOAuthTokenForApp:false successCallback: sc];
        
    }// if !access_token
    
    if(access_token){
        
        if(![self mustRefreshTokenFor:@"app"]){
            
            NSLog(@"don't need_auth");
            void (^myBlock)(NSDictionary*) = ^(NSDictionary* response){
                NSLog(@"\tmyBlock");
            
                GVUser *user = [GVUser sharedUser];
                [user updateProperties:[response objectForKey:@"result"] andStore:false];
                
                c(response);
            };
            
            //Authorization Bearer + app token
            [self execRequestWithMethod:@"POST" url:url params:@{@"email":email, @"password":password} auth:@"app" successCallback:myBlock errorCallback:nil needAuth:true];
        
        }else{
            NSLog(@"refresh_token");
            
            void (^sc)() = ^(){
                
                void (^myBlock)(NSDictionary*) = ^(NSDictionary* response){
                    NSLog(@"\tmyBlock");
                    
                    GVUser *user = [GVUser sharedUser];
                    [user updateProperties:[response objectForKey:@"result"] andStore:false];
                    
                    c(response);
                };
                
                //Authorization Bearer + app token
                [self execRequestWithMethod:@"POST" url:url params:@{@"email":email, @"password":password} auth:@"app" successCallback:myBlock errorCallback:e needAuth:true];
                
            };
            
            [self getAndSetOAuthTokenForApp:true successCallback: sc];

        }
    }

}

/*******************************************************************************************************************/

- (void) getCategoryListForStore:(NSString*)store_uid search:(nullable NSString*)q limit:(nullable NSNumber*)lim offset:(nullable NSNumber*)offset successCallback:(nullable void ( ^ )(NSDictionary*))sc{

    NSString* url = [[NSURL URLWithString:@"category/list" relativeToURL:self.baseURL] absoluteString];
    
    //Authorization Bearer + app token
    [self execRequestWithMethod:@"GET" url:url params:@{@"store_uid":store_uid} auth:@"app" successCallback:sc errorCallback:nil needAuth: true];

}

- (void) getStoreListWithSuccessCallback:(nullable void ( ^ )(NSDictionary*))sc errorCallback:(nullable void ( ^ )())ec{
    
    NSString* access_token = [[self.oauthTokens objectForKey:@"app"] objectForKey:@"access_token"];
    NSString* url = [[NSURL URLWithString:@"store/list" relativeToURL:self.baseURL] absoluteString];

    if(access_token){
        if([self mustRefreshTokenFor:@"app"]){
            NSLog(@"must refresh");
            void (^myBlock)() = ^(){
                [self execRequestWithMethod:@"GET" url:url params:nil auth:@"app" successCallback:sc errorCallback:ec needAuth: true];
            };
            
            [self getAndSetOAuthTokenForApp:true successCallback:myBlock];
        }else{
            //Authorization Bearer + app token
            [self execRequestWithMethod:@"GET" url:url params:nil auth:@"app" successCallback:sc errorCallback:ec needAuth: true];
        }
    }else{
        NSLog(@"token undefined");
        void (^myBlock)() = ^(){
            [self execRequestWithMethod:@"GET" url:url params:nil auth:@"app" successCallback:sc errorCallback:ec needAuth: true];
        };
        
        [self getAndSetOAuthTokenForApp:false successCallback:myBlock];
    }

}

- (void) getProductListForCat:(NSString*)category_uid search:(nullable NSString*)q limit:(nullable NSNumber*)lim offset:(nullable NSNumber*)offset successCallback:(nullable void ( ^ )(NSDictionary*))sc{

    NSString* access_token = [[self.oauthTokens objectForKey:@"user"] objectForKey:@"access_token"];
    NSLog(@"getProductList user access_token: %@", access_token);
    NSString* url = [[NSURL URLWithString:@"product/list" relativeToURL:self.baseURL] absoluteString];
    GVUser *user = [GVUser sharedUser];
    
    if(!access_token){
        
        void (^myBlock)() = ^(){
            [self execRequestWithMethod:@"GET" url:url params:@{@"category_uid":category_uid} auth:@"user" successCallback:sc errorCallback:nil needAuth: true];
        };
        
        [self getAndSetOAuthTokenForUser:false username:user.username password:user.password successCallback: myBlock errorCallback:nil];
    }
    
    if(access_token){
        
        if([self mustRefreshTokenFor:@"user"]){
            NSLog(@"must refresh");
            void (^myBlock)() = ^(){
                [self execRequestWithMethod:@"GET" url:url params:@{@"category_uid":category_uid} auth:@"user" successCallback:sc errorCallback:nil needAuth: true];
            };
            
            [self getAndSetOAuthTokenForUser:true username:user.username password:user.password successCallback: myBlock errorCallback:nil];
            
        }else{
        //Authorization Bearer + user token
        [self execRequestWithMethod:@"GET" url:url params:@{@"category_uid":category_uid} auth:@"user" successCallback:sc errorCallback:nil needAuth: true];
        }
    }

}

- (BOOL) mustRefreshTokenFor:(NSString*)appOrUser{
    
    if([appOrUser isEqualToString:@"app"]){
        
        NSInteger expires_in = (NSInteger)[[self.oauthTokens objectForKey:@"app"] objectForKey:@"expires_in"];
        NSDate* d  = [self.oauthTokens objectForKey:@"appDate"];
        NSTimeInterval interval = [d timeIntervalSinceNow];
        NSLog(@"App Interval: %f \tDate: %@\tExpires_in %ld", interval, d, (long)expires_in);
//        if(interval > expires_in) return true;
        
    }
    if([appOrUser isEqualToString:@"user"]){
        NSInteger expires_in = (NSInteger)[[self.oauthTokens objectForKey:@"user"] objectForKey:@"expires_in"];
        NSDate* d  = [self.oauthTokens objectForKey:@"userDate"];
        NSTimeInterval interval = [d timeIntervalSinceNow];
        NSLog(@"User Interval: %f \tDate: %@\tExpires_in %ld", interval, d, (long)expires_in);
//        if(interval > expires_in) return true;
    }
    
    return false;
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
