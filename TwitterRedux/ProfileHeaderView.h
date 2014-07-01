//
//  ProfileHeaderView.h
//  TwitterRedux
//
//  Created by Nicolas Melo on 7/1/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@interface ProfileHeaderView : UIView

- (void)reloadViewWithUser:(User *)user;

@end
