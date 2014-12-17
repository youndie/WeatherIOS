//
//  WIPWeatherProvider.h
//  Weather
//
//  Created by Pavel Votyakov on 17.12.14.
//  Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WIPWeatherDelegate;

@interface WIPWeatherProvider : NSObject <NSURLConnectionDelegate, NSXMLParserDelegate>

@property(retain, nonatomic) id <WIPWeatherDelegate> delegate;

- (instancetype)initWithDelegate:(id <WIPWeatherDelegate>)delegate;

+ (instancetype)providerWithDelegate:(id <WIPWeatherDelegate>)delegate;

- (void)load;


@end
