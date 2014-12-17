//
// Created by Pavel Votyakov on 16.12.14.
// Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WIPForecast;


@interface WIPWeather : NSObject

@property(retain, nonatomic) NSString *city;
@property(retain, nonatomic) NSString *country;
@property(nonatomic) double lat;
@property(nonatomic) double lon;
@property(retain, nonatomic) WIPForecast *forecast;

@end