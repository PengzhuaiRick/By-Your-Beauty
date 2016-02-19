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
    [self addSubview:img];
    self.mainImage = img;
//    for (int i = 0; i<1; i++) {
//        UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(i*imgWH, 0, imgWH, imgWH)];
//        view.image= [UIImage imageNamed:@"KZ_img_bg"];
//        [img addSubview:view];
//    }
    
    
    float labX = KMainScreenWidth*30/414;
    float labW = size.width - 2*labX;
    float labH =(size.height - imgWH)/3;
    float lab1Y = CGRectGetMaxY(img.frame);
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor blackColor];
//    lab1.text = @"ALBION清新莹润滋养护理";
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*15/320];
    lab1.lineBreakMode = 0;
    lab1.numberOfLines = 0;
    [self addSubview:lab1];
    self.label1 = lab1;
    
    float lab2Y =CGRectGetMaxY(lab1.frame);
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, labH)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
//    lab2.text = @"采用世界知名化妆品牌ALBION奥碧虹的清新系列,完美护肤四步曲,打造有透明感及有弹性的肌肤.";
    lab2.lineBreakMode = 0;
    lab2.numberOfLines = 0;
    lab2.textColor = kMainGrayBackColor;
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
    
    float btnH = labH*0.7;
    float btnY = CGRectGetMaxY(lab2.frame) + (labH - btnH)/2;
    float btnW = KMainScreenWidth* 100/320;
    UIButton* btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(labX, btnY, btnW, btnH);
    [btn setTitle:@"图文详情" forState:UIControlStateNormal];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithHexString:kMainThemeColor].CGColor;
    [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
    [self addSubview:btn];
    self.prideBtn = btn;
}


-(void)setupCellContentWith:(id)model{
    UNIGoodsModel* info = model;
    self.label1.text =info.projectName;
    self.label2.text = info.effect;
    NSArray* imgArr = [info.imgUrl componentsSeparatedByString:@","];
    float imgWH = _mainImage.frame.size.width;
    
    int k = 1;
    if (imgArr.count>0)
        k = (int)imgArr.count;
    _mainImage.contentSize = CGSizeMake(k*imgWH, imgWH);
    
    self.label3.text = [NSString stringWithFormat:@"1/%d",k];
    
    if (imgArr.count>0) {
                for (int i = 0;i<k;i++) {
            NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgArr[i]];
            UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(i*imgWH, 0, imgWH, imgWH)];
                   // view.image= [UIImage imageNamed:@"KZ_img_bg"];
                    view.contentMode = UIViewContentModeScaleAspectFit;
                    [view sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
           [_mainImage addSubview:view];
        }
    }else{
        NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,info.imgUrl];
        UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgWH, imgWH)];
         view.contentMode = UIViewContentModeScaleAspectFit;
        [view sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
        [_mainImage addSubview:view];
    }

   
    
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
