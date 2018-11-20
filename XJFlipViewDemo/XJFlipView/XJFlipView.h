//
//  XJFlipView.h
//  XJFlipViewDemo
//
//  Created by liuxj on 2018/11/20.
//  Copyright © 2018 lxj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJFlipView : UIView

@property (nonatomic, assign) BOOL isAnimating;

- (instancetype)initWithImages:(NSArray *)images;
- (void)clean;

@end
