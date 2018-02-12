//
//  ViewController.m
//  WeatherExample
//
//  Created by Timothy.Obrien on 2/11/18.
//  Copyright © 2018 Timothy.Obrien. All rights reserved.
//

#import "ViewController.h"
#import "WeatherCell.h"
@interface ViewController ()

@end


 static NSString *     IMAGE_URL_STR = @"https://openweathermap.org/img/w/";
static  NSString *     CELL_IDENTIFIER  = @"weatherIdentifier";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    UINib *cellNib = [UINib nibWithNibName:@"WeatherCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    _imageCache = [[NSCache alloc] init];
    
    
    self.imageOperationQueue = [[NSOperationQueue alloc]init];
    self.imageOperationQueue.maxConcurrentOperationCount = 5;
    
    self.imageCache = [[NSCache alloc] init];
    
    
    
    
  
    
    
    
    
    self.headerTemperature.text = @"-";
    
    [self fetchJson];
    
   
    
}


-(void) fetchJson
{
    
    ;
    
    dispatch_queue_t myQueue = dispatch_queue_create("ImageDownload",NULL);
    dispatch_async(myQueue, ^{
        
        NSError *error;
        NSString *url_string = [NSString stringWithFormat:
                                @"https://api.openweathermap.org/data/2.5/forecast/daily?q=Sunnyvale&mode=json&units=metric&cnt=16&appid=adb4503a31093fed77c0a5f39d4c512b"];
        
        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
        
        if(data)
        {
            NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            self.jsonData = json;
          _temperature =  [self.jsonData valueForKeyPath:@"list.temp.day"];
          _icons =   [self.jsonData valueForKeyPath:@"list.weather.icon"];
            
            dispatch_async(dispatch_get_main_queue(), ^{

                 [self.tableView  reloadData];
                 [self populateHeaderAddIcon];
                 [self  populateHeaderAddTemperature];
            });
        }
    });
    

   
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return  74;
    
    
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger returnVal =0;
    NSArray* list  = [self.jsonData valueForKeyPath:@"list"];
    if( list  )
    {
       returnVal =  [list count]-1;
        
    }
    
    return returnVal;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  WeatherCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
     
     if( self.jsonData)
     {
         
         
         NSArray* iconNameArray =  _icons[indexPath.row+1];
         NSString * iconName = iconNameArray.lastObject;

         NSString* imageStringURL =  [self buildURl:iconName];
         NSNumber* dayTemperature  = _temperature[indexPath.row+1];
         
         
         int temp =  [self CtoF:dayTemperature];
         
       
         cell.dayOfWeek.text = [self getNameOfDay:indexPath.row];

         cell.weatherIcon.image = nil;
         cell.tag = indexPath.row;
         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);

         dispatch_async(queue, ^(void) {
             
             
             
             NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStringURL]];
             
             
             
                                  UIImage* image = [[UIImage alloc] initWithData:imageData];
                                  if (image) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (cell.tag == indexPath.row) {
                                              cell.temperature.text =
                                              [self appendTemperatureChar: [NSString stringWithFormat:@"%d",temp] ] ;
                                              cell.weatherIcon.image = image;
                                              
                                              [cell setNeedsLayout];
                                          }
                                      });
                                  }
                                  });
    
         
     }
     
     
 return cell;
     
     
 }

- (NSString*) getNameOfDay:(long) index
{
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZoneLocal = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZoneLocal];
    NSArray *daySymbols = dateFormatter.standaloneWeekdaySymbols;
    long dayIndex = [comp weekday];
    
    
    NSString *dayName = daySymbols[(dayIndex+index) % 7];
    return dayName;
    
}

-  (int) CtoF:(NSNumber*) celcius
{
   return   (int)  ([celcius doubleValue] * 1.8) + 32;
    
}

-(NSString*) buildURl:(NSString*) iconName
{
    
    NSString* imageStringURLTemp  =  [IMAGE_URL_STR stringByAppendingString:iconName];
    NSString* imageStringURL =         [imageStringURLTemp stringByAppendingString:@".png"];
    return imageStringURL;
 
}


-(NSString*) appendTemperatureChar:(NSString*) temperature
{
    return   [temperature stringByAppendingString:@"°"];
}


-(void) populateHeaderAddTemperature
{
    NSNumber* dayTemperature  = _temperature[0];
    int temp =  [self CtoF:dayTemperature];
    NSString* temperature  = [self appendTemperatureChar: [NSString stringWithFormat:@"%d",temp] ] ;
    self.headerTemperature.text = temperature;
    
    
}

-(void) populateHeaderAddIcon
{
    NSArray* iconNameArray =  _icons[0];
    NSString * iconName = iconNameArray.lastObject;
    NSString* imageStringURL =  [self buildURl:iconName];
    
    
   
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
     dispatch_async(queue, ^(void) {
     NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStringURL]];

        UIImage* image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _headerImage.image = image;
               
            });
        }
    });
    
}



@end
