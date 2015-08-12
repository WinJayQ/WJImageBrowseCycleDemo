//
//  ViewController.m
//  WJImageBrowseCycleDemo
//
//  Created by jh navi on 15/8/12.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

#import "ViewController.h"

#define kMainWidth    [[UIScreen mainScreen] bounds].size.width
#define kMainHeight   [[UIScreen mainScreen] bounds].size.height
#define IMAGEVIEW_COUNT 3

@interface ViewController ()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_leftImageView;
    UIImageView *_centerImageView;
    UIImageView *_rightImageView;
    UIPageControl *_pageControl;
    UILabel *_label;
    NSMutableDictionary *_imageData;//图片数据
    int _currentImageIndex;//当前图片索引
    int _imageCount;//图片总数
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //加载数据
    [self loadImageData];
    [self loadUI];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoImageLoop) userInfo:nil repeats:YES];
}

#pragma mark 加载UI
- (void)loadUI{
    _scrollView=[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_scrollView];
    //设置代理
    _scrollView.delegate=self;
    //设置contentSize
    _scrollView.contentSize=CGSizeMake(IMAGEVIEW_COUNT*kMainWidth, kMainHeight) ;
    //设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(kMainWidth, 0) animated:NO];
    //设置分页
    _scrollView.pagingEnabled=YES;
    //去掉滚动条
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    //添加图片三个控件
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight)];
    _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_leftImageView];
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kMainWidth, 0, kMainWidth, kMainHeight)];
    _centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_centerImageView];
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*kMainWidth, 0, kMainWidth, kMainHeight)];
    _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_rightImageView];
    //加载默认图片
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_imageCount-1]];
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",0]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",1]];

    
    //添加分页控件
    _pageControl=[[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize size= [_pageControl sizeForNumberOfPages:_imageCount];
    _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
    _pageControl.center=CGPointMake(kMainWidth/2, kMainHeight-100);
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //设置总页数
    _pageControl.numberOfPages=_imageCount;
    //设置当前页
    _currentImageIndex=0;
    _pageControl.currentPage=_currentImageIndex;
    [self.view addSubview:_pageControl];
    
    
    //添加信息描述控件
    _label=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, kMainWidth,60)];
    _label.textAlignment=NSTextAlignmentCenter;
    _label.textColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    NSString *imageName=[NSString stringWithFormat:@"%i.jpg",_currentImageIndex];
    _label.text=_imageData[imageName];
    [self.view addSubview:_label];

}

#pragma mark 加载图片数据
-(void)loadImageData{
    //读取程序包路径中的资源文件
    NSString *path=[[NSBundle mainBundle] pathForResource:@"imageInfo" ofType:@"plist"];
    _imageData=[NSMutableDictionary dictionaryWithContentsOfFile:path];
    _imageCount=(int)_imageData.count;
}


#pragma mark 滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(kMainWidth, 0) animated:NO];
    //设置分页
    _pageControl.currentPage=_currentImageIndex;
    //设置描述
    NSString *imageName=[NSString stringWithFormat:@"%i.jpg",_currentImageIndex];
    _label.text=_imageData[imageName];
}

#pragma mark 重新加载图片
-(void)reloadImage{
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[_scrollView contentOffset];
    if (offset.x>kMainWidth) { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_imageCount;
    }else if(offset.x<kMainWidth){ //向左滑动
        _currentImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    }
    //UIImageView *centerImageView=(UIImageView *)[_scrollView viewWithTag:2];
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_currentImageIndex]];
    
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    rightImageIndex=(_currentImageIndex+1)%_imageCount;
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",leftImageIndex]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",rightImageIndex]];
}

#pragma mark 自动图片循环
- (void)autoImageLoop{
    int leftImageIndex,rightImageIndex;
    _currentImageIndex=(_currentImageIndex+1)%_imageCount;
    _centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",_currentImageIndex]];
    
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    rightImageIndex=(_currentImageIndex+1)%_imageCount;
    _leftImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",leftImageIndex]];
    _rightImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",rightImageIndex]];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(kMainWidth, 0) animated:NO];
    //设置分页
    _pageControl.currentPage=_currentImageIndex;
    //设置描述
    NSString *imageName=[NSString stringWithFormat:@"%i.jpg",_currentImageIndex];
    _label.text=_imageData[imageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
