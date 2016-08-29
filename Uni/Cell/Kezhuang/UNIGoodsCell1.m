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
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    float imgX = 0;
    float imgY =0;
    float imgWH =size.width;
    UIScrollView* img = [[UIScrollView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    //img.contentSize = CGSizeMake(3*imgWH, imgWH);
    img.pagingEnabled=YES;
    img.delegate = self;
    img.scrollsToTop=NO;
    [self addSubview:img];
    self.mainImage = img;
    
    
    float btnH = KMainScreenWidth* 25/414;
    float btnW = KMainScreenWidth * 77/414;
    float btnX =size.width - 25 -btnW;
    UIButton* btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, imgWH + btnH, btnW, btnH);
    [btn setTitle:@"图文详情" forState:UIControlStateNormal];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius = 3;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = btnH/2;
    btn.layer.borderColor = [UIColor colorWithHexString:kMainPinkColor].CGColor;
    [btn setTitleColor:[UIColor colorWithHexString:kMainPinkColor] forState:UIControlStateNormal];
    btn.titleLabel.font = kWTFont(14);
    [self addSubview:btn];
    self.prideBtn = btn;
    
    float labX = 25;
    float labW = size.width - 2*labX - btnW;
    float labH =KMainScreenWidth*18/414;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, imgWH + btnH, labW, labH)];
    lab1.font = kWTFont(14);;
    lab1.lineBreakMode = 0;
    lab1.numberOfLines = 0;
    [self addSubview:lab1];
    self.label1 = lab1;
    
    
    float lab2Y =CGRectGetMaxY(lab1.frame)+15;
    float lab2W = size.width - 2*labX;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, lab2W, labH)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
//    lab2.text = @"采用世界知名化妆品牌ALBION奥碧虹的清新系列,完美护肤四步曲,打造有透明感及有弹性的肌肤.";
    lab2.lineBreakMode = 0;
    lab2.numberOfLines = 0;
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [self addSubview:lab2];
    self.label2= lab2;
    
    
    float lab3Y = imgWH - KMainScreenWidth*30/320;
    float lab3H =KMainScreenWidth*15/320;
    float lab3W = KMainScreenWidth*35/320;
    float lab3X = size.width - labX - lab3W;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab3Y, lab3W, lab3H)];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth*10/320];
    lab3.textColor = [UIColor whiteColor];
    lab3.layer.masksToBounds = YES;
    lab3.layer.cornerRadius = lab3H/2;
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
//    lab3.text = @"1/1";
    [self addSubview:lab3];
    self.label3 = lab3;

    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(0, size.height-1, size.width, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];

}


-(void)setupCellContentWith:(id)model{
    UNIGoodsModel* info = model;
    self.label1.text =info.projectName;
    [self.label1 sizeToFit];
    self.label2.text = info.effect;
    [self.label2 sizeToFit];
    CGRect lab2R = self.label2.frame;
    lab2R.origin.y = CGRectGetMaxY(self.label1.frame)+10;
    self.label2.frame = lab2R;
    
    NSArray* imgArr = [info.imgUrl componentsSeparatedByString:@","];
    float imgH = _mainImage.frame.size.height;
    float imgW = _mainImage.frame.size.width;
    
    int k = 1;
    if (imgArr.count>0)
        k = (int)imgArr.count;
    _mainImage.contentSize = CGSizeMake(k*imgW, imgH);
    
    self.label3.hidden = k<2;
    self.label3.text = [NSString stringWithFormat:@"1/%d",k];
    
    if (imgArr.count>0) {
        for (int i = 0;i<k;i++) {
           // NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgArr[i]];
            UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(i*imgW, 0, imgW, imgH)];
                   // view.image= [UIImage imageNamed:@"KZ_img_bg"];
                    //view.contentMode = UIViewContentModeScaleAspectFit;
                    [view sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] placeholderImage:[UIImage imageNamed:@"KZ_img_goodsBg"]];
                    [_mainImage addSubview:view];
                    view = nil;
        }
    }else{
        //NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,info.imgUrl];
        UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgW, imgH)];
        // view.contentMode = UIViewContentModeScaleAspectFit;
        [view sd_setImageWithURL:[NSURL URLWithString:info.imgUrl] placeholderImage:nil];
        [_mainImage addSubview:view];
         view = nil;
    }

    imgArr = nil;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float xx = scrollView.contentOffset.x;
    int k = scrollView.contentSize.width / scrollView.frame.size.width;
    int l = xx/scrollView.frame.size.width;
    self.label3.text = [NSString stringWithFormat:@"%d/%d",++l,k];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
