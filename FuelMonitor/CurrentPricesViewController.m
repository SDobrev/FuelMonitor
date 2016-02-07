//
//  CurrentPricesViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/4/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "CurrentPricesViewController.h"

@interface CurrentPricesViewController ()

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
