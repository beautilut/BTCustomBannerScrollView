//
//  ViewController.m
//  Scrollview
//
//  Created by Beautilut on 2019/1/23.
//  Copyright © 2019 Beautilut. All rights reserved.
//

#import "ViewController.h"
#import "BTScrollerBannerView.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView * scrol = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrol.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*3);
    [self.view addSubview:scrol];
    
    BTScrollerBannerView * banner = [[BTScrollerBannerView alloc] initWithFrame:CGRectMake(0, 700, self.view.frame.size.width, 200)];
    [scrol addSubview:banner];
    
    // Do any additional setup after loading the view, typically from a nib.
}


@end
