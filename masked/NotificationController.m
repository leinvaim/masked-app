//
//  NotificationController.m
//  masked
//
//  Created by Kelvin Tamzil on 13/09/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "NotificationController.h"
#import "RequestCell.h"
#import "NotificationCell.h"
#import "ApiManager.h"

@interface NotificationController ()
@property (nonatomic, strong) NSArray *requests;

@end

@implementation NotificationController

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
}

- (void)viewDidAppear:(BOOL)animated
{
  [[ApiManager sharedManager] getRequests:^(NSArray *requests) {
    self.requests = requests;
    [self.tableView reloadData];
  } failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0){
        return [self.requests count];
    }
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
 
    if (section == 0){
        return @"request";
    } else{
        return @"notification";
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell;
//        RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test" forIndexPath:indexPath];
//    cell = [tableView dequeueReusableCellWithIdentaifier:@"request" forIndexPath:indexPath];
    
    RequestCell *requestCell;
    NotificationCell *notifCell;
    if(indexPath.section == 0) {
        requestCell = [tableView dequeueReusableCellWithIdentifier:@"request" forIndexPath:indexPath];
        NSDictionary *request = [self.requests objectAtIndex:indexPath.row];
        requestCell.userRequestNameLabel.titleLabel.text = [[request objectForKey:@"requestor"] objectForKey:@"name"]; //request.requestor.name;
        
        requestCell.userRequestPic.imageView.image = [UIImage imageNamed:@"image.jpg"];
        cell = requestCell;
    } else {
        notifCell = [tableView dequeueReusableCellWithIdentifier:@"notification" forIndexPath:indexPath];
        notifCell.notifLabel.text = @"bla bla like your photo";
        cell = notifCell;
    }
    
    
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
