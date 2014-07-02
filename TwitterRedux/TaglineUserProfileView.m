//
//  TaglineUserProfileView.m
//  TwitterRedux
//
//  Created by Nicolas Melo on 7/1/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "TaglineUserProfileView.h"
#import "User.h"

@interface TaglineUserProfileView()

@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;


@end

@implementation TaglineUserProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)reloadViewWithUser:(User *)user {
    self.taglineLabel.text = user.description;
}

@end
