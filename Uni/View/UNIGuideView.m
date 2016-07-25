//
//  UNIGuideView.m
//  Uni
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIGuideView.h"

@implementation UNIGuideView

-(id)initWithClassName:(NSString*)className{
    self = [super initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    if (self) {
        self.className = className;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
        __weak UNIGuideView* myself = self;
        [[tap rac_gestureSignal]subscribeNext:^(id x) {
            if ([myself.className isEqualToString:APPOINTGUIDE1]) {
                myself.className = APPOINTGUIDE2;
                myself.mainImg.image = [myself accordingToClassNameAndScreenSize];
            }else if ([myself.className isEqualToString:APPOINTGUIDE2]){
                 [myself removeFromSuperview];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AppointGuide" object:nil];
            }
            else
                [myself removeFromSuperview];
        }];
        [self addGestureRecognizer:tap];
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.mainImg = [[UIImageView alloc]initWithFrame:self.frame];
    self.mainImg.image = [self accordingToClassNameAndScreenSize];
    [self addSubview:self.mainImg];
    
}
#pragma mark 判断是否第一次打开
+(BOOL)determineWhetherFirstTime:(NSString*)classN{
    NSUserDefaults* userDefauls = [NSUserDefaults standardUserDefaults];
    NSString* cName = [userDefauls valueForKey:classN];
    if (cName)
        return YES;
    else{
        [userDefauls setObject:classN forKey:classN];
        [userDefauls synchronize];
        return NO;
    }
}

-(UIImage*)accordingToClassNameAndScreenSize{
    int height =KMainScreenHeight;
    NSString* imgName = nil;
    switch (height) {
        case 480:{
            if ([self.className isEqualToString:MAINGUIDE])
                imgName =@"guide_main_640_920";
            
            if ([self.className isEqualToString:CARDGUIDE])
                imgName =@"guide_card_640_920";
            
            if ([self.className isEqualToString:FUNCTIONGUIDE])
                imgName =@"guide_function_640_920";
            
            if ([self.className isEqualToString:REWARDGUIDE])
                imgName =@"guide_reward_640_920";
            
            if ([self.className isEqualToString:APPOINTGUIDE1])
                imgName =@"guide_rightLeft_640_920";
            
            if ([self.className isEqualToString:APPOINTGUIDE2])
                imgName =@"guide_upDown_640_920";
            
            if ([self.className isEqualToString:APPOINTDELGUIDE])
                imgName =@"guide_appointDel_640_920";
        }  break;
        case 568:{
            if ([self.className isEqualToString:MAINGUIDE])
                imgName =@"guide_main_640_1096";
            
            if ([self.className isEqualToString:CARDGUIDE])
                imgName =@"guide_card_640_1096";
            
            if ([self.className isEqualToString:FUNCTIONGUIDE])
                imgName =@"guide_function_640_1096";
            
            if ([self.className isEqualToString:REWARDGUIDE])
                imgName =@"guide_reward_640_1096";
            
            if ([self.className isEqualToString:APPOINTGUIDE1])
                imgName =@"guide_rightLeft_640_1096";
            
            if ([self.className isEqualToString:APPOINTGUIDE2])
                imgName =@"guide_upDown_640_1096";
            
            if ([self.className isEqualToString:APPOINTDELGUIDE])
                imgName =@"guide_appointDel_640_1096";
        }
            break;
        case 667:{
            if ([self.className isEqualToString:MAINGUIDE])
                imgName =@"guide_main_750_1334";
            
            if ([self.className isEqualToString:CARDGUIDE])
                imgName =@"guide_card_750_1334";
            
            if ([self.className isEqualToString:FUNCTIONGUIDE])
                imgName =@"guide_function_750_1334";
            
            if ([self.className isEqualToString:REWARDGUIDE])
                imgName =@"guide_reward_750_1334";
            
            if ([self.className isEqualToString:APPOINTGUIDE1])
                imgName =@"guide_rightLeft_750_1334";
            
            if ([self.className isEqualToString:APPOINTGUIDE2])
                imgName =@"guide_upDown_750_1334";
            
            if ([self.className isEqualToString:APPOINTDELGUIDE])
                imgName =@"guide_appointDel_750_1334";
        }
            break;
        case 736:{
            if ([self.className isEqualToString:MAINGUIDE])
                imgName =@"guide_main_1242_2208";
            
            if ([self.className isEqualToString:CARDGUIDE])
                imgName =@"guide_card_1242_2208";
            
            if ([self.className isEqualToString:FUNCTIONGUIDE])
                imgName =@"guide_function_1242_2208";
            
            if ([self.className isEqualToString:REWARDGUIDE])
                imgName =@"guide_reward_1242_2208";
            
            if ([self.className isEqualToString:APPOINTGUIDE1])
                imgName =@"guide_rightLeft_1242_2208";
            
            if ([self.className isEqualToString:APPOINTGUIDE2])
                imgName =@"guide_upDown_1242_2208";
            
            if ([self.className isEqualToString:APPOINTDELGUIDE])
                imgName =@"guide_appointDel_1242_2208";
        }
            break;
    }
    
    return [UIImage imageNamed:imgName];
}



@end
