//
// Created by Pavel Votyakov on 16.12.14.
// Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WIPTime : NSObject

@property(retain, nonatomic) NSDate *from;
@property(retain, nonatomic) NSDate *to;

@property(retain, nonatomic) NSString *precipitationType;
@property(retain, nonatomic) NSString *precipitationValue;

@property(retain, nonatomic) NSString *windDirection;
@property(retain, nonatomic) NSString *windSpeedName;
@property(retain, nonatomic) NSString *windSpeedValue;

@property(nonatomic) float temperatureMin;
@property(nonatomic) float temperatureAvg;
@property(nonatomic) float temperatureMax;
@property(nonatomic) float pressure;
@property(nonatomic) int humidity;

@property(retain, nonatomic) NSString *symbolNumber;
@property(retain, nonatomic) NSString *title;
@property(retain, nonatomic) NSString *var;


@end