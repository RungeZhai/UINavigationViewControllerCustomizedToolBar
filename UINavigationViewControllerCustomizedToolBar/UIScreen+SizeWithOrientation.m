//
//  UIScreen+SizeWithOrientation.m
//  ILSPrivatePhoto
//
//  Created by liuge on 12/10/14.
//  Copyright (c) 2014 iLegendSoft. All rights reserved.
//

#import "UIScreen+SizeWithOrientation.h"

@implementation UIScreen (SizeWithOrientation)

- (CGFloat)screenWidthOfOrientation:(UIInterfaceOrientation)interfaceOriention {
    return [self screenSizeOfOrientation:interfaceOriention].width;
}

- (CGFloat)screenHeightOfOrientation:(UIInterfaceOrientation)interfaceOriention {
    return [self screenSizeOfOrientation:interfaceOriention].height;
}

- (CGSize)screenSizeOfOrientation:(UIInterfaceOrientation)interfaceOriention {
    
    CGSize screenSize = self.bounds.size;
    BOOL needSwap = NO;
    if (UIDeviceOrientationIsPortrait(interfaceOriention)) {
        needSwap = (screenSize.width > screenSize.height);
    } else {
        needSwap = (screenSize.height > screenSize.width);
    }
    
    if (needSwap) {
        CGFloat swap = screenSize.width;
        screenSize.width = screenSize.height;
        screenSize.height = swap;
    }
    
    return screenSize;
}

@end
