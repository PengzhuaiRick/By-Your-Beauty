//
//  MainMidView.m
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMidView.h"

@implementation MainMidView

-(id)initWithFrame:(CGRect)frame headerTitle:(NSString*)string{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableviewHeader:string];
        [self setupTableviewFootView];
        [self setupTabView:frame];
        self.backgroundColor = [UIColor clearColor];
          }
    return self;
}

-(void)setupTabView:(CGRect)frame{
    if (_midTableview)
        return;
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, KMainScreenWidth*16/320, frame.size.width, tabH) style:UITableViewStylePlain];
    tab.scrollEnabled = NO;
    tab.delegate = self;
    tab.dataSource = self;
    [self addSubview:tab];
    tab.tableFooterView = [UIView new];
    _midTableview = tab;

}
#pragma mark 设置无数据页面
-(void)setupNoDataView{
    if (self.noDataView)
        return;
    
    UIView* noData = [[UIView alloc]initWithFrame:CGRectMake(0, KMainScreenWidth*16/320, self.frame.size.width, tabH)];
    noData.backgroundColor = [UIColor whiteColor];
    [self addSubview:noData];
    self.noDataView = noData;
    
    float imgWH =noData.frame.size.height*0.5;
    float imgY = (noData.frame.size.height - imgWH)/2;
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(16, imgY, imgWH, imgWH)];
    [noData addSubview:imgView];
    self.noDataImag = imgView;
    
    float lab1X = CGRectGetMaxX(imgView.frame)+20;
    float lab1W = noData.frame.size.width - lab1X - 20;
    float lab1H = 30;
    float lab1Y = noData.frame.size.height/2 - lab1H;
    UILabel* lab1 =[[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab1Y, lab1W, lab1H)];
    lab1.textColor = kMainGrayBackColor;
    lab1.font = [UIFont boldSystemFontOfSize:20];
    [noData addSubview:lab1];
    self.noDataLab1 = lab1;
    
    float lab2H = 45;
    float lab2Y = CGRectGetMaxY(lab1.frame);
    UILabel* lab2 =[[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab2Y, lab1W, lab2H)];
    lab2.font = [UIFont boldSystemFontOfSize:13];
    lab2.textColor = kMainGrayBackColor;
    lab2.lineBreakMode = NSLineBreakByWordWrapping;
    lab2.numberOfLines = 0;
    [noData addSubview:lab2];
    self.noDataLab2 = lab2;
}

-(void)setupNoDataViewSubView:(int)ty{
    if (ty == 1) {
        self.noDataLab1.text = @"已约完!";
        self.noDataLab2.text = @"忙里忙外,也要记得体贴自己!\n马上预约,来这里休憩片刻~";
        self.noDataImag.image = [UIImage imageNamed:@"main_img_nodata1"];
    }else if (ty == 2){
        self.noDataLab1.text = @"马上购买去!";
        self.noDataLab2.text = @"空空如也没关系,\n一大波超值套餐正来袭";
        self.noDataImag.image = [UIImage imageNamed:@"main_img_nodata2"];
    }
}

-(void)setupTableviewHeader:(NSString*)string{
    tabH = self.frame.size.height -KMainScreenWidth*16/320;
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, KMainScreenWidth*16/320)];
    view.image =[UIImage imageNamed:@"mian_img_cellH"];
    UILabel* lab = [[UILabel alloc]initWithFrame:
                    CGRectMake(10, 2,  self.frame.size.width-10, KMainScreenWidth*0.05)];
    lab.text=string;
    lab.textColor = [UIColor colorWithHexString:@"575757"];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.043];
    [view addSubview:lab];
    [self addSubview:view];
    self.titleLab = lab;
   // _midTableview.tableHeaderView = view;
}


-(void)setupTableviewFootView{
    float viewH = KMainScreenWidth*5/320;
    tabH-=viewH;
    float viewY = self.frame.size.height - viewH;
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewY,  self.frame.size.width,viewH)];
    view.image =[UIImage imageNamed:@"main_img_cellF"];
    [self addSubview:view];
    //_midTableview.tableFooterView = view;
    
//    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _midTableview.frame.size.width, 5)];
//    view.backgroundColor = [UIColor whiteColor];
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = 5;
//    _midTableview.tableFooterView=view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   // return KMainScreenWidth*55/320;
    return tableView.frame.size.height/2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //int n =_dataArray.count>2?2:(int)_dataArray.count;
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellName=@"Cell";
    MainMidCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
       // cell = [[NSBundle mainBundle]loadNibNamed:@"MainMidCell" owner:self options:nil].lastObject;
        cell = [[MainMidCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, tableView.frame.size.height/2) reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setupCellContent:_dataArray[indexPath.row] andType:type];
    
    if (type==2) {
        cell.handleBtn.tag = indexPath.row+10;
        [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             [self.delegate mainMidViewDelegataButton:self.dataArray[x.tag-10]];
        }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate mainMidViewDelegataCell:type];
}


-(void)startReloadData:(NSArray*)data andType:(int)type1{
    if (type1 == 1) {
        self.titleLab.text = @"我的预约";
    }
    if (type1 == 2) {
        self.titleLab.text = @"我的项目";
    }
    type=type1;
    if (data.count>0) {
        [_noDataView removeFromSuperview];
        _midTableview.hidden = NO;
        _dataArray = data;
        [_midTableview reloadData];
    }else{
        _midTableview.hidden = YES;
        [self setupNoDataView];
        [self setupNoDataViewSubView:type1];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
