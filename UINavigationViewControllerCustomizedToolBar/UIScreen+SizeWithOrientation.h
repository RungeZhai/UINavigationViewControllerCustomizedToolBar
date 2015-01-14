//
//  UIScreen+SizeWithOrientation.h
//  ILSPrivatePhoto
//
//  Created by liuge on 12/10/14.
//  Copyright (c) 2014 iLegendSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (SizeWithOrientation)

- (CGFloat)screenWidthOfOrientation:(UIInterfaceOrientation)interfaceOriention;
- (CGFloat)screenHeightOfOrientation:(UIInterfaceOrientation)interfaceOriention;
- (CGSize)screenSizeOfOrientation:(UIInterfaceOrientation)interfaceOriention;

@end
