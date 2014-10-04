//
//  ApiManager.h
//  masked
//
//  Created by Craig McNamara on 3/10/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ApiManager : NSObject

+ (id)sharedManager;

- (void)getPostsInFeed:(void (^)(NSArray *posts))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getPostsInExplore:(void (^)(NSArray *posts))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getPostsForUser:(NSDictionary *)user
                success:(void (^)(NSArray *posts))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getRequests:(void (^)(NSArray *requests))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getNotifications:(void (^)(NSArray *notifications))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)uploadNormalImage:(UIImage *)normalImage maskedImage:(UIImage *)maskedImage text:(NSString *)text;

- (void)likePost:(NSDictionary *)post
         success:(void (^)(NSDictionary *like))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)comment:(NSString *)text
         onPost:(NSDictionary *)post
        success:(void (^)(NSDictionary *like))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
