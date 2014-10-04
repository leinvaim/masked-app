//
//  ApiManager.m
//  masked
//
//  Created by Craig McNamara on 3/10/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "ApiManager.h"
#import "FileManager.h"

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

- (void)getRequests:(void (^)(NSArray *requests))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
  [self.manager GET:@"me/requests"
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: Couldn't get requests");
              NSLog(@"Error: %@", error);
              if(failure) {
                failure(operation, error);
              }
            }];

}

- (void)getNotifications:(void (^)(NSArray *notifications))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
  [self.manager GET:@"me/notifications"
         parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Debug: Got notifications");
              success(responseObject);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: Couldn't get notifications");
              NSLog(@"Error: %@", error);
              if(failure) {
                failure(operation, error);
              }
            }];
  
}

- (void)likePost:(NSDictionary *)post
         success:(void (^)(NSDictionary *like))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
  [self.manager POST:[NSString stringWithFormat:@"posts/%@/likes", [post objectForKey:@"id"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: Couldn't like post %@", post);
    NSLog(@"Error: %@", error);
    if(failure) {
      failure(operation, error);
    }
  }];
}

- (void)comment:(NSString *)text
           onPost:(NSDictionary *)post
        success:(void (^)(NSDictionary *like))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
  [self.manager POST:[NSString stringWithFormat:@"posts/%@/comments", [post objectForKey:@"id"]] parameters:@{@"text": text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    success(responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: Couldn't comment on post %@", post);
    NSLog(@"Error: %@", error);
    if(failure) {
      failure(operation, error);
    }
  }];
}

- (void)uploadNormalImage:(UIImage *)normalImage maskedImage:(UIImage *)maskedImage text:(NSString *)text
{
  NSString* normalPath = [[FileManager sharedManager] storeImage:normalImage asfileName:@"normal.png"];
  NSString* maskedPath = [[FileManager sharedManager] storeImage:normalImage asfileName:@"masked.png"];
  
  NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://ec2-54-206-66-123.ap-southeast-2.compute.amazonaws.com/masked/api/index.php/me/posts" parameters:@{@"text": text} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileURL:[NSURL fileURLWithPath:normalPath] name:@"normal" fileName:@"normal.png" mimeType:@"image/png" error:nil];
    
    [formData appendPartWithFileURL:[NSURL fileURLWithPath:maskedPath] name:@"masked" fileName:@"masked.png" mimeType:@"image/png" error:nil];
    
  } error:nil];
  
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  NSProgress *progress = nil;
  
  NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
    } else {
      NSLog(@"%@ %@", response, responseObject);
    }
  }];
  
  [uploadTask resume];
  
  
  [progress addObserver:self
             forKeyPath:@"fractionCompleted"
                options:NSKeyValueObservingOptionNew
                context:NULL];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"fractionCompleted"]) {
    NSProgress *progress = (NSProgress *)object;
    NSLog(@"progress = %f", progress.fractionCompleted);
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

@end
