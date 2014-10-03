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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
  [[ApiManager sharedManager] getPostsInFeed:^(NSArray *posts) {
    self.posts = posts;
    [self.tableView reloadData];
  } failure:nil];
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

- (IBAction)showUser:(id)sender {
  [self performSegueWithIdentifier:@"showUser" sender:self];
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
  NSData *data = [NSData dataWithContentsOfURL:url];
  
  [cell.userNameButton setTitle:[[post objectForKey:@"user"] objectForKey:@"name"] forState:UIControlStateNormal];
  [cell.profileImageButton setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
  cell.postImageView.image = [UIImage imageWithData:data];

  [cell.likeButton setTitle:[NSString stringWithFormat:@"Like (%d)", [[post objectForKey:@"likes"] count]] forState:UIControlStateNormal];
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
