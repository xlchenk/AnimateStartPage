//
//  StartAnimatView.m
//  动画启动登录页
//
//  Created by inwan on 16/9/13.
//  Copyright © 2016年 inwan. All rights reserved.
//


#import "StartAnimatView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGH  [UIScreen mainScreen].bounds.size.height

#define btnWidth 130
#define btnHeigh 40
#define BTN_WIDTHSCALE (SCREEN_WIDTH /375)*btnWidth
#define BTN_HEIGHSCALE (SCREEN_WIDTH /375)*btnHeigh
typedef enum  {
    Resize,
    ResizeAspect,
    ResizeAspectFill
} Sclemode;
@interface StartAnimatView ()<UIScrollViewDelegate>

@property(nonatomic,strong) AVPlayerViewController * playerController;//媒体播放控制器
@property(nonatomic,strong)UIView * bgView;//蒙版
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)NSString * strUrl;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)UILabel * scrollLable;
@property(nonatomic,strong)UIButton * loginBtn;
@property(nonatomic,strong)UIButton * rgiestBtn;
@property(nonatomic,strong)NSArray * labels;
//轮播定时器
@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,strong)UIImageView * imv;
@end


@implementation StartAnimatView
//懒加载
- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc]init];
        _loginBtn.frame = CGRectMake(40, SCREEN_HEIGH - BTN_HEIGHSCALE-50, BTN_WIDTHSCALE, BTN_HEIGHSCALE);
        [_loginBtn setTitle:@"Login in" forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor whiteColor];
        _loginBtn.alpha = 0.7;
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_loginBtn addTarget:self action:@selector(loginmetond) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _loginBtn;
}
- (UIButton *)rgiestBtn{
    if (!_rgiestBtn) {
        _rgiestBtn = [[UIButton alloc]init];
        _rgiestBtn.frame = CGRectMake(SCREEN_WIDTH-BTN_WIDTHSCALE-40, _loginBtn.frame.origin.y, BTN_WIDTHSCALE, BTN_HEIGHSCALE);
        _rgiestBtn.titleLabel.font = _loginBtn.titleLabel.font;
        _rgiestBtn.backgroundColor = [UIColor blackColor];
        _rgiestBtn.alpha = 0.7;
        [_rgiestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rgiestBtn addTarget:self action:@selector(rgietMethod) forControlEvents:UIControlEventTouchUpInside];
        [_rgiestBtn setTitle:@"Sign up" forState:UIControlStateNormal];
    }
    return _rgiestBtn;
}

- (UIImageView *)imv{
    if (!_imv) {
        _imv = [[UIImageView alloc]init];
        _imv.image = [UIImage imageNamed:@"keep6@2x.png"];
        _imv.frame = CGRectMake(80, 100, SCREEN_WIDTH-80*2, 125);
    }
    
    
    return _imv;
}
- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSString *)url{
    self = [super initWithFrame:frame];
    if (self) {
        self.playerController = [[AVPlayerViewController alloc]init];
        self.strUrl = url;
        NSURL * URL = [NSURL fileURLWithPath:self.strUrl];
        self.player = [[AVPlayer alloc]initWithURL:URL];
        self.playerController.player = self.player;
        self.playerController.view.frame = frame;
        //是否显示播放组件
        self.playerController.showsPlaybackControls = NO;
        //设置音量
        //self.playerController.player.volume = 0.5;
        //不进行比例缩放
        self.playerController.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self addSubview:self.playerController.view];
        //是否连续播放
        _alwaysRepeat = YES;
        //蒙版
        _bgView = [[UIView alloc]init];
        _bgView.frame = frame;
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.userInteractionEnabled = YES;
        [_playerController.view addSubview:_bgView];
  
        [_bgView addSubview:self.loginBtn];
        [_bgView addSubview:self.rgiestBtn];
        [_bgView addSubview:self.imv];
        _labels = @[@"每个动作都精确规范",@"规划陪伴你的训练过程",@"分享汗水后你的性感",@"全程记录你的健身数据"];
        [self buildScrollView];
        [self buildPageControl];
        [self myTmer];
    }
    return self;
}
- (void)buildPageControl{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame)-50, SCREEN_WIDTH, 40)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 4;
    [self.bgView addSubview:_pageControl];
}
//轮播的lable
- (void)buildScrollView{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, CGRectGetMinY(_loginBtn.frame)-170, SCREEN_WIDTH, 160);
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, _scrollView.frame.size.height);
    [self.bgView addSubview:_scrollView];
    
    for (NSInteger i = 0; i < 4; i++) {
        _scrollLable = [[UILabel alloc]init];
        _scrollLable.textAlignment = NSTextAlignmentCenter;
        _scrollLable.frame = CGRectMake(i*SCREEN_WIDTH, _scrollView.frame.size.height/2-20, SCREEN_WIDTH, 40);
        _scrollLable.textColor = [UIColor whiteColor];
        _scrollLable.text = self.labels[i];
        [_scrollView addSubview:_scrollLable];
    }
    
}



//登陆
- (void)loginmetond{
    
    [self.delegate loginAction];
    [self removeTimer];
}

//注册
- (void)rgietMethod{
    [self.delegate registerAction];
     [self removeTimer];
}

- (void)play{
    if (_alwaysRepeat) {
        //当播放结束的时候把播放头移动头移动到playerItem的末尾，如果此时调用player时没有效果的，应当播放完毕之后 将播放头再移回起始位置 调用seekToTime(KCMTimeZero)
        [self.playerController.player seekToTime:kCMTimeZero];
        [self.playerController.player play];

    }else{
        //播放
        [self.playerController.player play];
    }
    
}
//set方法
- (void)setAlwayRepeat:(BOOL)alwaysRepeat{
        _alwaysRepeat = alwaysRepeat;
        if (_alwaysRepeat) {
            //注册视频播放完毕的通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerController.player.currentItem];
        }
}
//当播放结束调用此方法
- (void)playerItemDidReachEnd {
    //当播放结束的时候把播放头移动头移动到playerItem的末尾，如果此时调用player时没有效果的，应当播放完毕之后 将播放头再移回起始位置 调用seekToTime(KCMTimeZero)
    [self.playerController.player seekToTime:kCMTimeZero];
    [self.playerController.player play];
}
//移除通知
- (void)dealloc{
    NSLog(@"移除通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//定时器
- (void)myTmer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollPage) userInfo:nil repeats:YES];
    
}
//不用的时候移除定时器
- (void)removeTimer{
    NSLog(@"移除定时器");
    [self.timer invalidate];
    self.timer = nil;
}
- (void)scrollPage{
    NSInteger page = (_pageControl.currentPage +1) % 4;
    _pageControl.currentPage = page;
    [self.scrollView setContentOffset:CGPointMake(page*SCREEN_WIDTH, 0) animated:YES];
}


#pragma scrollDelegate

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    if (_timer) {
        [self removeTimer];
    }
    return;
}
// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
    [self myTmer];
}
 // scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    //当前页码
    NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.pageControl.currentPage = page;
}
//=====================
#pragma mark -
/*
 // 返回一个放大或者缩小的视图
 - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
 
 }
 // 开始放大或者缩小
 - (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:
 (UIView *)view
 {
 
 }
 
 // 缩放结束时
 - (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
 {
 
 }
 
 // 视图已经放大或缩小
 - (void)scrollViewDidZoom:(UIScrollView *)scrollView
 {
 NSLog(@"scrollViewDidScrollToTop");
 }
 */

// 是否支持滑动至顶部
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
//{
//    return YES;
//}

// 滑动到顶部时调用该方法
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidScrollToTop");
//}

//// scrollView 已经滑动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidScroll");
//}
//
//// scrollView 开始拖动
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewWillBeginDragging");
//}
//
//// scrollView 结束拖动
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    NSLog(@"scrollViewDidEndDragging");
//}

//// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewWillBeginDecelerating");
//}
//
//// scrollview 减速停止
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidEndDecelerating");
//}

@end
