//
//  TweetCell.h
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/21/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LaunchProfileDelegate <NSObject>
- (void)launchProfilePageWithId:(NSInteger)userId;

@end

@interface RetweetCell : UITableViewCell
@property NSInteger authorUserId;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetAttributionLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetBodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetActionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UILabel *retweetUserLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetUserImageView;
@property (weak, nonatomic) id<LaunchProfileDelegate> delegate;

@end
