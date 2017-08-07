//
//  FinalScene.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/6/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class FinalScene: Scene
{
    //Scene Models
    let iPhone: InstanceModel;
    let NUM_INSTANCES: Int = 7;
    
    let background: Background;
    
    //Scene Touch Settings
    var previousTouchLocation: CGPoint = .zero;
    let touchSensitivity: Float = 0.01;
    
    override init(device: MTLDevice, size: CGSize)
    {
        //Init Nodes
        iPhone = InstanceModel(device: device, modelName: "iPhone", numInstances: NUM_INSTANCES);
        background = Background(device: device, imageName: "wallpaper.jpg");
        
        super.init(device: device, size: size);
        
        //Setup Scene Specific
        background.worldPosition.x = 0.0;
        background.worldPosition.y = -0.25;
        background.worldPosition.z = -4.0;
        background.worldScale = float3(6.0);
        
        iPhone.worldScale = float3(0.9);
        generateRandomTransformations();
        setCameraOrientation(position: float3(0.0, -0.25, -8.0), xRotation: 0.0, yRotation: 0.0);
        setLightingInfo(lightDirection: float3(0.0, 0.0, -1.0),
                        lightColor: float3(1.0, 1.0, 1.0),
                        ambientIntensity: 0.2,
                        diffuseIntensity: 0.6,
                        specularIntensity: 1.0,
                        shininess: 16.0);
        
        //Add Nodes to Scene
        addNode(childNode: background);
        addNode(childNode: iPhone);
        
    }
    
    private func generateRandomTransformations()
    {
        for _ in 0..<NUM_INSTANCES
        {
            for iPhoneInstance in iPhone.instances
            {
                iPhoneInstance.worldScale = float3(Float(arc4random_uniform(3) + 1) / 8);
                iPhoneInstance.worldPosition.x = Float(arc4random_uniform(5)) - 1;
                iPhoneInstance.worldPosition.y = Float(arc4random_uniform(5)) - 3;
                iPhoneInstance.worldPosition.z = Float(arc4random_uniform(6));
                iPhoneInstance.materialColor = float4(Float(drand48()), Float(drand48()), Float(drand48()), 1.0);
            }
        }
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
                                 specularIntensity: Float = 0.8,
                                 shininess: Float = 6.0)
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
        
        for iPhoneInstance in iPhone.instances
        {
            iPhoneInstance.worldRotation.x += Float(delta.y) * touchSensitivity;
            iPhoneInstance.worldRotation.y += Float(delta.x) * touchSensitivity;
        }
        previousTouchLocation = currentTouchLocation;
    }
}
