//
//  UNIGuideView.h
//  Uni
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIGuideView : UIView
@property(nonatomic,copy)NSString* className;
@property(nonatomic,strong)UIImageView* mainImg;

-(id)initWithClassName:(NSString*)className;


#pragma mark 判断是否第一次打开
+(BOOL)determineWhetherFirstTime:(NSString*)classN;
@end
