//
//  Node.swift
//  MetalBreakout
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Node
{
    var name: String = "Untitled";
    var children: [Node] = [];
    
    func addNode(childNode: Node)
    {
        children.append(childNode);
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float)
    {
        _ = children.map{ $0.render(commandEncoder: commandEncoder, deltaTime: deltaTime) };
    }
}
