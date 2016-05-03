//
//  View.m
//  OpenGLSimpleGame
//
//  Created by Radek Pistelak on 25.03.16.
//  Copyright © 2016 ran. All rights reserved.
//

#import "View.h"

@implementation View
{
    EAGLContext* _context;
}

- (instancetype) initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
        
        if (!_context || ![EAGLContext setCurrentContext:_context]) {
            return nil;
        }

        [self setContext:_context];
    }
    
    return self;
}

- (void)didMoveToWindow
{
    self.contentScaleFactor = self.window.screen.nativeScale;
}

@end
