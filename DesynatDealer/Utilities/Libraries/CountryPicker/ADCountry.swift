import UIKit

class ADCountry: NSObject {
  @objc let name: String
  let code: String
  var section: Int?
  let dialCode: String!
  
  init(name: String, code: String, dialCode: String = " - ") {
    self.name = name
    self.code = code
    self.dialCode = dialCode
  }
}
