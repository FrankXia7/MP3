//
//  GetDataTools.h
//  
//
//  Created by 半夏 on 15/10/6.
//
//

#import <Foundation/Foundation.h>

typedef void (^PassValue)(NSArray *array);


@interface GetDataTools : NSObject




// 数组,存储数据(作为单例的属性，这个数组可以在任何位置被访问)
@property(nonatomic,strong)NSMutableArray *dataArray;

// 单例方法
+(instancetype)shareGetData;

// 根据 url 获取数据方法(根据传入的 url，通过 Block 返回一个数组)
//（第三方基本都支持这种形式）（SDK 即第三方）
-(void)getdataWithURL:(NSString *)URL PassValue:(PassValue)passValue;


// 根据传入的 Index，返回一个“歌曲信息的模型”，这个模型来自上面的属性数组
-(MusicModel *)getModelWithIndex:(NSInteger )index;





@end
