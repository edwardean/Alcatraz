//
// ATZPackageTableCellView.m
//
// Copyright (c) 2013 Marin Usalj | mneorr.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ATZPackageTableCellView.h"
#import "ATZPackage.h"

@interface ATZPackageTableCellView()
@property (assign) BOOL isHighlighted;
@end

@implementation ATZPackageTableCellView

- (void)awakeFromNib {
    [self createTrackingArea];
}

- (void)setButtonsVisible:(BOOL)visible animated:(BOOL)animated {
    float alphaValue = visible ? 0.5f : 0.0f;
    
    id packageTypeTextField = animated ? self.packageTypeTextField.animator : self.packageTypeTextField;
    id websiteButton = animated ? self.websiteButton.animator : self.websiteButton;
    id screenshotButton = animated ? self.screenshotButton.animator : self.screenshotButton;
    
    if (visible) {
        [self.websiteButton setToolTip:[(ATZPackage *)self.objectValue website]];
        [self.websiteButton setHidden:!visible];
        [self.screenshotButton setHidden:!visible];
    }
    
    if (![(ATZPackage *)self.objectValue screenshotPath]) [self.screenshotButton setHidden:YES];
    
    [packageTypeTextField setAlphaValue:!visible];

    if (!self.isHighlighted) {
        [websiteButton setAlphaValue:alphaValue];
        [screenshotButton setAlphaValue:alphaValue];
        if (visible) self.isHighlighted = YES;
    }
}

- (void)viewWillDraw {
    if (!self.isHighlighted) [self setButtonsVisible:NO animated:NO];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [self showButtonsIfNeeded];
}

- (void)mouseExited:(NSEvent *)theEvent {
    self.isHighlighted = NO;
    [self setButtonsVisible:NO animated:YES];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    if (!self.isHighlighted)
        [self showButtonsIfNeeded];
}

#pragma mark - Private

- (void)createTrackingArea {
    NSTrackingAreaOptions focusTrackingAreaOptions = NSTrackingActiveInActiveApp | NSTrackingMouseEnteredAndExited |
                                                     NSTrackingAssumeInside      | NSTrackingInVisibleRect |
                                                     NSTrackingMouseMoved;
    
    NSTrackingArea *focusTrackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                     options:focusTrackingAreaOptions
                                                       owner:self
                                                    userInfo:nil];
    [self addTrackingArea:focusTrackingArea];
    [focusTrackingArea release];
}

- (void)showButtonsIfNeeded {
    NSPoint globalLocation = [NSEvent mouseLocation];
    NSPoint windowLocation = [self.window convertScreenToBase:globalLocation];
    NSPoint viewLocation = [self convertPoint:windowLocation fromView:nil];
    if(NSPointInRect(viewLocation, self.bounds)) {
        [self setButtonsVisible:YES animated:YES];
    }
}

@end
