//
//  MenuViewController.m
//  TwitterRedux
//
//  Created by Nicolas Melo on 6/27/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuHeaderTableViewCell.h"
#import "User.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ProfileViewController.h"

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MenuHeaderTableViewCell *headerCell;
@end

@implementation MenuViewController

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
    NSLog(@"viewDidLoad called on MenuViewController");
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"MenuHeaderTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"menuHeaderCell"];
    NSArray *nibs = [cellNib instantiateWithOwner:nil options:nil];
    self.headerCell = nibs[0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear MenuViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 1) {
        return 91;
    }
    
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"menuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        [self.headerCell reload];
        
        return self.headerCell;
    } else if(indexPath.row == 2) {
        cell.textLabel.text = @"Profile";
        
    } else if(indexPath.row == 3) {
        cell.textLabel.text = @"Mentions";
        
    } else if(indexPath.row == 4) {
        cell.textLabel.text = @"Timeline";
        
    } else if(indexPath.row == 5) {
        cell.textLabel.text = @"Logout";
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate movePanelToOriginalPositionWithTag:indexPath.row];
    
    
}

@end
