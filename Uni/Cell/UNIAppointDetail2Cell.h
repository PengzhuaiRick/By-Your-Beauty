//
//  UNIAppointDetail2Cell.h
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIMapAnnotation.h"
@interface UNIAppointDetail2Cell : UITableViewCell<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

-(void)setupCellContentWith:(int)state;
@end
