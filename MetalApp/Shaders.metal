//
//  Shaders.metal
//  MetalApp
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//Constant Buffers
struct ModelConstants // Register - 1
{
    float4x4 modelViewMatrix;
    float4 materialColor;
};

struct SceneConstants // Register - 2
{
    float4x4 projectionMatrix;
};

//Vertex Types
struct VertexPosColUVIn
{
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 uv [[ attribute(2) ]];
};

struct VertexPosColUVOut
{
    float4 position [[ position ]];
    float4 color;
    float2 uv;
    float4 materialColor;
};

//Vertex Shader -> Diffuse Info Vertex Shader
vertex VertexPosColUVOut diffuse_vertex_shader(const VertexPosColUVIn vertexIn [[ stage_in ]],
                                               constant ModelConstants& modelConstants [[ buffer(1) ]],
                                               constant SceneConstants& sceneConstants [[ buffer(2) ]])
{
    VertexPosColUVOut vertexOut;
    
    float4x4 modelViewProjectionMatrix = sceneConstants.projectionMatrix * modelConstants.modelViewMatrix;
    vertexOut.position = modelViewProjectionMatrix *  vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.uv = vertexIn.uv;
    vertexOut.materialColor = modelConstants.materialColor;
    
    return vertexOut;
}

//Fragment Shader -> Sampled Diffuse Texture Color + Model Tint Color Fragment Shader
fragment half4 diffuse_fragment_shader(VertexPosColUVOut vertexIn [[ stage_in ]], sampler sampler2D [[ sampler(0) ]], texture2d<float> diffuseTexture [[ texture(0) ]])
{
    //Sampled Color
    float4 diffuseTextureColor = diffuseTexture.sample(sampler2D, vertexIn.uv);
    
    //Model Color
    float4 diffuseColor = diffuseTextureColor * vertexIn.materialColor;
    
    //Final Color
    return half4(diffuseColor.r, diffuseColor.g, diffuseColor.b, 1);
}

//Fragment Shader -> Interpolated Color Fragment Shader
fragment half4 interp_fragment_shader(VertexPosColUVOut vertexIn [[ stage_in ]])
{
    return half4(vertexIn.color);
}
