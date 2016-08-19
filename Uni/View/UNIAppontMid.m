//
//  UNIAppontMid.m
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppontMid.h"
#import "UNIMyProjectModel.h"
//#import "UNIAddAndDelectCell.h"
#import "BaiduMobStat.h"
#import "UNIAppointCell.h"
@implementation UNIAppontMid
-(id)initWithFrame:(CGRect)frame andModel:(id)model{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
         _myData = [NSMutableArray array];
        if (model)
        [_myData addObject:model];
        [self setupUI:frame];
       
    }
    return self;
}
-(void)dealloc{

}

-(void)setupUI:(CGRect)frame{
   
    float labX = 16;
    float labY = 0;
    float labH = KMainScreenWidth*30/414;
    float labW =  KMainScreenWidth* 120/414;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab.text = @"预约项目";
    lab.font = kWTFont(15);
    [self addSubview:lab];
    self.lab1 = lab;
    
    float lab1WH =  KMainScreenWidth* 18/414;
    float lab1X = self.frame.size.width - 30 - lab1WH;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, 5, lab1WH, lab1WH)];
    lab1.backgroundColor = [UIColor colorWithHexString:kMainPinkColor];
    lab1.textColor = [UIColor whiteColor];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.text = [NSString stringWithFormat:@"%d",(int)self.myData.count];
    lab1.font = kWTFont(12);
    lab1.layer.masksToBounds=YES;
    lab1.layer.cornerRadius = lab1WH/2;
    [self addSubview:lab1];
    self.lab2 = lab1;
    
    
    float fieldH =KMainScreenWidth* 32 / 414;
    UITextField* field = [[UITextField alloc]initWithFrame:CGRectMake(labX,CGRectGetMaxY(lab.frame), self.frame.size.width-2*labX,fieldH)];
    field.hidden =_myData.count>0;
    field.placeholder = @" 填写您想预约的项目名称";
    field.layer.masksToBounds = YES;
    field.layer.cornerRadius = 3;
    field.layer.borderWidth = 1;
    field.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    field.font = [UIFont systemFontOfSize:KMainScreenWidth*15/414];
    [self addSubview:field];
    self.remarkField = field;
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate= self;
    [tool dismissTwoBtn];
    field.inputAccessoryView = tool;
    
    //_cellH =(frame.size.height - CGRectGetMaxY(lab.frame) - (KMainScreenWidth>400?40:25) - 10)/3;
    _cellH = KMainScreenWidth* 76/414;
    
    float tabY =CGRectGetMaxY(lab.frame);
    if (_myData.count <1) tabY =CGRectGetMaxY(field.frame);
    
    float tabH = _myData.count* _cellH;
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10,tabY, self.frame.size.width-20,tabH) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self addSubview:_myTableView];
    _myTableView.tableFooterView = [UIView new];
   
    CGRect selfR = self.frame;
    selfR.size.height = CGRectGetMaxY(_myTableView.frame)+5;
    self.frame = selfR;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellH;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* name = @"cell";
    UNIAppointCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[NSBundle mainBundle]loadNibNamed:@"UNIAppointCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [[cell.delectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(UIButton* x) {
            
//            NSIndexPath *cellIndexPath = [self.myTableView indexPathForCell:(UNIAppointCell*)x.superview];
//            [self.myData removeObjectAtIndex:cellIndexPath.row];
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:x.tag inSection:0];
            [self.myData removeObjectAtIndex:cellIndexPath.row];
            [self.myTableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
            self.lab2 .text = [NSString stringWithFormat:@"%d",(int)self.myData.count];
            [self.delegate UNIAppontMidDelegateMethod];
            [[BaiduMobStat defaultStat]logEvent:@"btn_delete_project_appoint" eventLabel:@"预约界面左滑删除项目"];

        }];
    }
    cell.delectBtn.tag = indexPath.row;
    if (indexPath.row == 0){
        cell.delectBtn.hidden = YES;
        if (_remarkField)
            cell.delectBtn.hidden = NO;
    }
    
    [cell setupCellContent:_myData[indexPath.row]];
    
    return cell;
}


//#pragma mark SWTableViewCell 删除代理事件
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
//    NSIndexPath *cellIndexPath = [self.myTableView indexPathForCell:cell];
//    [self.myData removeObjectAtIndex:cellIndexPath.row];
//    [self.myTableView deleteRowsAtIndexPaths:@[cellIndexPath]
//                          withRowAnimation:UITableViewRowAnimationAutomatic];
//    
//    [self.delegate UNIAppontMidDelegateMethod];
//}

#pragma mark 移除添加的项目
//-(void)delectTheAddProject{
//    int count =(int)self.myData.count;
//    for (int i=0; i<count; i++) {
//        if (i>0)
//            [self.myData removeLastObject];
//    }
//    [self.myTableView reloadData];
//    [self.delegate UNIAppontMidDelegateMethod];
//}


-(void)addProject:(NSArray*)modelArr{
   // [self.myData addObjectsFromArray:modelArr];
    self.lab2 .text = [NSString stringWithFormat:@"%d",(int)self.myData.count];
    [_myTableView reloadData];
    
}

-(void)keyboardTool:(BTKeyboardTool *)tool buttonClick:(KeyBoardToolButtonType)type{
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
