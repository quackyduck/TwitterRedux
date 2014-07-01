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

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) ProfileHeaderCell *profileCell;
@property (strong, nonatomic) CountsCell *countsCell;
@property (strong, nonatomic) User *user;
@property NSInteger userId;

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
    
    [[TwitterClient sharedInstance] lookupUserWithId:self.userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Got user info %@", responseObject);
        self.user = [[User alloc] initWithDictionary:(NSDictionary *)responseObject];
        
        
        UINib *profileHeaderNib = [UINib nibWithNibName:@"ProfileHeaderView" bundle:nil];
        [self.tableView registerNib:profileHeaderNib forHeaderFooterViewReuseIdentifier:@"profileHeader"];
        NSArray *profileNibs = [profileHeaderNib instantiateWithOwner:nil options:nil];
        
        ProfileHeaderView *profileHeaderView = (ProfileHeaderView *)profileNibs[0];
        [profileHeaderView reloadViewWithUser:self.user];
        
        self.tableView.tableHeaderView = profileHeaderView;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get user data.");
    }];
    
    UINib *countsCell = [UINib nibWithNibName:@"CountsCell" bundle:nil];
    [self.tableView registerNib:countsCell forCellReuseIdentifier:@"countsCell"];
    NSArray *countsNibs = [countsCell instantiateWithOwner:nil options:nil];
    self.countsCell = countsNibs[0];
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
