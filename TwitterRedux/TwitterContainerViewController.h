//
//  TwitterContainerViewController.h
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/27/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetsViewController.h"

@interface TwitterContainerViewController : UIViewController <CenterViewControllerDelegate>
@property (strong, nonatomic) UIViewController *mainViewController;
@property (strong, nonatomic) UIViewController *menuViewController;

- (id)initWithViewControllersMain:(UIViewController *)mainVC andMenu:(UIViewController *)menuVC;

@end
