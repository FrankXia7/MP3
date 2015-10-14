//
//  MusicListTableViewCell.h
//  UI_MP3Player
//
//  Created by 半夏 on 15/10/5.
//  Copyright © 2015年 半夏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"


@interface MusicListTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *CDimageview;

@property(nonatomic,strong)UILabel *singnameLable;

@property(nonatomic,strong)UILabel *singerLable;

@property(nonatomic,strong)MusicModel *model;






@end
