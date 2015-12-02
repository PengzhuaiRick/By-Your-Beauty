//
//  UNIAppointDetail2Cell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetail2Cell.h"

@implementation UNIAppointDetail2Cell

- (void)awakeFromNib {
    
   // float cellH = KMainScreenWidth*100/320;
    float cellW = KMainScreenWidth-16;
    
    UIImage* img = [UIImage imageNamed:@"function_img_cell2"];
    self.mainImg.image = img;
    float imgH = KMainScreenWidth*25/320;
    float imgW = imgH*img.size.width/img.size.height;
    float imgX = 8;
    float imgY = 8;
    self.mainImg.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    float labX = imgX+imgW+5;
    float labW = cellW - labX - 8;
    float labH = KMainScreenWidth* 25/320;
    
    float lab1Y = 8;
    self.label1.frame = CGRectMake(labX, lab1Y, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];

}
-(void)setupCellContentWith:(id)model{
    
    
    CLLocationCoordinate2D td =CLLocationCoordinate2DMake(37.32, -122.03);
    self.mapView.centerCoordinate = td;
    UNIMapAnnotation * end =[[UNIMapAnnotation alloc]initWithTitle:@"终点" andCoordinate:td];
    [self.mapView addAnnotation:end];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
