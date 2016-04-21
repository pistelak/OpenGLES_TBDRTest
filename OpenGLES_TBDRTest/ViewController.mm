//
//  ViewController.m
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 05.04.16.
//  Copyright © 2016 ran. All rights reserved.
//

#import "ViewController.h"

#import <vector>

@interface ViewController ()
@property (nonatomic, strong) EAGLContext *context;
@end

@implementation ViewController
{
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    
    std::vector<vertex_t> _vertices;
    std::vector<GLuint> _indices;
    
    BaseShader *_shader;
}

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
    
    self.preferredFramesPerSecond = 60;
    
    [EAGLContext setCurrentContext:_context];
    
#define TEST_TYPE 2
    
    _vertices = [self verticesForTestType:TEST_TYPE];
    _indices = [self indicesForTestType:TEST_TYPE];
    
    _shader = [[BaseShader alloc] init];
    [_shader loadShader];
    
    [self prepareToDraw];
}

- (void) prepareToDraw
{
    glUseProgram(_shader.program);
    glClearColor(0, 104.f/255.f, 55.f/255.f, 1.f);
    
    const CGSize screenSize = [self sizeOfScreen];
    const GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, screenSize.width, 0, screenSize.height, 0, 1);
    glUniformMatrix4fv(_shader.u_projectionMatrix, 1, 0, projectionMatrix.m);
    glViewport(0, 0, screenSize.width, screenSize.height);
    
    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, _vertices.size() * sizeof(vertex_t), &_vertices[0], GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indices.size() * sizeof(GLuint), &_indices[0], GL_STATIC_DRAW);
    
    // position
    glEnableVertexAttribArray(_shader.in_position);
    glVertexAttribPointer(_shader.in_position, 3, GL_FLOAT, GL_FALSE, sizeof(vertex_t), NULL);
    
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindBuffer(GL_UNIFORM_BUFFER, 0);
    
    glDisable(GL_SCISSOR_TEST);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_STENCIL_TEST);
}

#pragma mark -
#pragma mark GLKView delegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    CFTimeInterval previousTimestamp = CFAbsoluteTimeGetCurrent();
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindVertexArray(_vao);
    
#if TEST_TYPE == 0
    glDrawElements(GL_POINTS, (int) _vertices.size(), GL_UNSIGNED_INT, 0);
#else
    glDrawElements(GL_TRIANGLES, (int) _indices.size(), GL_UNSIGNED_INT, 0);
#endif
 
    glBindVertexArray(0);
    
    CFTimeInterval frameDuration = CFAbsoluteTimeGetCurrent() - previousTimestamp;
    NSLog(@"Frame duration: %f ms", frameDuration * 1000.0);
}

#pragma mark -
#pragma mark Helper methods

- (std::vector<vertex_t>) verticesForTestType:(NSUInteger) type
{
    std::vector<vertex_t> vertices;
 
    const CGSize screenSize = [self sizeOfScreen];
    const NSUInteger numberOfVertices= [self numberOfVerticesForScreenSize:screenSize andTestType:type];
    const CGSize particleSize = [self sizeOfQuadsForTestType:type];
    
    // position coordinates
    GLfloat xCoord = 0;
    GLfloat yCoord = 0;

    for (NSUInteger i = 0; i < numberOfVertices; ++i) {
        
        vertex_t newVertex = { xCoord, yCoord, 0 };
        
        vertices.push_back(newVertex);
        
        xCoord += particleSize.width;
        if (xCoord > screenSize.width) {
            xCoord = 0;
            yCoord += particleSize.height;
        }
    }
    
    NSLog(@"Number of vertices %lu", vertices.size());
    
    return vertices;
}

- (std::vector<GLuint>) indicesForTestType:(NSUInteger) type
{
    if (type == 1 || type == 2) {
        return [self triangleIndicesForTestType:type];
    } else {
        return [self pointIndices];
    }
}

- (std::vector<GLuint>) pointIndices // indicesForTestType - 0
{
    std::vector<GLuint> indices;
    
    const CGSize screenSize = [self sizeOfScreen];
    const uint32_t numberOfVertices = (uint32_t) [self numberOfVerticesForScreenSize:screenSize andTestType:0];
    
    for (NSUInteger i = 0; i < numberOfVertices; ++i) {
        indices.push_back((GLuint) i);
    }
    
    NSLog(@"Number of indices %lu", indices.size());
    
    return indices;
}

- (std::vector<GLuint>) triangleIndicesForTestType:(NSUInteger) type
{
    std::vector<GLuint> indices;
    
    const CGSize screenSize = [self sizeOfScreen];
    const uint32_t numberOfVertices = (uint32_t) [self numberOfVerticesForScreenSize:screenSize andTestType:type];
    const CGSize particleSize = [self sizeOfQuadsForTestType:type];
    
    const uint32_t verticesPerRow = (screenSize.width / particleSize.width) + 1;
    
    for (NSUInteger i = 0; i < (numberOfVertices - verticesPerRow); ++i) {
        
        if (((i + 1) % verticesPerRow) == 0) {
            continue;
        }
        
        // first triangle
        indices.push_back((GLuint) i + verticesPerRow);
        indices.push_back((GLuint) i + 1 + verticesPerRow);
        indices.push_back((GLuint) i);
        
        // second triangle
        indices.push_back((GLuint) i+1+verticesPerRow);
        indices.push_back((GLuint) i+1);
        indices.push_back((GLuint) i);
    }
    
    NSLog(@"Number of indices %lu", indices.size());
    
    return indices;
}

- (NSUInteger) numberOfVerticesForScreenSize:(CGSize) screenSize andTestType:(NSUInteger) type
{
    NSUInteger numberOfRows = screenSize.width / [self sizeOfQuadsForTestType:type].width;
    NSUInteger numberOfColumns = screenSize.height / [self sizeOfQuadsForTestType:type].height;
    
    return ++numberOfRows * ++numberOfColumns;
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
    
    return CGSizeMake(screenBounds.size.width * screenScale , screenBounds.size.height * screenScale);
}

@end

