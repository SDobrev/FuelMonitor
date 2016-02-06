//
//  ViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/4/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "ViewController.h"
#import "AddVehicleViewController.h"
#import "AddFuelEntryViewController.h"
#import "CurrentPricesViewController.h"
#import <ParseUI/ParseUI.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cars List";
    

    
    UIBarButtonItem *loginBarButton;
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        loginBarButton = [[UIBarButtonItem alloc]
                          initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                          target:self
                          action:@selector(logoutUser)];
    } else {
        loginBarButton = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemAction
         target:self
         action:@selector(showLogin)];
    }

    
    UIBarButtonItem *addVehicleBarButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:@selector(showAddVehicle)];
    UIBarButtonItem *addFuelSceneBarButton = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                            target:self
                                            action:@selector(showAddFuelEntry)];
    UIBarButtonItem *currentPricesSceneBarButton = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(showCurrentPrices)];
    UIBarButtonItem *mainSceneBarButton = [[UIBarButtonItem alloc]
                                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(showMain)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addVehicleBarButton, addFuelSceneBarButton,currentPricesSceneBarButton, mainSceneBarButton, nil];
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

- (void) logoutUser{
    [PFUser logOut];
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

- (void) showAddFuelEntry {
    NSString *storyBoardId = @"addFuelScene";
    AddFuelEntryViewController *addFuelEntryViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:addFuelEntryViewController animated:YES];
}

- (void) showCurrentPrices {
    NSString *storyBoardId = @"currentPricesScene";
    CurrentPricesViewController *currentPricesViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:currentPricesViewController animated:YES];
}
- (void) showMain {
    NSString *storyBoardId = @"mainScene";
    CurrentPricesViewController *mainViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:storyBoardId];
    [self.navigationController pushViewController:mainViewController animated:YES];
}
@end
