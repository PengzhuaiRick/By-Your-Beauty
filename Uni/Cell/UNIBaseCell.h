//
//  UNIBaseCell.h
//  Uni
//
//  Created by apple on 16/2/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIBaseCell : UITableViewCell
#pragma mark 裁剪图片
-(UIImage*)getSubImage:(CGRect)rect andImage:(UIImage*)CGImage;
#pragma mark 按指定大小缩放图片
- (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size;
@end
