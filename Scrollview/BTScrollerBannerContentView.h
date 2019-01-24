//
//  BTScrollerBannerContentView.h
//  Scrollview
//
//  Created by Beautilut on 2019/1/23.
//  Copyright © 2019 Beautilut. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    ContentTypeFirst = 0,
    ContentTypeSecond,
    ContentTypeThird,
    ContentTypeReady
} ContentType;

NS_ASSUME_NONNULL_BEGIN

@protocol BTScrollerBannerContentViewDelegate <NSObject>

-(id)getDataObject:(NSInteger)index;

@end

@interface BTScrollerBannerContentView : UIView

@property (nonatomic , weak) id <BTScrollerBannerContentViewDelegate> delegate;

@property (nonatomic , assign) ContentType currentType;
@property (nonatomic , strong) NSNumber * currentIndex;

@property (nonatomic , assign) CGFloat maxWidth;
@property (nonatomic , assign) CGFloat maxHeight;

@property (nonatomic , strong) UILabel * label;

-(void)updateStatus;
-(void)updateType:(NSNumber*)update;

-(void)animationWithOffset:(NSNumber *)offset;
@end

NS_ASSUME_NONNULL_END
