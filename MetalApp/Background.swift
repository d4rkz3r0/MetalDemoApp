//
//  Background.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/6/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Background: Node
{
    //Model Data
    var vertices: [Vertex] = [];
    var indices: [UInt16] = [];
    var worldMX = matrix_identity_float4x4;
    
    //Metal Buffers
    var vertexBuffer: MTLBuffer?;
    var indexBuffer: MTLBuffer?;
    
    //Renderable
    var pipelineState: MTLRenderPipelineState!;
    var vertexShaderName: String = "ui_vertex_shader";
    var fragmentShaderName: String = "ui_fragment_shader";
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
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride;
        
        return vertexDescriptor;
    }
    
    var modelConstants: ModelConstants = ModelConstants();
    
    //Textureable
    var diffuseTexture: MTLTexture?;

    
    init(device: MTLDevice, imageName: String)
    {
        super.init();
        
        buildVertices();
        
        guard let diffuseTexture = setTexture(device: device, imageName: imageName) else { print("UI Element is missing it's texture."); return; }
        self.diffuseTexture = diffuseTexture;
        
        buildBuffers(device: device);
        pipelineState = buildPipelineState(device: device);
    }
    
    private func buildVertices()
    {
        vertices =
            [
                Vertex(position: float3(-1, 1, 0),  color: float4(1, 0, 0, 1), uv: float2(0, 1)),
                Vertex(position: float3(-1, -1, 0), color: float4(0, 1, 0, 1), uv: float2(0, 0)),
                Vertex(position: float3(1, -1, 0),  color: float4(0, 0, 1, 1), uv: float2(1, 0)),
                Vertex(position: float3(1,  1, 0),  color: float4(1, 0, 1, 1), uv: float2(1, 1))
            ]
        
        indices =
            [
                0, 1, 2,
                2, 3, 0
            ]
    }
    
    private func buildBuffers(device: MTLDevice)
    {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: []);
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: []);
    }
}

//MARK: Protocol Conformance
extension Background: Renderable
{
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4)
    {
        guard let indexBuffer = indexBuffer, let pipelineState = pipelineState, let diffuseTexture = diffuseTexture else { return; }
        
        modelConstants.modelViewMX = modelViewMatrix;
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, at: 1);
        
        commandEncoder.setRenderPipelineState(pipelineState);
        commandEncoder.setFragmentTexture(diffuseTexture, at: 0);
        commandEncoder.setFrontFacing(.counterClockwise);
        commandEncoder.setCullMode(.none);
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0);
        
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0);
        
    }
}

extension Background: Texturable { }
