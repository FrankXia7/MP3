//
//  MusicPlayVIEW.m
//  UI_MP3Player
//
//  Created by lanou3g on 15/10/5.
//  Copyright (c) 2015年 半夏. All rights reserved.
//

#import "MusicPlayVIEW.h"

static MusicPlayVIEW *mt = nil;

@implementation MusicPlayVIEW


-(instancetype)init
{
    
    if (self = [super init]) {
        [self p_setup];
    }
    
    return self;
}

-(void)p_setup
{
    
    self.backgroundColor = [UIColor clearColor];
    
    
    // 1 scrollView
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    
    
//    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"你要设置的背景图片名称320*xx"]];
//    [scrollView setContentSize:CGSizeMake(320, 960)];
//    [self.view addSubview:scrollView];
 
    // mainscrollview 的背景图片
    self.mainScrollView.contentSize = CGSizeMake(2*kScreenWidth, CGRectGetHeight(self.mainScrollView.frame));
    
    //self.mainScrollView.backgroundColor = [UIColor clearColor];
    
    self.mainScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"90.png"]];
    
    
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.alwaysBounceHorizontal = YES;// 打开水平滚动
    
    self.mainScrollView.alwaysBounceVertical= NO;// 关闭垂直滚动
    // self.mainScrollView.bounces = NO;
    
    [self addSubview:self.mainScrollView];

    
    
    //2 headimageView
    self.headImageView = [[UIImageView alloc]init];
    
    self.headImageView.frame = CGRectMake(0, 0,kScreenWidth, CGRectGetHeight(self.mainScrollView.frame));
    // self.headImageView.image = [UIImage imageNamed:@"90.png"];
    
    //self.headImageView.frame = CGRectMake(20.f, 20.f, 100.f, 100.f);
    
    // 强行适应相框
    //self.headImageView.layer.masksToBounds = YES;
    //self.headImageView.layer.cornerRadius = 50;
    // 圆角切图
    
    self.headImageView.layer.cornerRadius = (kScreenWidth)/2;

    
    self.headImageView.backgroundColor = [UIColor yellowColor];
    
    [self.mainScrollView addSubview:self.headImageView];
    
  
    
   
    // 3歌词
    self.lyricTbaleView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth,CGRectGetHeight(self.headImageView.frame))style:(UITableViewStylePlain)];
   
    UIImageView *imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"000.png"]];
    

   // self.lyricTbaleView.backgroundColor = [UIColor clearColor];
    
    
    [self.lyricTbaleView setBackgroundView:imageView1];

    
    
    [self.mainScrollView addSubview:self.lyricTbaleView];
    
    // 进行时间
    self.currenlableView = [[UILabel alloc]init];
    self.currenlableView.frame = CGRectMake(7, CGRectGetMaxY(self.headImageView.frame)+10, 50, 30);
    
    self.currenlableView.text = @"curren";
    [self.currenlableView setTintColor:[UIColor blackColor]];
    
    //self.currenlableView.backgroundColor = [UIColor redColor];
    
    [self addSubview:self.currenlableView];
    
    // 时间滑块
    self.progressSlide = [[UISlider alloc]init];

    self.progressSlide.frame = CGRectMake(CGRectGetMaxX(self.currenlableView.frame)+5, CGRectGetMinY(self.currenlableView.frame), 250,30);
    
    [self.progressSlide setTintColor:[UIColor redColor]];
    
    self.progressSlide.thumbTintColor = [UIColor grayColor];
    
   // self.progressSlide.backgroundColor = [UIColor blueColor];
    
    [self addSubview:self.progressSlide];
    
    // 总时间
    self.totleTimeLbale = [[UILabel alloc]init];
    
    self.totleTimeLbale.frame = CGRectMake(CGRectGetMaxX(self.progressSlide.frame)+5, CGRectGetMinY(self.currenlableView.frame), 50, 30);

    self.totleTimeLbale.text = @"totletime";
    // lable 字体颜色设置
    [self.totleTimeLbale setTintColor:[UIColor blackColor]];
    
    //self.totleTimeLbale.backgroundColor = [UIColor redColor];
    
    [self addSubview:_totleTimeLbale];
    
    // 上一曲
    self.LastSongButton = [[UIButton alloc]init];
    self.LastSongButton.frame = CGRectMake(18, CGRectGetMaxY(self.currenlableView.frame)+85, 80, 30);
    
    [self.LastSongButton setTitle:@"上一曲" forState: UIControlStateNormal];
    //  Button 字体颜色设置
    [self.LastSongButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [self.LastSongButton addTarget:self action:@selector(LastSongButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    //self.LastSongButton.backgroundColor = [UIColor cyanColor];
   
    [self addSubview:_LastSongButton];
    
    // 暂停
    
    self.playPauseButton = [[UIButton alloc]init];
    
    self.playPauseButton.frame = CGRectMake(CGRectGetMaxX(self.LastSongButton.frame)+50, CGRectGetMinY(self.LastSongButton.frame), 80, 30);
   // self.playPauseButton.backgroundColor = [UIColor cyanColor];
    [self.playPauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    //  Button 字体颜色设置
    [self.playPauseButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    
    [self addSubview:_playPauseButton];
    
    // 下一曲
    self.NextSontButton = [[UIButton alloc]init];
    self.NextSontButton.frame = CGRectMake(CGRectGetMaxX(self.playPauseButton.frame)+50, CGRectGetMinY(self.playPauseButton.frame), 80, 30);
    [self.NextSontButton setTitle:@"下一曲" forState: UIControlStateNormal];
    //  Button 字体颜色设置
    [self.NextSontButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    
    //self.NextSontButton.backgroundColor = [UIColor cyanColor];
    [self addSubview:_NextSontButton];
    
    
    
    
}

-(void)LastSongButtonAction:(UIButton *)sender
{
    [self.delegate lastSongAction];
    
    
}

@end
