//
//  UNIBaseCell.m
//  Uni
//
//  Created by apple on 16/2/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIBaseCell.h"

@implementation UNIBaseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 裁剪图片
//-(UIImage*)getSubImage:(CGRect)rect andImage:(UIImage*)CGImage
//{
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(CGImage.CGImage, rect);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
//    
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
//    
//    return smallImage;
//}

#pragma mark 按指定大小缩放图片
- (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
