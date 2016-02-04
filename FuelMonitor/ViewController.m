//
//  ViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/4/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "ViewController.h"
#import "AddVehicleViewController.h"
#import <ParseUI/ParseUI.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cars List";
    
    UIBarButtonItem *loginBarButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
     target:self
     action:@selector(showLogin)];
    
    UIBarButtonItem *addVehicleBarButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:@selector(showAddVehicle)];
    
    self.navigationItem.rightBarButtonItem = addVehicleBarButton;
    self.navigationItem.leftBarButtonItem = loginBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showLogin{
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    logInViewController.delegate = self;
    [self presentViewController:logInViewController animated:YES completion:nil];
}

- (void) showAddVehicle {
    NSString *storyBoardId = @"addVehicleScene";
    AddVehicleViewController *addVehicleViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:addVehicleViewController animated:YES];
}
@end
