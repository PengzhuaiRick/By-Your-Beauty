//
//  UNICardInfoProgress.h
//  Uni
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNICardInfoProgress : UIView{
    CALayer* gaiLayer;
}
@property(nonatomic,assign)int num;
@property(nonatomic,assign)int total;
@property(nonatomic,strong) CAShapeLayer* progressLayer;


-(id)initWithFrame:(CGRect)frame andData:(NSArray*)data;

-(void)setProgrssLayerEndStroke:(float)num and:(float)total;
@end
