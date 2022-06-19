#import "BBYosemiteInterface.h"

@interface BBYosemiteInterface () {
    CGRect initialRect;
}
@end

@implementation BBYosemiteInterface

- (id)init {
    return [self initWithWindowNibName:@"BBYosemiteInterface"];
}

- (IBAction)customize:(id)sender{
    [[NSClassFromString(@"QSPreferencesController") sharedInstance] showPaneWithIdentifier:@"BBYosemitePrefs"];
}

- (void)windowDidLoad {
    initialRect = centerRectInRect([[self window] frame], [[NSScreen mainScreen] frame]);
    
    [super windowDidLoad];
    
    QSWindow *window = (QSWindow *)[self window];
    [window setLevel:NSPopUpMenuWindowLevel];
    [window setBackgroundColor:[NSColor clearColor]];
    [window setOpaque:NO];
    
    [window setHideOffset:NSMakePoint(0, 0)];
    [window setShowOffset:NSMakePoint(0, 0)];
    
    [window setMovableByWindowBackground:NO];
    [window setFastShow:YES];
    [window setHasShadow:YES];
    
    [window setFrame:standardRect display:YES];
    
    NSArray *theControls = [NSArray arrayWithObjects:dSelector, aSelector, iSelector, nil];
    for(QSSearchObjectView *theControl in theControls) {
        QSObjectCell *theCell = [theControl cell];
        
        [theControl setResultsPadding:NSMinX([dSelector frame])];
        [theControl setPreferredEdge:NSMaxY([dSelector frame])];
        [theControl setTextCellFont:[NSFont systemFontOfSize:16]];
        
        [(QSWindow *)[(theControl)->resultController window] setHideOffset:NSMakePoint(NSMaxX([iSelector frame]), 0)];
        [(QSWindow *)[(theControl)->resultController window] setShowOffset:NSMakePoint(NSMaxX([dSelector frame]), 0)];
        
        [theCell setBackgroundColor:[NSColor clearColor]];
        
        if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_10_Max) {
            [theCell setFont:[NSFont fontWithName:@"HelveticaNeue-Light" size:26]];
        } else {
            [theCell setFont:[NSFont systemFontOfSize:26 weight:NSFontWeightLight]];
        }
        
        [theCell setShowDetails:YES];
        [theCell setState:NSOnState];
        [theCell setCellRadiusFactor:30];
        [theCell setIconSize:QSSize32];
        [theCell setDetailsFont:[NSFont systemFontOfSize:12]];
        [theCell setImagePosition:NSImageRight];
    }
    [self setupColorMode];
    float imageAlpha = .2;
    [self.image1 setAlphaValue:imageAlpha];
    [self.image2 setAlphaValue:imageAlpha];
    [self.image3 setAlphaValue:imageAlpha];
    
    [self contractWindow:nil];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"QSYosemiteDarkMode" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"QSYosemiteDarkMode"]) {
        [self setupColorMode];
    }
}

- (void)setupColorMode {
    NSArray *theControls = [NSArray arrayWithObjects:dSelector, aSelector, iSelector, nil];
    BOOL darkMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"QSYosemiteDarkMode"];
    for(QSSearchObjectView *theControl in theControls) {
        QSObjectCell *theCell = [theControl cell];
        if (darkMode) {
            [theCell setHighlightColor:[NSColor colorWithRed:1 green:1 blue:1 alpha:.15]];
            [theCell setTextColor:[NSColor colorWithWhite:.8 alpha:1]];

        } else {
            [theCell setHighlightColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:.1]];
            [theCell setTextColor:[NSColor colorWithWhite:0.3 alpha:1]];
        }
    }
    float imageAlpha = darkMode ? 0.5 : 0.2;
    NSImage *searchImage = [[NSBundle bundleForClass:[self class]] imageForResource:(darkMode ? @"search-white.png" : @"search-black.png")];
    NSImage *actionImage = [[NSBundle bundleForClass:[self class]] imageForResource:(darkMode ? @"gear-white.png" : @"gear-black.png")];
    self.image1.image = searchImage;
    self.image2.image = actionImage;
    self.image3.image = searchImage;
    self.image1.alphaValue = imageAlpha;
    self.image2.alphaValue = imageAlpha;
    self.image3.alphaValue = imageAlpha;
}
    
- (void)showIndirectSelector:(id)sender {
    if (![iSelector superview] && !expanded)
        [iSelector setFrame:NSOffsetRect([aSelector frame],0,-64)];
    [super showIndirectSelector:sender];
}

- (NSSize) maxIconSize {
    return QSSize48;
}

- (void)showMainWindow:(id)sender {
    [[self window] setFrame:[self rectForState:[self expanded]]  display:YES];
    if ([[self window] isVisible]) [[self window] pulse:self];
    [super showMainWindow:sender];
    //    Does this need to be here?
    [[[self window] contentView] setNeedsDisplay:YES];
}

- (void)expandWindow:(id)sender {
    if (![self expanded])
        [[self window] setFrame:[self rectForState:YES] display:YES animate:YES];
    [super expandWindow:sender];
}

- (void)contractWindow:(id)sender {
    if ([self expanded])
        [[self window] setFrame:[self rectForState:NO] display:YES animate:YES];
    [super contractWindow:sender];
}

- (NSRect)rectForState:(BOOL)shouldExpand {
    NSRect newRect = initialRect;
    NSRect screenRect = [[NSScreen mainScreen] frame];
    
    float padding = 0;
    if (!shouldExpand) {
        newRect.size.height -= 64;
    } else {
        padding = 32;
    }
    
    return NSOffsetRect(centerRectInRect(newRect, screenRect), 0, (NSHeight(screenRect) / 5) - padding);
}

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
    return NSOffsetRect(NSInsetRect(rect, 8, 0), 0, 0);
}

- (NSTimeInterval)animationResizeTime:(NSRect)newWindowFrame {
    return 0.01;
}

@end
