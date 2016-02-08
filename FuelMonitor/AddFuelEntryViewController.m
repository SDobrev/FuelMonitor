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
    
    if(quantity <= 0 || trip <= 0 || price < 0)  {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid data"
                                                                       message:@"Quantity, trip or price cannot be < 0!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else{
    
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
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Upload Complete!"
                                                                           message:@"Successfully saved the fuel entry!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Upload Failure"
                                                                           message:[error localizedDescription]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
    }];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
