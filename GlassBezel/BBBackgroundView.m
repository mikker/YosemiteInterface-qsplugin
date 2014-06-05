//
//  BBBackgroundView.m
//  GlassBezel
//
//  Created by Mikkel Malmberg on 04/06/14.
//  Copyright (c) 2014 BRNBW. All rights reserved.
//

#import "BBBackgroundView.h"

@implementation BBBackgroundView

- (void)drawRect:(NSRect)rect {
  rect = [self bounds];
  
  NSBezierPath *roundRect = [NSBezierPath bezierPath];
  CGFloat minRadius = MIN(NSWidth(rect), NSHeight(rect) )/2;
  
  [roundRect appendBezierPathWithRoundedRectangle:rect withRadius:MIN(minRadius, 5)];
  [roundRect addClip];
  
  [[NSColor whiteColor] set];
  NSRectFill(rect);

  [super drawRect:rect];
}

@end
