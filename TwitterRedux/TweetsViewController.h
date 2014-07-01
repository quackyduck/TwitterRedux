//
//  TweetsViewController.h
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/20/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RetweetCell.h"

@protocol CenterViewControllerDelegate <NSObject>

@optional
- (void)movePanelLeft;
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPositionWithTag:(NSInteger)tag;

@end

@interface TweetsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LaunchProfileDelegate>

@property (nonatomic, weak) id<CenterViewControllerDelegate> delegate;

- (id)initWIthTimelineType:(NSInteger)type;

@end
