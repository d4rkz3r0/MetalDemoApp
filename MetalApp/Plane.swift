//
//  Plane.swift
//  MetalBreakout
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Plane: Node
{
    //Model Data
    var vertices: [VertexPosColUV] =
        [
            VertexPosColUV(position: float3(-1, 1, 0),  color: float4(1, 0, 0, 1), uv: float2(0, 1)),
            VertexPosColUV(position: float3(-1, -1, 0), color: float4(0, 1, 0, 1), uv: float2(0, 0)),
            VertexPosColUV(position: float3(1, -1, 0),  color: float4(0, 0, 1, 1), uv: float2(1, 0)),
            VertexPosColUV(position: float3(1,  1, 0),  color: float4(1, 0, 1, 1), uv: float2(1, 1))
        ]
    
    var indices: [UInt16] =
        [
            0, 1, 2,
            2, 3, 0
        ]
    
    //Model Transformation Data
    var worldMX = matrix_identity_float4x4;
    
    
    //VB/IB
    var vertexBuffer: MTLBuffer?;
    var indexBuffer: MTLBuffer?;
    //CB - CPU Side
    var modelConstants = ModelConstants();
    
    //Renderable
    var pipelineState: MTLRenderPipelineState!;
    var vertexShaderName: String = "diffuse_vertex_shader";
    var fragmentShaderName: String = "interp_fragment_shader";
    var vertexDescriptor: MTLVertexDescriptor
    {
        let vertexDescriptor = MTLVertexDescriptor();
        vertexDescriptor.attributes[0].format = .float3;
        vertexDescriptor.attributes[0].offset = 0;
        vertexDescriptor.attributes[0].bufferIndex = 0;
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride;
        vertexDescriptor.attributes[1].bufferIndex = 0;
        
        vertexDescriptor.attributes[2].format = .float2;
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride;
        vertexDescriptor.attributes[2].bufferIndex = 0;
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<VertexPosColUV>.stride;
        
        return vertexDescriptor;
    }
    
    //Textureable
    var diffuseTexture: MTLTexture?;
    
    
    //Misc
    var time: Float =  0;
    
    
    init(device: MTLDevice)
    {
        super.init();
        buildBuffers(device: device);
        pipelineState = buildPipelineState(device: device);
    }
    
    init(device: MTLDevice, imageName: String)
    {
        super.init();
        
        if let diffuseTexture = setTexture(device: device, imageName: imageName)
        {
            self.diffuseTexture = diffuseTexture;
            fragmentShaderName = "diffuse_fragment_shader";
        }
        else
        {
            fragmentShaderName = "interp_fragment_shader"
        }
        
        buildBuffers(device: device);
        pipelineState = buildPipelineState(device: device);
    }
    
    private func buildBuffers(device: MTLDevice)
    {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<VertexPosColUV>.stride, options: []);
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: []);
    }
    
        
    private func calcSineValue(deltaTime: Float) -> Float
    {
        time += deltaTime;
        
        return abs(sin(time) / 2 + 0.5);
    }
    
    private func calcWorldMatrix(rotationVal: Float)
    {
        let translationMatrix = matrix_identity_float4x4;
        let animatedRotationMatrix = matrix_float4x4(rotationAngle: rotationVal, x: 0, y: 0, z: 1);
        let scalingMatrix =  matrix_float4x4(scaleX: 0.5, y: 0.5, z: 0.5);
        
        modelConstants.modelViewMX = matrix_multiply(translationMatrix, matrix_multiply(animatedRotationMatrix, scalingMatrix));
    }
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float)
    {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime);
        
        guard let indexBuffer = indexBuffer, let pipelineState = pipelineState else { return; }
        
        
        calcWorldMatrix(rotationVal: calcSineValue(deltaTime: deltaTime));
        
        commandEncoder.setRenderPipelineState(pipelineState);
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0);
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.size, at: 1);
        commandEncoder.setFragmentTexture(diffuseTexture, at: 0);
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0);
    }
}

//Protocol Conformance
extension Plane: Renderable
{

}

extension Plane: Texturable
{
    
}
