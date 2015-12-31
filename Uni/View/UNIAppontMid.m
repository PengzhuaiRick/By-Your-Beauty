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
         _myData = [NSMutableArray array];
        [_myData addObject:model];
        [self setupUI:frame];
    }
    return self;
}

-(void)setupUI:(CGRect)frame{
   

    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, KMainScreenWidth*0.05)];
    view.image =[UIImage imageNamed:@"mian_img_cellH"];
    UILabel* lab = [[UILabel alloc]initWithFrame:
                    CGRectMake(10, 2,  self.frame.size.width-10, KMainScreenWidth*0.05)];
    lab.text=@"预约项目";
    lab.textColor = [UIColor colorWithHexString:@"575757"];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.043];
    [view addSubview:lab];
    [self addSubview: view];
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), self.frame.size.width, self.frame.size.height-CGRectGetMaxY(view.frame)-40) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self addSubview:_myTableView];
    _myTableView.tableFooterView = [UIView new];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, CGRectGetMaxY(_myTableView.frame), self.frame.size.width, 35);
    [btn setTitle:@"添加项目" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor colorWithHexString:@"c2c1c0"] forState:UIControlStateNormal];
    [self addSubview:btn];
    _addProBtn = btn;
    
    UIImage* add =[UIImage imageNamed:@"appoint_img_add"];
    UIImageView* addImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2+35, 5, 25, 25)];
    addImg.image =add;
    [btn addSubview:addImg];
    
    UIImageView* view1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame),  self.frame.size.width, 5)];
    view1.image =[UIImage imageNamed:@"main_img_cellF"];
    [self addSubview:view1];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*60/320;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* name = @"cell";
    UNIMyAppointCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[NSBundle mainBundle]loadNibNamed:@"UNIMyAppointCell" owner:self options:nil].lastObject;
        if (indexPath.row>0) {
            NSMutableArray* arr = [NSMutableArray array];
            [arr sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
            cell.rightUtilityButtons = arr;
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.mainLab.textColor = [UIColor colorWithHexString:@"ee4b7c"];
        cell.mainLab.font = [UIFont boldSystemFontOfSize:13];
        
        cell.subLab.textColor = [UIColor colorWithHexString:@"c2c1c0"];
        cell.subLab.font = [UIFont boldSystemFontOfSize:13];

    }
    UNIMyProjectModel* model = _myData[indexPath.row];
    //cell.mainImg.image = [UIImage imageNamed:@"main_img_cell1"];
  //  cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [cell.mainImg sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]
                    placeholderImage:[UIImage imageNamed:@"main_img_cell1"]];
    
    cell.mainLab.text = model.projectName;
  
    
    cell.subLab.text = [NSString stringWithFormat:@"服务时长%d分钟",model.costTime];
    
    
    cell.functionBtn.hidden=YES;
    return cell;
}
#pragma mark SWTableViewCell 删除代理事件
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *cellIndexPath = [self.myTableView indexPathForCell:cell];
    [self.myData removeObjectAtIndex:cellIndexPath.row];
    [self.myTableView deleteRowsAtIndexPaths:@[cellIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)addProject:(id)model{
    //[_myData addObject:model];
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
