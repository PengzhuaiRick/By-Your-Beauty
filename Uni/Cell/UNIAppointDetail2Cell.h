//
//  UNIAppointDetail2Cell.h
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIShopManage.h"
@interface UNIAppointDetail2Cell : UITableViewCell<MKMapViewDelegate>
@property (strong, nonatomic)  UIImageView *mainImg;
@property (strong, nonatomic)  UILabel *label1;
//@property (weak, nonatomic) IBOutlet MKMapView *mapView;
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setupCellContentWith:(int)state;
@end
