//
//  MusicPlayTools.h
//  UI_MP3Player
//
//  Created by 半夏 on 15/10/6.
//  Copyright © 2015年 半夏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// 定义协议
// 如果外界想使用本类，必须遵循和实现协议中的两个方法
@protocol MusicPlayToolsDelegate<NSObject>

// 外界实心这个方法的同时，也将参数的值拿走了。这样就起到了“通过代理方法向外界传递值”的功能
-(void)getCurTime:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress;

// 播放结束之后，做什么操作由外部决定
-(void)endOfPlayAction;

@end

@interface MusicPlayTools : NSObject

// 本类中的播放器指针
@property(nonatomic,strong)AVPlayer *player;
// 本类中的，播放中的“歌曲信息模型”
@property(nonatomic,strong)MusicModel *model;

// 代理
@property(nonatomic,weak)id<MusicPlayToolsDelegate>delegate;


//单例方法
+(instancetype)shareMusicPlay;


// 开始播放音乐
-(void)musicPlay;

// 暂停音乐
-(void)musicPause;

// 准备播放
-(void)musicPrePlay;

//跳转
-(void)seekToTimeWithValue:(CGFloat)value;

// 返回一个歌词数组
-(NSMutableArray *)getMusicLyricArray;

// 根据当前播放时间，返回对应歌词在数组中的位置
-(NSInteger)getIndexWithCurTime;




@end
