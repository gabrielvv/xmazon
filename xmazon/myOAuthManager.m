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

- (void) getAndSetOAuthTokenForApp:(BOOL)refresh;
//- (void) getAndSetOAuthTokenForApp:(BOOL)refresh successCallback:(nullable void (^)())block;
- (void) getAndSetOAuthTokenWithGrantType:(NSString*)type andParams:(nullable NSDictionary*) params andCallback:(void (^)(NSDictionary*))block;
- (void) execRequestWithMethod:(NSString*)method url:(NSString*)url params:(id)params auth:(NSString*)appOrUser callback:(nullable void ( ^ )(NSDictionary*))c needToken:(BOOL)need_token;

@end

@implementation myOAuthManager

@synthesize waitFlag = waitFlag_;
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
        self.waitFlag = false;
    }
    return self;
}

- (void)dealloc{
    //Should never be called, but just here for clarity.
}

/**************************************  EXEC REQUEST *******************************************************/

- (void) execRequestWithMethod:(NSString*)method url:(NSString*)url params:(id)params auth:(NSString*)appOrUser callback:(nullable void ( ^ )(NSDictionary*))c needToken:(BOOL)need_token{
    
    NSString* access_token = [[self.oauthTokens objectForKey:appOrUser] objectForKey:@"access_token"];
    
    NSString* authHeader = [NSString stringWithFormat:@"Bearer %@",access_token];
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
            
            //HTTP CODE CHECK
            NSNumber* httpCode = [response objectForKey:@"code"];
            if([httpCode isEqualToNumber:[NSNumber numberWithInt:401]]){
                NSLog(@"\tCode 401");
            }
            
            if([httpCode isEqualToNumber:[NSNumber numberWithInt:500]]){
                NSLog(@"\tCode 500"); //ça marche
            }
            
            if(![httpCode isEqualToNumber:[NSNumber numberWithInt:401]] && ![httpCode isEqualToNumber:[NSNumber numberWithInt:500]]){
                //Appel Callback
                if(c) c(response);
            }
            self.waitFlag = false;

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"POST server error: %@", error);
            count++;
            self.waitFlag = false;
        }];
    }
    
    if([method isEqualToString:@"GET"]){
        [self GET:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            response = (NSDictionary *)responseObject;
            NSLog(@"GET server response: %@", response);
            
            //HTTP CODE CHECK
            NSNumber* httpCode = [response objectForKey:@"code"];
            if(![httpCode isEqualToNumber:[NSNumber numberWithInt:401]] && ![httpCode isEqualToNumber:[NSNumber numberWithInt:500]]){
                //Appel Callback
                if(c) c(response);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"GET server error: %@", error);
//            count++;
            fail = true;
        }];
    }
    
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
    [self execRequestWithMethod:@"POST" url:url params:params auth:nil callback:block needToken:false];
//    return [self execRequestWithMethod:@"POST" Url:url params:params auth:nil callback:];

}

/*******************************************************************************************************************/

- (void) getAndSetOAuthTokenForApp:(BOOL)refresh successCallback:(nullable void (^)())block{
    NSLog(@"getAndSetOAuthTokenForApp");
    NSString* grant_type = refresh ? @"refresh_token" : @"client_credentials";
    
    [self getAndSetOAuthTokenWithGrantType:grant_type andParams:nil andCallback:^(NSDictionary* response){
        NSLog(@"My Block");
        [self.oauthTokens setObject:response forKey:@"app"];
//        NSLog(@"\t oauthTokens %@", [self.oauthTokens objectForKey:@"app"]);
        if(block) block();
    }];
    
//    return [self.oauthTokens objectForKey:@"app"];
}

/*******************************************************************************************************************/

- (void) getAndSetOAuthTokenForUser:(BOOL)refresh username:(NSString*)username password:(NSString*)password successCallback:(void (^)())block{
    
    NSDictionary* additionalParams = nil;
    NSString* grant_type = refresh ? @"refresh_token" : @"password";

    if(!refresh){

        additionalParams = @{@"username": username, @"password": password};
            
        [self getAndSetOAuthTokenWithGrantType:grant_type andParams:additionalParams andCallback:^(NSDictionary* response){
            NSLog(@"My Block");
            [self.oauthTokens setObject:response forKey:@"user"];
            NSLog(@"\t oauthTokens %@", [self.oauthTokens objectForKey:@"user"]);
            GVUser *user = [GVUser sharedUser];
            [user updateProperties:@{@"uid": @"", @"password": password, @"username": username, @"lastname": @"", @"email": @"", @"firstname":@""} andStore:true];
            block();
        }];
    }

}

/*******************************************************************************************************************/

- (void) authSubscribeWithMail:(NSString*)email andPassword:(NSString*)password callback:(nullable void ( ^ )(NSDictionary*))c{
    
    NSLog(@"authSubscribeWithMail");
    //    NSDictionary* response;
    NSString* url = [[NSURL URLWithString:@"auth/subscribe" relativeToURL:self.baseURL] absoluteString];
    
    NSString* access_token = [[self.oauthTokens objectForKey:@"app"] objectForKey:@"access_token"];
    
    //Si le token n'est pas disponible, on lance une requête de token
    if(!access_token){
        
        self.waitFlag = true;
        NSLog(@"need_token");
        
        void (^sc)() = ^(){
        
            void (^myBlock)(NSDictionary*) = ^(NSDictionary* response){
                NSLog(@"\tmyBlock");
                
                GVUser *user = [GVUser sharedUser];
                [user updateProperties:[response objectForKey:@"result"] andStore:false];
                
                c(response);
            };

            //Authorization Bearer + app token
            [self execRequestWithMethod:@"POST" url:url params:@{@"email":email, @"password":password} auth:@"app" callback:myBlock needToken:true];
        
        };
        
        [self getAndSetOAuthTokenForApp:false successCallback: sc];
        
    }// if !access_token
    
    if(access_token){
        NSLog(@"don't need_token");
        void (^myBlock)(NSDictionary*) = ^(NSDictionary* response){
            NSLog(@"\tmyBlock");
        
            GVUser *user = [GVUser sharedUser];
            [user updateProperties:[response objectForKey:@"result"] andStore:false];
            
            c(response);
        };
        
        
        //Authorization Bearer + app token
        [self execRequestWithMethod:@"POST" url:url params:@{@"email":email, @"password":password} auth:@"app" callback:myBlock needToken:true];
    }

}

/*******************************************************************************************************************/

- (void) getCategoryListForStore:(NSString*)store_uid search:(nullable NSString*)q limit:(nullable NSNumber*)lim offset:(nullable NSNumber*)offset successCallback:(nullable void ( ^ )(NSDictionary*))sc{

    NSString* url = [[NSURL URLWithString:@"category/list" relativeToURL:self.baseURL] absoluteString];
    
    //Authorization Bearer + app token
    [self execRequestWithMethod:@"GET" url:url params:@{@"store_uid":store_uid} auth:@"app" callback:sc needToken: true];

}

- (void) getStoreListWithSuccessCallback:(nullable void ( ^ )(NSDictionary*))sc{
    
    NSString* url = [[NSURL URLWithString:@"store/list" relativeToURL:self.baseURL] absoluteString];

    //Authorization Bearer + app token
    [self execRequestWithMethod:@"GET" url:url params:nil auth:@"app" callback:sc needToken: true];

}

- (void) getProductListForCat:(NSString*)category_uid search:(nullable NSString*)q limit:(nullable NSNumber*)lim offset:(nullable NSNumber*)offset successCallback:(nullable void ( ^ )(NSDictionary*))sc{

    NSString* url = [[NSURL URLWithString:@"product/list" relativeToURL:self.baseURL] absoluteString];
    
    //Authorization Bearer + user token
    [self execRequestWithMethod:@"GET" url:url params:@{@"category_uid":category_uid} auth:@"user" callback:sc needToken: true];

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
