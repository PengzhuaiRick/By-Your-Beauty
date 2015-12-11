//
//  UNIGoodsCell1.m
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIGoodsCell1.h"
#import "UNIGoodsModel.h"
@implementation UNIGoodsCell1

- (void)awakeFromNib {
   
}
-(void)setupCellContentWith:(id)model{
    UNIGoodsModel* info = model;
    
    NSDictionary *attribute = @{NSFontAttributeName: self.label1.font};
    CGSize size = [info.projectName boundingRectWithSize:CGSizeMake(self.label1.frame.size.width, 200)
                                                 options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    self.label1.text = info.projectName;
    CGRect lab1Re = self.label1.frame;
    lab1Re.size = size;
    self.label1.frame = lab1Re;
    
    CGRect lab2Re = self.label2.frame;
    self.label2.frame =CGRectMake(lab2Re.origin.x,
                                  lab2Re.origin.y+(size.height - 20)/2,
                                  lab2Re.size.width,
                                  lab2Re.size.height);

    
    CGRect lab3Re = self.label3.frame;
    self.label3.frame =CGRectMake(lab3Re.origin.x,
                                  CGRectGetMaxY(self.label1.frame)+5,
                                  lab3Re.size.width,
                                  lab3Re.size.height);
    
    CGRect lab4Re = self.label4.frame;
    self.label4.frame =CGRectMake(lab4Re.origin.x,
                                  CGRectGetMaxY(self.label3.frame),
                                  lab4Re.size.width,
                                  lab4Re.size.height);
    
    CGRect lab5Re = self.label5.frame;
    self.label5.frame =CGRectMake(lab5Re.origin.x,
                                  CGRectGetMaxY(self.label4.frame),
                                  lab5Re.size.width,
                                  lab5Re.size.height);
    
    
    CGRect prideRe = self.prideBtn.frame;
    self.prideBtn.frame =CGRectMake(prideRe.origin.x,
                                  CGRectGetMaxY(self.label1.frame),
                                  prideRe.size.width,
                                  prideRe.size.height);
    
    CGRect lab6Re = self.label6.frame;
    self.label6.frame =CGRectMake(lab6Re.origin.x,
                                    CGRectGetMaxY(self.label4.frame),
                                    lab6Re.size.width,
                                    lab6Re.size.height);
    
    self.label2.text = [NSString stringWithFormat:@"￥ %d",(int)info.shopPrice];
    self.label3.text = [NSString stringWithFormat:@"[规格] %@",info.specifications];
    self.label4.text = [NSString stringWithFormat:@"[编号] %@",info.goodsCode];
    self.label5.text = [NSString stringWithFormat:@"[所属品牌] %@",info.belong];
    self.label6.text = [NSString stringWithFormat:@"销售 %d",info.sellNum];
    
    [self.prideBtn setTitle:[NSString stringWithFormat:@" %d",info.likesNum] forState:UIControlStateNormal];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
