//
//  MyRewardView.m
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MyRewardView.h"
#import "UNIRewardDetailCell.h"
@implementation MyRewardView
-(id)initWithFrame:(CGRect)frame andNum:(int)num andType:(int)ty{
    self = [super initWithFrame:frame];
    if (self) {
        type = ty;
        total = num;
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = [NSMutableArray array];
        [self setupTableView];
    }
    return self;
}
-(void)setupTableView{
    
    NSString* string = @"约满奖励";
    if (type == 2)
        string = @"准时奖励";
    
    UILabel* lab = [[UILabel alloc]initWithFrame:
                    CGRectMake(15, 10, self.frame.size.width-20 , 20)];
    lab.text=string;
    lab.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?17:14];
    [self addSubview:lab];

    CALayer* lay = [CALayer layer];
    lay.frame = CGRectMake(20, CGRectGetMaxY(lab.frame)+9, lab.frame.size.width,1);
    lay.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"].CGColor;
    [self.layer addSublayer:lay];
    
    float tabY =CGRectGetMaxY(lab.frame)+10;
    float tabH = self.frame.size.height -tabY;
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY, self.frame.size.width,tabH)
                                                   style:UITableViewStylePlain];
    tab.backgroundColor= [UIColor whiteColor];
    tab.delegate = self;
    tab.dataSource = self;
    tab.separatorStyle = 0;
    [self addSubview:tab];
    _midTableview = tab;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // return KMainScreenWidth*55/320;
    return KMainScreenWidth>400?90:80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellName=@"Cell";
    UNIRewardDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UNIRewardDetailCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width,KMainScreenWidth>400?90:80) reuseIdentifier:cellName andTpye:type];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setupCellContent:self.dataArray[indexPath.row] andType:type andTotal:total];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.delegate mainMidViewDelegataCell:type];
}

-(void)startReflashTableView:(NSArray*)arr{
    if (arr.count<1) {
        self.midTableview.hidden=YES;
        UIView* view = [[UIView alloc]initWithFrame:self.midTableview.frame];
        [self addSubview:view];
        nodataView = view;
        
        UIImageView* imgVIew = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_img_nodata3"]];
        float imgWH = KMainScreenWidth>400? 60:50,
        imgX = (view.frame.size.width - imgWH)/2,
        imgY = 15;
        imgVIew.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
        [view addSubview:imgVIew];
        
        UILabel* lab = [[UILabel alloc]init];
        lab.text=@"马上预约，即可领取丰厚豪礼！\n多约多送，抓紧机会！";
        lab.font =[UIFont systemFontOfSize:(KMainScreenWidth>400?14:12)];
        lab.lineBreakMode = 0;
        lab.numberOfLines = 0;
        lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
        [lab sizeToFit];
        float labW = lab.frame.size.width,
        labH = lab.frame.size.height,
        labX = (view.frame.size.width - labW)/2;
        
        lab.frame= CGRectMake(labX, CGRectGetMaxY(imgVIew.frame)+15, labW, labH);
        [view addSubview:lab];
        return;
    }
    NSArray* array =[arr sortedArrayUsingComparator:^NSComparisonResult(UNIMyRewardModel* obj1, UNIMyRewardModel* obj2) {
        if (obj1.rewardNum > obj2.rewardNum)
            return NSOrderedDescending;
        else
            return NSOrderedAscending;
    }];
    
    if (nodataView)
        [nodataView removeFromSuperview];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    self.midTableview.hidden=NO;
    [self.midTableview reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
