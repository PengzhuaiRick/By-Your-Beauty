//
//  UNIGuideView.h
//  Uni
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^GuideBlock)(id model);
@interface UNIGuideView : UIView
@property(nonatomic,copy)NSString* className;
@property(nonatomic,strong)UIImageView* mainImg;

typedef void (^GuideBlock)(id model);
@property(nonatomic,copy)GuideBlock guideBlock;

-(id)initWithClassName:(NSString*)className;


#pragma mark 判断是否第一次打开
+(BOOL)determineWhetherFirstTime:(NSString*)classN;
@end
