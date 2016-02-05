//
//  VehicleCell.h
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/5/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionLabel;
@end
