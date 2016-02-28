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
- (NSDictionary*) getOAuthTokenForUser:(BOOL)refresh;
- (NSDictionary*) getOAuthTokenForApp:(BOOL)refresh;
- (NSDictionary*) getOAuthTokenWithGrantType:(NSString*)type andParams:(nullable NSDictionary*) params;
- (NSDictionary*) execRequestWithUrl:(NSString*)url params:(id)params grantType:(NSString*)type;

@end

@implementation myOAuthManager

@synthesize oauthTokens = oauthTokens_;
@synthesize credentials = credentials_;

#pragma mark Singleton Methods

+ (id)sharedManager{
    static myOAuthManager *sharedOAuthManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedOAuthManager = [[self alloc] init];
    });
    return sharedOAuthManager;
}

- (id)init{
    self = [super initWithBaseURL:[NSURL URLWithString:@"http://xmazon.appspaces.fr/"]];
    //initWithBaseURL:sessionConfiguration is also available
    
    if(self){
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.credentials = @{@"client_id": @"7ca51914-8590-4069-af62-f657887c4dc0", @"client_secret": @"a8e2713d651840870e9d18d6cd4ebc5ebe03ca08"};
    }
    return self;
}

- (void)dealloc{
    //Should never be called, but just here for clarity.
}

- (NSDictionary*) execRequestWithUrl:(NSString*)url params:(id)params grantType:(NSString*)type{

    NSLog(@"url : %@", url);
    __block NSDictionary* response;
    //If we fail, we repeat the request X times until we decide it's too much
    __block int count = 0;
    
    [self POST:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        response = (NSDictionary *)responseObject;
        NSLog(@"server response: %@", response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"server error: %@", error);
        count++;
    }];
    
    return response;
}

- (NSDictionary*) getOAuthTokenWithGrantType:(NSString*)type andParams:(nullable NSDictionary*)additionalParams{
    
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
        return nil;
    }

    NSString* url = [[NSURL URLWithString:@"oauth/token" relativeToURL:self.baseURL] absoluteString];

    return [self execRequestWithUrl:url params:params grantType:type];

}

- (NSDictionary*) getOAuthTokenForApp:(BOOL)refresh{
    
    NSString* grant_type = refresh ? @"client_credentials" : @"refresh_token";
    [self.oauthTokens setObject:[self getOAuthTokenWithGrantType:grant_type andParams:nil] forKey:@"app"];
    return [self.oauthTokens objectForKey:@"app"];
}

- (NSDictionary*) getOAuthTokenForUser:(BOOL)refresh{
    
    NSDictionary* additionalParams = nil;
    NSString* grant_type = refresh ? @"password" : @"refresh_token";
//    NSString* username;
//    NSString* password;

    
    if(!refresh){
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        //On récupère les valeurs dans la mémoire
//        if((username = [userDefaults valueForKey:@"username"]) && (username = [userDefaults valueForKey:@"username"])){
//            additionalParams = @{@"username": username, @"password": password};
//        }else{
//            
//            return nil;
//        }
        
        GVUser *user = [GVUser sharedUser];
        if(user.username && user.password){
            additionalParams = @{@"username": user.username, @"password": user.password};
        }else{
            return nil;
        }
    }

    [self.oauthTokens setObject:[self getOAuthTokenWithGrantType:grant_type andParams: additionalParams] forKey:@"user"];
    
    return [self.oauthTokens objectForKey:@"user"];
}

- (GVUser*) authSubscribeWithMail:(NSString*)email andPassword:(NSString*)password{
    
    NSDictionary* response;
    NSString* url = [[NSURL URLWithString:@"auth/subscribe" relativeToURL:self.baseURL] absoluteString];
    
    //Authorization Bearer + app token
    response = [self execRequestWithUrl:url params:@{@"email":email, @"password":password} header:;
    //On stocke les valeurs dans la mémoire
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setValue:[response objectForKey:@"username"] forKey:@"username"];
//    [userDefaults setValue:[response objectForKey:@"password"] forKey:@"password"];
    
    GVUser *user = [GVUser sharedUser];
    [user updateProperties:response];
    [userDefaults setObject:user forKey:@"user"];
    
    return user;
}


- (NSDictionary*) getCategoryList{
    
}
//- (BOOL) cartRemove{
//    
//}
//- (BOOL) cartAdd{
//    
//}
//- (NSDictionary*) getProductList{
//    
//}
//- (NSDictionary*) getUser{
//    
//}
//- (NSDictionary*) getStoreList{
//    
//}
//- (NSDictionary*) getOrderList{
//    
//}
//- (BOOL) orderCreate{
//    
//}

@end
