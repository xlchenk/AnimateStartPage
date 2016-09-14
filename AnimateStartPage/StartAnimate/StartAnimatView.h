//
//  StartAnimatView.h
//  动画启动登录页
//
//  Created by inwan on 16/9/13.
//  Copyright © 2016年 inwan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StartAnimatDelegete <NSObject>

- (void)loginAction;
- (void)registerAction;

@end
@interface StartAnimatView : UIView
@property(nonatomic,weak)id<StartAnimatDelegete>delegate;
/**
 *  是否重复播放
 */
@property(nonatomic,assign,setter=setAlwayRepeat:) BOOL alwaysRepeat;

/**
 *  初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSString *)url;
/**
 *  启动播放
 */
- (void)play;
@end
