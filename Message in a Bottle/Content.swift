//
//  Content.swift
//
//  Created by Hasitha De Mel on 11/2/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class Content: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let serverId = "serverId"
    static let title = "title"
    static let message = "message"
    static let productId = "productId"
  }

  // MARK: Properties
  public var serverId: String?
  public var title: String?
  public var message: String?
  public var productId: String?

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public required init?(map: Map){

  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    serverId <- map[SerializationKeys.serverId]
    title <- map[SerializationKeys.title]
    message <- map[SerializationKeys.message]
    productId <- map[SerializationKeys.productId]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = serverId { dictionary[SerializationKeys.serverId] = value }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = message { dictionary[SerializationKeys.message] = value }
    if let value = productId { dictionary[SerializationKeys.productId] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.serverId = aDecoder.decodeObject(forKey: SerializationKeys.serverId) as? String
    self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
    self.message = aDecoder.decodeObject(forKey: SerializationKeys.message) as? String
    self.productId = aDecoder.decodeObject(forKey: SerializationKeys.productId) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(serverId, forKey: SerializationKeys.serverId)
    aCoder.encode(title, forKey: SerializationKeys.title)
    aCoder.encode(message, forKey: SerializationKeys.message)
    aCoder.encode(productId, forKey: SerializationKeys.productId)
  }

}
