//
//  FuelingCell.h
//  FuelMonitor
//
//  Created by Stoyan Dobrev on 2/7/16.
//  Copyright © 2016 SDobrev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuelingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tripLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLiterLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
