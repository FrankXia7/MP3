//
//  MusicPlayVIEW.h
//  UI_MP3Player
//
//  Created by lanou3g on 15/10/5.
//  Copyright (c) 2015年 半夏. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MusicPlayVIEWDelegate<NSObject>

-(void)lastSongAction;

@end

@interface MusicPlayVIEW : UIView

// 主页面
@property(nonatomic,strong)UIScrollView *mainScrollView;
//CD页面图片
@property(nonatomic,strong)UIImageView *headImageView;
//歌词
@property(nonatomic,strong)UITableView *lyricTbaleView;
// 进行时间
@property(nonatomic,strong)UILabel *currenlableView;
// 时间滑块
@property(nonatomic,strong)UISlider *progressSlide;
// 总时间
@property(nonatomic,strong)UILabel *totleTimeLbale;
// 上一曲
@property(nonatomic,strong)UIButton *LastSongButton;
// 暂停
@property(nonatomic,strong)UIButton *playPauseButton;
// 下一曲
@property(nonatomic,strong)UIButton *NextSontButton;

// 单例 +(instancetype)shareMusicPlayer;

@property(nonatomic,weak)id<MusicPlayVIEWDelegate>delegate;

@end


