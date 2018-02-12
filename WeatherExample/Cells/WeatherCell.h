//
//  WeatherCell.h
//  WeatherExample
//
//  Created by Timothy.Obrien on 2/11/18.
//  Copyright © 2018 Timothy.Obrien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayOfWeek;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic)  NSCache *imagesCache;

@end
