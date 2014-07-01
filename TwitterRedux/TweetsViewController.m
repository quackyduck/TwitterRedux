//
//  TweetsViewController.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/20/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "RetweetCell.h"
#import "TweetMainCell.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "User.h"
#import "ProfileViewController.h"

#import "DetailViewController.h"

const NSInteger kHomeTimeline = 0;
const NSInteger kMentionsTimeline = 1;
const NSInteger kUserTimeline = 2;

@interface TweetsViewController ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) RetweetCell *offscreenRetweetCell;
@property (strong, nonatomic) TweetMainCell *offscreenCell;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property NSInteger currentTimelineType;
@end

@implementation TweetsViewController

- (id)initWIthTimelineType:(NSInteger)type {
    self = [self initWithNibName:nil bundle:nil];
    self.currentTimelineType = type;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.tweets = [[NSMutableArray alloc] init];
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"TweetMainCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"tweetCell"];
    NSArray *nibs = [cellNib instantiateWithOwner:nil options:nil];
    self.offscreenCell = nibs[0];
    
    UINib *retweetCellNib = [UINib nibWithNibName:@"RetweetCell" bundle:nil];
    [self.tableView registerNib:retweetCellNib forCellReuseIdentifier:@"retweetCell"];
    NSArray *retweetNibs = [retweetCellNib instantiateWithOwner:nil options:nil];
    self.offscreenRetweetCell = retweetNibs[0];
    
    
    self.titleLabel.text = @"Home";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
    
    self.navigationItem.titleView = self.titleLabel;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hamburger" style:UIBarButtonItemStylePlain target:self action:@selector(onMenuOpen:)];
    self.navigationItem.leftBarButtonItem.tag = 1;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(compose:)];
    
    [[TwitterClient sharedInstance] verifyMeSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Verifying myself %@", responseObject);
        [User setCurrentUser:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get my user info %@", error);
    }];
    
    
    [self.tableView addSubview:self.refreshControl];
    
    [self refresh:self];
}

- (void)onMenuOpen:(id)sender {
    UIButton *button = sender;
    NSLog(@"Boink, button tag: %ld", (long)button.tag);
    
    switch (button.tag) {
        case 0: {
            [self.delegate movePanelToOriginalPositionWithTag:0];
            break;
        }
            
        case 1: {
            [self.delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

- (void)signOut:(id)sender {
    NSLog(@"Sign OUT!!!");
    [[TwitterClient sharedInstance] deauthorize];
    
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController.view addSubview:lvc.view];
    [self.view removeFromSuperview];
    
}

- (void)compose:(id)sender {
    
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    UIColor *color = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    nvc.navigationBar.tintColor = color;
    
    [self presentViewController:nvc animated:YES completion:nil];

}

- (void)refresh:(id)sender {
    
    if (self.currentTimelineType == kHomeTimeline) {
    
        [[TwitterClient sharedInstance] homeTimelineWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSLog(@"Timeline: %@", responseObject);
            [self.tweets removeAllObjects];
            
            for (NSDictionary *tweetData in responseObject) {
                Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetData];
                [self.tweets addObject:tweet];
            }
            
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to load Tweet timeline %@", error);
        }];
    } else if(self.currentTimelineType == kMentionsTimeline) {
        [[TwitterClient sharedInstance] mentionsTimelineWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSLog(@"Timeline: %@", responseObject);
            [self.tweets removeAllObjects];
            
            for (NSDictionary *tweetData in responseObject) {
                Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetData];
                [self.tweets addObject:tweet];
            }
            
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed to load Tweet timeline %@", error);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell forListing:(Tweet *)tweet {
    if (tweet.isRetweet) {
        // regular tweet
        RetweetCell *tweetCell = (RetweetCell *)cell;
        tweetCell.tweetBodyLabel.text = tweet.text;
        tweetCell.nameLabel.text = tweet.name;
        tweetCell.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
        tweetCell.timeLabel.text = [tweet tweetFormattedDate];
        tweetCell.retweetUserLabel.text = [NSString stringWithFormat:@"@%@ retweeted", tweet.retweetScreenName];
    }
    else {
        TweetMainCell *tweetCell = (TweetMainCell *)cell;
        tweetCell.tweetBodyLabel.text = tweet.text;
        tweetCell.nameLabel.text = tweet.name;
        tweetCell.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
        tweetCell.timeLabel.text = [tweet tweetFormattedDate];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = self.tweets[indexPath.row];
    CGFloat height;
    if (tweet.isRetweet) {
        [self configureCell:self.offscreenRetweetCell forListing:tweet];
        [self.offscreenRetweetCell layoutSubviews];
        height = [self.offscreenRetweetCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    else {
        [self configureCell:self.offscreenCell forListing:tweet];
        [self.offscreenCell layoutSubviews];
        height = [self.offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    
    
//    NSLog(@"Height of cell: %f", height);
    
    return height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Tweet *tweet = self.tweets[indexPath.row];
    if (tweet.isRetweet) {
        RetweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"retweetCell"];
        [self configureCell:cell forListing:tweet];
        cell.delegate = self;
        cell.authorUserId = tweet.authorUserId;
        
        NSURL *profileURL = [NSURL URLWithString:tweet.profileURL];
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:profileURL];
        
//        NSLog(@"Download image from %@", tweet.profileURL);
        
        [cell.profileImageView.imageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            cell.profileImageView.alpha = 0.0;
//            NSLog(@"Downloaded profile image.");
            
            UIGraphicsBeginImageContextWithOptions(cell.profileImageView.bounds.size, NO, [UIScreen mainScreen].scale);
            [[UIBezierPath bezierPathWithRoundedRect:cell.profileImageView.bounds cornerRadius:4.0] addClip];
            [image drawInRect:cell.profileImageView.bounds];
            
            UIImage *profileImage = UIGraphicsGetImageFromCurrentImageContext();
            [cell.profileImageView setBackgroundImage:profileImage forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.25
                             animations:^{
                                 cell.profileImageView.alpha = 1.0;
                             }];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Failed to load Yelp item's pic.");
        }];
        
        return cell;
    }

    TweetMainCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    [self configureCell:cell forListing:tweet];
    
    NSURL *profileURL = [NSURL URLWithString:tweet.profileURL];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:profileURL];
    
//    NSLog(@"Download image from %@", tweet.profileURL);
    
    [cell.profileImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.profileImageView.alpha = 0.0;
//        NSLog(@"Downloaded profile image.");
        
        UIGraphicsBeginImageContextWithOptions(cell.profileImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:cell.profileImageView.bounds cornerRadius:4.0] addClip];
        [image drawInRect:cell.profileImageView.bounds];
        
        cell.profileImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             cell.profileImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load Yelp item's pic.");
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *dvc = [[DetailViewController alloc] initWithTweet:self.tweets[indexPath.row]];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)launchProfilePageWithId:(NSInteger)userId {
    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:profileVC animated:YES];
}


@end
