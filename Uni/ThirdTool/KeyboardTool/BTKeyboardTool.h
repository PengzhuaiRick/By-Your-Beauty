//
//  BTKeyboardTool.h
//  IOS动画和事件的综合—自定义键盘
//
//  Created by songbo on 14-2-11.
//  Copyright (c) 2014年 ection. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardToolDelegate;


//枚举类型
typedef enum {
    kKeyboardToolButtonTypeNext,//下一个按钮
    kKeyboardToolButtonTypePervious,//上一个按钮
    kKeyboardToolButtonTypeDone,//完成按钮
}KeyBoardToolButtonType;

@interface BTKeyboardTool : UIToolbar
@property(nonatomic,assign)id<KeyboardToolDelegate>toolDelegate;
//直接返回一个tool给他
@property (strong, nonatomic) IBOutlet UIButton *preBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;


+(id)keyboardTool;

//写成-号码为了能连线  实现用+
-(IBAction)next;
-(IBAction)pervious;
-(IBAction)done;
-(void)dismissTwoBtn;
@end



@protocol KeyboardToolDelegate <NSObject>

-(void)keyboardTool:(BTKeyboardTool*)tool buttonClick:(KeyBoardToolButtonType)type;

@end