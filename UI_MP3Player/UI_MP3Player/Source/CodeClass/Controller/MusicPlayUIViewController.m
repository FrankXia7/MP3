//
//  MusicPlayUIViewController.m
//  UI_MP3Player
//
//  Created by 半夏 on 15/10/6.
//  Copyright © 2015年 半夏. All rights reserved.
//

#import "MusicPlayUIViewController.h"

#import "MusicPlayVIEW.h"

static MusicPlayUIViewController *musicPVC = nil;

@interface MusicPlayUIViewController ()<MusicPlayToolsDelegate,MusicPlayVIEWDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)MusicPlayVIEW *ROOTView;
@property(nonatomic,strong)MusicPlayTools *aa;
@property(nonatomic,strong)NSArray *lyricArray;


@end

@implementation MusicPlayUIViewController

-(void)loadView
{
    self.ROOTView = [[MusicPlayVIEW alloc]init];
    
    self.view = _ROOTView;
    
    
}


+(instancetype)sharemusicPlay
{
    if (musicPVC == nil) {
        static dispatch_once_t once_Taken;
        
        dispatch_once(&once_Taken,^{
            
            musicPVC = [[MusicPlayUIViewController alloc]init];
            
        });
    }
    return musicPVC;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 标题栏文字
    self.navigationItem.title = @"音乐";
    
    
    
    // iOS7.0以后，原点是（0.0）而之前希望是 iOS7之前的（0.64）处，也就是 navigationController 导航栏的下边作为（0.0），新的设置就是做这个的。
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // 这里用一个指针指向播放器结束，以后使用这个单例的地方，可以直接使用这个指针，而不用每次都打印那么多。
    self.aa = [MusicPlayTools shareMusicPlay];
    [MusicPlayTools shareMusicPlay].delegate = self;

    //切割 cdimageview为圆型
    self.ROOTView.headImageView.layer.cornerRadius = kScreenWidth / 2;
    self.ROOTView.headImageView.layer.masksToBounds = YES;
    // 为 view 设置代理
    self.ROOTView.delegate  = self;
    [self.ROOTView.NextSontButton addTarget: self action:@selector(NextSontButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.ROOTView.progressSlide addTarget:self action:@selector(progressSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.ROOTView.playPauseButton addTarget:self action:@selector(playPauseButtonAction:) forControlEvents:UIControlEventTouchUpOutside];
    
    // 为播放器添加观察者 ，观察播放速率“rate”
    // 因为 AVPlayer 没有一个内部属性来标识当前的播放状态，所以我们可以通过 rate 变相的得到播放状态
    // 这里观察播放速率 rate，是为了获得播放/ 暂停的触发事件，做出相应的响应事件（如更改 button 的文字）
    [self.aa.player addObserver:self forKeyPath:@"rate" options:(NSKeyValueObservingOptionNew) context:nil];

    // 设置歌词的 tableView 代理
    self.ROOTView.lyricTbaleView.delegate = self;
    self.ROOTView.lyricTbaleView.dataSource = self;
    
    
    
}

// 观察播放速率的响应方法，速率==0，表示没有暂停，
// 速率不为0 ，表示播放中
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"rate"]) {
        if ([[change valueForKey:@"new"] integerValue] == 0) {
            [self.ROOTView.playPauseButton setTitle:@"暂停" forState:(UIControlStateNormal)];
        }else
        {
            [self.ROOTView.playPauseButton setTitle:@"star" forState:(UIControlStateNormal)];
        
        }
    }
    
}


// 每次打开音乐（播放界面）都会执行一次
// 单例中，viewDidLoad 只走一遍，切歌之类的操作，需要多次进行，所以应该写在 viewAppear 中
-(void)viewWillAppear:(BOOL)animated
{
    [self p_play];
}

-(void)p_play
{
    
    // 判断当前播放的 model 和点击 cell 的 index 对应的 model，是不是同一个，
    
    // 如果是同一个，说明正在播放的和我们点击的是同一个，这个时候不需要重新播放，直接返回就行了。
    if ([[MusicPlayTools shareMusicPlay].model isEqual:[[GetDataTools shareGetData] getModelWithIndex:self.index] ]) {
        NSLog(@"run here");
        return;
    }
    
    // 如果播放中和我们点击的不是同一个，那么替换播放器的 model
    // 然后重新播放
    [MusicPlayTools shareMusicPlay].model = [[GetDataTools shareGetData]getModelWithIndex:self.index];
    
    // 注意这是准备播放。不是开始播放
    [[MusicPlayTools shareMusicPlay] musicPrePlay];
    
    // 设置歌曲封面
    [self.ROOTView.headImageView sd_setImageWithURL:[NSURL URLWithString:[MusicPlayTools shareMusicPlay].model.picUrl]];
    // 设置歌词
    self.lyricArray = [self.aa getMusicLyricArray];
    NSLog(@"========%@",self.lyricArray);
    
    // 文字居中

        
    [self.ROOTView .lyricTbaleView reloadData];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 这个协议方法是播放器单例调起的
// 作为协议方法，播放器单例将播放进度以参数形式传出来
-(void)getCurTime:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress
{
    self.ROOTView.currenlableView.text = curTime;
    self.ROOTView.totleTimeLbale.text = totleTime;
    self.ROOTView.progressSlide.value = progress;
    
    // 2d 仿真变换
    self.ROOTView.headImageView.transform = CGAffineTransformRotate(self.ROOTView.headImageView.transform, M_PI/360);
    
    // 返回歌词在数组中的位置，然后根据这个位置，将 tableview 跳到对应的哪一行，
    NSInteger index = [self.aa getIndexWithCurTime];
    if (index == -1) {
        return;
        
    }
    
    NSIndexPath * tmpIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    [self.ROOTView.lyricTbaleView selectRowAtIndexPath:tmpIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    

}

-(void)lastSongAction
{
    if (self.index > 0) {
        self.index --;
    }
    else
    {
        self.index = [GetDataTools shareGetData].dataArray.count - 1;
        
    }
    [self p_play];
}

-(void)NextSontButtonAction:(UIButton *)sender
{
    if (self.index == [GetDataTools shareGetData].dataArray.count -1) {
        self.index = 0;
    }
    else
    {
        self.index ++;
        
    }
    [self p_play];
}

-(void)endOfPlayAction{
    
    
    [self NextSontButtonAction:nil];
    
    
}


// 滑动 slider
-(void)progressSliderAction:(UISlider *)sender
{
    [[MusicPlayTools shareMusicPlay]seekToTimeWithValue:sender.value];

}
// 暂停播放的方法
-(void)playPauseButtonAction:(UIButton *)sender
{
    // 滑动 AVPlayer 的 rate 判断
    if ([MusicPlayTools shareMusicPlay].player.rate == 0) {
        [[MusicPlayTools shareMusicPlay]musicPlay];
    }
    else
    {
        [[MusicPlayTools shareMusicPlay]musicPause];
    
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    // 这里使用kvc 取值,只是为了展示用,并不是必须用
    cell.textLabel.text = [self.lyricArray[indexPath.row] valueForKey:@"lyricStr"];
    cell.backgroundColor = [UIColor clearColor];
    // 歌词文字居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}







@end
