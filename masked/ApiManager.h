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

@end
