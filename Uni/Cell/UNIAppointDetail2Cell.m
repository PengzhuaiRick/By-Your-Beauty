//
//  UNIAppointDetail2Cell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetail2Cell.h"
#import "UNIShopManage.h"
@implementation UNIAppointDetail2Cell

- (void)awakeFromNib {
    
    float cellH = KMainScreenWidth*220/320;
    float cellW = KMainScreenWidth-32;
    
    UIImage* img = [UIImage imageNamed:@"function_img_cell2"];
    self.mainImg.image = img;
    float imgH = KMainScreenWidth*18/320;
    float imgW = imgH*img.size.width/img.size.height;
    float imgX = 20;
    float imgY = 5;
    self.mainImg.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    float labX = imgX+imgW+5;
    float labW = cellW - labX - 8;
    float labH = KMainScreenWidth* 18/320;

    self.label1.frame = CGRectMake(labX, imgY, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
    
    float mapY = imgY+imgH+8;
    float mapW = cellW - imgX*2;
    float mapH = cellH - imgY - imgH - 16;
    self.mapView.frame = CGRectMake(imgX, mapY, mapW, mapH);

}
-(void)setupCellContentWith:(int)state{
    UNIShopManage* manager = [UNIShopManage getShopData];
    self.label1.text =manager.address;
    if (state>1) {
        self.mapView.hidden = YES;
    }else{
    CLLocationCoordinate2D td =CLLocationCoordinate2DMake(manager.x.doubleValue,manager.y.doubleValue);
    self.mapView.centerCoordinate = td;
        
    UNIMapAnnotation * end =[[UNIMapAnnotation alloc]initWithTitle:manager.shopName andCoordinate:td];
        [self.mapView addAnnotation:end];
        
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(td,2000, 2000);//以td为中心，显示2000米
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
    [_mapView setRegion:adjustedRegion animated:YES];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
