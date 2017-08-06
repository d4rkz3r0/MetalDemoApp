//
//  LightingScene.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/6/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class LightingScene: Scene
{
    //Scene Models
    let iPhone: Model;
    
    //Scene Touch Settings
    var previousTouchLocation: CGPoint = .zero;
    let touchSensitivity: Float = 0.01;
    
    
    override init(device: MTLDevice, size: CGSize)
    {
        iPhone = Model(device: device, modelName: "iPhone");
        
        super.init(device: device, size: size);
        
        //Scene Specific
        camera.worldPosition.y = -3.0;
        camera.worldPosition.z = -10.0;
        
        iPhone.worldScale = float3(0.75);
        
        addNode(childNode: iPhone);
        
        lightingInfo.lightColor = float3(0.0, 0.0, 1.0);
        lightingInfo.ambientIntensity = 0.5;
    }
    
    override func update(deltaTime: Float)
    {
        
    }
    
    //MARK: Model Touch Interaction
    override func touchesBegan(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else { return; }
        previousTouchLocation = touch.location(in: view);
    }
    
    override func touchesMoved(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else { return; }
        
        let currentTouchLocation = touch.location(in: view);
        
        let delta = CGPoint(x: previousTouchLocation.x - currentTouchLocation.x,
                            y: previousTouchLocation.y - currentTouchLocation.y);
        
        iPhone.worldRotation.x += Float(delta.y) * touchSensitivity;
        iPhone.worldRotation.y += Float(delta.x) * touchSensitivity;
        
        previousTouchLocation = currentTouchLocation;
    }
    
}
