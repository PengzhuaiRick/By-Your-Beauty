//
//  UNIAppontMid.m
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppontMid.h"
#import "MainMidCell.h"
@implementation UNIAppontMid
-(void)setupUI{
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
    MainMidCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MainMidCell" owner:self options:nil].lastObject;
    }
    [cell setupCellContent:nil andType:1];
    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
