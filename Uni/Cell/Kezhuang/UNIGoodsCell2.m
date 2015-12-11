//
//  UNIGoodsCell2.m
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIGoodsCell2.h"
#import "UNIGoodsModel.h"
@implementation UNIGoodsCell2

- (void)awakeFromNib {
    // Initialization code
}

-(void)setupCellContentWith:(id)model{
   UNIGoodsModel* info = model;
    
    NSDictionary *attribute = @{NSFontAttributeName: self.label1.font};
    CGSize size = [info.effect boundingRectWithSize:CGSizeMake(self.label1.frame.size.width, 200)
                                                 options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGRect lab1Re = self.label1.frame;
    lab1Re.size = size;
    self.label1.frame = lab1Re;
    
    CGRect lab2Re = self.label2.frame;
    self.label2.frame =CGRectMake(lab2Re.origin.x,
                                  CGRectGetMaxY(self.label1.frame)+5,
                                  lab2Re.size.width,
                                  lab2Re.size.height);
    CGRect titel2Re = self.title2.frame;
    self.title2.frame =CGRectMake(titel2Re.origin.x,
                                  CGRectGetMaxY(self.label1.frame)+5,
                                  titel2Re.size.width,
                                  titel2Re.size.height);
    
    CGRect lab3Re = self.label3.frame;
    self.label3.frame =CGRectMake(lab3Re.origin.x,
                                  CGRectGetMaxY(self.label2.frame),
                                  lab3Re.size.width,
                                  lab3Re.size.height);
    
    CGRect titel3Re = self.title3.frame;
    self.title3.frame =CGRectMake(titel3Re.origin.x,
                                  CGRectGetMaxY(self.label2.frame),
                                  titel3Re.size.width,
                                  titel3Re.size.height);
    
    
    CGRect lab4Re = self.label4.frame;
    self.label4.frame =CGRectMake(lab4Re.origin.x,
                                  CGRectGetMaxY(self.label3.frame),
                                  lab4Re.size.width,
                                  lab4Re.size.height);
    CGRect titel4Re = self.title4.frame;
    self.title4.frame =CGRectMake(titel4Re.origin.x,
                                  CGRectGetMaxY(self.label3.frame),
                                  titel4Re.size.width,
                                  titel4Re.size.height);

    
    
    self.label1.text = info.effect;
    self.label2.text = info.crowd;
    self.label3.text = info.place;
    self.label4.text = info.texture;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
