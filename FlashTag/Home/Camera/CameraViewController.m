//
//  CameraViewController.m
//  FlashTag
//
//  Created by py on 15/9/4.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//   相机胶卷

#import "CameraViewController.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "PhotoCollectionViewCell.h"
#import "PhotoFolderModel.h"
#import "PhotoFolderTableView.h"
#import "PYAllCommon.h"
#import "MarkFilterViewController.h"
#import "CameraBtn.h"

#import "UIImage+fixOrientation.h"

@interface CameraViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PhotoFolderTableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)NSMutableArray *imageArray;

@property(nonatomic ,weak)UICollectionView *photeCollection;

@property(nonatomic ,assign)BOOL isCameraRoll;

@property(nonatomic ,weak)PhotoFolderTableView *photoFolderTable;

@property(nonatomic ,weak)UIButton *cover;
/** 文件夹个数*/
@property(nonatomic ,assign)int photoFolderCount;
/** 当前文件夹名字*/
@property(nonatomic,copy)NSString *currentPhotoFolderName;
//拍照
@property UIImagePickerController *uip;

@property(nonatomic ,weak) CameraBtn* photoButton;
@property(nonatomic,copy)NSString *fileName;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    /** 取消按钮*/
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:PYColor(@"999999") forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = PYSysFont(17 *rateH);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 200, 44)];
//    
//    UILabel *folderName = [[UILabel alloc]init];
    
    
     /** 相机胶卷*/
//    CameraBtn *photoBtn = [[CameraBtn alloc]initWithFrame:CGRectMake(0, 20, 200, 17)];
    CameraBtn *photoBtn = [[CameraBtn alloc]initWithFrame:CGRectMake(0, 55, 90, 12)];
    [photoBtn setTitle:@"相机胶卷" forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [photoBtn setTitleColor:PYColor(@"222222") forState:UIControlStateNormal];
    [photoBtn setImage:[UIImage imageNamed:@"ic_drop_down_arrow"] forState:UIControlStateNormal];
    photoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    photoBtn.titleLabel.font = PYSysFont(17 *rateH);
//    photoBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:photoBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.titleView = photoBtn;
    self.photoButton = photoBtn;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(105, 105);
//    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumInteritemSpacing = 0.25;
    layout.minimumLineSpacing = 0.25;
    
    
    UICollectionView *photeCollection =  [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight) collectionViewLayout:layout];
    photeCollection.backgroundColor = [UIColor whiteColor];
    self.photeCollection = photeCollection;
    photeCollection.delegate = self;
    photeCollection.dataSource = self;
    [self.view addSubview:photeCollection];
    [self.photeCollection registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"peiJianId"];
    
 
    
    UIButton *cover = [[UIButton alloc]init];
    cover.frame = CGRectMake(0, 64 , fDeviceWidth, fDeviceHeight - 64);
    self.cover = cover;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0;
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    
    self.currentPhotoFolderName = @"相机胶卷";

    [self photoButtonClick];
}


- (PhotoFolderTableView *)photoFolderTable
{
    if(_photoFolderTable == nil)
    {

        PhotoFolderTableView *photeFolder =  [[PhotoFolderTableView alloc]init];
        photeFolder.view.frame = CGRectMake(0, 64, fDeviceWidth,fmin(self.photoFolderCount * 60 *rateH, kCalculateV(568 - 64)));
        [self addChildViewController:photeFolder];
        _photoFolderTable = photeFolder;
        _photoFolderTable .delegate = self;
        [self.view addSubview:photeFolder.view];
        
    }
    return _photoFolderTable;
}
- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                    
                    NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                    /*result.defaultRepresentation.fullScreenImage//图片的大图
                     result.thumbnail                            //图片的缩略图小图
                     //                    NSRange range1=[urlstr rangeOfString:@"id="];
                     //                    NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                     //                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                     */
                    
                    //                    [self._dataArray addObject:urlstr];
                    //                   if (index == 0) {
                    //                       PhotoFolderModel *model = [self.photoFolderArray lastObject];
                    //                       model.urlStr = urlstr;
                    //                         if (!self.isCameraRoll) {
                    //                       *stop = YES;
                    //                         }
                    //                    }
                    //                    if (self.isCameraRoll) {
                    [self.imageArray addObject:urlstr];
                    //                    }
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
                    if([self.currentPhotoFolderName isEqualToString: name])
                    {
                        [group enumerateAssetsUsingBlock:groupEnumerAtion];
                        [self.photeCollection reloadData];
                    }
                    self.photoFolderCount ++;
                }
            }
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count + 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 0)
    {
        PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"peiJianId" forIndexPath:indexPath];
        cell.isFirst = YES;
        return cell;
    }else
    {
        PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"peiJianId" forIndexPath:indexPath];
        cell.imagePath = self.imageArray[indexPath.item - 1];
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    //资源类型为图片库
    //    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    picker.delegate = self;
    //    //设置选择后的图片可被编辑
    //    picker.allowsEditing = YES;
    //    [self presentViewController:picker animated:YES completion:nil];
    if(indexPath.item == 0)
    {
        [self takePhoto:UIImagePickerControllerSourceTypeCamera Item:0];
    }else
    {
        [self takePhoto:UIImagePickerControllerSourceTypePhotoLibrary Item:indexPath.item];
    }
}

/**截图Start
 @name Mingle
 @email fu.chenming@puyuntech.com
 */

- (void)takePhoto:(UIImagePickerControllerSourceType)type Item:(NSInteger)item{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && type == UIImagePickerControllerSourceTypeCamera)
    {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        imagePicker.toolbarHidden = YES;
        imagePicker.navigationBarHidden = YES;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        _uip = imagePicker;
    }
    else
    {
//        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        //       imagePicker.showsCameraControls = YES;
//        imagePicker.toolbarHidden = YES;
//        imagePicker.navigationBarHidden = YES;
//        imagePicker.allowsEditing = YES;
//        //        imagePicker.wantsFullScreenLayout = NO;
//        imagePicker.delegate = self;
//        _uip = imagePicker;
        _uip = nil;
        
        
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        NSURL *url=[NSURL URLWithString:[self.imageArray[item - 1] copy]];
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
            //获取资源图片的详细资源信息
         if (asset) {
                UIImage *image=[UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
                [self cropWithImage:image];
            }else
            {
                [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                            usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                 {
                     [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                         if([result.defaultRepresentation.url isEqual:url])
                         {
                             UIImage *image=[UIImage imageWithCGImage:[result defaultRepresentation].fullScreenImage];
                             [self cropWithImage:image];
                             
                             *stop = YES;
                         }
                     }];
                 }
        
     failureBlock:^(NSError *error)
                 {
                     //                 NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                     
                 }];
            }
            
        }failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }
         ];
    }
    
    if (self.uip)
    {
        [self presentViewController:_uip animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    
   image = [image fixOrientation];
//    NSData *DATA  = UIImageJPEGRepresentation(image, 0.1);
//   image = [UIImage imageWithData:DATA];
//
    
//    //去除 图片压缩
    CGSize scaledsize = CGSizeMake(fDeviceWidth,450 *rateH);
//    if (image.size.width > image.size.height) {
//        scaledsize = CGSizeMake(fDeviceWidth,fDeviceWidth);
//    }
   image = [image scaleToSize:scaledsize];
    
    [self cropWithImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)cropWithImage:(UIImage*)image
{
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.delegate = self;
    switch (self.type) {
        case CutTypeCircle:
        {
            imageCrop.ratioOfWidthAndHeight = 1/self.ratio;
        }
            break;
            
        default:
        {
            imageCrop.ratioOfWidthAndHeight = self.ratio;
        }
            break;
    }
    imageCrop.type = self.type;
    imageCrop.image = image;
    [imageCrop showWithAnimation:YES];
}

- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    if ([self.delagate respondsToSelector:@selector(afterCut:ByViewController:)]) {
        switch (self.type) {
            case CutTypeCircle:
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            default:
            {
                MarkFilterViewController *vc = [[MarkFilterViewController alloc]init];
                vc.isFirst = self.isFrist;
                
//                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
//                UIImage *iamge = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:self]];
                vc.image = cropImage;
                
                
                [self.navigationController pushViewController:vc animated:YES];
                
                if([self.delagate respondsToSelector:@selector(afterCut:ByViewController:)])
                {
                    [self.delagate afterCut:cropImage ByViewController:self];
                }
            }
                break;
        }
    }
}

/**截图End
 @name Mingle
 @email fu.chenming@puyuntech.com
 */

- (void)coverClick
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.cover.alpha = 0;
        self.photoFolderTable.view.hidden = YES;
    }];
    
    
}

- (void)photoBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.cover.alpha = 0.5;
        self.photoFolderTable.view.hidden = NO;
    }];
    
}
- (void)cancelBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoFolderTableView:(PhotoFolderTableView *)photoFolderTableView didSelectRowAtName:(NSString *)name
{
    [self coverClick];
    [self.imageArray removeAllObjects];
    self.currentPhotoFolderName = name;
//    [self.photoButton setTitle:self.currentPhotoFolderName forState:UIControlStateNormal];
//    [self getImgs];
    [self photoButtonClick];
}
/**
 *  相机胶卷按钮点击事件
 */
- (void)photoButtonClick
{
    NSDictionary *userDisplayNameDic = @{NSFontAttributeName: PYSysFont(17 *rateW)};
    CGRect rect =  [self.currentPhotoFolderName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:userDisplayNameDic context:nil];
      if(rect.size.width > 100 *rateW)
      {
      self.photoButton.frame = CGRectMake(0, 55, 100 *rateW, 12);
      }else
      {
      self.photoButton.frame = CGRectMake(0, 55, rect.size.width + 17 *rateW, 12);
      }

    [self.photoButton setTitle:self.currentPhotoFolderName forState:UIControlStateNormal];
    [self getImgs];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
