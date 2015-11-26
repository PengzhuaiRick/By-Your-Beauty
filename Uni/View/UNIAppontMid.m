//
//  UNIAppontMid.m
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppontMid.h"

@implementation UNIAppontMid
-(void)setupUI{
    _myData = [NSMutableArray array];
    _myTableView.dataSource=self;
    _myTableView.delegate=self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (self.frame.size.height-30)/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* name = @"cell";
    UNIMyAppointCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[NSBundle mainBundle]loadNibNamed:@"UNIMyAppointCell" owner:self options:nil].lastObject;
        NSMutableArray* arr = [NSMutableArray array];
        [arr sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
        cell.rightUtilityButtons = arr;
        cell.delegate = self;
    }
    cell.mainImg.image = [UIImage imageNamed:@"main_img_cell1"];
  //  cell.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    cell.mainLab.text = @"WODASD";
    cell.mainLab.textColor = [UIColor colorWithHexString:@"ee4b7c"];
    cell.mainLab.font = [UIFont boldSystemFontOfSize:13];
    
    cell.subLab.text = @"NANANA";
    cell.subLab.textColor = [UIColor colorWithHexString:@"c2c1c0"];
    cell.subLab.font = [UIFont boldSystemFontOfSize:13];
    
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
    [_myData addObject:model];
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
