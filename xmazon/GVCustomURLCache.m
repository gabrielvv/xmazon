//
//  GVCustomURLCache.m
//  xmazon
//
//  Created by VAUTRIN on 04/03/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "GVCustomURLCache.h"

static NSString * const CustomURLCacheExpirationKey = @"CustomURLCacheExpiration";
static NSTimeInterval const CustomURLCacheExpirationInterval = 600;

@interface GVCustomURLCache ()


@end

@implementation GVCustomURLCache

+ (instancetype)standardURLCache {
    static GVCustomURLCache *_standardURLCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardURLCache = [[GVCustomURLCache alloc]
                             initWithMemoryCapacity:(2 * 1024 * 1024)
                             diskCapacity:(100 * 1024 * 1024)
                             diskPath:nil];
    });
                  
    return _standardURLCache;
}
                  
#pragma mark - NSURLCache
                  
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
  NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
  
  if (cachedResponse) {
      NSDate* cacheDate = cachedResponse.userInfo[CustomURLCacheExpirationKey];
      NSDate* cacheExpirationDate = [cacheDate dateByAddingTimeInterval:CustomURLCacheExpirationInterval];
      if ([cacheExpirationDate compare:[NSDate date]] == NSOrderedAscending) {
          [self removeCachedResponseForRequest:request];
          return nil;
      }
  }


    return cachedResponse;
}
                  
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse
forRequest:(NSURLRequest *)request
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
    userInfo[CustomURLCacheExpirationKey] = [NSDate date];

    NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:userInfo storagePolicy:cachedResponse.storagePolicy];

    [super storeCachedResponse:modifiedCachedResponse forRequest:request];
}

// Overriding the NSURLResponse before caching

//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
//                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
//    NSMutableDictionary *mutableUserInfo = [[cachedResponse userInfo] mutableCopy];
//    NSMutableData *mutableData = [[cachedResponse data] mutableCopy];
//    NSURLCacheStoragePolicy storagePolicy = NSURLCacheStorageAllowedInMemoryOnly;
//    
//    // ...
//    
//    return [[NSCachedURLResponse alloc] initWithResponse:[cachedResponse response]
//                                                    data:mutableData
//                                                userInfo:mutableUserInfo
//                                           storagePolicy:storagePolicy];
//}

// If you do not wish to cache the NSURLCachedResponse, just return nil from the delegate function:

//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
//                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
//    return nil;
//}

@end

