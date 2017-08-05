//
//  InstancedScene.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/5/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class InstancedScene: Scene
{
    var iPhone: InstanceModel;
    
    override init(device: MTLDevice, size: CGSize)
    {
        iPhone = InstanceModel(device: device, modelName: "iPhone", numInstances: 7);
        
        super.init(device: device, size: size);
        
        addNode(childNode: iPhone);
        
        generateRandomTransformations(device: device);
        
    }
    
    func generateRandomTransformations(device: MTLDevice)
    {
        for _ in 0..<7
        {
            for iPhoneInstance in iPhone.instances
            {
                iPhoneInstance.worldScale = float3(Float(arc4random_uniform(3) + 1) / 10);
                iPhoneInstance.worldPosition.x = Float(arc4random_uniform(5)) - 2;
                iPhoneInstance.worldPosition.y = Float(arc4random_uniform(7)) - 3;
                iPhone.materialColor = float4(Float(drand48()), Float(drand48()), Float(drand48()), 1.0);
            }
        }
    }
    
    override func update(deltaTime: Float)
    {
        for iPhoneInstance in iPhone.instances
        {
            iPhoneInstance.worldRotation.y += deltaTime;
        }
    }
}
