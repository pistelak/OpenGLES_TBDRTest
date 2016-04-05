//
//  ViewController.m
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 05.04.16.
//  Copyright © 2016 ran. All rights reserved.
//

#import "ViewController.h"

#import "ViewController.h"
#import "Quad.h"

@interface ViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) NSArray *models;

@end

@implementation ViewController
{
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    
    NSUInteger _vertexCount;
    NSUInteger _indexCount;
    
    GLKMatrix4 _projectionMatrix;
    
    BaseShader *_shader;
}

const vertex_t vertices[] = {
    {{  0.0,  1.0, 0.0 }}, // 0 TL
    {{  1.0,  1.0, 0.0 }}, // 1 TR
    {{  1.0,  0.0, 0.0 }}, // 2 BR
    {{  0.0,  0.0, 0.0 }}, // 3 BL
};

const GLubyte indices[] = {
    0, 1, 3, 1, 2, 3
};

@dynamic view;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (![self context]) {
        NSLog(@"ERR: Failed to create EAGLContext!");
    }
    
    [self.view setContext:_context];
    [self.view setDelegate:self];
    
    [EAGLContext setCurrentContext:_context];
    
#define TEST_TYPE 1
    
    const NSUInteger testType = TEST_TYPE;
    
    [self loadShaders];
    [self initModelForTestType:testType];

#if TEST_TYPE != 0 
    
    [self initVAO];
    
#endif
    
    [self prepareToDraw];
}

#pragma mark -
#pragma mark Model helpers

- (void) loadShaders
{
    _shader = [[BaseShader alloc] init];
    [_shader loadShader];
}

- (void) initModelForTestType:(NSUInteger) type
{
    const CGSize screenSize = [self sizeOfScreen];
    const CGSize particleSize = [self sizeOfQuadsForTestType:type];
    const NSUInteger numberOfItems = [self numberOfQuadsForScreenSize:screenSize andTestType:type];
    const GLKVector2 scale = GLKVector2Make(particleSize.width, particleSize.height);
    
    NSMutableArray<Quad *> *models = [NSMutableArray arrayWithCapacity:numberOfItems];
    
    // position coordinates
    NSUInteger xCoord = 0;
    NSUInteger yCoord = screenSize.height - particleSize.height;
    
    for (NSUInteger i = 0; i < numberOfItems; ++i) {
        
        Quad *newQuad = [[Quad alloc] init];
        [newQuad setPosition:GLKVector2Make(xCoord, yCoord)];
        [newQuad setScale:scale];
        
        [models addObject:newQuad];
        
        xCoord += particleSize.width;
        if ((xCoord + particleSize.width) >= screenSize.width) {
            xCoord = 0;
            yCoord -= particleSize.height;
        }
    }
    
    _models = models;
}

- (void) initVAO
{
    _vertexCount = sizeof(vertices)/sizeof(vertex_t);
    _indexCount = sizeof(indices)/sizeof(GLubyte);
    
    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, _vertexCount * sizeof(vertex_t), vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indexCount * sizeof(GLubyte), indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(vertex_t), 0);
    
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

- (GLKMatrix4) projectionMatrix
{
    const CGSize screenSize = [self sizeOfScreen];
    return GLKMatrix4MakeOrtho(0, screenSize.width, 0, screenSize.height, 0, 1);
}

- (void) prepareToDraw
{
    _projectionMatrix = [self projectionMatrix];
    
    glUseProgram(_shader.program);
    glUniformMatrix4fv(_shader.u_projectionMatrix, 1, 0, _projectionMatrix.m);
    
    glClearColor(0, 104.f/255.f, 55.f/255.f, 1.f);
    
    glDisable(GL_SCISSOR_TEST);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_STENCIL_TEST);
}

#pragma mark -
#pragma mark GLKView delegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    CFTimeInterval previousTimestamp = CFAbsoluteTimeGetCurrent();
    
#if TEST_TYPE != 0
    
    glBindVertexArray(_vao);
    
    for (Quad *quad in _models) {
        glUniformMatrix4fv(_shader.u_modelMatrix, 1, 0, quad.modelMatrix.m);
        glDrawElements(GL_TRIANGLES, (int) _indexCount, GL_UNSIGNED_BYTE, 0);
    }
    
    glBindVertexArray(0);

#else 
    
    for (Quad *quad in _models) {
        glUniformMatrix4fv(_shader.u_modelMatrix, 1, 0, quad.modelMatrix.m);
        glDrawArrays(GL_POINTS, 0, 1);
    }
    
#endif
    
    
    CFTimeInterval frameDuration = CFAbsoluteTimeGetCurrent() - previousTimestamp;
    NSLog(@"Frame duration: %f ms", frameDuration * 1000.0);
}

#pragma mark -
#pragma mark Helper methods

- (NSUInteger) numberOfQuadsForScreenSize:(CGSize) screenSize andTestType:(NSUInteger) type
{
    NSUInteger numberOfRows = screenSize.width / [self sizeOfQuadsForTestType:type].width;
    NSUInteger numberOfColumns = screenSize.height / [self sizeOfQuadsForTestType:type].height;
    
    return (numberOfRows * numberOfColumns);
}

- (CGSize) sizeOfQuadsForTestType:(NSUInteger) type
{
    switch (type) {
        case 1:
            return CGSizeMake(2, 2);
        case 2:
            return CGSizeMake(4, 1);
        default:
            return CGSizeMake(1, 1); // points
    }
}

- (CGSize) sizeOfScreen
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    return CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
}

@end

