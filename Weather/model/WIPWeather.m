//
// Created by Pavel Votyakov on 16.12.14.
// Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import "WIPWeather.h"
#import "WIPForecast.h"


@implementation WIPWeather {

}

- (id)init {
    if (self = [super init]) {
        self.forecast = [[WIPForecast alloc] init];
    }
    return self;
}

@end