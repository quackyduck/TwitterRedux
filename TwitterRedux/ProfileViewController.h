//
//  ProfileViewController.h
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/29/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (id)initWithUserId:(NSInteger)userId;
@end
