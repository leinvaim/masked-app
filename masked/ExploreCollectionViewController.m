//
//  ExploreCollectionViewController.m
//  masked
//
//  Created by Kelvin Tamzil on 12/09/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "ExploreCollectionViewController.h"
#import "ExploreCollectionViewCell.h"
#import "ApiManager.h"

@interface ExploreCollectionViewController ()
@property (strong, nonatomic) NSArray *posts;
@end

@implementation ExploreCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[ApiManager sharedManager] getPostsInExplore:^(NSArray *posts) {
      self.posts = posts;
      [self.collectionView reloadData];
    } failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.posts count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"explore";

  ExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
  NSURL *url = [NSURL URLWithString:[post objectForKey:@"imageUrl"]];
  NSData *data = [NSData dataWithContentsOfURL:url];
  
  cell.postImageView.image = [UIImage imageWithData:data];
  //  cell.postImageView.image = [UIImage imageNamed:@"image.jpg"];
  return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
