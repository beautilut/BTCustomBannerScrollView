//
//  ViewController.m
//  Scrollview
//
//  Created by Beautilut on 2019/1/23.
//  Copyright © 2019 Beautilut. All rights reserved.
//

#import "ViewController.h"
#import "BTScrollerBannerView.h"
#import "BTCustomBannerScrollView.h"

@interface ViewController () <BTCustomBannerScrollViewDelegate>



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView * scrol = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrol.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*3);
    [self.view addSubview:scrol];
    
    BTScrollerBannerView * banner = [[BTScrollerBannerView alloc] initWithFrame:CGRectMake(0, 700, self.view.frame.size.width, 200)];
    [scrol addSubview:banner];


    BTCustomBannerScrollView * scrollView = [[BTCustomBannerScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    scrollView.backgroundColor = [UIColor greenColor];
    scrollView.dataSource = self;
    [scrol addSubview:scrollView];

    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark --

-(NSInteger)numberOfItems {
    return 15;
}

-(UIView *)scrollView:(BTCustomBannerScrollView *)bannerScrollView viewForItemAtIndexPath:(NSInteger)index {
    UIView * bannerView = [bannerScrollView dequeueReusableCellWithIndex:index];
    if (!bannerView) {
        bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [bannerView addSubview:label];
        label.tag = 100;
        bannerView.backgroundColor = [UIColor blueColor];
    }

    UILabel * label = [bannerView viewWithTag:100];
    label.text = @(index).stringValue;
    return bannerView;
}

@end
