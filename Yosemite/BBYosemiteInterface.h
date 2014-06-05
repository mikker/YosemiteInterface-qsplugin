@interface BBYosemiteInterface : QSResizingInterfaceController {
	NSRect standardRect;
}

@property (assign) IBOutlet NSImageView *image1;
@property (assign) IBOutlet NSImageView *image2;
@property (assign) IBOutlet NSImageView *image3;

@end

@interface NSWindow (QSBCInterfaceController)
- (NSTimeInterval)animationResizeTime:(NSRect)newWindowFrame;
@end
