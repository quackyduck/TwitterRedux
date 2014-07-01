//
//  MenuHeaderTableViewCell.h
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/29/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
- (void)reload;

@end
