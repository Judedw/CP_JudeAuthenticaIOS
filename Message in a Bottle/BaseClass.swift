//
//  BaseClass.swift
//
//  Created by Hasitha De Mel on 11/2/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class BaseClass: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let content = "content"
    static let status = "status"
    static let statusCode = "statusCode"
  }

  // MARK: Properties
  public var content: Content?
  public var status: String?
  public var statusCode: Int?

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
    content <- map[SerializationKeys.content]
    status <- map[SerializationKeys.status]
    statusCode <- map[SerializationKeys.statusCode]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = content { dictionary[SerializationKeys.content] = value.dictionaryRepresentation() }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = statusCode { dictionary[SerializationKeys.statusCode] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.content = aDecoder.decodeObject(forKey: SerializationKeys.content) as? Content
    self.status = aDecoder.decodeObject(forKey: SerializationKeys.status) as? String
    self.statusCode = aDecoder.decodeObject(forKey: SerializationKeys.statusCode) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(content, forKey: SerializationKeys.content)
    aCoder.encode(status, forKey: SerializationKeys.status)
    aCoder.encode(statusCode, forKey: SerializationKeys.statusCode)
  }

}
