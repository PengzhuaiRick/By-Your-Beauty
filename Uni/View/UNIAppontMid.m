//
//  UNIAppontMid.m
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppontMid.h"
#import "UNIMyProjectModel.h"
#import "UNIAddAndDelectCell.h"
@implementation UNIAppontMid
-(id)initWithFrame:(CGRect)frame andModel:(id)model{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
         _myData = [NSMutableArray array];
        if (model)
        [_myData addObject:model];
        [self setupUI:frame];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delectTheAddProject) name:@"delectTheAddProject" object:nil];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"delectTheAddProject" object:nil];
}

-(void)setupUI:(CGRect)frame{
   
    float labX = 16;
    float labY = KMainScreenWidth>400?10:5;
    float labH = KMainScreenWidth>400?20:17;
    float labW =  KMainScreenWidth* 100/320;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab.text = @"预约项目";
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?17:14];
    [self addSubview:lab];
    self.lab1 = lab;
    
    _cellH =(frame.size.height - CGRectGetMaxY(lab.frame) - (KMainScreenWidth>400?40:25) - 10)/3;
    float tabH = _myData.count* _cellH;
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lab.frame), self.frame.size.width-20,tabH) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self addSubview:_myTableView];
    _myTableView.tableFooterView = [UIView new];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, CGRectGetMaxY(_myTableView.frame)+5, self.frame.size.width, (KMainScreenWidth>400?40:25));
    [btn setTitle:@" 添加项目" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setImage:[UIImage imageNamed:@"appoint_img_add"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:kMainBlackTitleColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth>400?17:13];
    [self addSubview:btn];
    _addProBtn = btn;
    
    CGRect selfR = self.frame;
    selfR.size.height = CGRectGetMaxY(btn.frame)+5;
    self.frame = selfR;
    
    btn = nil;lab = nil;
    
//    CALayer* lay = [CALayer layer];
//    lay.frame = CGRectMake(10, CGRectGetMinY(btn.frame), _myTableView.frame.size.width - 20, 0.5);
//    lay.backgroundColor = kMainGrayBackColor.CGColor;
//    [btn.layer addSublayer:lay];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellH;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* name = @"cell";
//    UNIAddMyAppointCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
//    if (!cell) {
//        cell =[[UNIAddMyAppointCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, _cellH) reuseIdentifier:name];
//               cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    UNIAddAndDelectCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[UNIAddAndDelectCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, _cellH) reuseIdentifier:name];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delectBtn.tag = indexPath.row;
        [[cell.delectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(UIButton* x) {
            NSLog(@"%@",x.superview);
            
            NSIndexPath *cellIndexPath = [self.myTableView indexPathForCell:(UNIAddAndDelectCell*)x.superview];
            [self.myData removeObjectAtIndex:cellIndexPath.row];
            [self.myTableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self.delegate UNIAppontMidDelegateMethod];

        }];
    }
    if (indexPath.row >0){
        cell.moveView.userInteractionEnabled = YES;
        //cell.delectBtn.enabled = YES;
    }
    else{
        cell.moveView.userInteractionEnabled = NO;
       // cell.delectBtn.enabled = NO;
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
-(void)delectTheAddProject{
    int count =(int)self.myData.count;
    for (int i=0; i<count; i++) {
        if (i>0)
            [self.myData removeLastObject];
    }
    [self.myTableView reloadData];
    [self.delegate UNIAppontMidDelegateMethod];
}


-(void)addProject:(NSArray*)modelArr{
    [self.myData addObjectsFromArray:modelArr];
    [_myTableView reloadData];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
