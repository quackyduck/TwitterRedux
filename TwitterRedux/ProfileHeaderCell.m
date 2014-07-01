//
//  ProfileHeaderCell.m
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/29/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "User.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@interface ProfileHeaderCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *whiteViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;


@end

@implementation ProfileHeaderCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCellWithUser:(User *)user {
    User *current = user;
    self.nameLabel.text = current.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", current.screenName];
    
    NSURL *profileURL = [NSURL URLWithString:[current profileImageURL]];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:profileURL];
    
    [self.profileImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImageView.alpha = 0.0;
        NSLog(@"Downloaded profile image.");
        
        UIGraphicsBeginImageContextWithOptions(self.profileImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:self.profileImageView.bounds cornerRadius:4.0] addClip];
        [image drawInRect:self.profileImageView.bounds];
        
        self.profileImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.profileImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load profile item's pic.");
    }];
    
    NSURL *profileBackgroundURL = [NSURL URLWithString:[current profileBackgroundImageURL]];
    NSURLRequest *backgroundImageRequest = [NSURLRequest requestWithURL:profileBackgroundURL];
    
    [self.backgroundImageView setImageWithURLRequest:backgroundImageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.backgroundImageView.alpha = 0.0;
        NSLog(@"Downloaded background image.");
        
        UIGraphicsBeginImageContextWithOptions(self.backgroundImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:self.backgroundImageView.bounds cornerRadius:4.0] addClip];
        [image drawInRect:self.backgroundImageView.bounds];
        
        self.backgroundImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.backgroundImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load background item's pic.");
    }];
    
}

@end
