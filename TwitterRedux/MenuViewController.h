//
//  MenuViewController.h
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/27/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterContainerViewController.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id<CenterViewControllerDelegate> delegate;

@end
