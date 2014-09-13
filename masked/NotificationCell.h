//
//  NotificationCell.h
//  masked
//
//  Created by Kelvin Tamzil on 13/09/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *notifUserPic;
@property (weak, nonatomic) IBOutlet UIButton *notifImage;

@property (weak, nonatomic) IBOutlet UILabel *notifLabel;
@end
