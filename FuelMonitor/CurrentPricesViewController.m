//
//  CurrentPricesViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/4/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "CurrentPricesViewController.h"
#import "FuelMonitor-Swift.h"


@interface CurrentPricesViewController ()
- (IBAction)getPrices:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *dieselTextField;
@property (weak, nonatomic) IBOutlet UILabel *gasolineTextField;
@property (weak, nonatomic) IBOutlet UILabel *lpgTextField;
@property (weak, nonatomic) IBOutlet UILabel *methaneTextField;

@end

@implementation CurrentPricesViewController
//http://fuelo.net/api/price?key=beb5cdf4554ce11&fuel=gasoline

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Current Prices";
    self.dieselTextField.text = @"1.78";
    self.gasolineTextField.text = @"1.82";
    self.lpgTextField.text = @"0.88";
    self.methaneTextField.text = @"1.58";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getPrices:(id)sender {
    HttpData *prices = [[HttpData alloc] init];
    NSString *gasoline = @"gasoline";
    [prices httpRequest:gasoline];
}

@end
