//
//  BTKeyboardTool.m
//  IOS动画和事件的综合—自定义键盘
//
//  Created by songbo on 14-2-11.
//  Copyright (c) 2014年 ection. All rights reserved.
//

#import "BTKeyboardTool.h"

@implementation BTKeyboardTool

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
\
+(id)keyboardTool{
    NSArray *array= [[NSBundle mainBundle]loadNibNamed:@"BTKeyboardTool" owner:nil options:nil];
    return [array lastObject];
    
}

#pragma mark 隐藏两个按钮
-(void)dismissTwoBtn{
    [_nextBtn setTitle:@"" forState:UIControlStateNormal];
     [_preBtn setTitle:@"" forState:UIControlStateNormal];
    _nextBtn.enabled=NO;
    _preBtn.enabled=NO;
    _nextBtn=nil;
    _preBtn=nil;
    
}


#pragma mark -按钮点击事件
-(void)next{
   // NSLog(@"点击工具栏下一个");
    if ([_toolDelegate respondsToSelector:@selector(keyboardTool: buttonClick:)]) {
        [_toolDelegate keyboardTool:self buttonClick:kKeyboardToolButtonTypeNext];
    }
}

-(void)pervious
{
   // NSLog(@"点击工具栏上一个");
    if ([_toolDelegate respondsToSelector:@selector(keyboardTool: buttonClick:)]) {
        [_toolDelegate keyboardTool:self buttonClick:kKeyboardToolButtonTypePervious];
    }
}

-(void)done
{
   // NSLog(@"点击工具栏完成");
    if ([_toolDelegate respondsToSelector:@selector(keyboardTool: buttonClick:)]) {
        [_toolDelegate keyboardTool:self buttonClick:kKeyboardToolButtonTypeDone];
    }
}


@end
