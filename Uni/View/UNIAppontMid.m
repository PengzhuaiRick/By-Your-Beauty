//
//  UNIAppontMid.m
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppontMid.h"
#import "UNIMyProjectModel.h"
@implementation UNIAppontMid
-(id)initWithFrame:(CGRect)frame andModel:(id)model{
    self=[super initWithFrame:frame];
    if (self) {
        _cellH =KMainScreenWidth*70/320;
        self.backgroundColor = [UIColor whiteColor];
         _myData = [NSMutableArray array];
        [_myData addObject:model];
        [self setupUI:frame];
    }
    return self;
}

-(void)setupUI:(CGRect)frame{
   
    float labX = 8;
    float labY = 5;
    float labH = KMainScreenWidth* 20/320;
    float labW =  KMainScreenWidth* 100/320;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab.text = @"预约项目";
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth*15/320];
    [self addSubview:lab];
    self.lab1 = lab;
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lab.frame), self.frame.size.width-20,_cellH*_myData.count) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self addSubview:_myTableView];
    _myTableView.tableFooterView = [UIView new];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, CGRectGetMaxY(_myTableView.frame)+5, self.frame.size.width, 35);
    [btn setTitle:@"添加项目" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setImage:[UIImage imageNamed:@"appoint_img_add"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    _addProBtn = btn;
    
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
    UNIAddMyAppointCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[UNIAddMyAppointCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, _cellH) reuseIdentifier:name];
        if (indexPath.row>0) {
            NSMutableArray* arr = [NSMutableArray array];
            [arr sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
            cell.rightUtilityButtons = arr;
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.mainLab.textColor = [UIColor colorWithHexString:kMainTitleColor];
        cell.mainLab.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
        
        cell.subLab.textColor = kMainGrayBackColor;
        cell.subLab.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];

    }
    UNIMyProjectModel* model = _myData[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,model.logoUrl];
    [cell.mainImg sd_setImageWithURL:[NSURL URLWithString:str]
                    placeholderImage:[UIImage imageNamed:@"main_img_cell1"]];
    
    cell.mainLab.text = model.projectName;
    cell.subLab.text = [NSString stringWithFormat:@"服务时长%d分钟",model.costTime];
    return cell;
}


#pragma mark SWTableViewCell 删除代理事件
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *cellIndexPath = [self.myTableView indexPathForCell:cell];
    [self.myData removeObjectAtIndex:cellIndexPath.row];
    [self.myTableView deleteRowsAtIndexPaths:@[cellIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
