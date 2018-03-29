//
//  SoftwareReleaseTransModel.swift
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

public enum SoftwareReleaseScheduleStatus: String {
    case SCHEDULED = "SCHEDULED"
    case INPROGRESS = "INPROGRESS"
    case COMPLETE = "COMPLETE"
    case CANCELLED = "CANCELLED"
}

public enum SoftwareReleaseTransStatus: String {
    case PENDING = "PENDING"
    case INPROGRESS = "INPROGRESS"
    case RECEIVED = "RECEIVED"
    case COMPLETE = "COMPLETE"
    case ERROR = "ERROR"
}

public class SoftwareReleaseTransModel: AuditResponseModel {
    public var applicationHid: String
    public var objectHid: String
    public var deviceCategory: String
    public var softwareReleaseScheduleHid: String
    public var fromSoftwareReleaseHid: String
    public var toSoftwareReleaseHid: String
    public var softwareReleaseTransStatus: String
    public var error: String
    public var relatedSoftwareReleaseTransHid: String
    public var started: String
    public var ended: String
    
    override init(json: [String : AnyObject]) {
        applicationHid = json["applicationHid"] as? String ?? ""
        objectHid = json["objectHid"] as? String ?? ""
        deviceCategory = json["deviceCategory"] as? String ?? ""
        softwareReleaseScheduleHid = json["softwareReleaseScheduleHid"] as? String ?? ""
        fromSoftwareReleaseHid = json["fromSoftwareReleaseHid"] as? String ?? ""
        toSoftwareReleaseHid = json["toSoftwareReleaseHid"] as? String ?? ""
        softwareReleaseTransStatus = json["softwareReleaseTransStatus"] as? String ?? ""
        error = json["error"] as? String ?? ""
        relatedSoftwareReleaseTransHid = json["relatedSoftwareReleaseTransHid"] as? String ?? ""
        started = json["started"] as? String ?? ""
        ended = json["ended"] as? String ?? ""
        super.init(json: json)
    }
}

public class CreateSoftwareReleaseTransModel: RequestModel {
    public var objectHid: String
    public var deviceCategory: AcnDeviceCategory
    public var softwareReleaseScheduleHid: String
    public var fromSoftwareReleaseHid: String
    public var toSoftwareReleaseHid: String
    public var status: SoftwareReleaseTransStatus
    public var error: String
    public var relatedSoftwareReleaseTransHid: String
    
    public init(objectHid: String,
                deviceCategory: AcnDeviceCategory,
                softwareReleaseScheduleHid: String,
                fromSoftwareReleaseHid: String,
                toSoftwareReleaseHid: String,
                status: SoftwareReleaseTransStatus,
                error: String,
                relatedSoftwareReleaseTransHid: String) {
        self.objectHid = objectHid
        self.deviceCategory = deviceCategory
        self.softwareReleaseScheduleHid = softwareReleaseScheduleHid
        self.fromSoftwareReleaseHid = fromSoftwareReleaseHid
        self.toSoftwareReleaseHid = toSoftwareReleaseHid
        self.status = status
        self.error = error
        self.relatedSoftwareReleaseTransHid = relatedSoftwareReleaseTransHid
    }
    
    override public var params: [String : AnyObject] {
        return [
            "objectHid" : objectHid as AnyObject,
            "deviceCategory" : deviceCategory.rawValue as AnyObject,
            "softwareReleaseScheduleHid" : softwareReleaseScheduleHid as AnyObject,
            "fromSoftwareReleaseHid" : fromSoftwareReleaseHid as AnyObject,
            "toSoftwareReleaseHid" : toSoftwareReleaseHid as AnyObject,
            "status" : status as AnyObject,
            "error" : error as AnyObject,
            "relatedSoftwareReleaseTransHid" : relatedSoftwareReleaseTransHid as AnyObject
        ]
    }
}

public class SoftwareReleaseUpdateModel: RequestModel {
    public var objectHid: String
    public var toSoftwareReleaseHid: String
    public var softwareReleaseScheduleHid: String
    
    public init(objectHid: String,
                toSoftwareReleaseHid: String,
                softwareReleaseScheduleHid: String) {
        self.objectHid = objectHid
        self.toSoftwareReleaseHid = toSoftwareReleaseHid
        self.softwareReleaseScheduleHid = softwareReleaseScheduleHid
    }
    
    public override var params: [String : AnyObject] {
        return [
            "objectHid" : objectHid as AnyObject,
            "toSoftwareReleaseHid" : toSoftwareReleaseHid as AnyObject,
            "softwareReleaseScheduleHid" : softwareReleaseScheduleHid as AnyObject
        ]
    }
}

public class CreateSoftwareReleaseScheduleModel : RequestModel {
    public var scheduledDate: String
    public var softwareReleaseHid: String
    public var deviceCategory: AcnDeviceCategory
    public var comments: String
    public var objectHids = [String]()
    public var notifyOnStart: Bool
    public var notifyOnEnd: Bool
    public var notifyOnSubmit: Bool
    public var notifyEmails: String
    public var name: String
    public var onDemand: Bool
    public var deviceTypeHid: String
    public var hardwareVersionHid: String
    
    public init(scheduledDate: String,
                         softwareReleaseHid: String,
                         deviceCategory: AcnDeviceCategory,
                         comments: String,
                         objectHids: [String],
                         notifyOnStart: Bool,
                         notifyOnEnd: Bool,
                         notifyOnSubmit: Bool,
                         notifyEmails: String,
                         name: String,
                         onDemand: Bool,
                         deviceTypeHid: String,
                         hardwareVersionHid: String) {
        self.scheduledDate = scheduledDate
        self.softwareReleaseHid = softwareReleaseHid
        self.deviceCategory = deviceCategory
        self.comments = comments
        self.objectHids = objectHids
        self.notifyOnStart = notifyOnStart
        self.notifyOnEnd = notifyOnEnd
        self.notifyOnSubmit = notifyOnSubmit
        self.notifyEmails = notifyEmails
        self.name = name
        self.onDemand = onDemand
        self.deviceTypeHid = deviceTypeHid
        self.hardwareVersionHid = hardwareVersionHid
    }
    
    public override var params: [String : AnyObject] {
        return [
            "scheduledDate" : scheduledDate as AnyObject,
            "softwareReleaseHid" : softwareReleaseHid as AnyObject,
            "deviceCategory" : deviceCategory.rawValue as AnyObject,
            "comments" : comments as AnyObject,
            "objectHids" : objectHids as AnyObject,
            "notifyOnStart" : notifyOnStart as AnyObject,
            "notifyOnEnd" : notifyOnEnd as AnyObject,
            "notifyOnSubmit" : notifyOnSubmit as AnyObject,
            "notifyEmails" : notifyEmails as AnyObject,
            "name" : name as AnyObject,
            "onDemand" : onDemand as AnyObject,
            "deviceTypeHid" : deviceTypeHid as AnyObject,
            "hardwareVersionHid" : hardwareVersionHid as AnyObject
        ]
    }
}

public class UpdateSoftwareReleaseScheduleModel : CreateSoftwareReleaseScheduleModel {
    public var status: SoftwareReleaseScheduleStatus
    
    public init(scheduledDate: String,
                softwareReleaseHid: String,
                deviceCategory: AcnDeviceCategory,
                comments: String,
                objectHids: [String],
                notifyOnStart: Bool,
                notifyOnEnd: Bool,
                notifyOnSubmit: Bool,
                notifyEmails: String,
                name: String,
                onDemand: Bool,
                deviceTypeHid: String,
                hardwareVersionHid: String,
                status: SoftwareReleaseScheduleStatus) {
        self.status = status
        super.init(scheduledDate: scheduledDate, softwareReleaseHid: softwareReleaseHid, deviceCategory: deviceCategory, comments: comments, objectHids: objectHids, notifyOnStart: notifyOnStart, notifyOnEnd: notifyOnEnd, notifyOnSubmit: notifyOnSubmit, notifyEmails: notifyEmails, name: name, onDemand: onDemand, deviceTypeHid: deviceTypeHid, hardwareVersionHid: hardwareVersionHid)
    }
    
    override public var params: [String : AnyObject] {
        var result = super.params
        result["status"] = status.rawValue as AnyObject
        return result
    }
}

public class SoftwareReleaseScheduleModel : AuditResponseModel {
    public var applicationHid: String
    public var scheduledDate: String
    public var softwareReleaseHid: String
    public var deviceCategory: String
    public var comments: String
    public var objectHids: [String]
    public var status: String
    public var notifyOnStart: String
    public var notifyOnEnd: String
    public var notifyOnSubmit: String
    public var notifyEmails: String
    public var name: String
    public var onDemand: String
    public var deviceTypeHid: String
    public var hardwareVersionHid: String
    
    override init(json: [String : AnyObject]) {
        applicationHid = json["applicationHid"] as? String ?? ""
        scheduledDate = json["scheduledDate"] as? String ?? ""
        softwareReleaseHid = json["softwareReleaseHid"] as? String ?? ""
        deviceCategory = json["deviceCategory"] as? String ?? ""
        comments = json["comments"] as? String ?? ""
        objectHids = json["objectHids"] as? [String] ?? [String]()
        status = json["status"] as? String ?? ""
        notifyOnStart = json["notifyOnStart"] as? String ?? ""
        notifyOnEnd = json["notifyOnEnd"] as? String ?? ""
        notifyOnSubmit = json["notifyOnSubmit"] as? String ?? ""
        notifyEmails = json["notifyEmails"] as? String ?? ""
        name = json["name"] as? String ?? ""
        onDemand = json["onDemand"] as? String ?? ""
        deviceTypeHid = json["deviceTypeHid"] as? String ?? ""
        hardwareVersionHid = json["hardwareVersionHid"] as? String ?? ""
        super.init(json: json)
    }
}

public class SoftwareReleaseCommandModel {
    public var softwareReleaseTransHid: String
    public var hid: String
    public var fromSoftwareVersion: String
    public var toSoftwareVersion: String
    public var md5Checksum: String
    public var tempToken: String
    
    public init(json: [String : AnyObject]) {
        softwareReleaseTransHid = json["softwareReleaseTransHid"] as? String ?? ""
        hid = json["hid"] as? String ?? ""
        fromSoftwareVersion = json["fromSoftwareVersion"] as? String ?? ""
        toSoftwareVersion = json["toSoftwareVersion"] as? String ?? ""
        md5Checksum = json["md5checksum"] as? String ?? ""
        tempToken = json["tempToken"] as? String ?? ""
    }
}
