//
//  ViewController.h
//  WeatherExample
//
//  Created by Timothy.Obrien on 2/11/18.
//  Copyright © 2018 Timothy.Obrien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (nonatomic, strong) NSOperationQueue *imageOperationQueue;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) NSArray *jsonData;
@property (nonatomic, strong) NSArray *temperature;
@property (nonatomic, strong) NSArray *icons;

@end

