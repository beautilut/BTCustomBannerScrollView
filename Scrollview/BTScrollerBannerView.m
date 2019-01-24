//
//  BTScrollerBannerView.m
//  Scrollview
//
//  Created by Beautilut on 2019/1/23.
//  Copyright © 2019 Beautilut. All rights reserved.
//

#import "BTScrollerBannerView.h"
#import "BTScrollerBannerContentView.h"


@interface BTScrollerBannerView () <UIScrollViewDelegate , BTScrollerBannerContentViewDelegate>

@property (nonatomic , strong) NSArray * data;
@property (nonatomic , assign) NSInteger currentIndex;

@property (nonatomic , strong) UIScrollView * scrollView;
@property (nonatomic , strong) UIView * backView;

@property (nonatomic , strong) NSArray <BTScrollerBannerContentView *> * contentViews;

@end


@implementation BTScrollerBannerView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        self.scrollView.frame= self.bounds;
        
        self.data = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
        
        self.backView.frame = self.bounds;
        [self.scrollView addSubview:self.backView];
        
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        NSMutableArray * array = [NSMutableArray array];
        UIView * last = nil;
        for (int i = 0 ; i < 4 ; i++) {
            BTScrollerBannerContentView  * view = [[BTScrollerBannerContentView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            view.currentType = i;
            view.maxWidth = self.frame.size.width;
            view.maxHeight = self.frame.size.height;
            [view.label setText:self.data[i]];
            view.currentIndex = @(0);
            view.delegate = self;
            view.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
            
            [view updateStatus];
            
            if (last) {
                [self.backView insertSubview:view belowSubview:last];
            }else {
                [self.backView addSubview:view];
            }
            
            
            last = view;
            
            [array addObject:view];
        }
        
        self.contentViews = [array copy];
        
        self.currentIndex = 0;
    }
    return self;
}

-(void)dealloc
{
    [self removeObserver:self.scrollView forKeyPath:@"contentOffset"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark --scroll view delegate--

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger temp = self.currentIndex;
    if (scrollView.contentOffset.x == 0 || (scrollView.contentOffset.x == self.frame.size.width && self.currentIndex == self.data.count - 1)) {
        self.currentIndex = self.currentIndex - 1;
        if (self.currentIndex < 0) {
            self.currentIndex = 0;
        }
    }else {
        self.currentIndex = self.currentIndex + 1;
        if (self.currentIndex >= self.data.count -1  ) {
            self.currentIndex = self.data.count - 1 ;
        }
    }
    
    if (self.currentIndex > 0 && self.currentIndex < self.data.count-1 ) {
        self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    if (temp != self.currentIndex) {
        [self.contentViews makeObjectsPerformSelector:@selector(updateType:) withObject:@(temp - self.currentIndex)];
        [self.contentViews makeObjectsPerformSelector:@selector(setCurrentIndex:) withObject:@(self.currentIndex)];
    }
}

-(id)getDataObject:(NSInteger)index
{
    if (self.data.count > index && index >= 0) {
        return self.data[index];
    }else {
        return nil;
    }
}

#pragma mark -- kvo --
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        CGFloat newoffset_x = newvalue.UIOffsetValue.horizontal;
        
        CGRect frame = self.backView.frame;
        self.backView.frame = CGRectMake(newoffset_x, frame.origin.y, frame.size.width, frame.size.height);
        
        if (self.currentIndex == 0) {
            [self.contentViews makeObjectsPerformSelector:@selector(animationWithOffset:) withObject:@(newoffset_x/self.frame.size.width + 1)];
        }else if(self.currentIndex == self.data.count - 1) {
            
            if (newoffset_x < self.frame.size.width*2) {
                [self.contentViews makeObjectsPerformSelector:@selector(animationWithOffset:) withObject:@(newoffset_x/self.frame.size.width - 1)];
            }
            
        }else{
            [self.contentViews makeObjectsPerformSelector:@selector(animationWithOffset:) withObject:@(newoffset_x/self.frame.size.width)];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.currentIndex == 0 && scrollView.contentOffset.x > self.scrollView.frame.size.width) {
        scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
    if (self.currentIndex == self.data.count - 1 && scrollView.contentOffset.x < self.scrollView.frame.size.width) {
        scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }
}

#pragma mark --

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [UIColor greenColor];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor redColor];
    }
    return _backView;
}
@end
