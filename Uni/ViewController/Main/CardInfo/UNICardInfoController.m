//
//  UNICardInfoController.m
//  Uni
//  会员卡使用详情
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNICardInfoController.h"
#import "UNICardInfoCell.h"
#import "UNICardInfoRequest.h"
#import <MJRefresh/MJRefresh.h>
@interface UNICardInfoController ()<UITableViewDataSource,UITableViewDelegate>{
    int pageNum;
    UIView* topView;
    UIView* midView;
    UITableView* myTableView;
    
}
@property(nonatomic, strong)NSMutableArray* myData;
@end

@implementation UNICardInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTopview];
    [self setupTableView];
    [self startRequestInTimeInfo];
    [self startRequestCardInfo];
   
    
   }

-(void)setupNavigation{
    self.title = @"使用会员卡详情";
    self.view .backgroundColor= [UIColor colorWithHexString: kMainBackGroundColor];
    
}
#pragma mark 开始请求准时奖励信息
-(void)startRequestInTimeInfo{
    UNICardInfoRequest* request = [[UNICardInfoRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_ITRewardInfo]
                      params:nil];
    request.rqrewardBlock=^(int total,int num,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (err) {
                [YIToast showText:err.localizedDescription];
                return ;
            }
            if (total>0) {
                [self setupmidView:total and:num];
            }else
                [YIToast showText:tips];
        });
    };
}

#pragma mark 开始请求会员卡信息
-(void)startRequestCardInfo{
    UNICardInfoRequest* request = [[UNICardInfoRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_GetCardInfo]
                      params:@{@"page":@(pageNum),@"size":@(20)}];
    request.cardInfoBlock=^(NSArray* arr,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->myTableView.header endRefreshing];
            [self->myTableView.footer endRefreshing];
            if (err) {
                [YIToast showText:err.localizedDescription];
                return ;
            }
            if (arr && arr.count>0) {
                if (arr.count<20)
                    self->myTableView.footer.hidden=YES;
                else
                    self->myTableView.footer.hidden=NO;
                if (self->pageNum == 0) {
                    [self.myData removeAllObjects];
                }
                [self.myData addObjectsFromArray:arr];
                [self->myTableView reloadData];
            }else
                [YIToast showText:tips];
        });
    };
}

#pragma mark 开始加载准时奖励视图
-(void)setupTopview{
    float topX = 16;
    float topY = 64+16;
    float topW = KMainScreenWidth - topX*2;
    float topH = KMainScreenWidth* 80/320;
    UIView* top = [[UIView alloc]initWithFrame:CGRectMake(topX, topY, topW, topH)];
    [self.view addSubview:top];
    topView = top;
    
    UIImage* img = [UIImage imageNamed:@"mian_img_cellH"];
    float imgH = KMainScreenWidth* 16/320;
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topW, imgH)];
    imgView.image =img;
    [top addSubview:imgView];
    
    float labX = KMainScreenWidth*5/320;
    float labY = 0;
    float labW = topW- labX*2;
    UILabel* lab =[[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, imgH)];
    lab.text = @"准时奖励";
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth* 12/320];
    [top addSubview:lab];
    
    UIImage* img2 = [UIImage imageNamed:@"main_img_cellF"];
    float img2H = KMainScreenWidth*5/320;
    float img2Y = topH - img2H;
    UIImageView* imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, img2Y, topW, img2H)];
    imgView2.image = img2;
    [top addSubview:imgView2];
    
    float midH = topH - imgH - img2H;
    UIView * midview = [[UIView alloc]initWithFrame:CGRectMake(0, imgH, topW, midH)];
    midview.backgroundColor = [UIColor whiteColor];
    [top addSubview:midview];
    midView = midview;
    
    float btnX =labX*4;
    float btnW = topW - btnX*2;
    float btnH =KMainScreenWidth* 15/320;
    float btnY =topH - btnH;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [btn setImage:[UIImage imageNamed:@"appoint_btn_xunwen"] forState:UIControlStateNormal];
    [btn setTitle:@"准时到店满10次" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:kMainTitleColor] forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont boldSystemFontOfSize:KMainScreenWidth* 11/320];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [top addSubview:btn];

}
-(void)setupmidView:(int)total and:(int)num{
    UIImage* img3 =[UIImage imageNamed:@"main_img_proLess"];
    float jc = (midView.frame.size.width-20)/10;
    float img3H = img3.size.height*jc/img3.size.width;
    float img3Y = (midView.frame.size.height - img3H)/2;
    int bs = total/10; //倍数
    for (int i = 0; i<10; i++) {
        
        UIImageView* img = [[UIImageView alloc]initWithFrame:
                            CGRectMake(10+(jc*i),img3Y, jc,img3H)];
        if (i<num)
            img.image = [UIImage imageNamed:@"main_img_bluePro"];
        else
            img.image = img3;
        [midView addSubview:img];
        float labw =jc;
        NSString* tit = [NSString stringWithFormat:@"%i",(i+1)*bs];
        if (tit.length<2) {
            labw -= KMainScreenWidth*1/320;
        }
        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,labw,img3H)];
        lab.text = tit;
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentRight;
        lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*7/320];
        [img addSubview:lab];
    }
    
    UIImage* img4 =[UIImage imageNamed:@"card_img_ITNreward"];
    float img4W = KMainScreenWidth*20/320;
    float img4H = img4.size.height * img4W / img4.size.width;
    float img4X = midView.frame.size.width - img4W - 5;
    float img4Y =(midView.frame.size.height - img4H)/2;
    UIImageView* awardImge = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,img4W,img4H)];
        if (total ==num)
            awardImge.image = [UIImage imageNamed:@"card_img_ITreward"];
        else
            awardImge.image =img4;
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(img4X,img4Y,img4W,img4H)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:awardImge];
    [midView addSubview:view];

}

-(void)setupTableView{
    self.myData = [NSMutableArray array];
    
    float tabX = 16;
    float tabY = CGRectGetMaxY(topView.frame)+16;
    float tabW = KMainScreenWidth - tabX*2;
    float tabH = KMainScreenHeight - tabY - 16;
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    myTableView.delegate=self;
    myTableView.dataSource = self;
    myTableView.layer.masksToBounds = YES;
    myTableView.layer.cornerRadius = 5;
    [self.view addSubview:myTableView];
    
    myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->pageNum =0;
        [self startRequestCardInfo];
    }];
    //if (self.myData.count>=20) {
        myTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            ++self->pageNum;
            [self startRequestCardInfo];
        }];
   // }else
       // myTableView.footer.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth* 65/320;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UNICardInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell =[[NSBundle mainBundle]loadNibNamed:@"UNICardInfoCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setupCellContentWith:self.myData[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
