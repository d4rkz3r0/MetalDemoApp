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
    float3x3 normalMatrix;
    float4 materialColor;
    float specularIntensity = 1.0;
    float shininess = 1.0;
};

struct SceneConstants // Register - 2
{
    float4x4 projectionMatrix;
};

struct LightingInfo // Register - 3
{
    float3 lightDirection;
    float3 lightColor;
    float ambientIntensity;
    float diffuseIntensity;
};


//Vertex Types
struct VertexIn
{
    float4 position [[ attribute(0) ]];
    float4 color    [[ attribute(1) ]];
    float2 uv       [[ attribute(2) ]];
    float3 normal   [[ attribute(3) ]];
};

struct VertexOut
{
    float4 position [[ position ]];
    float4 color;
    float2 uv;
    float3 normal;
    float4 materialColor;
    float specularIntensity;
    float shininess;
    float3 eyePosition;
};

//Vertex Shader -> Diffuse Info Vertex Shader
vertex VertexOut diffuse_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                        constant ModelConstants& modelConstants [[ buffer(1) ]],
                                        constant SceneConstants& sceneConstants [[ buffer(2) ]])
{
    //From Vertex Buffer
    VertexOut vertexOut;

    float4x4 modelViewProjectionMatrix = sceneConstants.projectionMatrix * modelConstants.modelViewMatrix;
    vertexOut.position = modelViewProjectionMatrix *  vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.uv = vertexIn.uv;
    
    //From Constant Buffers
    vertexOut.normal = modelConstants.normalMatrix * vertexIn.normal;
    vertexOut.materialColor = modelConstants.materialColor;
    vertexOut.specularIntensity = modelConstants.specularIntensity;
    vertexOut.shininess = modelConstants.shininess;
    vertexOut.eyePosition = (modelConstants.modelViewMatrix * vertexIn.position).xyz;
    
    return vertexOut;
}

//Vertex Shader -> Instanced Model with Diffuse Info Vertex Shader
vertex VertexOut instanced_diffuse_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                                 constant ModelConstants* modelInstanceData [[ buffer(1) ]],
                                                 constant SceneConstants& sceneConstants [[ buffer(2) ]],
                                                 uint instanceID [[ instance_id ]])
{
    VertexOut vertexOut;
    
    ModelConstants instanceModelData = modelInstanceData[instanceID];
    
    float4x4 modelViewProjectionMatrix = sceneConstants.projectionMatrix * instanceModelData.modelViewMatrix;
    vertexOut.position = modelViewProjectionMatrix *  vertexIn.position;
    vertexOut.color = vertexIn.color;
    vertexOut.uv = vertexIn.uv;
    vertexOut.materialColor = instanceModelData.materialColor;
    
    return vertexOut;
}

//Fragment Shader -> Sampled Diffuse Texture Color + Model Tint Color + Scene Lighting Info Fragment Shader
fragment half4 lighted_diffuse_fragment_shader(VertexOut vertexIn [[ stage_in ]],
                                               sampler sampler2D [[ sampler(0) ]],
                                               constant LightingInfo& lightingInfo [[ buffer(3) ]],
                                               texture2d<float> diffuseTexture [[ texture(0) ]])
{
    // Init
    float4 finalColor = float4(0.0, 0.0, 0.0, 0.0);
    //Get Sampled Color
    float4 diffuseTextureColor = diffuseTexture.sample(sampler2D, vertexIn.uv);
    
    //Get Model Tint Color
    float4 diffuseModelColor = vertexIn.materialColor;
    
    //Update Final Color
    finalColor = diffuseTextureColor * diffuseModelColor;
    
    // Calc Lighting Factors
    //Scene Ambient Color
    float3 sceneAmbientColor = lightingInfo.lightColor * lightingInfo.ambientIntensity;
    
    //Scene Diffuse Color
    float3 normal = normalize(vertexIn.normal);
    float diffuseFactor = saturate(-dot(normal, lightingInfo.lightDirection));
    float3 sceneDiffuseColor = lightingInfo.lightColor * lightingInfo.diffuseIntensity * diffuseFactor;
    
    //Scene Specular Color
    float3 eyePos = normalize(vertexIn.eyePosition);
    float3 lightReflection = reflect(lightingInfo.lightDirection, normal);
    float specularFactor = pow(saturate(-dot(lightReflection, eyePos)), vertexIn.shininess);
    float3 sceneSpecularColor = lightingInfo.lightColor * vertexIn.specularIntensity * specularFactor;
    
    // Combine Lighting Factors
    float4 combinedLightingColor = float4((sceneAmbientColor + sceneDiffuseColor + sceneSpecularColor), 1.0);
    
    //Update Final Color
    finalColor = finalColor * combinedLightingColor;
    

    // Return Fragment Color
    if (finalColor.a == 0.0) { discard_fragment(); }
    return half4(finalColor.r, finalColor.g, finalColor.b, 1.0);
}


//Fragment Shader -> Sampled Diffuse Texture Color + Model Tint Color Fragment Shader
fragment half4 diffuse_fragment_shader(VertexOut vertexIn [[ stage_in ]],
                                       sampler sampler2D [[ sampler(0) ]],
                                       texture2d<float> diffuseTexture [[ texture(0) ]])
{
    //Sampled Color
    float4 diffuseTextureColor = diffuseTexture.sample(sampler2D, vertexIn.uv);
    
    //Model Color
    float4 diffuseColor = diffuseTextureColor * vertexIn.materialColor;
    
    if (diffuseColor.a == 0.0) { discard_fragment(); }

    //Final Color
    return half4(diffuseColor.r, diffuseColor.g, diffuseColor.b, 1);
}

//Fragment Shader -> Interpolated Color Fragment Shader
fragment half4 interp_fragment_shader(VertexOut vertexIn [[ stage_in ]])
{
    return half4(vertexIn.color);
}
