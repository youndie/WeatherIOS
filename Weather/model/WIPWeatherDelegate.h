//
// Created by Pavel Votyakov on 16.12.14.
// Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WIPWeather;

@protocol WIPWeatherDelegate <NSObject>

- (void)didWeatherLoadSucceed:(WIPWeather *)loadedContent;

- (void)didWeatherLoadFail:(NSError *)error;

@end