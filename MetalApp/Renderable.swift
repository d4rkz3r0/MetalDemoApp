//
//  Renderable.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

protocol Renderable
{
    var pipelineState: MTLRenderPipelineState! { get set };
    var vertexShaderName: String { get };
    var fragmentShaderName: String { get };
    var vertexDescriptor: MTLVertexDescriptor { get };
    
    var modelConstants: ModelConstants { get set };
    
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4);
}

extension Renderable
{
    func buildPipelineState(device: MTLDevice) -> MTLRenderPipelineState
    {
        let shaderLibrary = device.newDefaultLibrary();
        let vertexShader = shaderLibrary?.makeFunction(name: vertexShaderName);
        let fragmentShader = shaderLibrary?.makeFunction(name: fragmentShaderName);
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor();
        pipelineDescriptor.vertexFunction = vertexShader;
        pipelineDescriptor.fragmentFunction = fragmentShader;
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm;
        pipelineDescriptor.vertexDescriptor = vertexDescriptor;
        
        let pipelineState: MTLRenderPipelineState;
        do
        {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor);
        } catch let error as NSError { fatalError("error: \(error.localizedDescription)"); }
        
        return pipelineState;
    }
}
