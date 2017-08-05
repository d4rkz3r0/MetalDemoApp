//
//  InstanceModel.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/5/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class InstanceModel: Node
{
    //Model Data
    var model: Model;
    var modelConstants = ModelConstants();
    
    //Model Instances Data
    var instances = [Node]();
    var instanceConstants = [ModelConstants]();
    var instanceBuffer: MTLBuffer?
    
    //Rendereable Conformance
    var pipelineState: MTLRenderPipelineState!;
    var vertexDescriptor: MTLVertexDescriptor;
    var vertexShaderName: String = "instanced_diffuse_vertex_shader";
    var fragmentShaderName: String;
    
    
    
    init(device: MTLDevice, modelName: String, numInstances: Int)
    {
        model = Model(device: device, modelName: modelName);
        vertexDescriptor = model.vertexDescriptor;
        fragmentShaderName = model.fragmentShaderName;

        super.init();
        
        name = modelName;
        createInstances(numInstances: numInstances);
        makeBuffer(device: device);
        pipelineState = buildPipelineState(device: device);
        
    }
    
    func createInstances(numInstances: Int)
    {
        for i in 0..<numInstances
        {
            let instance = Node();
            instance.name = "Instance \(i)";
            instances.append(instance);
            instanceConstants.append(ModelConstants());
        
        
        }
    }
    
    //ModelViewData for all instances of this model.
    func makeBuffer(device: MTLDevice)
    {
        instanceBuffer = device.makeBuffer(length: MemoryLayout<ModelConstants>.stride * instanceConstants.count, options: []);
        instanceBuffer?.label = "Instance Buffer";
        
    }
}

extension InstanceModel: Renderable
{
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4)
    {
        guard let instanceBuffer = instanceBuffer, instances.count > 0 else { print("Instance Data not initialized."); return; }
        
        var instanceDataPointer = instanceBuffer.contents().bindMemory(to: ModelConstants.self, capacity: instances.count);
        
        for instance in instances
        {
            instanceDataPointer.pointee.modelViewMX = matrix_multiply(modelViewMatrix, instance.modelMatrix);
            instanceDataPointer.pointee.materialColor = instance.materialColor;
            instanceDataPointer = instanceDataPointer.advanced(by: 1);
        }
        
        commandEncoder.setFragmentTexture(model.diffuseTexture, at: 0);
        commandEncoder.setRenderPipelineState(pipelineState);
        commandEncoder.setVertexBuffer(instanceBuffer, offset: 0, at: 1);
        
        guard let meshes = model.meshes as? [MTKMesh], meshes.count > 0 else { return; }
        
        for mesh in meshes
        {
            let vertexBuffer = mesh.vertexBuffers[0];
            commandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, at: 0);
            
            for submesh in mesh.submeshes
            {
                commandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                     indexCount: submesh.indexCount,
                                                     indexType: submesh.indexType,
                                                     indexBuffer: submesh.indexBuffer.buffer,
                                                     indexBufferOffset: submesh.indexBuffer.offset,
                                                     instanceCount: instances.count);
            }
        }
    }
}
