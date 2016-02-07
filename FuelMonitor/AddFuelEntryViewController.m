//
//  AddFuelEntryViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/4/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "AddFuelEntryViewController.h"
#import <Parse/Parse.h>

@interface AddFuelEntryViewController ()
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *tripTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;


@end

@implementation AddFuelEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Fuel Entry";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    // Create PFObject with fueling information
    double quantity = (double)[self.quantityTextField.text doubleValue];
    double trip = (double)[self.tripTextField.text doubleValue];
    double price = (double)[self.priceTextField.text doubleValue];
    
    PFObject *fueling = [PFObject objectWithClassName:@"Fueling"];
    fueling[@"quantity"] = @(quantity);
    fueling[@"trip"] = @(trip);
    fueling[@"price"] = @(price);
    fueling[@"vehicleId"] = _vehicleId;
    
    // Upload fueling to Parse
    [fueling saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //       [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the fueling" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the fueling from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
