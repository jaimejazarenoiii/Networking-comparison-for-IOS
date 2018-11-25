//
//  ViewController.swift
//  tester
//
//  Created by Jaime Jazareno III on 25/11/2018.
//  Copyright © 2018 Jaime Jazareno III. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        doAlamofireRequest()
        // Do any additional setup after loading the view, typically from a nib.
    }

  func doAlamofireRequest() {
    Alamofire.request("https://reqres.in/api/users").responseJSON { response in
      debugPrint("Request: \(String(describing: response.request))")   // original url request
      debugPrint("Response: \(String(describing: response.response))") // http url response
      debugPrint("Result: \(response.result)")                         // response serialization result
      if let json = response.result.value {
        let newJson = JSON(json)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let encryptedData = try? newJson["data"].rawData() {
          NSLog(String(data: encryptedData, encoding: .utf8) ?? "")
          let users = try? decoder.decode([User].self, from: encryptedData)
          debugPrint("Users: \(users)")
        }
      }

      if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
        debugPrint("Data: \(utf8Text)") // original server data as UTF8 string
      }
    }
  }

}

struct User: Codable {
  var id: Int
  var firstName: String
  var lastName: String
  var avatar: URL
}

