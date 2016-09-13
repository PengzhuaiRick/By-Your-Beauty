//
//  UNIGuideView.m
//  Uni
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIGuideView.h"

@implementation UNIGuideView

-(id)initWithClassName:(NSString*)className tapBlock:(GuideBlock)cn{
    self = [super initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    if (self) {
        self.className = className;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
       __weak UNIGuideView* myself = self;
        [[tap rac_gestureSignal]subscribeNext:^(id x) {
//            if ([myself.className isEqualToString:APPOINTGUIDE1]) {
//                myself.className = APPOINTGUIDE2;
//                myself.mainImg.image = [myself accordingToClassNameAndScreenSize];
//            }else if ([myself.className isEqualToString:APPOINTGUIDE2]){
//                 [myself removeFromSuperview];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"AppointGuide" object:nil];
//            }
            if (cn)
                cn(nil);
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
            if ([self.className isEqualToString:MAINGUIDE1])
                imgName =@"guide_main_640_920";
            
            if ([self.className isEqualToString:APPOINTLIST])
                imgName =@"guide_card_640_920";
            
            if ([self.className isEqualToString:FUNCTIONGUIDE1])
                imgName =@"guide_function_640_920";
            
            if ([self.className isEqualToString:REWARDGUIDE])
                imgName =@"guide_reward_640_920";
            
            if ([self.className isEqualToString:APPOINTGUIDE1])
                imgName =@"guide_rightLeft_640_920";
            
            if ([self.className isEqualToString:APPOINTGUIDE2])
                imgName =@"guide_upDown_640_920";
            
            if ([self.className isEqualToString:APPOINTGUIDE3])
                imgName =@"guide_appointDel_640_920";
        }  break;
        case 568:{
            if ([self.className isEqualToString:MAINGUIDE1])
                imgName =@"guide_main_640_1096_1";
            if ([self.className isEqualToString:MAINGUIDE2])
                imgName =@"guide_main_640_1096_2";
            if ([self.className isEqualToString:MAINGUIDE3])
                imgName =@"guide_main_640_1096_3";
            if ([self.className isEqualToString:MAINGUIDE4])
                imgName =@"guide_main_640_1096_4";
            if ([self.className isEqualToString:MAINGUIDE5])
                imgName =@"guide_main_640_1096_5";
            if ([self.className isEqualToString:MAINGUIDE6])
                imgName =@"guide_main_640_1096_6";
            if ([self.className isEqualToString:MAINGUIDE7])
                imgName =@"guide_main_640_1096_7";
            if ([self.className isEqualToString:MAINGUIDE8])
                imgName =@"guide_main_640_1096_8";
            
            
            if ([self.className isEqualToString:APPOINTLIST])
                imgName =@"guide_function_640_1096";
            
            
            if ([self.className isEqualToString:FUNCTIONGUIDE1])
                imgName =@"guide_function_640_1096_1";
            if ([self.className isEqualToString:FUNCTIONGUIDE2])
                imgName =@"guide_function_640_1096_2";
            if ([self.className isEqualToString:FUNCTIONGUIDE3])
                imgName =@"guide_function_640_1096_3";
            if ([self.className isEqualToString:FUNCTIONGUIDE4])
                imgName =@"guide_function_640_1096_4";

            
            if ([self.className isEqualToString:REWARDGUIDE])
                imgName =@"guide_reward_640_1096";
            
            
            if ([self.className isEqualToString:APPOINTGUIDE1])
                imgName =@"guide_appoint_640_1096_1";
            if ([self.className isEqualToString:APPOINTGUIDE2])
                imgName =@"guide_appoint_640_1096_2";
            if ([self.className isEqualToString:APPOINTGUIDE3])
                imgName =@"guide_appoint_640_1096_3";
            if ([self.className isEqualToString:APPOINTGUIDE4])
                imgName =@"guide_appoint_640_1096_4";
        }
            break;
        case 667:{
            if ([self.className isEqualToString:MAINGUIDE1])
                imgName =@"guide_main_750_1334_1";
            if ([self.className isEqualToString:MAINGUIDE2])
                imgName =@"guide_main_750_1334_2";
            if ([self.className isEqualToString:MAINGUIDE3])
                imgName =@"guide_main_750_1334_3";
            if ([self.className isEqualToString:MAINGUIDE4])
                imgName =@"guide_main_750_1334_4";
            if ([self.className isEqualToString:MAINGUIDE5])
                imgName =@"guide_main_750_1334_5";
            if ([self.className isEqualToString:MAINGUIDE6])
                imgName =@"guide_main_750_1334_6";
            if ([self.className isEqualToString:MAINGUIDE7])
                imgName =@"guide_main_750_1334_7";
            if ([self.className isEqualToString:MAINGUIDE8])
                imgName =@"guide_main_750_1334_8";
            
            
            if ([self.className isEqualToString:APPOINTLIST])
                imgName =@"guide_appointList_750_1334";
            
            
            if ([self.className isEqualToString:FUNCTIONGUIDE1])
                imgName =@"guide_function_750_1334_1";
            if ([self.className isEqualToString:FUNCTIONGUIDE2])
                imgName =@"guide_function_750_1334_2";
            if ([self.className isEqualToString:FUNCTIONGUIDE3])
                imgName =@"guide_function_750_1334_3";
            if ([self.className isEqualToString:FUNCTIONGUIDE4])
                imgName =@"guide_function_750_1334_4";
            
            
            if ([self.className isEqualToString:REWARDGUIDE])
                imgName =@"guide_reward_750_1334";
            
            
            if ([self.className isEqualToString:APPOINTGUIDE1])
                imgName =@"guide_appoint_750_1334_1";
            if ([self.className isEqualToString:APPOINTGUIDE2])
                imgName =@"guide_appoint_750_1334_2";
            if ([self.className isEqualToString:APPOINTGUIDE3])
                imgName =@"guide_appoint_750_1334_3";
            if ([self.className isEqualToString:APPOINTGUIDE4])
                imgName =@"guide_appoint_750_1334_4";

        }
            break;
        case 736:{
            if ([self.className isEqualToString:MAINGUIDE1])
                imgName =@"guide_main_1242_2208_1";
            if ([self.className isEqualToString:MAINGUIDE2])
                imgName =@"guide_main_1242_2208_2";
            if ([self.className isEqualToString:MAINGUIDE3])
                imgName =@"guide_main_1242_2208_3";
            if ([self.className isEqualToString:MAINGUIDE4])
                imgName =@"guide_main_1242_2208_4";
            if ([self.className isEqualToString:MAINGUIDE5])
                imgName =@"guide_main_1242_2208_5";
            if ([self.className isEqualToString:MAINGUIDE6])
                imgName =@"guide_main_1242_2208_6";
            if ([self.className isEqualToString:MAINGUIDE7])
                imgName =@"guide_main_1242_2208_7";
            if ([self.className isEqualToString:MAINGUIDE8])
                imgName =@"guide_main_1242_2208_8";
            
            if ([self.className isEqualToString:APPOINTLIST])
                imgName =@"guide_appointList_1242_2208";
            
            if ([self.className isEqualToString:FUNCTIONGUIDE1])
                imgName =@"guide_function_1242_2208_1";
            if ([self.className isEqualToString:FUNCTIONGUIDE2])
                imgName =@"guide_function_1242_2208_2";
            if ([self.className isEqualToString:FUNCTIONGUIDE3])
                imgName =@"guide_function_1242_2208_3";
            if ([self.className isEqualToString:FUNCTIONGUIDE4])
                imgName =@"guide_function_1242_2208_4";
            
            if ([self.className isEqualToString:REWARDGUIDE])
                imgName =@"guide_reward_1242_2208";
            
            if ([self.className isEqualToString:APPOINTGUIDE1])
                imgName =@"guide_appoint_1242_2208_1";
            
            if ([self.className isEqualToString:APPOINTGUIDE2])
                imgName =@"guide_appoint_1242_2208_2";
            
            if ([self.className isEqualToString:APPOINTGUIDE3])
                imgName =@"guide_appoint_1242_2208_3";
            
            if ([self.className isEqualToString:APPOINTGUIDE4])
                imgName =@"guide_appoint_1242_2208_4";
        }
            break;
    }
    
    return [UIImage imageNamed:imgName];
}



@end
