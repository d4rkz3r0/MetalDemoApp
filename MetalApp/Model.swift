//
//  Model.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/4/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Model: Node
{
    //Model Data
    var meshes: [AnyObject]?;
    
    //Model Textures
    var diffuseTexture: MTLTexture?;
    
    //Mesh Data
    var vertices: [VertexPosColUV] = [];
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
    var vertexShaderName: String = "diffuse_vertex_shader";
    var fragmentShaderName: String = "interp_fragment_shader";
    var vertexDescriptor: MTLVertexDescriptor
    {
        let vertexDescriptor = MTLVertexDescriptor();
        
        //Position
        vertexDescriptor.attributes[0].format = .float3;
        vertexDescriptor.attributes[0].offset = 0;
        vertexDescriptor.attributes[0].bufferIndex = 0;
        
        //Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<Float>.stride * 3;
        vertexDescriptor.attributes[1].bufferIndex = 0;
        
        //UVs
        vertexDescriptor.attributes[2].format = .float2;
        vertexDescriptor.attributes[2].offset = MemoryLayout<Float>.stride * 7;
        vertexDescriptor.attributes[2].bufferIndex = 0;
        
        //Normals
        vertexDescriptor.attributes[3].format = .float3;
        vertexDescriptor.attributes[3].offset = MemoryLayout<Float>.stride * 9;
        vertexDescriptor.attributes[3].bufferIndex = 0;
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.stride * 12;
        
        return vertexDescriptor;
    }
    
    //Misc
    var time: Float =  0;
    
    init(device: MTLDevice, modelName: String)
    {
        super.init();
    
        name = modelName;
        let diffuseTextureName = modelName + "_D.jpg";
        
        loadModel(device: device, modelName: modelName);
        
        if let diffuseTexture = setTexture(device: device, imageName: diffuseTextureName)
        {
            self.diffuseTexture = diffuseTexture;
            fragmentShaderName = "diffuse_fragment_shader";
        }
        else
        {
            fragmentShaderName = "interp_fragment_shader"
        }

        
        pipelineState = buildPipelineState(device: device);
        
    }
    
    
    func loadModel(device: MTLDevice, modelName: String)
    {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else { fatalError("Unable to load model."); }
        
        let modelIOVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor);
        
        //Position
        let positionAttribute = modelIOVertexDescriptor.attributes[0] as! MDLVertexAttribute;
        positionAttribute.name = MDLVertexAttributePosition;
        modelIOVertexDescriptor.attributes[0] = positionAttribute;
        
        //Color
        let colorAttribute = modelIOVertexDescriptor.attributes[1] as! MDLVertexAttribute;
        colorAttribute.name = MDLVertexAttributeColor;
        modelIOVertexDescriptor.attributes[1] = colorAttribute;
        
        //UVs
        let textureCoordsAttribute = modelIOVertexDescriptor.attributes[2] as! MDLVertexAttribute;
        textureCoordsAttribute.name = MDLVertexAttributeTextureCoordinate;
        modelIOVertexDescriptor.attributes[2] = textureCoordsAttribute;
        
        //Normals
        let normalsAttribute = modelIOVertexDescriptor.attributes[3] as! MDLVertexAttribute;
        normalsAttribute.name = MDLVertexAttributeNormal;
        modelIOVertexDescriptor.attributes[3] = normalsAttribute;
        
        let bufferAllocator = MTKMeshBufferAllocator(device: device);
        
        //Load Model Into Memory
        let asset = MDLAsset(url: assetURL, vertexDescriptor: modelIOVertexDescriptor, bufferAllocator: bufferAllocator);
        
        //Grab Model's meshes.
        do
        {
            meshes = try MTKMesh.newMeshes(from: asset, device: device, sourceMeshes: nil);
            
        } catch { print("Error retrieving model's meshes."); }
        
    }
}

extension Model: Renderable
{
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4)
    {
        //MVP + Material Color Constant Buffer
        modelConstants.modelViewMX = modelViewMatrix;
        modelConstants.materialColor = materialColor;
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, at: 1);
        
        
        if diffuseTexture != nil
        {
            commandEncoder.setFragmentTexture(diffuseTexture, at: 0);
        }
        
        commandEncoder.setRenderPipelineState(pipelineState);
        
        guard let meshes = meshes as? [MTKMesh], meshes.count > 0 else { print("Model has no meshes!"); return; }
        
        for aMesh in meshes
        {
            let vertexBuffer = aMesh.vertexBuffers[0];
            commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, at: 0);
            
            for aSubMesh in aMesh.submeshes
            {
                commandEncoder.drawIndexedPrimitives(type: aSubMesh.primitiveType,
                                                     indexCount: aSubMesh.indexCount,
                                                     indexType: aSubMesh.indexType,
                                                     indexBuffer: aSubMesh.indexBuffer.buffer,
                                                     indexBufferOffset: aSubMesh.indexBuffer.offset);
            }
            
        }
    }
}

extension Model: Texturable { }
