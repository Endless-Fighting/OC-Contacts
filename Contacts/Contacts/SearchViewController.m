//
//  SearchViewController.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/10.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#import "SearchViewController.h"
#import <WebKit/WebKit.h>

@interface SearchViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation SearchViewController

- (void)viewDidLoad{
    [super loadView];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.baidu.com/?pu=sz%401321_666"]]];
    [self.view addSubview:webView];
}


@end
