//
//  UNIPurChaseView.m
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIPurChaseView.h"
#import "UNIPurStyleCell.h"
@implementation UNIPurChaseView
-(id)initWithFrame:(CGRect)frame andPrice:(CGFloat)price{
    self = [super initWithFrame:frame];
    if (self) {
        gPrice = price;
        [self setupTableView];
    }
    return self;
}

-(void)setupTableView{
    float btnWH =self.frame.size.width;
    float btnY = 25;
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-btnWH-btnY) style:UITableViewStylePlain];
    tab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tab.backgroundColor= [UIColor clearColor];
    tab.scrollEnabled = NO;
    tab.delegate = self;
    tab.dataSource = self;
    [self addSubview:tab];
    _myTableview = tab;
    [self setupTableViewFooter];
    
    
    float btnX = (self.frame.size.width-btnWH)/2;
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(btnX, btnY, btnWH, btnWH);
    [btn setBackgroundImage:[UIImage imageNamed:@"appoint_btn_sure"] forState:UIControlStateNormal];
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.lineBreakMode = 0;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
    [btn setTitle:@"确定\n支付" forState:UIControlStateNormal];
    [self addSubview:btn];
}
-(void)setupTableViewFooter{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myTableview.frame.size.width, 25)];
    self.myTableview.tableFooterView = view;
    
    float labX =view.frame.size.width -100;

    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, 5, 80, 20)];
    lab1.text = [NSString stringWithFormat:@"￥%.2f",gPrice];
    lab1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    lab1.font = [UIFont boldSystemFontOfSize:13];
    [view addSubview:lab1];
    
    
    float lab2X = labX - 50;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, 5, 50, 20)];
    lab2.text = @"合计";
    lab2.font = [UIFont boldSystemFontOfSize:13];
    [view addSubview:lab2];

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cellH = 40;
    if (indexPath.row==3 ||indexPath.row == 4) {
        cellH = 55;
    }
    return cellH;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5 ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row==3 ||indexPath.row == 4) {
            UNIPurStyleCell* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIPurStyleCell" owner:self options:nil].lastObject;
            if (indexPath.row == 3) {
                cell.label1.text = @"微信支付";
                cell.label2.text = @"使用微信支付";
            }else{
                cell.label1.text = @"支付宝";
                cell.label2.text = @"使用支付宝";
            }
            return cell;
        }else{
            static NSString* name = @"cell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"请您到XX美容院领取您的宝贝";
                    cell.textLabel.textColor = [UIColor colorWithHexString:kMainThemeColor];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
                    break;
                case 1:
                    cell.textLabel.text = @"广州某街道20号";
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
                    cell.imageView.image = [UIImage imageNamed:@"function_img_cell2"];
                    break;
                case 2:
                    cell.textLabel.text = @"020-88888888";
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
                    cell.imageView.image = [UIImage imageNamed:@"function_img_cell3"];
                    break;

            }
            return cell;
        }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.delegate mainMidViewDelegataCell:type];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
