//
//  UNIAppointDetail2Cell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetail2Cell.h"

@implementation UNIAppointDetail2Cell

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    
    float imgX = KMainScreenWidth* 16 /320;
    float imgWH =size.height/2;
    float imgY = (size.height-imgWH)/2;
    
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.image =[UIImage imageNamed:@"function_img_scell6"];
    [self addSubview:img];
    self.mainImg = img;
    
    
    float labX = CGRectGetMaxX(img.frame)+10;
    float labW = size.width - labX*2;
    float labH = size.height;
    float labY = 0;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    lab1.lineBreakMode = 0 ;
    lab1.numberOfLines = 0;
    [self addSubview:lab1];
    self.label1 = lab1;
    
    UNIShopManage* manager = [UNIShopManage getShopData];
    self.label1.text =manager.address;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

-(void)setupCellContentWith:(int)state{
    //    if (state>1) {
//        self.mapView.hidden = YES;
//    }else{
//    CLLocationCoordinate2D td =CLLocationCoordinate2DMake(manager.x.doubleValue,manager.y.doubleValue);
//    self.mapView.centerCoordinate = td;
    
//    UNIMapAnnotation * end =[[UNIMapAnnotation alloc]initWithTitle:manager.shopName andCoordinate:td];
//        [self.mapView addAnnotation:end];
//        
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(td,2000, 2000);//以td为中心，显示2000米
//    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];//适配map view的尺寸
//    [_mapView setRegion:adjustedRegion animated:YES];
//    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
