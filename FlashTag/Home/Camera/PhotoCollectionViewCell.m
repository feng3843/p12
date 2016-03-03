//
//  PhotoCollectionViewCell.m
//  test
//
//  Created by 夏雪 on 15/8/31.
//  Copyright (c) 2015年 py. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import<AssetsLibrary/AssetsLibrary.h>

@interface PhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@end
@implementation PhotoCollectionViewCell

- (void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
    
  
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    NSURL *url=[NSURL URLWithString:imagePath];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
           if (asset) {
            UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
            self.photoImage.image = image;
        }else
        {
            [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                   usingBlock:^(ALAssetsGroup *group, BOOL *stop)
             {
                 [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                     if([result.defaultRepresentation.url isEqual:url])
                     {
                         UIImage *image=[UIImage imageWithCGImage:result.thumbnail];
                         self.photoImage.image = image;
                      
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

    }
     ];
}

- (void)setIsFirst:(BOOL)isFirst
{
    _isFirst = isFirst;
    self.photoImage.image = [UIImage imageNamed:@"img_new_photo"];
}
@end
