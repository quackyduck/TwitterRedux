//
//  ProfileHeaderView.m
//  TwitterRedux
//
//  Created by Nicolas Melo on 7/1/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "User.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@interface ProfileHeaderView()



@end

@implementation ProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reloadViewWithUser:(User *)user {
    
    User *current = user;
//    self.nameLabel.text = current.name;
//    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", current.screenName];
    
//    NSURL *profileURL = [NSURL URLWithString:[current profileImageURL]];
//    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:profileURL];
    
//    [self.profileImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        self.profileImageView.alpha = 0.0;
//        NSLog(@"Downloaded profile image.");
//        
//        UIGraphicsBeginImageContextWithOptions(self.profileImageView.bounds.size, NO, [UIScreen mainScreen].scale);
//        [[UIBezierPath bezierPathWithRoundedRect:self.profileImageView.bounds cornerRadius:4.0] addClip];
//        [image drawInRect:self.profileImageView.bounds];
//        
//        self.profileImageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             self.profileImageView.alpha = 1.0;
//                         }];
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"Failed to load profile item's pic.");
//    }];
    
    NSURL *profileBackgroundURL = [NSURL URLWithString:[current profileBackgroundImageURL]];
    NSURLRequest *backgroundImageRequest = [NSURLRequest requestWithURL:profileBackgroundURL];
    
    [self.bannerImageView setImageWithURLRequest:backgroundImageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.bannerImageView.alpha = 0.0;
        NSLog(@"Downloaded background image.");
        
        UIGraphicsBeginImageContextWithOptions(self.bannerImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:self.bannerImageView.bounds cornerRadius:4.0] addClip];
        [image drawInRect:self.bannerImageView.bounds];
        
        self.bannerImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.bannerImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load background item's pic.");
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
