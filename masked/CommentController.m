//
//  CommentController.m
//  masked
//
//  Created by Kelvin Tamzil on 14/09/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "CommentController.h"
#import "AnnonCommentCell.h"

@interface CommentController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *keyboardToolbar;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UITextField *addCommentField;
@property (strong, nonatomic) NSMutableArray *comments;


@end

@implementation CommentController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)textFieldFinished:(id)sender
{
//    [sender keyboardWillHide:nil];
    if (self.addCommentField.text.length == 0){
        return;
    }
    
    [self.comments addObject:@{@"text":self.addCommentField.text}];
    NSLog(@"comments array is %@", self.comments);
    self.addCommentField.text = @"";
    [self.commentTableView reloadData];
    [self.addCommentField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    self.comments = [NSMutableArray array];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect keyboardToolbarFrame = self.keyboardToolbar.frame;
    CGRect commentTableFrame = self.commentTableView.frame;
    keyboardToolbarFrame.origin.y = self.view.frame.size.height - kbSize.height - keyboardToolbarFrame.size.height;
    commentTableFrame.size.height = keyboardToolbarFrame.origin.y - self.commentTableView.frame.origin.y;
    self.commentTableView.frame = commentTableFrame;
    self.keyboardToolbar.frame = keyboardToolbarFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect keyboardToolbarframe = self.keyboardToolbar.frame;
    CGRect commentTableFrame = self.commentTableView.frame;
    keyboardToolbarframe.origin.y = self.view.frame.size.height - keyboardToolbarframe.size.height - self.tabBarController.tabBar.frame.size.height;
    commentTableFrame.size.height = keyboardToolbarframe.origin.y - self.commentTableView.frame.origin.y;
    self.keyboardToolbar.frame = keyboardToolbarframe;
    self.commentTableView.frame = commentTableFrame;
    
    [UIView commitAnimations];
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"counts %d", [self.comments count]);
    return [self.comments count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnonCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"annonCell" forIndexPath:indexPath];
    cell.annonImage.image = [UIImage imageNamed:@"image.jpg"];
    NSDictionary *comment = [self.comments objectAtIndex:indexPath.row];
    cell.annonLabel.text = [comment objectForKey:@"text"];
    return cell;
}

@end
