//
//  CountsCell.m
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/29/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "CountsCell.h"
#import "User.h"

@interface CountsCell()
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

@end

@implementation CountsCell

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
    self.tweetsLabel.text = [user statusCountDisplay];
    self.followingLabel.text = [user friendCountDisplay];
    self.followersLabel.text = [user followerCountDisplay];
}

@end
