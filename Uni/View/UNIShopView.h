//
//  UNIShopView.h
//  Uni
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIShopManage.h"
@interface UNIShopView : UIView
@property(nonatomic,strong)UILabel* nameLab;
@property(nonatomic,strong)UILabel* addressLab;
@property(nonatomic,strong)UIButton* listBtn;
@property(nonatomic,assign)int shopId;
@end
