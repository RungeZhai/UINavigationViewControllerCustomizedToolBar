//
//  UIImage+Additions.m
//  VideoDownloader
//
//  Created by liuge on 13-1-15.
//  Copyright (c) 2015年 liuge. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage(UIImage_Additions)


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
