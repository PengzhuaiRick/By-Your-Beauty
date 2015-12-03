//
//  UNICardInfoController.m
//  Uni
//  会员卡使用详情
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNICardInfoController.h"
#import "UNICardInfoCell.h"
@interface UNICardInfoController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView* topView;
    UITableView* myTableView;
}

@end

@implementation UNICardInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTopview];
    [self setupTableView];
}
-(void)setupNavigation{
    self.title = @"使用会员卡详情";
    self.view .backgroundColor= [UIColor colorWithHexString: kMainBackGroundColor];
    
}

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

    
    UIImage* img3 =[UIImage imageNamed:@"main_img_proLess"];
    float jc = (midview.frame.size.width-20)/10;
    float img3H = img3.size.height*jc/img3.size.width;
    float img3Y = (midview.frame.size.height - img3H)/2;
    for (int i = 0; i<10; i++) {
        
        UIImageView* img = [[UIImageView alloc]initWithFrame:
                            CGRectMake(10+(jc*i),img3Y, jc,img3H)];
        if (i<3)
            img.image = [UIImage imageNamed:@"main_img_bluePro"];
        else
            img.image = img3;
        [midview addSubview:img];
        
        UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,jc-2,img3H)];
        lab.text = [NSString stringWithFormat:@"%i",i+1];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentRight;
        lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*8/320];
        [img addSubview:lab];
    }
    
    UIImage* img4 =[UIImage imageNamed:@"main_img_unaward"];
    float img4W = KMainScreenWidth*25/320;
    float img4H = img4.size.height * img4W / img4.size.width;
    float img4X = midview.frame.size.width - img4W - 5;
    float img4Y =(midview.frame.size.height - img4H)/2;
    UIImageView* awardImge = [[UIImageView alloc]initWithFrame:CGRectMake(img4X,img4Y,img4W,img4H)];
//    if (nextRewardNum ==num)
//        awardImge.image = [UIImage imageNamed:@"main_img_award"];
//    else
    awardImge.image =img4;
    [midview addSubview:awardImge];

}
-(void)setupTableView{
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
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
    [cell setupCellContentWith:nil];
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
