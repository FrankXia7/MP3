//
//  MusicLyricModel.m
//  
//
//  Created by 半夏 on 15/10/6.
//
//

#import "MusicLyricModel.h"

@implementation MusicLyricModel
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@", self.lyricTime,self.lyricStr];
}
@end
