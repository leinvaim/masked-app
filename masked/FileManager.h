//
//  FileManager.h
//  masked
//
//  Created by Craig McNamara on 4/10/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (id)sharedManager;

- (NSString *)storeImage:(UIImage *)image asfileName:(NSString *)fileName;

@end
