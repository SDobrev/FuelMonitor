//
//  AddVehicleViewController.m
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/4/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import "AddVehicleViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import "MainViewController.h"

@interface AddVehicleViewController ()
- (IBAction)save:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *vehicleImageView;
@property (weak, nonatomic) IBOutlet UITextField *makeTextField;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *powerTextField;
@end

@implementation AddVehicleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Vehicle";
    UILongPressGestureRecognizer  *hold = [[UILongPressGestureRecognizer  alloc] initWithTarget:self action:@selector(holdDetected)];
    hold.minimumPressDuration = 1.0f;
    hold.allowableMovement = 100.f;
    [_vehicleImageView setUserInteractionEnabled:YES];
    [_vehicleImageView addGestureRecognizer:hold];

}

-(void)holdDetected{
    [self showPhotoLibary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPhotoLibary
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures from the Camera Roll album.
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    
    [self.navigationController presentModalViewController: mediaUI animated: YES];
}

- (IBAction)save:(id)sender {

    
    if([self.makeTextField.text  isEqual: @""] || self.modelTextField.text == @"")  {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid data"
                                                                       message:@"Please fill make and model!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else{
    
    // Create PFObject with vehicle information
    PFObject *vehicle = [PFObject objectWithClassName:@"Vehicle"];
    [vehicle setObject: self.makeTextField.text forKey:@"make"];
    [vehicle setObject: self.modelTextField.text forKey:@"model"];
    [vehicle setObject: self.yearTextField.text forKey:@"year"];
    PFUser *user = [PFUser currentUser];
    vehicle[@"user"] = user;
    
    // Vehicle image
    
    NSData *imageData = UIImageJPEGRepresentation(_vehicleImageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", _modelTextField.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [vehicle setObject: imageFile forKey:@"imageFile"];
    
    
//    // Show progress
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"Uploading";
//    [hud show:YES];
    
    // Upload vehicle to Parse
    [vehicle saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
 //       [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Upload Complete!"
                                                                           message:@"Successfully saved the vehicle!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];

            // Notify table view to reload the vehicles from Parse cloud
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

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.vehicleImageView.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
