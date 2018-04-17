///**
/**
 NewDawn
 Created by: Mathieu Janneau on 24/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import Foundation

struct Therapist {
  var name: String
  var lat: String
  var lng: String
  var adresse: String
  var tel: String
  var profession: String
  
  init(name: String, lat: String, lng: String, adresse: String, tel: String, profession: String) {
    self.name = name
    self.lat = lat
    self.lng = lng
    self.adresse = adresse
    self.tel = tel
    self.profession = profession
  }
  
  static func getTherapist() -> [Therapist] {
    var therapists: [Therapist] = []
    // Load local Json
    guard let url: URL = Bundle.main.url(forResource: "adresses", withExtension: "json") else {return []}
    do {
      // Parsing
      let jsonData = try Data(contentsOf: url)
      if let dataSet = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
      // Iterate througth json data
      for data in dataSet {
        if let name = data["name"] as? String {
          if let lat = data["lat"] as? String {
            if let lng = data["lng"] as? String {
              if let adresse = data["adresse"] as? String {
                if let tel = data["telephone"] as? String {
                  if let profession = data["profession"] as? String {
                    // Create a Therapist object
                    let medic = Therapist(name: name,
                                          lat: lat,
                                          lng: lng,
                                          adresse: adresse,
                                          tel: tel,
                                          profession: profession)
                    therapists.append(medic)
                  }
                }
              }
            }
          }
        }
      }}
    } catch let error {
      print(error)
    }
    return therapists
  }
}
