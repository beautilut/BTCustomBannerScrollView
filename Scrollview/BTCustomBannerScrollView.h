//
//  BTCustomBannerScrollView.h
//  Scrollview
//
//  Created by Beautilut on 2019/1/24.
//  Copyright © 2019 Beautilut. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTCustomBannerScrollViewDelegate;

@interface BTCustomBannerScrollView : UIScrollView

@property (nonatomic , weak) id <BTCustomBannerScrollViewDelegate> dataSource;
@property (nonatomic , assign) NSInteger maxReusableItem;

-(UIView *)dequeueReusableCellWithIndex:(NSInteger)index;

-(void)reloadData;

-(void)bannerView:(UIView *)bannerView animationWithOffset:(CGFloat)offset;
@end

@protocol BTCustomBannerScrollViewDelegate <NSObject>


-(NSInteger)numberOfItems;

-(UIView *)scrollView:(BTCustomBannerScrollView *)bannerScrollView viewForItemAtIndexPath:(NSInteger)index;

@end
