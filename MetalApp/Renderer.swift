//
//  Renderer.swift
//  MetalBreakout
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import Foundation
import MetalKit

class Renderer: NSObject
{
    //Metal Objects
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var bilinearSamplerState: MTLSamplerState?
    
    //Rendering Objects
    var scene: Scene?;
    
    
    init(device: MTLDevice)
    {
        self.device = device;
        commandQueue = device.makeCommandQueue();
        super.init();
        
        buildSamplerStates();
    }
    
    private func buildSamplerStates()
    {
        let samplerStateDescriptor = MTLSamplerDescriptor();
        samplerStateDescriptor.minFilter = .linear;
        samplerStateDescriptor.magFilter = .linear;
        bilinearSamplerState = device.makeSamplerState(descriptor: samplerStateDescriptor);
    }
    
    func getDeltaTime(_ view: MTKView) -> Float { return (1 / Float(view.preferredFramesPerSecond));}
}

extension Renderer: MTKViewDelegate
{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func draw(in view: MTKView)
    {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let bilinearSamplerState = bilinearSamplerState
            else { print("One or more required Items not initialized"); return; }
        
        
        let commandBuffer = commandQueue.makeCommandBuffer();
        
        //Encode Scene Commands
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor);
        commandEncoder.setFragmentSamplerState(bilinearSamplerState, at: 0);
        
        scene?.render(commandEncoder: commandEncoder, deltaTime: getDeltaTime(view));
        commandEncoder.endEncoding();

        //Present via GPU
        commandBuffer.present(drawable);
        commandBuffer.commit();
    }
}