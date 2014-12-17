//
//  WIPForecastTableViewController.h
//  Weather
//
//  Created by Pavel Votyakov on 16.12.14.
//  Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIPWeatherDelegate.h"

@interface WIPForecastTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, WIPWeatherDelegate>

@property(retain, nonatomic) WIPWeather *weather;

@end
