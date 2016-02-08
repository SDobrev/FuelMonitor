//
//  FuelingsViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/7/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "FuelingsViewController.h"
#import <ParseUI/ParseUI.h>
#import "DMVehicle.h"
#import "FuelingCell.h"
#import "AddFuelEntryViewController.h"

@interface FuelingsViewController ()

@end

@implementation FuelingsViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Fueling";
        
        // The key of the PFObject to display in the label of the default cell style
    //    self.textKey = @"vehicleId";
        
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
    self.title = @"Fuelings List";
    UIBarButtonItem *addFuelingBarButton = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                            target:self
                                            action:@selector(showAddFueling)];
    
    self.navigationItem.rightBarButtonItem = addFuelingBarButton;
    
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
    [query whereKey:@"vehicleId" equalTo: self.vehicleId];
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"FuelingCell";
    FuelingCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FuelingCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSNumber *price = [object objectForKey:@"price"];
    NSNumber *quantity = [object objectForKey:@"quantity"];
    NSNumber *trip = [object objectForKey:@"trip"];
    NSDate *date = [object objectForKey:@"createdAt"];
    
    NSNumber *consumption = @([quantity doubleValue] / ([trip doubleValue] /100));
    NSNumber *priceLiter = @([price integerValue] / [quantity integerValue]);
    
    [cell.contentView.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.contentView.layer setBorderWidth:1.5f];
    
    cell.tripLabel.text =[NSString stringWithFormat:@"Trip: %@", trip];
    cell.consumptionLabel.text = [NSString stringWithFormat:@"%@ l/100", consumption];
    cell.dateLabel.text = [NSString stringWithFormat:@"Date: %@", date];
    cell.priceLiterLabel.text = [NSString stringWithFormat:@"Liter price: %@", priceLiter];
    
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

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void) showAddFueling {
    NSString *objectId = self.vehicleId;
    NSString *storyBoardId = @"addFuelScene";
    
    AddFuelEntryViewController *addFuelVC = [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    addFuelVC.vehicleId = objectId;
    [self.navigationController pushViewController:addFuelVC animated:YES];
}

@end
