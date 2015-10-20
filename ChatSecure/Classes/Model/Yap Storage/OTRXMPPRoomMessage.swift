//
//  OTRXMPPRoomMessage.swift
//  ChatSecure
//
//  Created by David Chiles on 10/19/15.
//  Copyright © 2015 Chris Ballinger. All rights reserved.
//

import Foundation
import YapDatabase

public class OTRXMPPRoomMessage: OTRYapDatabaseObject {
    
    public static let roomEdgeName = "OTRRoomMesageEdgeName"
    
    public var roomJID:String?
    
    /** This is the full JID of the sender. This should be equal to the occupant.jid*/
    public var senderJID:String?
    public var displayName:String?
    public var incoming = false
    public var messageText:String?
    public var messageDate:NSDate?
    
    public var roomUniqueId:String?
    
    public override var hash: Int {
        get {
            return super.hash
        }
    }
}

extension OTRXMPPRoomMessage:YapDatabaseRelationshipNode {
    //MARK: YapRelationshipNode
    public func yapDatabaseRelationshipEdges() -> [AnyObject]! {
        
        if let roomID = self.roomUniqueId {
            let relationship = YapDatabaseRelationshipEdge(name: OTRXMPPRoomMessage.roomEdgeName, sourceKey: self.uniqueId, collection: OTRXMPPRoomMessage.collection(), destinationKey: roomID, collection: OTRXMPPRoom.collection(), nodeDeleteRules: YDB_NodeDeleteRules.DeleteSourceIfDestinationDeleted)
            return [relationship]
        } else {
            return []
        }
    }
}

extension OTRXMPPRoomMessage:OTRMesssageProtocol {
    
    //MARK: OTRMessageProtocol
    
    public func threadId() -> String! {
        return self.roomUniqueId
    }
    
    public func messageIncoming() -> Bool {
        return self.incoming
    }
    
    public func messageMediaItemKey() -> String! {
        return nil
    }
    
    public func messageError() -> NSError! {
        return nil
    }
    
    public func transportedSecurely() -> Bool {
        return false;
    }
    
    //MARK: JSQMessageData Protocol methods
    
    public func senderId() -> String! {
        return self.senderJID
    }
    
    public func senderDisplayName() -> String! {
        return self.displayName
    }
    
    public func date() -> NSDate! {
        return self.messageDate
    }
    
    public func isMediaMessage() -> Bool {
        return false
    }
    
    public func messageHash() -> UInt {
        
        //TODO this is not correct but UInt(self.hash) is not working
        return UInt(self.date().timeIntervalSince1970)
    }
    
    public func text() -> String! {
        return self.messageText
    }
    
    public func messageRead() -> Bool {
        return true
    }
    
}