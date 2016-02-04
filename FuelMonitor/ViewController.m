//
//  ViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/4/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "ViewController.h"
#import <ParseUI/ParseUI.h>

@interface ViewController ()

- (IBAction)tapLogin:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapLogin:(id)sender {
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    logInViewController.delegate = self;
    [self presentViewController:logInViewController animated:YES completion:nil];
}
@end
