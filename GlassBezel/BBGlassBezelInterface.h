/* QSController */

@interface BBGlassBezelInterface : QSResizingInterfaceController {
	NSRect standardRect;
}
@end

@interface NSWindow (QSBCInterfaceController)
- (NSTimeInterval)animationResizeTime:(NSRect)newWindowFrame;
@end
