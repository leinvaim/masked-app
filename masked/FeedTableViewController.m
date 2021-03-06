//
//  FeedTableViewController.m
//  masked
//
//  Created by Kelvin Tamzil on 12/09/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "FeedTableViewController.h"
#import "PostTableViewCell.h"
#import "ProfileCollectionViewController.h"
#import "ApiManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"

@interface FeedTableViewController ()
@property (strong, nonatomic) NSArray *posts;
@end

@implementation FeedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSLog(@"Debug: Getting posts");
  [[ApiManager sharedManager] getPostsInFeed:^(NSArray *posts) {
    NSLog(@"Debug: Got posts, rendering tableview");
    self.posts = posts;
    [self.tableView reloadData];
  } failure:nil];

//  [[ApiManager sharedManager] uploadNormalImage:[UIImage imageNamed:@"image.jpg"] maskedImage:[UIImage imageNamed:@"image2.jpg"]];
}

- (void)viewDidAppear:(BOOL)animated {
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"showUser"])
  {
    // Get reference to the destination view controller
    ProfileCollectionViewController *profileVC = [segue destinationViewController];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
    
    profileVC.user = [post objectForKey:@"user"];
  }
}

#pragma mark - Actions

- (IBAction)showUser:(id)sender {
  [self performSegueWithIdentifier:@"showUser" sender:self];
}

- (IBAction)likePost:(id)sender {
  CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

  NSLog(@"Debug: Liking post %ld", (long)indexPath.row);
  NSDictionary *post = [self.posts objectAtIndex:indexPath.row];

  PostTableViewCell *postCell = (PostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  [postCell.likeButton setTitle:[NSString stringWithFormat:@"Like (%lu)", ((unsigned long)[[post objectForKey:@"likes"] count]+1)] forState:UIControlStateNormal];
  
  [[ApiManager sharedManager] likePost:post success:^(NSDictionary *like) {
    NSLog(@"Debug: Increasing like button count");
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];
//      NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//  NSLog(@"Wants to like %ld", (long)indexPath.row);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
  PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"post" forIndexPath:indexPath];
  NSURL *url = [NSURL URLWithString:[post objectForKey:@"imageUrl"]];
//  NSData *data = [NSData dataWithContentsOfURL:url];
  
  [cell.userNameButton setTitle:[[post objectForKey:@"user"] objectForKey:@"name"] forState:UIControlStateNormal];
  [cell.profileImageButton setImageForState:UIControlStateNormal withURL:url];
//  [cell.profileImageButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
  [cell.postImageView setImageWithURL:url];

  [cell.likeButton setTitle:[NSString stringWithFormat:@"Like (%lu)", (unsigned long)[[post objectForKey:@"likes"] count]] forState:UIControlStateNormal];
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
