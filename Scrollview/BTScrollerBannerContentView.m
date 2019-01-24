//
//  BTScrollerBannerContentView.m
//  Scrollview
//
//  Created by Beautilut on 2019/1/23.
//  Copyright © 2019 Beautilut. All rights reserved.
//

#import "BTScrollerBannerContentView.h"

@implementation BTScrollerBannerContentView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.label.backgroundColor = [UIColor blueColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)updateStatus
{
    if (ContentTypeFirst == self.currentType) {
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    }else if(ContentTypeSecond == self.currentType) {
        self.transform = CGAffineTransformMakeScale(0.8 , 0.8);
        
        self.center = CGPointMake(self.maxWidth/2 + 20, self.center.y);
        self.alpha = 1.0f;
    }else if(ContentTypeThird == self.currentType) {
        self.transform = CGAffineTransformMakeScale(0.6 , 0.6);
        self.center = CGPointMake(self.maxWidth/2 + 40, self.center.y);
        self.alpha = 1.0f;
    }else if(ContentTypeReady == self.currentType) {
        self.transform = CGAffineTransformIdentity;
        self.alpha = 0;
    }
}

-(void)updateType:(NSNumber *)update;
{
    self.currentType = self.currentType + update.integerValue;
    if (self.currentType > ContentTypeReady) {
        self.currentType = ContentTypeFirst;
    }
    if (self.currentType < ContentTypeFirst) {
        self.currentType = ContentTypeReady;
    }
    [self updateStatus];
}

-(void)updateData:(id)data
{
    if (data) {
        [self.label setText:data];
        self.hidden = NO;
    }else {
        [self.label setText:@""];
        self.hidden = YES;
    }
}

-(void)animationWithOffset:(NSNumber *)scale
{
    if (ContentTypeFirst == self.currentType) {
        if (scale.floatValue < 1) {
            //scale 变小
            CGFloat scaleValue = scale.floatValue;
            self.transform = CGAffineTransformMakeScale(0.8 + 0.2*scaleValue , 0.8 + 0.2*scaleValue);
            self.center = CGPointMake(self.maxWidth /2  + 20 - 20*scaleValue, self.maxHeight / 2);
            
        }else if(scale.floatValue > 1) {
            
            //scale 变大
            CGFloat scaleValue = scale.floatValue - 1;
            self.transform = CGAffineTransformIdentity;
            CGFloat left = self.maxWidth/2 - (self.frame.size.width/2 + self.maxWidth/2)*scaleValue;
            self.center = CGPointMake(left, self.maxHeight/2);
            
        }
        
    }else if(ContentTypeSecond == self.currentType) {
        
        if (scale.floatValue < 1) {
            
            //scale 变小
            CGFloat scaleValue = scale.floatValue ;
            self.transform = CGAffineTransformMakeScale(0.6 + 0.2*scaleValue , 0.6 + 0.2*scaleValue);
            self.center = CGPointMake(self.maxWidth /2 + 40 - 20*scaleValue, self.maxHeight/2);
            
            
        }else if(scale.floatValue > 1) {
            
            //scale 变大
            CGFloat scaleValue = scale.floatValue - 1;
            
            self.transform = CGAffineTransformMakeScale(0.8 + 0.2*scaleValue , 0.8 + 0.2*scaleValue);
            self.center = CGPointMake(self.maxWidth /2 + 20 - 20*scaleValue, self.maxHeight / 2);

        }else{
            
        }
        
    }else if(ContentTypeThird == self.currentType) {
        if (scale.floatValue < 1) {
            

            
            //scale 变小
            CGFloat scaleValue = scale.floatValue;
            self.center = CGPointMake(self.maxWidth / 2 + 40, self.maxHeight  /2);
            self.transform = CGAffineTransformMakeScale(0.6 *(scaleValue) , 0.6 *(scaleValue));
            self.alpha = scaleValue;
            
        }else if(scale.floatValue > 1) {
            
            
            
            //scale 变大
            CGFloat scaleValue = scale.floatValue - 1;

            self.transform = CGAffineTransformMakeScale(0.6 + 0.2*scaleValue , 0.6 + 0.2*scaleValue);
            self.center = CGPointMake(self.maxWidth /2 + 40 - 20*scaleValue, self.maxHeight/2);
            
        }else{
            
        }
    }else if(ContentTypeReady == self.currentType) {
        if (scale.floatValue < 1) {
            
            if ([self.delegate respondsToSelector:@selector(getDataObject:)]) {
                id data = [self.delegate getDataObject:self.currentIndex.integerValue - 1];
                [self updateData:data];
            }
            
            
            [self.superview bringSubviewToFront:self];
            //scale 变小
            CGFloat scaleValue = scale.floatValue;
            self.transform = CGAffineTransformIdentity;
            self.alpha = 1;
            
            CGFloat left = -self.frame.size.width/2 + (self.frame.size.width/2 + self.maxWidth/2)*(1-scaleValue);
            self.center = CGPointMake(left, self.maxHeight/2);
            
        }else if(scale.floatValue > 1) {
            [self.superview sendSubviewToBack:self];
            
            if ([self.delegate respondsToSelector:@selector(getDataObject:)]) {
               id data = [self.delegate getDataObject:self.currentIndex.integerValue + 3];
                [self updateData:data];
            }
            
            CGFloat scaleValue = scale.floatValue - 1;
            
            self.center = CGPointMake(self.maxWidth / 2 + 40, self.maxHeight  /2);
            self.transform = CGAffineTransformMakeScale(0.6 *(scaleValue) , 0.6 *(scaleValue));
            self.alpha = scaleValue;
            
        }else{
            
        }
    }
}

@end
