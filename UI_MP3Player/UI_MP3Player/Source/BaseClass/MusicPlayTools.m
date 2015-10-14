//
//  MusicPlayTools.m
//  UI_MP3Player
//
//  Created by 半夏 on 15/10/6.
//  Copyright © 2015年 半夏. All rights reserved.
//

#import "MusicPlayTools.h"
static MusicPlayTools *mp = nil;

// 延展
@interface MusicPlayTools()
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation MusicPlayTools

// 单例方法
+(instancetype)shareMusicPlay
{
    if (mp == nil) {
        
        static dispatch_once_t once_token;
        dispatch_once(&once_token,^{
            mp = [[MusicPlayTools alloc]init];
        
        });
        
       
    }
    return mp;
}

// 重写 init 方法
// 因为，我们应得到“某首歌曲播放结束”这一事件，之后由外界来决定“播放结束之后采取什么样的操作”
// AVPlayer 并没有通过 Block 或者代理向我们返回这已状态（实事件），而是向通知中心注册了一条通知   （AVPlayerItemDidPlayToEndTimeNotification），我们也只有这一条途径获取播放结束这一事件，   so ，在我们创建好一个播放器时（[[AVPlayer alloc ]init]）,应该立刻为通知中心添加观察者，来观察这一事件的发生，
// 这个动作放在 init 里，最及时也最合理
-(instancetype)init
{
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc]init];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endOfPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        
    }
    return self;
    
    
}

// 播放结束后的方法,由代理具体实现行为
-(void)endOfPlay:(NSNotification *)sender
{
    // 要先暂停一下
    // 看看 musicPlay 方法，第一个 if 判断

    [self musicPause];
    [self.delegate endOfPlayAction];

}

// 准备播放，我们在外部调用播放器时候，不会调用“直接播放”，而是调用这个“准备播放”当它准备好时，会直接播放
-(void)musicPrePlay
{
    // 通过下面的逻辑，只要 AVPlayer 有 currentItem，那么一定被添加了观察者，
    // 所以上来直接移除之
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    // 根据传入的 URL，创建一个 item 对象
    // initWithURL 的初始化方法建立异步联接，什么时候连接建立完成，我们不知道，但是它完成连接之后，会修改自身内部的属性status，so，我们要观察这个属性，当他的状态变为 AVPlayerItemStatusReadToPlay 时，我们便能得知，播放器已经准备好，可以播放了。
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:self.model.mp3Url]];
    // 为 item 添加观察者
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];

    // 用新创建的 item，替换 AVPlayer 之前的 item，新的 item是带着观察者
    
    NSLog(@"===========%@",item);
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    
}

//
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"status"]) {
//        
//        switch ([[change valueForKey:@"new"]integerValue]) {
//            case AVPlayerItemStatusUnknown:
//                
//                NSLog(@"dont know what");
//                break;
//                
//                case AVPlayerStatusReadyToPlay:
//                [self musicPlay];
//               
//                break;
//                
//                case AVPlayerStatusFailed:
//                NSLog(@"Read Failed");
//                break;
//                
//            default:
//                break;
//        }
//    }
//
//    
//}

// 观察者的处理方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        
        switch ([[change valueForKey:@"new"]integerValue]) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"what's that");
                break;
            
                // 观察到这种status 变为 这种状态，菜户真正开始播放
            case AVPlayerItemStatusReadyToPlay:
                [self musicPlay];
                break;
                
            case AVPlayerItemStatusFailed:
                NSLog(@"Failed");
                break;
        }
    }
}


// 播放
-(void)musicPlay
{
    
    // 如果计时器已经存在了，说明已经在播放中，直接返回
    // 对于一斤个存在的计时器，只有 musicPause 方法才会使之停止和注销
    if (self.timer !=nil) {
        return;
    }
    
    // 播放后，开启一个计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    
    [self.player play];
    
    
}

-(void)timerAction:(NSTimer *)sender
{
    // 计时器的处理方法，不断调用代理方法，将播放进度返回出去
    // 非常之重要
    [self.delegate getCurTime:[self valueToString:[self getCurTime]] Totle:[self valueToString:[self getTotleTime]] Progress:[self getProgress]];
    
    
    
}

// 暂停
-(void)musicPause
{
    // 停止计时器
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];

    
}

// 跳转方法
-(void)seekToTimeWithValue:(CGFloat)value
{
   // 先暂停
    [self musicPause];
    
    // 跳转
    [self.player seekToTime:CMTimeMake(value *[self getTotleTime], 1) completionHandler:^(BOOL finished) {
        
        if (finished == YES) {
            [self musicPlay];
        }
    }];
    
    
    
}



// 获取当前播放时间
-(NSInteger )getCurTime
{
    
    if (self.player.currentItem) {
    
        // 用 Value/scale,就是 AVPlayer 计算时间的算法，他就是这么规定的。
        return self.player.currentTime.value / self.player.currentTime.timescale;
    }
    return 0;
    
}


// 获取总时间
-(NSInteger )getTotleTime
{
    
    
    CMTime totleTime = [self.player.currentItem duration];
    // 用 Value/scale,就是 AVPlayer 计算时间的算法，他就是这么规定的。
    if (totleTime.timescale == 0 ) {
        return 1;
    }else
    {
        return totleTime.value / totleTime.timescale;
        
        
    }
    
}


// 获取当前播放进度
-(CGFloat)getProgress
{
    
    return (CGFloat)[self getCurTime] / (CGFloat)[self getTotleTime];

}

// 将整数秒转化为00：00 的格式字符串
-(NSString *)valueToString:(NSInteger )value
{
    return [NSString stringWithFormat:@"%.2ld:%.2ld",value / 60,value % 60];

}

// 返回一个歌词数组（这里有 BUG）
-(NSMutableArray *)getMusicLyricArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *str in self.model.timeLyric) {
        
        if (str.length == 0) {
            
            continue;
            
        }
        MusicLyricModel *model = [[MusicLyricModel alloc]init];
        model.lyricTime = [str substringWithRange:NSMakeRange(1, 9)];
        model.lyricStr = [str substringFromIndex:11];
        [array addObject:model];
        
    }
    return array;
    
    
}

-(NSInteger )getIndexWithCurTime
{
    
    NSInteger index = 0;
    
    NSString *curTime = [self valueToString:[self getCurTime]];
    
    
    for (NSString *str in self.model.timeLyric ) {

        if (str.length == 0 ) {
            continue;
        }
        if ([curTime isEqualToString:[str substringWithRange:NSMakeRange(1, 5)]]) {
            return index;
        }
        
        index ++;
    }
    return -1;

}




@end
