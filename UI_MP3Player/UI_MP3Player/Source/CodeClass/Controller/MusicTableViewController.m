//
//  MusicTableViewController.m
//  UI_MP3Player
//
//  Created by 半夏 on 15/10/5.
//  Copyright © 2015年 半夏. All rights reserved.
//

#import "MusicTableViewController.h"
#import "MusicPlayUIViewController.h"

//#import "MusicPlayVIEW.h"

@interface MusicTableViewController ()


@property(nonatomic,strong)NSArray *dataArray;


@end

@implementation MusicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[MusicListTableViewCell class] forCellReuseIdentifier:@"cell"];
   
    // 标题栏文字
    self.navigationItem.title = @"列表";
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"000.png"]];
 
   // self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setBackgroundView:imageView];

// 用 XIB 的时候可以用下面的方法注册
//    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    // 调用获取播放列表的方法，结果已Block 的参数形式返回
    [[GetDataTools shareGetData] getdataWithURL:kURL PassValue:^(NSArray *array) {
        
        // 花括号里的代码被称为 Block
        // block 具有捕获当前上下文的功能，它能带着这个类中的 dataarray，到另外一个类中去赋值，
        
        self.dataArray = array;
        
        // 花括号里的代码实际上在子线程中执行的，
        // 子线程中严禁跟新 UI
        // 通过这种方式返回到主线程中去执行 reloadata 的操作，
        // 注意：面试时、问线程的通信方法/ 方式有哪些，这个算一种
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
            
        });
        
    }];
    
}
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
   // cell.singerLable.text = self.dataArray[indexPath.row].
    //cell.singnameLable.text = @"歌曲名";
    
    cell.model = self.dataArray[indexPath.row];
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicPlayUIViewController *musicVC = [MusicPlayUIViewController sharemusicPlay];
    
    musicVC.index = indexPath.row;
    
    [self.navigationController pushViewController:musicVC animated:YES];
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
