//
//  WIPTimeViewController.m
//  Weather
//
//  Created by Pavel Votyakov on 17.12.14.
//  Copyright (c) 2014 Pavel Votyakov. All rights reserved.
//

#import "WIPTimeViewController.h"
#import "WIPTime.h"

@interface WIPTimeViewController ()
@property(weak, nonatomic) IBOutlet UILabel *fromLabel;
@property(weak, nonatomic) IBOutlet UILabel *toLabel;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UILabel *maxLabel;
@property(weak, nonatomic) IBOutlet UILabel *minLabel;
@property(weak, nonatomic) IBOutlet UILabel *windLabel;
@property(weak, nonatomic) IBOutlet UILabel *precipitationLabel;
@property(weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end

@implementation WIPTimeViewController {
@private
    __unsafe_unretained WIPTime *_time;
}

@synthesize time = _time;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH:mm"];

    _titleLabel.text = _time.title;
    _imageView.image = nil;
    _fromLabel.text = [dateFormatter stringFromDate:_time.from];
    _toLabel.text = [dateFormatter stringFromDate:_time.to];
    _minLabel.text = [NSString stringWithFormat:@"%0.0f°",_time.temperatureMin];
    _temperatureLabel.text = [NSString stringWithFormat:@"%0.0f°",_time.temperatureAvg];
    _maxLabel.text = [NSString stringWithFormat:@"%0.0f°",_time.temperatureMax];
    _windLabel.text = _time.windSpeedValue;
    _precipitationLabel.text = _time.precipitationValue;

    //todo cache imgs
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", @"http://openweathermap.org/img/w/", _time.var, @".png"]]];
        if (data) {
            UIImage *tmpImage = [[UIImage alloc] initWithData:data];
            if (tmpImage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                        _imageView.image = tmpImage;
                });
            }
        }
    });

}

@end
