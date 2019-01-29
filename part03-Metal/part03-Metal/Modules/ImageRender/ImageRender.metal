//
//  ImageRender.metal
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/29.
//  Copyright © 2019 残无殇. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "ImageRenderHeaders.h"

typedef struct {
    float4 position [[position]];
    float2 texCoords;
} ImageRenderRasterizerData;

vertex ImageRenderRasterizerData imageRenderVertexShader(constant ImageRenderVertex *vertices [[buffer(0)]],
                                                         uint vid [[vertex_id]]) {
    ImageRenderRasterizerData outVertex;
    
    outVertex.position = vector_float4(vertices[vid].position, 0.0, 1.0);
    outVertex.texCoords = vertices[vid].textureCoordinate;
    
    return outVertex;
}

fragment float4 imageRenderFragmentShader(ImageRenderRasterizerData inVertex [[stage_in]],
                                          texture2d<float> tex2d [[texture(0)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    return float4(tex2d.sample(textureSampler, inVertex.texCoords).rgba);
}
