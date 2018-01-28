//
//  NodeApi.swift
//  AcnSDK
//
//  Copyright (c) 2017 Arrow Electronics, Inc.
//  All rights reserved. This program and the accompanying materials
//  are made available under the terms of the Apache License 2.0
//  which accompanies this distribution, and is available at
//  http://apache.org/licenses/LICENSE-2.0
//
//  Contributors: Arrow Electronics, Inc.
//

public class NodeApi {
    
    let NodeUrl = "/api/v1/kronos/nodes"
    let NodeUrlHid = "/api/v1/kronos/nodes/%@"
    let NodeTypesUrl = "/api/v1/kronos/nodes/types"
    let NodeTypesUrlHid = "/api/v1/kronos/nodes/types/%@"
    
    // MARK: Node
    
    public func nodes(completionHandler: @escaping (_ nodes: [NodeModel]?) -> Void) {
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: NodeUrl,
            method: .GET,
            model: nil,
            info: "Get nodes"
        ) { json, success in
            if success && json != nil {
                if let data = json!["data"] as? [[String: AnyObject]] {
                    var nodes = [NodeModel]()
                    for jsonNode in data {
                        nodes.append(NodeModel(json: jsonNode))
                    }
                    completionHandler(nodes)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func createNode(node: NodeRequestModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: NodeUrl,
            method: .POST,
            model: node,
            info: "Create node"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func updateNode(hid: String, node: NodeRequestModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: NodeUrlHid, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .PUT,
            model: node,
            info: "Update node"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    // MARK: NodeType
    
    public func nodeTypes(completionHandler: @escaping (_ nodeTypes: [NodeTypeModel]?) -> Void) {
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: NodeTypesUrl,
            method: .GET,
            model: nil,
            info: "Get node types"
        ) { json, success in
            if success && json != nil {
                if let data = json!["data"] as? [[String: AnyObject]] {
                    var nodeTypes = [NodeTypeModel]()
                    for jsonNodeType in data {
                        nodeTypes.append(NodeTypeModel(json: jsonNodeType))
                    }
                    completionHandler(nodeTypes)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
    
    public func createNodeType(node: NodeTypeRequestModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: NodeTypesUrl,
            method: .POST,
            model: node,
            info: "Create node type"
        ) { _, success in
            completionHandler(success)
        }
    }
    
    public func updateNodeType(hid: String, node: NodeTypeRequestModel, completionHandler: @escaping (_ success: Bool) -> Void) {
        let formatURL = String(format: NodeTypesUrlHid, hid)
        ArrowConnectIot.sharedInstance.sendIotCommonRequest(
            urlString: formatURL,
            method: .PUT,
            model: node,
            info: "Update node type"
        ) { _, success in
            completionHandler(success)
        }
    }
}
