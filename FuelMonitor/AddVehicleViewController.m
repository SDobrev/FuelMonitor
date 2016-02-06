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

@interface AddVehicleViewController ()
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

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
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [_vehicleImageView setUserInteractionEnabled:YES];
    [_vehicleImageView addGestureRecognizer:singleTap];

}

-(void)tapDetected{
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
    // Create PFObject with vehicle information
    PFObject *vehicle = [PFObject objectWithClassName:@"Vehicle"];
    [vehicle setObject: self.makeTextField.text forKey:@"make"];
    [vehicle setObject: self.modelTextField.text forKey:@"model"];
    [vehicle setObject: self.yearTextField.text forKey:@"year"];

    // Recipe image
    NSData *imageData = UIImageJPEGRepresentation(_vehicleImageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", _modelTextField.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [vehicle setObject: imageFile forKey:@"imageFile"];
    
     vehicle.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the vehicle" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.vehicleImageView.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
