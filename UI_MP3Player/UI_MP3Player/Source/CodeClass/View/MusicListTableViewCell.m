//
//  MusicListTableViewCell.m
//  UI_MP3Player
//
//  Created by 半夏 on 15/10/5.
//  Copyright © 2015年 半夏. All rights reserved.
//

#import "MusicListTableViewCell.h"

@implementation MusicListTableViewCell


#pragma mark  CD图片
-(UIImageView *)CDimageview
{
    if (_CDimageview == nil) {
        self.CDimageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 80, 80)];
        
        _CDimageview.backgroundColor = [UIColor yellowColor];
        
        [self.contentView addSubview:_CDimageview];
        
    }
    return _CDimageview;
    
    
}


#pragma mark 歌名
-(UILabel *)singnameLable
{
    if (_singnameLable == nil) {
        self.singnameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.CDimageview.frame)+20, CGRectGetMinY(self.CDimageview.frame), CGRectGetWidth(self.contentView.frame)-CGRectGetWidth(self.CDimageview.frame)-30, 40)];
      
       // _singnameLable.backgroundColor = [UIColor brownColor];
        
        [self.contentView addSubview:_singnameLable];
        
    }
    
    return _singnameLable;
    
    
}

#pragma mark 歌手名

-(UILabel *)singerLable
{
    if (_singerLable == nil) {
        self.singerLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.singnameLable.frame), CGRectGetMaxY(self.singnameLable.frame)+10,CGRectGetWidth(self.singnameLable.frame),CGRectGetHeight(self.singnameLable.frame))];
        
        // self.singerLable.backgroundColor = [UIColor cyanColor];
        
        [self.contentView addSubview:_singerLable];
    }
    return _singerLable;
    
}

// 重写 model 的 方法

-(void)setModel:(MusicModel *)model
{
    // 歌手名,歌曲名
    self.singerLable.text = model.singer;
    self.singnameLable.text = model.name;
   
    // 图片请求
    NSURL *picURL = [NSURL URLWithString:model.picUrl];
    [self.CDimageview sd_setImageWithURL:picURL placeholderImage:nil];
    
    
}





- (void)awakeFromNib {
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
