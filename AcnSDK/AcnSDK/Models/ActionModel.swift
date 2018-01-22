//
//  ActionModelCloud.swift
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

import Foundation

public enum ActionType: String {
    case NoType            = "NoType"
    case SendEmail         = "SendEmail"
    case SkypeCall         = "InitiateSkypeCall"
    case SkypeMeeting      = "InitiateSkypeMeeting"
    case ArrowInsightAlarm = "RaiseOneViewAlarm"
    
    public var nameForDisplay: String {
        switch self {
        case .NoType:            return "No Type"
        case .SendEmail:         return "Send Email"
        case .SkypeCall:         return "Skype Call"
        case .SkypeMeeting:      return "Skype Meeting"
        case .ArrowInsightAlarm: return "Arrow Insight Alarm"
        }
    }
}

public enum ActionEditField: String {
    case Description
    case Criteria
    case Expiration
    case Email
    case Message
    case Phone
    case SipAddress
    case Severity
    case Location
}

public class ActionModel: RequestModel {
    
    public static let defaultFields: [ActionEditField] = [.Description, .Criteria, .Expiration]
    static let sendEmailFields:      [ActionEditField] = [.Description, .Criteria, .Expiration, .Email]
    static let skypeCallFields:      [ActionEditField] = [.Description, .Criteria, .Expiration, .Message, .Phone, .SipAddress]
    static let skypeMeetingFields:   [ActionEditField] = [.Description, .Criteria, .Expiration, .SipAddress]
    static let insightAlarmFields:   [ActionEditField] = [.Description, .Criteria, .Expiration, .Severity, .Location]
    
    public var actionType: ActionType {
        didSet {
            systemName = actionType.rawValue
        }
    }
    public var index: Int
    public var systemName: String
    public var description: String
    public var criteria: String
    public var expiration: Int
    public var enabled: Bool
    
    var email      = "me@here.com"
    
    var message    = "Default message."
    var phone      = "000-000-0000"
    var sipAddress = "sip:me@here.com"
    
    var location   = "Default Location"
    var severity   = 1
    
    override var params: [String: AnyObject] {
        
        var parameters = [String: AnyObject]()
        
        switch actionType {
        case .SendEmail:
            parameters["Email"] = email as AnyObject?
            break
        case .SkypeCall:
            parameters["Message"]    = message as AnyObject?
            parameters["Phone"]      = phone as AnyObject?
            parameters["SipAddress"] = sipAddress as AnyObject?
            break
        case .SkypeMeeting:
            parameters["SipAddress"] = sipAddress as AnyObject?
            break
        case .ArrowInsightAlarm:
            parameters["Severity"] = severity as AnyObject?
            parameters["Location"] = location as AnyObject?
            break
        case .NoType:
            break
            
        }
        
        return [
            "index"       : index as AnyObject,
            "systemName"  : systemName as AnyObject,
            "description" : description as AnyObject,
            "criteria"    : criteria as AnyObject,
            "enabled"     : enabled as AnyObject,
            "parameters"  : parameters as AnyObject
        ]
    }
    
    public var editFields: [ActionEditField] {
        switch actionType {
        case .NoType:            return ActionModel.defaultFields
        case .SendEmail:         return ActionModel.sendEmailFields
        case .SkypeCall:         return ActionModel.skypeCallFields
        case .SkypeMeeting:      return ActionModel.skypeMeetingFields
        case .ArrowInsightAlarm: return ActionModel.insightAlarmFields
        }
    }
    
    public override init() {
        actionType = .NoType
        index = 0
        systemName = ""
        description = ""
        criteria = ""
        expiration = 60
        enabled = true
    }
    
    public init (json: [String : AnyObject]) {
        index       = json["index"] as! Int
        systemName  = json["systemName"] as! String
        if let type = ActionType(rawValue: systemName) {
            actionType = type
        } else {
            actionType = .NoType
        }
        description = json["description"] as! String
        criteria    = json["criteria"] as! String
        expiration  = json["expiration"] as! Int
        enabled     = json["enabled"] as! Bool
        
        if let parameters = json["parameters"] as? [String : AnyObject] {
            if !parameters.isEmpty {
                switch actionType {
                case .NoType:
                    break
                case .SendEmail:
                    email = parameters["Email"] as! String
                    break
                case .SkypeCall:
                    message    = parameters["Message"] as! String
                    phone      = parameters["Phone"] as! String
                    sipAddress = parameters["SipAddress"] as! String
                    break
                case .SkypeMeeting:
                    sipAddress = parameters["SipAddress"] as! String
                    break
                case .ArrowInsightAlarm:
                    if let severity = parameters["Severity"] as? Int {
                        self.severity = severity
                    }
                    location = parameters["Location"] as! String
                    break
                }
            }            
        }
    }
    
    public init(model: ActionModel) {
        index       = model.index
        systemName  = model.systemName
        actionType  = model.actionType
        description = model.description
        criteria    = model.criteria
        expiration  = model.expiration
        enabled     = model.enabled
        
        email       = model.email
        message     = model.message
        phone       = model.phone
        sipAddress  = model.sipAddress
        severity    = model.severity
        location    = model.location
    }
    
    public func copy(model: ActionModel) {
        index       = model.index
        systemName  = model.systemName
        actionType  = model.actionType
        description = model.description
        criteria    = model.criteria
        expiration  = model.expiration
        enabled     = model.enabled
        
        email       = model.email
        message     = model.message
        phone       = model.phone
        sipAddress  = model.sipAddress
        severity    = model.severity
        location    = model.location
    }
    
    public func textForField(field: ActionEditField) -> String {
        switch field {
        case .Description: return description
        case .Criteria:    return criteria
        case .Expiration:  return String(expiration)
        case .Email:       return email
        case .Message:     return message
        case .Phone:       return phone
        case .SipAddress:  return sipAddress
        case .Severity:    return String(severity)
        case .Location:    return location
        }
    }
    
    public func setDataForField(data: String, field: ActionEditField) {
        switch field {
        case .Description:
            description = data
            break
        case .Criteria:
            criteria = data
            break
        case .Expiration:
            expiration = (data as NSString).integerValue
            break
        case .Email:
            email = data
            break
        case .Message:
            message = data
            break
        case .Phone:
            phone = data
            break
        case .SipAddress:
            sipAddress = data
            break
        case .Severity:
            severity = (data as NSString).integerValue
            break
        case .Location:
            location = data
            break
        }
    }

}
