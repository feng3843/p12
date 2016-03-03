//
//  PhotoFolderTableView.m
//  test
//
//  Created by 夏雪 on 15/8/31.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import "PhotoFolderTableView.h"
#import "PhotoFolderTableViewCell.h"
#import "PhotoFolderModel.h"

@interface PhotoFolderTableView ()
@property(nonatomic ,strong)NSMutableArray *photoFolder;
@property(nonatomic ,strong)NSMutableArray *photoFoldergroup;
@end

@implementation PhotoFolderTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self getImgs];
//    });
    self.tableView.rowHeight = 60 *rateH;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
 
}

- (NSMutableArray *)photoFolder
{
    if (_photoFolder == nil) {
        _photoFolder = [NSMutableArray array];
    }
    return _photoFolder;
}

- (NSMutableArray *)photoFoldergroup
{
    if (_photoFoldergroup == nil) {
        _photoFoldergroup = [NSMutableArray array];
    }
    return _photoFoldergroup;
}

-(void)getImgs{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
         ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                    
//                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    /*result.defaultRepresentation.fullScreenImage//图片的大图
                     result.thumbnail                            //图片的缩略图小图
                     //                    NSRange range1=[urlstr rangeOfString:@"id="];
                     //                    NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                     //                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                     */
                    
                    //                    [self._dataArray addObject:urlstr];
                                       if (index == 0) {
//                                           PhotoFolderModel *model = [self.photoFolder firstObject];
//                                           model.urlStr = urlstr;
                                            *stop = YES;
                                           
                                        }
                }
              
            }
        };
       
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
             if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                //                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                
                NSString *g1=[g substringFromIndex:16 ] ;
                
                NSArray *arr=[NSArray arrayWithArray:[g1 componentsSeparatedByString:@","]];
                NSString *name=[[arr objectAtIndex:0]substringFromIndex:5];
                NSString *count=[[arr objectAtIndex:2]substringFromIndex:14];
                 
                 if ([count intValue] > 0) {
                     
                     if ([name isEqualToString:@"Camera Roll"]||[name isEqualToString:@"All Photos"]||[name isEqualToString:@"所有照片"]) {
                         name = @"相机胶卷";
                         
                     }
                     if ([name isEqualToString:@"My Photo Stream"]||[name isEqualToString:@"我的照片流"]) {
                         name = @"我的照片流";
                     }
                     
                     
                     
                     PhotoFolderModel *model = [[PhotoFolderModel alloc]init];
                     model.count = count;
                     model.name = name;
                     model.posterImage = [UIImage imageWithCGImage:group.posterImage];
                     
                     [group enumerateAssetsUsingBlock:groupEnumerAtion];
                     
                     if ([@"相机胶卷" isEqualToString:name]) {
                         [self.photoFolder insertObject:model atIndex:0];
                     }
                     else if([@"我的照片流" isEqualToString:name])
                     {
                        [self.photoFolder insertObject:model atIndex:1];
                     }else
                     {
                          [self.photoFolder addObject:model];
                     }
                     
                 }
            }
            else
            {
                [self.tableView reloadData];
            }
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        
        
    });
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    return 1;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.photoFolder.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *photoFolder = @"photoFolderID";

    PhotoFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoFolder];
    if (cell == nil) {
        cell = [[PhotoFolderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoFolder];
    }
    cell.backgroundColor = PYColor(@"ebebeb");

    
    NSInteger num = indexPath.row;
    cell.photoFolderModel = self.photoFolder[num];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(photoFolderTableView:didSelectRowAtName:)]) {
           NSInteger num = indexPath.row;
    
        PhotoFolderModel *model = self.photoFolder[num];
        [self.delegate photoFolderTableView:self didSelectRowAtName:model.name];
    }
}

@end
