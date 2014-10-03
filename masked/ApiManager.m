//
//  ApiManager.m
//  masked
//
//  Created by Craig McNamara on 3/10/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "ApiManager.h"

@interface ApiManager ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) NSDictionary *currentUser;

@end

@implementation ApiManager

+ (id)sharedManager {
  static ApiManager *sharedMyManager = nil;
  @synchronized(self) {
    if (sharedMyManager == nil)
      sharedMyManager = [[self alloc] init];
  }
  return sharedMyManager;
}

- (id)init {
  if (self = [super init]) {
    NSURL *baseUrl = [NSURL URLWithString:@"http://ec2-54-206-66-123.ap-southeast-2.compute.amazonaws.com/masked/api/index.php/"];
    self.manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:baseUrl];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
  }
  return self;
}


- (void)getPostsInFeed:(void (^)(NSArray *posts))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
 
  [self.manager GET:@"me/feed"
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: Couldn't get posts in feed");
              NSLog(@"Error: %@", error);
              if(failure) {
                failure(operation, error);
              }
            }];
}

- (void)getPostsInExplore:(void (^)(NSArray *posts))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
  [self.manager GET:@"me/explore"
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: Couldn't get posts in explore");
              NSLog(@"Error: %@", error);
              if(failure) {
                failure(operation, error);
              }
            }];
}

- (void)getPostsForUser:(NSDictionary *)user
                success:(void (^)(NSArray *posts))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
  [self.manager GET:[NSString stringWithFormat:@"users/%@/posts", [user objectForKey:@"id"]]
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: Couldn't get posts in explore");
              NSLog(@"Error: %@", error);
              if(failure) {
                failure(operation, error);
              }
            }];
}

@end
