/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Utility class for creating a quad.
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import <Metal/Metal.h>
#import <simd/simd.h>

#import "AAPLQuad.h"

static const uint32_t kCntQuadTexCoords = 6;
static const uint32_t kSzQuadTexCoords  = kCntQuadTexCoords * sizeof(simd::float2);

static const uint32_t kCntQuadVertices = kCntQuadTexCoords;
static const uint32_t kSzQuadVertices  = kCntQuadVertices * sizeof(simd::float4);

static const simd::float4 kQuadVertices[kCntQuadVertices] =
{
    { -1.0f,  -1.0f, 0.0f, 1.0f },
    {  1.0f,  -1.0f, 0.0f, 1.0f },
    { -1.0f,   1.0f, 0.0f, 1.0f },
    
    {  1.0f,  -1.0f, 0.0f, 1.0f },
    { -1.0f,   1.0f, 0.0f, 1.0f },
    {  1.0f,   1.0f, 0.0f, 1.0f }
};

static const simd::float2 kQuadTexCoords[kCntQuadTexCoords] =
{
    { 0.0f, 0.0f },
    { 1.0f, 0.0f },
    { 0.0f, 1.0f },
    
    { 1.0f, 0.0f },
    { 0.0f, 1.0f },
    { 1.0f, 1.0f }
};

@implementation AAPLQuad
{
@private
    // textured Quad
    id <MTLBuffer>  m_VertexBuffer;
    id <MTLBuffer>  m_TexCoordBuffer;
    
    // Dimensions
    CGSize  _size;
    CGRect  _bounds;
    float   _aspect;
    
    // Indicies
    NSUInteger  _vertexIndex;
    NSUInteger  _texCoordIndex;
    NSUInteger  _samplerIndex;
    
    // Scale
    simd::float2 m_Scale;
}

- (instancetype) initWithDevice:(id <MTLDevice>)device
{
    self = [super init];
    
    if(self)
    {
        if(!device)
        {
            NSLog(@">> ERROR: Invalid device!");
            
            return nil;
        } // if
        
        m_VertexBuffer = [device newBufferWithBytes:kQuadVertices
                                             length:kSzQuadVertices
                                            options:MTLResourceStorageModeShared];
        
        if(!m_VertexBuffer)
        {
            NSLog(@">> ERROR: Failed creating a vertex buffer for a quad!");
            
            return nil;
        } // if
        m_VertexBuffer.label = @"quad vertices";
        
        m_TexCoordBuffer = [device newBufferWithBytes:kQuadTexCoords
                                               length:kSzQuadTexCoords
                                              options:MTLResourceStorageModeShared];
        
        if(!m_TexCoordBuffer)
        {
            NSLog(@">> ERROR: Failed creating a 2d texture coordinate buffer!");
            
            return nil;
        } // if
        m_TexCoordBuffer.label = @"quad texcoords";
        
        _vertexIndex   = 0;
        _texCoordIndex = 1;
        _samplerIndex  = 0;
        
        _size   = CGSizeMake(0.0, 0.0);
        _bounds = CGRectMake(0.0, 0.0, 0.0, 0.0);
        
        _aspect = 1.0f;
        
        m_Scale = 1.0f;
    } // if
    
    return self;
} // _setupWithTexture

- (void) setBounds:(CGRect)bounds
{
} // setBounds

- (void) encode:(id <MTLRenderCommandEncoder>)renderEncoder
{    
    [renderEncoder setVertexBuffer:m_VertexBuffer
                            offset:0
                           atIndex:_vertexIndex ];
    
    [renderEncoder setVertexBuffer:m_TexCoordBuffer
                            offset:0
                           atIndex:_texCoordIndex ];
} // encode

@end
