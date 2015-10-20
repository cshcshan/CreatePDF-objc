//
//  ViewController.m
//  TestCreatePDF
//
//  Created by Han Chen on 2015/10/20.
//  Copyright © 2015年 Han Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CGRect a4Rect;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    a4Rect = CGRectMake(0, 0, 612, 792);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createPDFButton:(UIButton *)sender {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *pdfFilePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"NewPDF.pdf"]];
    
    NSLog(@"%@", pdfFilePath);
    
    UIGraphicsBeginPDFContextToFile(pdfFilePath, a4Rect, nil);
    UIView *pdfView;
    for (int page = 0; page < 10; page++) {
        pdfView = [self createTemplatePDF];
        pdfView = [self createPDFContentWithTemplate:pdfView AndPageNumber:(page + 1)];
        UIGraphicsBeginPDFPage();
        CGContextRef pdfContext = UIGraphicsGetCurrentContext();
        [pdfView.layer renderInContext:pdfContext];
    }
    
    UIGraphicsEndPDFContext();
}

-(UIView *)createTemplatePDF {
    const int TITLE_HEIGHT = 60;
    const int BOTTOM_HEIGHT = 120;
    const int INTERVAL_HEIGHT = 10;
    const int INTERVAL_COUNT = 4;
    const int CONTENT_WIDTH = CGRectGetWidth(a4Rect) - 40 * 2;
    const int CENTER_HEIGHT = CGRectGetHeight(a4Rect) - TITLE_HEIGHT - BOTTOM_HEIGHT - INTERVAL_HEIGHT * INTERVAL_COUNT;
    
    
    UIView *pdfView = [[UIView alloc] initWithFrame:a4Rect];
    
    // TITLE
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(a4Rect), TITLE_HEIGHT)];
    [titleLabel setText:@"建立PDF測試"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1.0]];
    [titleLabel setFont:[UIFont systemFontOfSize:48.0]];
    [pdfView addSubview:titleLabel];
    
    // CENTER
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0.5 * (CGRectGetWidth(a4Rect) - CONTENT_WIDTH),
                                                                  CGRectGetMaxY(titleLabel.frame) + INTERVAL_HEIGHT,
                                                                  CONTENT_WIDTH, CENTER_HEIGHT)];
    [centerView setBackgroundColor:[UIColor colorWithRed:64/255.0 green:224/255.0 blue:208/255.0 alpha:1.0]];
    [centerView setTag:100];
    [pdfView addSubview:centerView];
    
    // BOTTOM
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.5 * (CGRectGetWidth(a4Rect) - CONTENT_WIDTH),
                                                                  CGRectGetMaxY(centerView.frame) + INTERVAL_HEIGHT,
                                                                  CONTENT_WIDTH, BOTTOM_HEIGHT)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:1.0]];
    [pdfView addSubview:bottomView];
    
    return pdfView;
}

-(UIView *)createPDFContentWithTemplate:(UIView *)pdfView AndPageNumber:(int)pageNumber {
    UIView *contentView = [pdfView viewWithTag:100];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(contentView.frame), 100)];
    [contentLabel setText:[NSString stringWithFormat:@"第 %d 頁", pageNumber]];
    [contentLabel setTextAlignment:NSTextAlignmentCenter];
    [contentLabel setTextColor:[UIColor darkGrayColor]];
    [contentLabel setFont:[UIFont systemFontOfSize:24.0]];
    [contentView addSubview:contentLabel];
    return pdfView;
}

@end
