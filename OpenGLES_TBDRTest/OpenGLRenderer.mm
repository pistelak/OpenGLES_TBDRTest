//
//  OpenGLRenderer.m
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 5/3/16.
//  Copyright © 2016 ran. All rights reserved.
//

#import "OpenGLRenderer.h"

#import <vector>

#import "TestQuad.h"
#import "TestPoint.h"

@implementation OpenGLRenderer
{
    BaseShader *_shader;
    
    ScreenFillingTestType _testType;
    
    TestPoint *_points;
    TestQuad *_squares;
    TestQuad *_rectangles;
}

- (instancetype) initWithTestType:(NSUInteger) type
{
    self = [super init];
    if (self) {
        
        _testType = (ScreenFillingTestType) type;
        
        [self prepareToDraw];
        
        _points = [[TestPoint alloc] initWithSizeOfScreen:[self sizeOfScreen] andShader:_shader];
        
        _squares = [[TestQuad alloc] initWithSizeOfScreen:[self sizeOfScreen]
                                              sizeOfQuads:[self sizeOfQuadsForTestType:ScreenFillingTestSquare]
                                                andShader:_shader];
        
        _rectangles = [[TestQuad alloc] initWithSizeOfScreen:[self sizeOfScreen]
                                                 sizeOfQuads:[self sizeOfQuadsForTestType:ScreenFillingTestRectangle]
                                                   andShader:_shader];
    }
    
    return self;
}

- (void) prepareToDraw
{
    _shader = [[BaseShader alloc] init];
    [_shader loadShader];
    
    glUseProgram(_shader.program);
    
    glClearColor(0, 104.f/255.f, 55.f/255.f, 1.f);
    
    const CGSize screenSize = [self sizeOfScreen];
    const GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, screenSize.width, 0, screenSize.height, 0, 1);
    glUniformMatrix4fv(_shader.u_projectionMatrix, 1, 0, projectionMatrix.m);
    
    glDisable(GL_SCISSOR_TEST);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_STENCIL_TEST);
    
    glEnable(GL_PRIMITIVE_RESTART_FIXED_INDEX);
}

#pragma mark -
#pragma mark GLKView delegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
//    glFinish();
    
//    CFTimeInterval previousTimestamp = CFAbsoluteTimeGetCurrent();
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    switch (_testType) {
        case ScreenFillingTestPoint:
            [_points draw];
            break;
        case ScreenFillingTestSquare:
            [_squares draw];
            break;
        case ScreenFillingTestRectangle:
            [_rectangles draw];
            break;
    }
    
//    glFinish();
    
//    CFTimeInterval frameDuration = CFAbsoluteTimeGetCurrent() - previousTimestamp;
//    NSLog(@"Frame duration: %f ms", frameDuration * 1000.0);
}

- (void) glkViewControllerUpdate:(ViewController *)controller
{
    if (_testType != controller.type) {
        _testType = controller.type;
    }
}

#pragma mark -
#pragma mark Helper methods

- (CGSize) sizeOfQuadsForTestType:(ScreenFillingTestType) type
{
    switch (type) {
        case ScreenFillingTestPoint:
            return CGSizeMake(1, 1);
        case ScreenFillingTestSquare:
            return CGSizeMake(2, 2);
        case ScreenFillingTestRectangle:
            return CGSizeMake(4, 1);
    }
}

- (CGSize) sizeOfScreen
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    return CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
}

@end
