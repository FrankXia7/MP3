//
//  MusicModel.m
//  UI_MP3Player
//
//  Created by 半夏 on 15/10/5.
//  Copyright © 2015年 半夏. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

// 重写的 kvc 的部分方法
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    if ([key isEqualToString:@"id"]) {
        
        self.ID = value;
    }
    if ([key isEqualToString:@"lyric"]) {
        self.timeLyric = [value componentsSeparatedByString:@"\n"];
    }
    
}


@end
