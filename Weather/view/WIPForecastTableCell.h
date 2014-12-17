//
//  WIPForecastTableCell.h
//  Weather
//
//  Created by Pavel Votyakov on 17.12.14.
//  Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIPForecastTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTemperatureLabel;


@end
