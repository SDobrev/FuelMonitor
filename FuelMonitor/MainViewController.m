//
//  MainViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/5/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "MainViewController.h"
#import <ParseUI/ParseUI.h>
#import "DMVehicle.h"
#import "VehicleCell.h"
#import "AddVehicleViewController.h"
#import "FuelingsViewController.h"
#import "CurrentPricesViewController.h"
#import "LoginViewController.h"



@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Vehicle";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"make";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        //self.objectsPerPage = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Vehicle list";
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
        LoginViewController *logInViewController = [[LoginViewController alloc] init];
    logInViewController.delegate = self;
    [self presentViewController:logInViewController animated:YES completion:nil];
    }
    
    UIBarButtonItem *logoutBarButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Logout"
                                        style: UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(logoutUser)];
    
    UIBarButtonItem *addVehicleBarButton = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                            target:self
                                            action:@selector(showAddVehicle)];
    
    UIBarButtonItem *currentPricesBarButton = [[UIBarButtonItem alloc]
                                               initWithTitle:@"Prices"
                                               style: UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(showCurrentPrices)];
    
    self.navigationItem.leftBarButtonItem = logoutBarButton;
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects: addVehicleBarButton,currentPricesBarButton,nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];

}

- (void)refreshTable:(NSNotification *) notification
{
    [self loadObjects];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*    if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }*/
    PFUser *user = [PFUser currentUser];
        if (user) {
            [query whereKey:@"user" equalTo:user];
            [query orderByDescending:@"createdAt"];
        }
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"VehicleCell";
    VehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VehicleCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell.contentView.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.contentView.layer setBorderWidth:1.5f];
    cell.modelLabel.text = [object objectForKey:@"model"];
    cell.yearLabel.text = [object objectForKey:@"year"];
    cell.consumptionLabel.text =[object objectForKey:@"avgConsumption"];
    
    //image
    PFFile *thumbnail = [object objectForKey:@"imageFile"];
    PFImageView *thumbnailImageView = (PFImageView*)cell.cellImageView;
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.png"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *myObject = [self.objects objectAtIndex:indexPath.row];
    NSString *objectId = [myObject objectId];

    NSString *storyBoardId = @"fuelingsScene";
    
    FuelingsViewController *fuelingsVC = [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    fuelingsVC.vehicleId = objectId;
    [self.navigationController pushViewController:fuelingsVC animated:YES];
}


- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void) logoutUser{
    [PFUser logOut];
    LoginViewController *logInViewController = [[LoginViewController alloc] init];
    logInViewController.delegate = self;
    [self presentViewController:logInViewController animated:YES completion:nil];
}

- (void) showAddVehicle {
    NSString *storyBoardId = @"addVehicleScene";
    AddVehicleViewController *addVehicleViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:addVehicleViewController animated:YES];
}

- (void) showCurrentPrices {
    NSString *storyBoardId = @"currentPricesScene";
    CurrentPricesViewController *currentPricesViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:currentPricesViewController animated:YES];
}
@end
