//
//  ProfileCollectionViewController.m
//  masked
//
//  Created by Kelvin Tamzil on 13/09/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "ProfileCollectionViewController.h"
#import "ProfileHeaderView.h"

@interface ProfileCollectionViewController ()

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
    self.title = [user objectForKey:@"name"];
    // Get the users profile pictures from the server
    
  }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
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
