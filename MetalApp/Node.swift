//
//  Node.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Node
{
    var name: String = "Untitled";
    var children: [Node] = [];
    
    //Transformation Info
    var worldPosition = float3(0);
    var worldRotation = float3(0);
    var worldScale = float3(1);
    
    var modelMatrix: matrix_float4x4
    {
        //Translation
        var matrix = matrix_float4x4(translationX: worldPosition.x, y: worldPosition.y, z: worldPosition.z);
        
        //Rotation
        matrix = matrix.rotatedBy(rotationAngle: worldRotation.x, x: 1, y: 0, z: 0);
        matrix = matrix.rotatedBy(rotationAngle: worldRotation.y, x: 0, y: 1, z: 0);
        matrix = matrix.rotatedBy(rotationAngle: worldRotation.z, x: 0, y: 0, z: 01);
        
        //Scaling
        matrix = matrix.scaledBy(x: worldScale.x, y: worldScale.y, z: worldScale.z);
        
        return matrix;
    }
    
    
    func addNode(childNode: Node)
    {
        children.append(childNode);
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4)
    {
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix);
        
        _ = children.map{ $0.render(commandEncoder: commandEncoder, parentModelViewMatrix: modelViewMatrix) };
        
        // Is the Node a Renderable?
        if let renderable = self as? Renderable
        {
            commandEncoder.pushDebugGroup(name);
            renderable.doRender(commandEncoder: commandEncoder, modelViewMatrix: modelViewMatrix);
            commandEncoder.popDebugGroup();
        }
    }
}
