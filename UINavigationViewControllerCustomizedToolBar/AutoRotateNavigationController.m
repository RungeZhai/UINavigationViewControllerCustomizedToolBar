//
//  AutoRotateNavigationController.m
//  ILSPrivatePhoto
//
//  Created by liuge on 13-5-30.
//  Copyright (c) 2013年 iLegendSoft. All rights reserved.
//

#import "AutoRotateNavigationController.h"
#import "UIImage+Additions.h"
#import "UIScreen+SizeWithOrientation.h"

#define kIsIPad     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kNormalColor                        [UIColor colorWithRed:120 / 255.f green:138 / 255.f blue:144 / 255.f alpha:1.f]
#define kHighlightColor                     [UIColor colorWithRed:154 / 255.f green:82 / 255.f blue:234 / 255.f alpha:1.f]

#define kBottomToolBarHeight ((kIsIPad ? 56.f : 49.f) + 1.f / [UIScreen mainScreen].scale)

// for navigation bottom toolbar
#define kTitle          @"Title"
#define kNormalImage    @"NormalImage"
#define kHighligntImage @"HighlightImage"

#define kLineViewColor                      [UIColor colorWithWhite:192 / 255.f alpha:1.f]

@interface AutoRotateNavigationController ()

@property (strong, nonatomic) UIView *bottomToolbar;
@property (strong, nonatomic) NSArray *bottomToolbarItems;// record the buttons on the toolbar so that we know which button is clicked and can remove them when reset
@property (strong, nonatomic)   NSArray *toolBarItemInfo;// data source

@end

@implementation AutoRotateNavigationController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    
    self.toolbar.hidden = YES;
    
    _bottomToolbar = [[UIToolbar alloc] initWithFrame:(CGRect){0, self.view.frame.size.height - kBottomToolBarHeight,
        self.view.frame.size.width, kBottomToolBarHeight}];
    // keep at bottom with fixed height
    _bottomToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_bottomToolbar];
    
    // UIToolbar has a line on the top of the view, so no need to add one
//    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){0, 0, CGRectGetWidth(_bottomToolbar.frame), 1.f / [UIScreen mainScreen].scale}];
//    lineView.backgroundColor = kLineViewColor;
//    // keep at top with fixed height
//    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
//    [_bottomToolbar addSubview:lineView];
    
    [self setupToolBar];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - customized toolbar

- (void)setupToolBar {
    
    [self setupToolBarItemInfo];
    
    int i = 0x087593BE;
    NSMutableArray *itemArray = [NSMutableArray new];
    for (NSDictionary *itemInfo in _toolBarItemInfo) {
        UIButton *button =
        [self toolBarButtonWithTitle:itemInfo[kTitle]
                         normalImage:[UIImage imageNamed:itemInfo[kNormalImage]]
                    highlightedImage:[UIImage imageNamed:itemInfo[kHighligntImage]]
                              target:self
                              action:@selector(toolbarItemClicked:)
                             enabled:YES
                                 tag:i++];
        
        [itemArray addObject:button];
    }
    
    [self setToolbarItems:itemArray];
}

- (void)toolbarItemClicked:(id)sender {
    NSLog(@"clicked %lu", (unsigned long)[_bottomToolbarItems indexOfObject:sender]);
}

- (void)setupToolBarItemInfo {
    
    NSDictionary *dict1 = @{kTitle:NSLocalizedString(@"Move", @""), kNormalImage:@"btn_move_normal", kHighligntImage:@"btn_move_normal"};
    NSDictionary *dict2 = @{kTitle:NSLocalizedString(@"Copy", @""), kNormalImage:@"btn_move_normal", kHighligntImage:@"btn_move_normal"};
    NSDictionary *dict3 = @{kTitle:NSLocalizedString(@"Delete", @""), kNormalImage:@"btn_move_normal", kHighligntImage:@"btn_move_normal"};
    NSDictionary *dict4 = @{kTitle:NSLocalizedString(@"Share", @""), kNormalImage:@"btn_move_normal", kHighligntImage:@"btn_move_normal"};
    _toolBarItemInfo = @[dict1, dict2, dict3, dict4];
}

- (void)setToolbarItems:(NSArray *)toolbarItems {
    
    if (_bottomToolbarItems.count > 0) {
        for (UIView *view in _bottomToolbarItems) {
            [view removeFromSuperview];
        }
        _bottomToolbarItems = nil;
    }
    
    if (toolbarItems.count > 0) {
        for (UIButton *button in toolbarItems) {
            [_bottomToolbar addSubview:button];
        }
        
        [self setFramesOfToolBarItems:toolbarItems superViewSize:_bottomToolbar.bounds.size animated:NO];
    }
    
    _bottomToolbarItems = toolbarItems;
}

- (void)setFramesOfToolBarItems:(NSArray *)toolbarItems superViewSize:(CGSize)superViewSize animated:(BOOL)animated {
    if (toolbarItems.count > 0) {
        CGFloat duration = animated ? .3f : .0f;
        [UIView animateWithDuration:duration animations:^{
            // if items less than 4, evenly arrange the items
            // otherwise, the left and margin is fixed(iphone = 15, ipad = 22)
            CGFloat leftMargin, horizontalInterval;
            
            if (toolbarItems.count < 4) {
                horizontalInterval = superViewSize.width / toolbarItems.count;
                leftMargin = (horizontalInterval - superViewSize.height) / 2.f;
            } else {
                leftMargin = kIsIPad ? 22.f / 320.f * superViewSize.width : 15.f / 768.f * superViewSize.width;
                horizontalInterval = (superViewSize.width - leftMargin * 2 - superViewSize.height) / (toolbarItems.count - 1);
            }
            for (UIButton *button in toolbarItems) {
                button.frame = (CGRect){leftMargin, 0, superViewSize.height, superViewSize.height};
                leftMargin += horizontalInterval;
            }
        }];
    }
}

- (UIButton *)toolBarButtonWithTitle:(NSString *)title
                         normalImage:(UIImage *)normalImage
                    highlightedImage:(UIImage *)highLightImage
                              target:(id)target
                              action:(SEL)action
                             enabled:(BOOL)enabled
                                 tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:(CGRect){0, 0, kBottomToolBarHeight, kBottomToolBarHeight}];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:10.f];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageWithImage:highLightImage scaledToSize:(CGSize){27, 27}] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageWithImage:normalImage scaledToSize:(CGSize){27, 27}] forState:UIControlStateNormal];
    [button setTitleColor:kNormalColor forState:UIControlStateNormal];
    [button setTitleColor:kHighlightColor forState:UIControlStateHighlighted];
    button.enabled = enabled;
    button.tag = tag;
    
    // the space between the image and text
    CGFloat spacing = 10.0;
    //
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.frame.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    //
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height), 0.0, 0.0, - titleSize.width);
    
    return button;
}


#pragma mark - UIInterfaceOrientation

// willRotateToInterfaceOrientation:duration: will not trigger in UINavigationViewController
// so we have to observe the UIDeviceOrientationDidChangeNotification
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"will rotate called");
}

- (void)didRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    CGSize toolBarSizeAfterRotation = (CGSize){[[UIScreen mainScreen] screenWidthOfOrientation:toInterfaceOrientation], _bottomToolbar.bounds.size.height};
    
    [self setFramesOfToolBarItems:_bottomToolbarItems superViewSize:toolBarSizeAfterRotation animated:YES];
}

- (void)orientationChanged:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self didRotateToInterfaceOrientation:orientation];
}

@end

