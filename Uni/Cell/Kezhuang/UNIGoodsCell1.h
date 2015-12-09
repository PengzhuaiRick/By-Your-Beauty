//
//  UNIGoodsCell1.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIGoodsCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *label1; //美国爽肤精油
@property (weak, nonatomic) IBOutlet UILabel *label2; // 价格
@property (weak, nonatomic) IBOutlet UILabel *label3; //规格
@property (weak, nonatomic) IBOutlet UILabel *label4; //编号
@property (weak, nonatomic) IBOutlet UILabel *label5; //所属品牌
@property (weak, nonatomic) IBOutlet UILabel *label6; //销量
@property (weak, nonatomic) IBOutlet UIButton *prideBtn; //点赞

-(void)setupCellContentWith:(id)model;
@end
