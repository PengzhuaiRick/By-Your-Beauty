//
//  UNIAlbumController.m
//  Uni
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIAlbumController.h"
#import "UNIAlbumRequest.h"
@interface UNIAlbumController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong)NSArray* imgArray;
@property (weak, nonatomic) IBOutlet UILabel *descreberLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *nodataLabel;
@end

@implementation UNIAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self startRequest];
}
-(void)setupNavigation{
    self.title = @"相册";
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
    //self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
-(void)startRequest{
    __weak UNIAlbumController* myself = self;
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIAlbumRequest* rq = [[UNIAlbumRequest alloc]init];
    [rq postWithSerCode:@[API_URL_GetShopImages] params:nil];
    rq.getShopImages=^(NSArray* arr,NSString*tips,NSError* err){
        [LLARingSpinnerView RingSpinnerViewStop1];
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (arr) {
            myself.imgArray = arr;
            [myself setupUI];
        }else
            [YIToast showText:tips];
        
    };
}

-(void)setupUI{
    _nodataLabel.hidden = self.imgArray.count>0;
    _numLab.hidden = self.imgArray.count<1;
    _numLab.text = [NSString stringWithFormat:@"1/%d",(int)self.imgArray.count];
    UNIAlbumModel* model = self.imgArray[0];
    _descreberLab.text = model.intro;
    self.scrollView.contentSize = CGSizeMake(KMainScreenWidth*self.imgArray.count, KMainScreenHeight-64);
    
    for (int i=0; i<self.imgArray.count; i++) {
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(KMainScreenWidth*i, 64, KMainScreenWidth, KMainScreenWidth)];
        [self.scrollView addSubview:img];
        UNIAlbumModel* model = self.imgArray[i];
        [img sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"KZ_img_goodsBg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                float h = KMainScreenWidth* image.size.height/image.size.width;
                float x = img.frame.origin.x;
                float y = (KMainScreenHeight - h - 64)/2;
                img.frame= CGRectMake(x, y, KMainScreenWidth, h);
            }
        }];
    }

}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float x = scrollView.contentOffset.x;
    int i = x/KMainScreenWidth;
    UNIAlbumModel* model = self.imgArray[i];
    _descreberLab.text = model.intro;
    
    _numLab.text = [NSString stringWithFormat:@"%d/%d",i+1,(int)self.imgArray.count];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
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
