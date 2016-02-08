//
//  LoginViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/8/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
}

- (void)viewDidLayoutSubviews {
    [self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
}
@end
