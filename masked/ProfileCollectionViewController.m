//
//  ProfileCollectionViewController.m
//  masked
//
//  Created by Kelvin Tamzil on 13/09/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "ProfileCollectionViewController.h"
#import "ProfileHeaderView.h"
#import "ApiManager.h"

@interface ProfileCollectionViewController ()
@property (strong, nonatomic) NSArray *posts;
@end

@implementation ProfileCollectionViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
}

- (void)setUser:(NSDictionary *)user
{
  if (_user != user) {
    _user = user;
    self.title = [user objectForKey:@"username"];
    
    // Get the users pictures from the server
    [[ApiManager sharedManager] getPostsForUser:user
                                        success:^(NSArray *posts) {
                                          self.posts = posts;
                                          [self.collectionView reloadData];
                                        } failure:nil];
    
  }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//  if([self.posts count] > 0) {
//    NSLog(@"Section 1");
//    return 1;
//  }
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  NSLog(@"Debug %lu", (unsigned long)[self.posts count]);
//    return [self.posts count];
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"imagePost";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ProfileHeaderView *header = nil;
    
    if ([kind isEqual:UICollectionElementKindSectionHeader])
    {
        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:@"profileHeader"
                                                           forIndexPath:indexPath];
        header.swappedList.titleLabel.text = @"List people";
        header.profilePic.image = [UIImage imageNamed:(@"image2.jpg")];
//        header.swappedList.text = @"hello world";
//        header.headerLabel.text = @"Car Image Gallery";
    }
    return header;
    
//    static NSString *identifier = @"profileHeader";
//    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    
//    return cell;
//    
//    //UICollectionReusableView *header = nil;
//    UICollectionReusableView *header = [UICollectionReusableView :@"profileHeader" forIndexPath:indexPath];
//    
//    if ([kind isEqual:UICollectionElementKindSectionHeader])
//    {
//        header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                    withReuseIdentifier:@"test"
//                                                           forIndexPath:indexPath];
//    }
//    return header;
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
