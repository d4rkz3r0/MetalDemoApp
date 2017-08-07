//
//  Plane.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/4/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Primitive: Node
{
    //Model Data
    var vertices: [Vertex] = [];
    var indices: [UInt16] = [];
    
    //Model Transformation Data
    var worldMX = matrix_identity_float4x4;
    
    
    //VB/IB
    var vertexBuffer: MTLBuffer?;
    var indexBuffer: MTLBuffer?;
    //CB - CPU Side
    var modelConstants = ModelConstants();
    
    //Renderable
    var pipelineState: MTLRenderPipelineState!;
    var vertexShaderName: String = "lit_vertex_shader";
    var fragmentShaderName: String = "default_fragment_shader";
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
    
    //Textureable
    var diffuseTexture: MTLTexture?;
    
    //Misc
    var time: Float =  0;
    
    
    init(device: MTLDevice)
    {
        super.init();
        
        buildVertices();
        buildBuffers(device: device);
        pipelineState = buildPipelineState(device: device);
    }
    
    init(device: MTLDevice, imageName: String)
    {
        super.init();
        
        buildVertices();
        
        if let diffuseTexture = setTexture(device: device, imageName: imageName)
        {
            self.diffuseTexture = diffuseTexture;
            fragmentShaderName = "diffuse_fragment_shader";
        }
        else
        {
            fragmentShaderName = "default_fragment_shader"
        }
        
        buildBuffers(device: device);
        pipelineState = buildPipelineState(device: device);
    }
    
    //Override this function in subclasses...
    func buildVertices() { }
    
    private func buildBuffers(device: MTLDevice)
    {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: []);
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: []);
    }
}

//Protocol Conformance
extension Primitive: Renderable
{
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4)
    {
        guard let indexBuffer = indexBuffer, let pipelineState = pipelineState else { return; }
        
        commandEncoder.setRenderPipelineState(pipelineState);
        commandEncoder.setFragmentTexture(diffuseTexture, at: 0);
        commandEncoder.setFrontFacing(.counterClockwise);
        commandEncoder.setCullMode(.back);
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0);
        
        modelConstants.modelViewMX = modelViewMatrix;
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.size, at: 1);
        
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0);
        
    }
}

extension Primitive: Texturable
{
    
}
