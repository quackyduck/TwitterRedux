//
//  MenuHeaderTableViewCell.m
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/29/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "MenuHeaderTableViewCell.h"
#import "User.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@interface MenuHeaderTableViewCell()
@end

@implementation MenuHeaderTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reload {
    User *current = [User currentUser];
    self.nameLabel.text = current.name;
    self.screenNameLabel.text = current.screenName;
    
    NSLog(@"LOADING!!");
    
    NSURL *profileURL = [NSURL URLWithString:[[User currentUser] profileImageURL]];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:profileURL];
    
    [self.profileImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImageView.alpha = 0.0;
        NSLog(@"Got the menu header profile pic");
        
        UIGraphicsBeginImageContextWithOptions(self.profileImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:self.profileImageView.bounds cornerRadius:4.0] addClip];
        [image drawInRect:self.profileImageView.bounds];
        
        self.profileImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.profileImageView.alpha = 1.0;
                         }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to profile pic.");
    }];
    
    
}

@end
