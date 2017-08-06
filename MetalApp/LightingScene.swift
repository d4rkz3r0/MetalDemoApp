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
        //Init Nodes
        iPhone = Model(device: device, modelName: "iPhone");
        super.init(device: device, size: size);
        
        //Setup Scene Specific
        iPhone.worldScale = float3(0.75);
        setCameraOrientation(position: float3(0.0, -3.0, -10.0), xRotation: 0.0, yRotation: 0.0);
        setLightingInfo(lightDirection: float3(0.0, 0.0, -1.0),
                        lightColor: float3(1.0, 1.0, 1.0),
                        ambientIntensity: 0.2,
                        diffuseIntensity: 0.6,
                        specularIntensity: 0.4,
                        shininess: 4.0);
        
        //Add Nodes to Scene
        addNode(childNode: iPhone);
    }
    
    private func setCameraOrientation(position: float3, xRotation: Float, yRotation: Float)
    {
        camera.worldPosition.x = position.x;
        camera.worldPosition.y = position.y;
        camera.worldPosition.z = position.z;
        
        camera.worldRotation.x = xRotation;
        camera.worldRotation.y = yRotation;
    }
    
    private func setLightingInfo(lightDirection: float3 = float3(0.0),
                                 lightColor: float3 = float3(1.0),
                                 ambientIntensity: Float = 0.2,
                                 diffuseIntensity: Float = 0.8,
                                 specularIntensity: Float = 0.2,
                                 shininess: Float = 2.0)
    {
        lightingInfo.lightDirection = lightDirection;
        lightingInfo.lightColor = lightColor;
        lightingInfo.ambientIntensity = ambientIntensity;
        lightingInfo.diffuseIntensity = diffuseIntensity;
        lightingInfo.specularIntensity = specularIntensity;
        lightingInfo.shininess = shininess;
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
