//
//  FileManager.m
//  masked
//
//  Created by Craig McNamara on 4/10/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (id)sharedManager {
  static FileManager *sharedMyManager = nil;
  @synchronized(self) {
    if (sharedMyManager == nil)
      sharedMyManager = [[self alloc] init];
  }
  return sharedMyManager;
}

- (NSString *)storeImage:(UIImage *)image asfileName:(NSString *)fileName
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          fileName];
  NSData* normalData = UIImagePNGRepresentation(image);
  [normalData writeToFile:path atomically:YES];
  
  return path;
}


@end
