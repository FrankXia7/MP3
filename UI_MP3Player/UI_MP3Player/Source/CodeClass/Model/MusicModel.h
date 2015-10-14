//
//  MusicModel.h
//  UI_MP3Player
//
//  Created by 半夏 on 15/10/5.
//  Copyright © 2015年 半夏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

// 歌曲信息接口
@property(nonatomic,strong)NSString *mp3Url;// 音乐地址

@property(nonatomic,strong)NSString *ID;// 歌曲 ID[实际名称是 id(小写)]
@property(nonatomic,strong)NSString *name; // 歌曲名
@property(nonatomic,strong)NSString *picUrl; // 图片地址
@property(nonatomic,strong)NSString *bluePicUrl; // 模糊图片地址
@property(nonatomic,strong)NSString *album; // 专辑
@property(nonatomic,strong)NSString *singer; // 歌手
@property(nonatomic,strong)NSString *duration; // 时长
@property(nonatomic,strong)NSString *artists_name; // 作曲
@property(nonatomic,strong)NSArray *timeLyric; // 歌词






@end
