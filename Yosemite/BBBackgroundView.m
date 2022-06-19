#import "BBBackgroundView.h"

@implementation BBBackgroundView

- (void)drawRect:(NSRect)rect {
  rect = [self bounds];
  
  NSBezierPath *roundRect = [NSBezierPath bezierPath];
  CGFloat minRadius = MIN(NSWidth(rect), NSHeight(rect) )/2;
  
  [roundRect appendBezierPathWithRoundedRectangle:rect withRadius:MIN(minRadius, 5)];
  [roundRect addClip];
  
  BOOL darkMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"QSYosemiteDarkMode"];
  if (darkMode) {
      [[NSColor colorWithRed:.1 green:.1 blue:.1 alpha:.99] set];
  } else {
      [[NSColor colorWithRed:1 green:1 blue:1 alpha:.99] set];
  }
  NSRectFill(rect);

  [super drawRect:rect];
}

@end
