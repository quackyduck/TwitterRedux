//
//  ProfileHeaderCell.h
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/29/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface ProfileHeaderCell : UITableViewCell

- (void)reloadCellWithUser:(User *)user;

@end
