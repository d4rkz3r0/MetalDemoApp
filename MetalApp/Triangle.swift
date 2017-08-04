//
//  Triangle.swift
//  MetalBreakout
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Triangle: Node
{
    //Model Data
    var triangleVertices: [VertexPos] =
        [
            VertexPos(position: float3(0, 0.25, 0)),
            VertexPos(position: float3(-0.25, 0, 0)),
            VertexPos(position: float3(0.25, 0, 0))
        ]
    
    //Buffers
    var vertexBuffer: MTLBuffer?;
    
    //Renderable
    var pipelineState: MTLRenderPipelineState!;
    var vertexShaderName: String = "default_vertex_shader";
    var fragmentShaderName: String = "fragment_shader";
    var vertexDescriptor: MTLVertexDescriptor
    {
        let vertexDescriptor = MTLVertexDescriptor();
        vertexDescriptor.attributes[0].format = .float3;
        vertexDescriptor.attributes[0].offset = 0;
        vertexDescriptor.attributes[0].bufferIndex = 0;
        vertexDescriptor.layouts[0].stride = MemoryLayout<VertexPos>.stride;
        
        return vertexDescriptor;
    }

    
    init(device: MTLDevice)
    {
        super.init();
        buildBuffers(device: device);
        pipelineState = buildPipelineState(device: device);
    }
    
    private func buildBuffers(device: MTLDevice)
    {
        vertexBuffer = device.makeBuffer(bytes: triangleVertices, length: triangleVertices.count * MemoryLayout<VertexPos>.stride, options: []);
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float)
    {
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime);
        
        guard let vertexBuffer = vertexBuffer, let pipelineState = pipelineState else { return; }
        
        //Center Triangle
        commandEncoder.setRenderPipelineState(pipelineState);
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0);
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: triangleVertices.count);
    }
}

extension Triangle: Renderable
{
    
}
