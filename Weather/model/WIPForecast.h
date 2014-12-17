//
// Created by Pavel Votyakov on 16.12.14.
// Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WIPForecast : NSObject

@property(retain, nonatomic) NSDate *from;
@property(retain, nonatomic) NSDate *to;
@property(retain, nonatomic) NSDate *sunrise;
@property(retain, nonatomic) NSDate *sunset;
@property(retain, nonatomic) NSMutableArray *times;

@end