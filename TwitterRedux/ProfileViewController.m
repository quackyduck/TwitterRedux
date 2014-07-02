//
//  ProfileViewController.m
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/29/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "ProfileViewController.h"
//#import "ProfileHeaderCell.h"
#import "CountsCell.h"
#import "User.h"
#import "TwitterClient.h"
#import "ProfileHeaderView.h"
#import "MainUserProfileView.h"
#import "TaglineUserProfileView.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) ProfileHeaderCell *profileCell;
@property (strong, nonatomic) CountsCell *countsCell;
@property (strong, nonatomic) User *user;
@property NSInteger userId;
@property (strong, nonatomic) ProfileHeaderView *profileHeaderView;

@property (strong, nonatomic) NSArray *pageViews;

@end

@implementation ProfileViewController

- (id)initWithUserId:(NSInteger)userId {
    self = [self initWithNibName:nil bundle:nil];
    self.userId = userId;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *mainProfileNib = [UINib nibWithNibName:@"MainUserProfileView" bundle:nil];
    [self.tableView registerNib:mainProfileNib forHeaderFooterViewReuseIdentifier:@"mainProfileView"];
    NSArray *mainProfileNibs = [mainProfileNib instantiateWithOwner:nil options:nil];
    
    UINib *taglineProfileNib = [UINib nibWithNibName:@"TaglineUserProfileView" bundle:nil];
    [self.tableView registerNib:taglineProfileNib forHeaderFooterViewReuseIdentifier:@"taglineProfileView"];
    NSArray *taglineProfileNibs = [taglineProfileNib instantiateWithOwner:nil options:nil];

    
    MainUserProfileView *mainProfileView = mainProfileNibs[0];
    TaglineUserProfileView *taglineProfileView = taglineProfileNibs[0];
    
    self.pageViews = @[mainProfileView, taglineProfileView];
    
    
    UINib *profileHeaderNib = [UINib nibWithNibName:@"ProfileHeaderView" bundle:nil];
    [self.tableView registerNib:profileHeaderNib forHeaderFooterViewReuseIdentifier:@"profileHeader"];
    NSArray *profileNibs = [profileHeaderNib instantiateWithOwner:nil options:nil];
    
    
    NSInteger pageCount = self.pageViews.count;
    self.profileHeaderView = (ProfileHeaderView *)profileNibs[0];
    self.profileHeaderView.pageControl.currentPage = 0;
    self.profileHeaderView.pageControl.numberOfPages = pageCount;
    
    self.profileHeaderView.scrollView.delegate = self;
    
    
    [[TwitterClient sharedInstance] lookupUserWithId:self.userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got user info %@", responseObject);
        self.user = [[User alloc] initWithDictionary:(NSDictionary *)responseObject];
        
        
        
        [self.profileHeaderView reloadViewWithUser:self.user];
        
        self.tableView.tableHeaderView = self.profileHeaderView;
        
        [mainProfileView reloadViewWithUser:self.user];
        [taglineProfileView reloadViewWithUser:self.user];
        
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get user data.");
    }];
    
    UINib *countsCell = [UINib nibWithNibName:@"CountsCell" bundle:nil];
    [self.tableView registerNib:countsCell forCellReuseIdentifier:@"countsCell"];
    NSArray *countsNibs = [countsCell instantiateWithOwner:nil options:nil];
    self.countsCell = countsNibs[0];
    
    [self loadVisiblePages];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGSize pagesScrollViewSize = self.profileHeaderView.scrollView.frame.size;
    self.profileHeaderView.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageViews.count, pagesScrollViewSize.height);
    
    [self loadVisiblePages];
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.profileHeaderView.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.profileHeaderView.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.profileHeaderView.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
	// Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageViews.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }

    UIView *pageView = [self.pageViews objectAtIndex:page];
    CGRect frame = self.profileHeaderView.scrollView.bounds;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0.0f;
    frame = CGRectInset(frame, 10.0f, 0.0f);
    pageView.contentMode = UIViewContentModeScaleAspectFit;
    pageView.frame = frame;
    
    [self.profileHeaderView.scrollView addSubview:pageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height;
    [self.countsCell layoutSubviews];
    height = [self.countsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    NSLog(@"height is %f", height);
    
    return height + 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.countsCell reloadCellWithUser:self.user];
    return self.countsCell;
}

@end
