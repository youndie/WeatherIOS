//
//  WIPWeatherProvider.m
//  Weather
//
//  Created by Pavel Votyakov on 17.12.14.
//  Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import "WIPWeatherProvider.h"
#import "WIPWeatherDelegate.h"
#import "WIPWeather.h"
#import "WIPForecast.h"
#import "WIPTime.h"

@implementation WIPWeatherProvider {
@private
    id <WIPWeatherDelegate> _delegate;
    WIPWeather *_weather;
    NSString *_currentElement;
    WIPTime *_currentTime;
    NSMutableData *_responseData;
    NSDateFormatter *_dateFormatter;


}

@synthesize delegate = _delegate;

- (instancetype)initWithDelegate:(id <WIPWeatherDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    }

    return self;
}

+ (instancetype)providerWithDelegate:(id <WIPWeatherDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate];
}

- (void)load {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/forecast?q=Yekaterinburg&mode=xml"]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


#pragma mark XMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [_delegate didWeatherLoadFail:parseError];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [_delegate didWeatherLoadSucceed:_weather];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _currentElement = elementName;
    if ([elementName isEqualToString:@"location"]) if ([attributeDict count] > 0) {
        _weather.lat = [@([attributeDict[@"latitude"] doubleValue]) doubleValue];
        _weather.lon = [@([attributeDict[@"longitude"] doubleValue]) doubleValue];
    }
    if ([elementName isEqualToString:@"sun"]) {
        _weather.forecast.sunrise = attributeDict[@"rise"];
        _weather.forecast.sunset = attributeDict[@"set"];
    }


    if ([elementName isEqualToString:@"time"]) {
        _currentTime = [[WIPTime alloc] init];
        _currentTime.from = [_dateFormatter dateFromString:
                attributeDict[@"from"]];
        _currentTime.to = [_dateFormatter dateFromString:attributeDict[@"to"]];
    }
    if ([elementName isEqualToString:@"windDirection"])
        _currentTime.windDirection = attributeDict[@"deg"];

    if ([elementName isEqualToString:@"windSpeed"])
        _currentTime.windSpeedValue = attributeDict[@"mps"];

    if ([elementName isEqualToString:@"temperature"]) {
        _currentTime.temperatureAvg = [[NSNumber numberWithInteger:[attributeDict[@"value"] floatValue]] floatValue];
        _currentTime.temperatureMin = [[NSNumber numberWithInteger:[attributeDict[@"min"] floatValue]] floatValue];
        _currentTime.temperatureMax = [[NSNumber numberWithInteger:[attributeDict[@"max"] floatValue]] floatValue];

    }

    if ([elementName isEqualToString:@"pressure"])
        _currentTime.pressure = [@([attributeDict[@"value"] doubleValue]) floatValue];

    if ([elementName isEqualToString:@"humidity"])
        _currentTime.humidity = [@([attributeDict[@"value"] integerValue]) integerValue];

    if ([elementName isEqualToString:@"symbol"]) if ([attributeDict count] > 0) {
        _currentTime.title = attributeDict[@"name"];
        _currentTime.symbolNumber = attributeDict[@"number"];
        _currentTime.var = attributeDict[@"var"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    _currentElement = nil;
    if ([elementName isEqualToString:@"time"]) {
        [_weather.forecast.times addObject:_currentTime];
        _currentTime = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([_currentElement isEqualToString:@"name"])
        _weather.city = string;
    if ([_currentElement isEqualToString:@"country"])
        _weather.country = string;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:_responseData];
    parser.delegate = self;
    _weather = [WIPWeather new];
    [parser parse];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_delegate didWeatherLoadFail:error];
}

@end
