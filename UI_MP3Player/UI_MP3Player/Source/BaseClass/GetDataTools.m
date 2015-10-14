//
//  GetDataTools.m
//  
//
//  Created by 半夏 on 15/10/6.
//
//

#import "GetDataTools.h"

static GetDataTools *gd = nil;

@implementation GetDataTools

// 单例方法，（创建单例要熟练掌握）
+(instancetype)shareGetData
{
    if (gd == nil) {
        static dispatch_once_t once_taken;
        
        dispatch_once(&once_taken,^{
            gd = [[GetDataTools alloc]init];
        
        });
    }
    return gd;

}

// 根据 url 获取数据方法
-(void)getdataWithURL:(NSString *)URL PassValue:(PassValue)passValue
{
    //为什么要用子线程、
    // 因为，这里请求数据时：arrayWithContentsOfURL方法是同步请求（请求数据不结束，主线程就不能工作）
    
     // 线程队列（全局）
    dispatch_queue_t globl_t = dispatch_get_global_queue(0, 0);
    
   // 定义子线程的内容
    dispatch_async(globl_t, ^{
        
    // 此花括号内的所有操作都不胡阻塞主线程工作
        
        // 请求数据
        NSArray * array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:URL]];
        
        // 解析，将解析好的“歌曲信息模型”，加入属性数组，以便外界能随时访问
        for (NSDictionary *dict in array) {
            
            MusicModel *model = [[MusicModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
            
            // NSLog(@"333333====== %@",model);
            
        }
        
        
        
        // ! 这个 Block 是外界出啊如的（外界的代码放到这里来执行），但是我的 self.dataArray 可以作为参数，传递给外界的代码块中，这样外界就能拿到这个数组
        passValue(self.dataArray);
        
    });
    
}

// 懒加载
-(NSMutableArray *)dataArray
{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
    
}

// 根据传入的 index 返回一个“歌曲信息模型”
-(MusicModel *)getModelWithIndex:(NSInteger )index
{
    
    
//    MusicModel *musicModel = [[MusicModel alloc]init];
//    return musicModel;
    
    return self.dataArray[index];
    
    
}




//-(MusicModel *)getModelWithIndex:(NSInteger *)index
//{
//    
//    
//}



@end
