//
//  CBCandleView.m
//  LineChart
//
//  Created by ly on 12/18/12.
//  Copyright (c) 2012 Lei Yan. All rights reserved.
//

#import "CBCandleView.h"

@implementation CBCandleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.list = [[NSMutableArray alloc] initWithCapacity:0];
//    [self.list addObject:@[@6.79, @6.68, @6.83, @6.62]];
    [self.list addObjectsFromArray:[NSArray arrayWithContentsOfFile:@"/Users/ly/Documents/Projects/LineChart/LineChart/silver.plist"]];
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    double zoomScale = 100;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 设置坐标原点为左下角，y轴正向向上，x轴正向向右 */
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -300-560);
    
    for (int i = 0; i < [self.list count]; i++) {
        NSArray *prices = [self.list objectAtIndex:i];
        double openingPrice = [prices[1] doubleValue];
        double closingPrice = [prices[2] doubleValue];
        double ceilingPrice = [prices[3] doubleValue];
        double floorPrice =   [prices[4] doubleValue];
        
        NSLog(@"%f, %f, %f, %f", openingPrice, closingPrice, ceilingPrice, floorPrice);
        
        /* 设置填充色 */
        if (openingPrice > closingPrice) {        // 红
            CGContextSetRGBFillColor(context, 1, 0, 0, 1);
            CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
        }
        else if (openingPrice < closingPrice) {        // 绿
            CGContextSetRGBFillColor(context, 0, 1, 0, 1);
            CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
        }
        else {  // 黑色
            CGContextSetRGBFillColor(context, 0, 0, 0, 1);
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        }

        /* 绘制蜡烛图 */
        int height = (closingPrice-openingPrice)*zoomScale;
        if (height == 0)
            height = 1;
        
        
        CGContextFillRect(context, CGRectMake(i*11, openingPrice*zoomScale, 11, height));
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, i*11+6, ceilingPrice*zoomScale);
        CGContextAddLineToPoint(context, i*11+6, floorPrice*zoomScale);
        CGContextClosePath(context);
        CGContextStrokePath(context);
    }
    
}


@end
