//
//  PostTableViewCell.h
//  masked
//
//  Created by Kelvin Tamzil on 12/09/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *userNameButton;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@end
