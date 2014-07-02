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

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (void)reloadViewWithUser:(User *)user;

@end
