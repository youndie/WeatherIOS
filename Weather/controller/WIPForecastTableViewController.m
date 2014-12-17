//
//  WIPForecastTableViewController.m
//  Weather
//
//  Created by Pavel Votyakov on 16.12.14.
//  Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import "WIPForecastTableViewController.h"
#import "WIPWeather.h"
#import "WIPWeatherProvider.h"
#import "WIPForecast.h"
#import "WIPTime.h"
#import "WIPTimeViewController.h"
#import "WIPForecastTableCell.h"

@interface WIPForecastTableViewController ()

@end

@implementation WIPForecastTableViewController {
@private
    WIPWeather *_weather;
    WIPTime *selectedTime;
    NSDateFormatter *dateFormatter;
    NSMutableArray *days;
    NSDateFormatter *headerDateFormatter;
}

@synthesize weather = _weather;

- (void)viewDidLoad {
    [super viewDidLoad];
    days = [NSMutableArray new];
    dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH:mm"];
    [[self refreshControl] addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    if (days.count == 0) {
        [self refreshData];
    }
}

- (void)refreshData {
    [[WIPWeatherProvider providerWithDelegate:self] load];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return days.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *) days[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WIPForecastTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCell" forIndexPath:indexPath];

    WIPTime *time = ((NSArray *) days[indexPath.section])[indexPath.row];

    cell.titleLabel.text = time.title;
    cell.timeImageView.image = nil;
    cell.fromLabel.text = [dateFormatter stringFromDate:time.from];
    cell.minTemperatureLabel.text = [NSString stringWithFormat:@"%0.0f°", time.temperatureMin];
    cell.avgTemperatureLabel.text = [NSString stringWithFormat:@"%0.0f°", time.temperatureAvg];
    cell.maxTemperatureLabel.text = [NSString stringWithFormat:@"%0.0f°", time.temperatureMax];


    //todo cache imgs
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[self makePicURL:time.var]];
        if (data) {
            UIImage *tmpImage = [[UIImage alloc] initWithData:data];
            if (tmpImage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    WIPForecastTableCell *updateCell = (id) [tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.timeImageView.image = tmpImage;
                });
            }
        }
    });


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedTime = _weather.forecast.times[indexPath.row];
    [self performSegueWithIdentifier:@"ShowDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WIPTimeViewController *timeViewController = [segue destinationViewController];
    timeViewController.time = selectedTime;
    selectedTime = nil;
}

- (void)didWeatherLoadSucceed:(WIPWeather *)loadedContent {
    [self.refreshControl endRefreshing];
    self.weather = loadedContent;
    [days removeAllObjects];

    headerDateFormatter = [[NSDateFormatter alloc] init];
    [headerDateFormatter setDateFormat:@"dd MMM"];

    int currentIndex = -1;
    NSString *currentDate = @"";

    for (WIPTime *currentTime in loadedContent.forecast.times) {

        if (![currentDate isEqualToString:
                [headerDateFormatter stringFromDate:currentTime.from]]) {
            currentDate = [headerDateFormatter stringFromDate:currentTime.from];
            currentIndex++;
            days[currentIndex] = [NSMutableArray new];
        }
        [((NSMutableArray *) days[currentIndex]) addObject:currentTime];
    }


    [self.tableView reloadData];
}

- (void)didWeatherLoadFail:(NSError *)error {
    [self.refreshControl endRefreshing];
}

- (NSURL *)makePicURL:(NSString *)icon {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", @"http://openweathermap.org/img/w/", icon, @".png"]];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22; //play around with this value
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    WIPTime *time = ((NSArray *) days[section])[0];
    return [headerDateFormatter stringFromDate:time.from];
}


@end
