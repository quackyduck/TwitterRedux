//
//  TwitterContainerViewController.m
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/27/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "TwitterContainerViewController.h"
#import "TweetsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileViewController.h"
#import "User.h"

const NSInteger kMainscreenOpenOffset = 40;
const NSInteger kMainscreenClosedOffset = 0;
const double kAnimationViewTransitionDelay = 0;
const double kAnimationViewTransitionDuration = .2f;
#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4

@interface TwitterContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *edgePanGesture;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property double xOffset;
@property BOOL showingMenu;
@end

@implementation TwitterContainerViewController

- (id)initWithViewControllersMain:(UIViewController *)mainVC andMenu:(UIViewController *)menuVC {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.mainViewController = mainVC;
        self.menuViewController = menuVC;
        
        self.edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanEdgeGesture:)];
        self.edgePanGesture.minimumNumberOfTouches = 1;
        self.edgePanGesture.maximumNumberOfTouches = 1;
        [self.edgePanGesture setEdges:UIRectEdgeLeft];
        
        self.xOffset = 0;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainViewController.view.tag = CENTER_TAG;
    
    [self.contentView addSubview:self.mainViewController.view];
    [self addChildViewController:self.mainViewController];
    [self.mainViewController didMoveToParentViewController:self];
    
    self.tapGesture.enabled = NO;
    [self.contentView addGestureRecognizer:self.edgePanGesture];
//    [self.panGesture requireGestureRecognizerToFail:self.tapGesture];
    [self resetGestureRecognizers:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
    
    if (value)
    {
        [self.mainViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [self.mainViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.mainViewController.view.layer setShadowOpacity:0.8];
        [self.mainViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }
    else
    {
        [self.mainViewController.view.layer setCornerRadius:0.0f];
        [self.mainViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
    
}

- (void)resetGestureRecognizers:(BOOL)open {
    self.edgePanGesture.enabled = !open;
    self.panGesture.enabled = open;
}

- (void)resetMainViewWithTag:(NSInteger)tag {
    [self.menuViewController.view removeFromSuperview];
    [self.menuViewController removeFromParentViewController];
    
    UINavigationController* main = (UINavigationController *)self.mainViewController;
    TweetsViewController *home = (TweetsViewController *)main.topViewController;
    home.navigationItem.leftBarButtonItem.tag = 1;
    self.showingMenu = NO;
    [self showCenterViewWithShadow:NO withOffset:0];
    
    if (tag == 2) {
        ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:[[User currentUser] userId]];
        UINavigationController* nav = (UINavigationController *) self.mainViewController;
        [nav pushViewController:profileVC animated:NO];
    } else if (tag == 3) {
        TweetsViewController *tweetsVC = [[TweetsViewController alloc] initWIthTimelineType:1];
        tweetsVC.delegate = self;
        UINavigationController* nav = (UINavigationController *) self.mainViewController;
        [nav pushViewController:tweetsVC animated:NO];
    } else if (tag == 4) {
        TweetsViewController *tweetsVC = [[TweetsViewController alloc] initWIthTimelineType:0];
        tweetsVC.delegate = self;
        UINavigationController* nav = (UINavigationController *) self.mainViewController;
        [nav pushViewController:tweetsVC animated:NO];
    }
    
	
}

- (void)movePanelRight {
    NSLog(@"Moving right panel");
    UIView *childView = [self getMenuView];
    [self.contentView sendSubviewToBack:childView];
    
    [UIView animateWithDuration:kAnimationViewTransitionDuration delay:kAnimationViewTransitionDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate!
        CGRect frame = self.mainViewController.view.frame;
        frame.origin.x = [UIScreen mainScreen].bounds.size.width - kMainscreenOpenOffset;
        self.mainViewController.view.frame = frame;
    } completion:^(BOOL finished){
        if (finished) {
            UINavigationController* main = (UINavigationController *)self.mainViewController;
            TweetsViewController *home = (TweetsViewController *)main.topViewController;
            home.navigationItem.leftBarButtonItem.tag = 0;
        }
    }];
    
    [self resetGestureRecognizers:YES];
}

- (void)movePanelToOriginalPositionWithTag:(NSInteger)tag {
    [UIView animateWithDuration:kAnimationViewTransitionDuration delay:kAnimationViewTransitionDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // animate!
        CGRect frame = self.mainViewController.view.frame;
        frame.origin.x = kMainscreenClosedOffset;
        self.mainViewController.view.frame = frame;
    } completion:^(BOOL finished){
        if (finished) {
            [self resetMainViewWithTag:tag];
        }
    }];
    
    [self resetGestureRecognizers:NO];
}

- (UIView *)getMenuView {
    NSLog(@"Getting the menu now...");
    
    [self.menuViewController willMoveToParentViewController:self];
    [self.contentView addSubview:self.menuViewController.view];
    [self addChildViewController:self.menuViewController];
    [self.menuViewController didMoveToParentViewController:self];
    self.menuViewController.view.tag = LEFT_PANEL_TAG;
    self.showingMenu = YES;
    
    self.menuViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    [self showCenterViewWithShadow:YES withOffset:2];
    
    UIView *view = self.menuViewController.view;
    return view;
}

- (IBAction)didPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint touchLoc = [sender locationInView:self.contentView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.mainViewController.view.frame;
        frame.origin.x = touchLoc.x;
        self.mainViewController.view.frame = frame;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat totalWidth = [UIScreen mainScreen].bounds.size.width;
        if (self.mainViewController.view.frame.origin.x > (totalWidth/2)) {
            [self movePanelRight];
            
        } else {
            // animate closed
            [self movePanelToOriginalPositionWithTag:0];
        }
    }
}

- (IBAction)didTapGesture:(UITapGestureRecognizer *)sender {
    CGFloat totalWidth = [UIScreen mainScreen].bounds.size.width;
    CGPoint touchLoc = [sender locationInView:self.contentView];
    if (touchLoc.x >= (totalWidth - kMainscreenOpenOffset)) {
        // close the main view
        [self movePanelToOriginalPositionWithTag:0];
    }
}

- (void)didPanEdgeGesture:(UIGestureRecognizer *)sender {
    
    CGPoint touchLoc = [sender locationInView:self.contentView];
//    NSLog(@"Point (%f, %f)", touchLoc.x, touchLoc.y);
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIView *childView = [self getMenuView];
        [self.contentView sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:[(UIScreenEdgePanGestureRecognizer*)sender view]];
        
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        
        CGRect frame = self.mainViewController.view.frame;
        frame.origin.x = touchLoc.x;
        self.mainViewController.view.frame = frame;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat totalWidth = [UIScreen mainScreen].bounds.size.width;
        
        if (self.mainViewController.view.frame.origin.x > (totalWidth/2)) {
            // animate open
            [self movePanelRight];
            
        } else {
            // animate closed
            [self movePanelToOriginalPositionWithTag:0];
        }
    }
    
    
}

@end
