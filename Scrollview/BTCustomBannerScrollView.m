//
//  BTCustomBannerScrollView.m
//  Scrollview
//
//  Created by Beautilut on 2019/1/24.
//  Copyright © 2019 Beautilut. All rights reserved.
//

#import "BTCustomBannerScrollView.h"

@interface BTCustomBannerScrollView ()

@property (nonatomic , strong) UIView * contentView;

@property (nonatomic , strong) NSMutableDictionary * cellDics;
@property (nonatomic , strong) NSMutableDictionary * visiableCellDic;
@end

@implementation BTCustomBannerScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.contentView];
        self.maxReusableItem = 4;
        
        [self setShowsVerticalScrollIndicator:NO];
        [self setShowsHorizontalScrollIndicator:NO];

        self.bounces = NO;
        self.pagingEnabled = YES;
       
    }
    return self;
}

-(void)reloadData {
    /*
     重置cell
     */
    [self.cellDics.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.cellDics removeAllObjects];
    [self.visiableCellDic removeAllObjects];
    
    CGFloat offsize = [self.dataSource numberOfItems] * self.frame.size.width;
    [self setContentSize:CGSizeMake(offsize, self.frame.size.height)];
}

-(void)layoutSubviews {

    [super layoutSubviews];

    self.contentView.frame = CGRectMake(self.contentOffset.x, 0, self.frame.size.width, self.frame.size.height);

    {//计算当前
        NSInteger currentIndex = self.contentOffset.x / self.frame.size.width;
        
        NSRange range = NSMakeRange(currentIndex, self.maxReusableItem);
        
        @autoreleasepool {
            NSMutableArray * array = [NSMutableArray array];
            [self.visiableCellDic.allKeys enumerateObjectsUsingBlock:^(NSNumber * key, NSUInteger idx, BOOL * _Nonnull stop) {
                if (key.integerValue >= range.location && key.integerValue < range.length + range.location) {
                    
                }else{
                    [array addObject:key];
                }
            }];
            [self.visiableCellDic removeObjectsForKeys:array];
        }

        
        for (NSInteger x = 0  ; x < self.maxReusableItem ; x ++) {
            NSInteger index = (currentIndex + x) % self.maxReusableItem;
            UIView * reuseCell = [self.visiableCellDic objectForKey:@(currentIndex + x)];
            if (!reuseCell) {
                reuseCell = [self.dataSource scrollView:self viewForItemAtIndexPath:currentIndex+x];
                if (!reuseCell.superview) {
                    [self.contentView addSubview:reuseCell];
                    [self.contentView sendSubviewToBack:reuseCell];
                }
                if(x == 0) {
                    [self.contentView bringSubviewToFront:reuseCell];
                }else if(x == 3) {
                    [self.contentView sendSubviewToBack:reuseCell];
                }
                if (![self.visiableCellDic objectForKey:@(currentIndex+x)]) {
                    [self.visiableCellDic setObject:reuseCell forKey:@(currentIndex+x)];
                }
                if (![self.cellDics objectForKey:@(index)]) {
                    [self.cellDics setObject:reuseCell forKey:@(index)];
                }
            }
            if ((currentIndex + x) >= [self.dataSource numberOfItems]) {
                reuseCell.hidden = YES;
            }else {
                reuseCell.hidden = NO;
            }
            
            [self bannerView:reuseCell animationWithOffset:self.contentOffset.x - index*self.frame.size.width];
            
        }

    }
}



-(UIView *)dequeueReusableCellWithIndex:(NSInteger)index {
    NSInteger current = index % self.maxReusableItem;
    UIView * reuseCell = [self.cellDics objectForKey:@(current)];
    return reuseCell;
}

#pragma mark --
/**
 实现动画效果
 */
-(void)bannerView:(UIView *)bannerView animationWithOffset:(CGFloat)offset
{
     CGFloat cutedOffset= offset - (int)(offset/(self.frame.size.width * self.maxReusableItem))*(self.frame.size.width*self.maxReusableItem);

    if (cutedOffset < 0) {
        cutedOffset = self.frame.size.width * self.maxReusableItem + cutedOffset;
    }
    
    if (cutedOffset <= self.frame.size.width) {
         CGFloat scale = cutedOffset / self.frame.size.width;

         bannerView.transform = CGAffineTransformIdentity;
         bannerView.alpha = 1.0f;

        CGFloat left = self.frame.size.width / 2 - (bannerView.frame.size.width / 2 + self.frame.size.width / 2 + 50)* scale;
        bannerView.center = CGPointMake(left, self.frame.size.height / 2);


     }else if (cutedOffset >= self.frame.size.width && cutedOffset < self.frame.size.width * 2) {

         CGFloat scale = (cutedOffset - self.frame.size.width) / self.frame.size.width;
         
         
         bannerView.alpha = scale;

         bannerView.transform = CGAffineTransformMakeScale(0.6*scale , 0.6*scale);
         bannerView.center = CGPointMake(self.frame.size.width / 2 + 40, self.frame.size.height / 2);


     }else if (cutedOffset >= self.frame.size.width * 2 && cutedOffset < self.frame.size.width * 3) {
         CGFloat scale = (cutedOffset - self.frame.size.width*2) / self.frame.size.width;

         bannerView.alpha = 1.0f;

         bannerView.transform = CGAffineTransformMakeScale(0.6 + 0.2*scale , 0.6 + 0.2*scale);
         bannerView.center = CGPointMake(self.frame.size.width /2 + 40 - 20*scale, self.frame.size.height / 2);

     }else if (cutedOffset >= self.frame.size.width * 3 && cutedOffset < self.frame.size.width * 4) {
         CGFloat scale = (cutedOffset - self.frame.size.width * 3) / self.frame.size.width;

         bannerView.alpha = 1.0f;

         bannerView.transform = CGAffineTransformMakeScale(0.8 + 0.2*scale , 0.8 + 0.2*scale);
         bannerView.center = CGPointMake(self.frame.size.width /2 + 20 - 20*scale, self.frame.size.height / 2);
     }

}

#pragma mark ---

-(void)setDataSource:(id<BTCustomBannerScrollViewDelegate>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

-(UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

-(NSMutableDictionary *)visiableCellDic
{
    if (!_visiableCellDic) {
        _visiableCellDic = [[NSMutableDictionary alloc] init];
    }
    return _visiableCellDic;
}

-(NSMutableDictionary *)cellDics
{
    if (!_cellDics) {
        _cellDics = [[NSMutableDictionary alloc] init];
    }
    return _cellDics;
}

@end
