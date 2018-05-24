//
//  NewDawnTests.swift
//  NewDawnTests
//
//  Created by Mathieu Janneau on 13/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import XCTest

import FirebaseDatabase
import FirebaseStorage

@testable import NewDawn


class NewDawnTests: XCTestCase {
  // MARK: - USER MOCKS
  let username = "mockUser"
  let controller = MainTabBarController()
  let mockEmailAccount = "mockuser@newdawn.com"
  let mockEmailPassword = "Tetsuogi1"
  
  // MARK: - CHALLENGE MOCK
  /// Chalenge title
  let challengeName = "challengeName"
  /// Category in which cchallenge appears
  let objective = " Objective"
  /// Date chosen by users to process the challenge
  let dueDate = Date()
  /// This property stores the achievement or not of the task
  let isDone = true
  /// This property stores whether the user wants to be notified or not 10 minutes before due date
  let isNotified = true
  /// This property stores the final state success or failure
  let isSuccess = true
  /// Anticipated anxiety level
  let anxietyLevel = 5
  /// Anticipated Benefit level that user is waiting for when achieving task
  let benefitLevel = 5
  /// Post task felt anxiety
  let felt = 5
  /// Property that stores a potential comment
  let comment = "comment"
  /// Location name associated with the task
  let destination = "Destiantion"
  /// Location latitude
  let destinationLat = 10.0
  /// Location longitude
  let destinationLong = 10.0
  /// Convert date to double
  var dateToStore: Double = 0.0
  
  
  override func setUp() {
    super.setUp()
    DatabaseService.shared.purgeChallenges(for: username)
    dateToStore = dueDate.timeIntervalSince1970
  }
  
  // MARK: - USER TEST
  /// test storing user in user default
  func testGivenAuserWhenLoggedThenStoreInUserDefault() {
    // save user in userDefaults
    LoginService.shared.validateUser(username)
    
    // retrieve user from userDefaults
    let loggedUser = UserDefaults.standard.object(forKey: "currentUser")
    
    //Assertion
    XCTAssert(loggedUser as! String == "mockUser")
  }
  // MARK: - CHALLENGES RELATED TEST
  
  // MARK: - OBJECT TEST
  /// test challenge model
  func testGivenValuesWhenInitChallengeThenChallengeCreated() {
    
    
    // init function to test
    let newChallenge = Challenge(user: username, name: challengeName, objective: objective, dueDate: dateToStore, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isNotified: isNotified, isDone: isDone, isSuccess: isSuccess, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong)
    
    // Assertions
    XCTAssert(newChallenge.user == username)
    XCTAssert(newChallenge.name == challengeName)
    XCTAssert(newChallenge.objective == objective)
    XCTAssert(newChallenge.dueDate == dateToStore)
    XCTAssert(newChallenge.anxietyLevel == anxietyLevel)
    XCTAssert(newChallenge.benefitLevel == benefitLevel)
    XCTAssert(newChallenge.isSuccess == 1)
    XCTAssert(newChallenge.isDone == 1)
    XCTAssert(newChallenge.isNotified == 1)
    XCTAssert(newChallenge.destination == destination)
    XCTAssert(newChallenge.destinationLat == destinationLat)
    XCTAssert(newChallenge.destinationLong == destinationLong)
    
  }
  
  /// test optionnal values in challenge init
  func testGivenValuesWhenInitwithNilValuesThenChallengeCreated() {
    
    // init function to test
    let newChallenge = Challenge(user: username, name: challengeName, objective: objective, dueDate: dateToStore, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isNotified: isNotified, isDone: isDone, isSuccess: isSuccess, destination: nil, destinationLat: nil, destinationLong: nil)
    
    // Assertions
    XCTAssert(newChallenge.user == username)
    XCTAssert(newChallenge.name == challengeName)
    XCTAssert(newChallenge.objective == objective)
    XCTAssert(newChallenge.dueDate == dateToStore)
    XCTAssert(newChallenge.anxietyLevel == anxietyLevel)
    XCTAssert(newChallenge.benefitLevel == benefitLevel)
    XCTAssert(newChallenge.isSuccess == 1)
    XCTAssert(newChallenge.isDone == 1)
    XCTAssert(newChallenge.isNotified == 1)
    XCTAssert(newChallenge.destination == nil)
    XCTAssert(newChallenge.destinationLat == nil)
    XCTAssert(newChallenge.destinationLong == nil)
    
  }
  
  func testGivenAChallengeWhenConvertToJsonThenDict() {
    // create challenge
    let newChallenge = Challenge(user: username, name: challengeName, objective: objective, dueDate: dateToStore, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isNotified: isNotified, isDone: isDone, isSuccess: isSuccess, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong)
    let challengeToTest = newChallenge.toAnyObject()
    XCTAssert(challengeToTest["user"] as? String == "mockUser")
    XCTAssert(challengeToTest["objective"] as? String == " Objective")
    XCTAssert(challengeToTest["name"] as? String == "challengeName")
    XCTAssert(challengeToTest["anxietyLevel"] as? Int == 5)
    XCTAssert(challengeToTest["benefitLevel"] as? Int == 5)
    XCTAssert(challengeToTest["isDone"] as? Int == 1)
    XCTAssert(challengeToTest["isSuccess"] as? Int == 1)
    XCTAssert(challengeToTest["isNotified"] as? Int == 1)
    XCTAssert(challengeToTest["destination"] as? String == "Destiantion")
  }
  
  
  

  
  // MARK: - METHOD TEST
  /// test Saving challenge in BDD
  func testGivenAChallengeWhenSavingThenStoredInFB() {
    
    // Create an expectation for a background download task.
    let expectation = XCTestExpectation(description: "challenge is stored")
    var testResult = false
    // Array to store results
    var array = [Challenge]()
    
    
    var receivedError: Error? = nil
    // Create entity in Firebase
    DatabaseService.shared.createChallenge(dueDate: dateToStore, user: username, name: challengeName, objective: objective, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isDone: 1, isNotified: 1, isSuccess: 1, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong) {(error) in
      if error != nil {
        receivedError = error
      }
    }
    
    // Load from firebase
    DatabaseService.shared.loadChallenges(for: username) { (result)  in
      guard let data = result else { return}
      
      for item in data {
        array.append(item)
      }
      if array.contains(where: {$0.user == self.username}) {
        testResult = true
        print(testResult)
        
      }
      XCTAssert(testResult)
      XCTAssertNil(receivedError)
      expectation.fulfill()
    }
    // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
    wait(for: [expectation], timeout: 10.0)
  }
  
  
  /// test update challenge
  func testGivenAChallengeWhenUpdatingThenStoredInFB() {
    
    // Create an expectation for a background download task.
    let expectation = XCTestExpectation(description: "challenge is stored")
    var receivedError: Error?
    var challengeTocheck: Challenge?
    
    
    // create a challenge to test
    DatabaseService.shared.createChallenge(dueDate: dateToStore, user: username, name: "testUpdate", objective: objective, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isDone: 1, isNotified: 1, isSuccess: 1, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong) {(error) in
      if error != nil {
        receivedError = error
      }
      print("ERROR")
      
    }
    
    DatabaseService.shared.loadChallenges(for: "mockUser", completionHandler: { (result) in
      
      guard let challengeTocheck = result?.last else { return}
      
      // Update entity in Firebase
      DatabaseService.shared.updateChallenge(dueDate: self.dateToStore, key: challengeTocheck.key, user: "paul", name: "test", objective: "testObjective", anxietyLevel: 0, benefitLevel: 0, isDone: 0, isNotified: 0, isSuccess: 0, destination: "nowhere", destinationLat: 0.0, destinationLong: 0.0) { (error) in
        if error != nil {
          receivedError = error
        }
        
      }
    })
    
    
    // Load from firebase
    Database.database().reference().child("challenges").observe(.value) { (snapshot) in
      var container = [Challenge]()
      for item in snapshot.children {
        
        let newChal = Challenge(snapshot: item as! DataSnapshot)
        container.append(newChal)
      }
      
      challengeTocheck = container.last
    }
    
    if let chal = challengeTocheck {
      XCTAssert(chal.name! == "test")
      XCTAssert(chal.user! == "paul")
      XCTAssert(chal.anxietyLevel! == 0)
      XCTAssert(chal.benefitLevel! == 0)
      XCTAssert(chal.isDone! == 0)
      XCTAssert(chal.isNotified! == 0)
      XCTAssert(chal.isSuccess! == 0)
      if let dest = chal.destination {
        XCTAssert(dest == "nowhere")
        if let long = chal.destinationLong {
          XCTAssert(long == 0.0)
          if let lat = chal.destinationLat {
            XCTAssert(lat == 0.0)
          }
        }
      }}
    
    XCTAssertNil(receivedError)
    expectation.fulfill()
    // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
    wait(for: [expectation], timeout: 10.0)
  }
  
  /// test load Challenges
  func testGivenStoredChallengesWhenFetchingThenLoad() {
    // Declare expectation
    let expectation = XCTestExpectation(description: "Load some challenges")
    
    // create a challenge to test
    DatabaseService.shared.createChallenge(dueDate: dateToStore, user: username, name: "testUpdate", objective: objective, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isDone: 1, isNotified: 1, isSuccess: 1, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong) {(error) in
      if error != nil {
        print(error!)
      }
      
      
    }
    
    // array to store results
    var arrayOfChallenges = [Challenge]()
    // fetch data
    DatabaseService.shared.loadChallenges(for: username){ (result) in
      guard let data = result else { return }
      for item in data {
        arrayOfChallenges.append(item)
      }
      XCTAssertFalse(arrayOfChallenges.isEmpty)
      expectation.fulfill()
    }
    
    // async delay
    wait(for: [expectation], timeout: 200.0)
    
  }
  
  
  /// test image upload
  func testGivenImageWhenUserUploadThenStoredAndUpdateChallenge() {
    
    let expectation = XCTestExpectation(description: "image stored in db")
    var challengeTocheck : Challenge?
    // image
    let image = #imageLiteral(resourceName: "bg")
    // Convert to data
    guard let data = UIImagePNGRepresentation(image) else { return}
    Database.database().reference().child("challenges").observe(.value) { (snapshot) in
      var container = [Challenge]()
      for item in snapshot.children {
        
        let newChal = Challenge(snapshot: item as! DataSnapshot)
        container.append(newChal)
      }
      
      challengeTocheck = container.last
      guard let key = challengeTocheck?.key else { return}
      DatabaseService.shared.uploadImagePic(data: data, for: key, isDone: 1, isSuccess: 1, comment: "test Comment") {(status,error) in
        if error != nil {

        } else{
          
          XCTAssert(status == "success")
          expectation.fulfill()}
      }
      
    }
    // async delay !!! Do not go under 20 cause it s an heavy image !!!
    wait(for: [expectation], timeout: 30)
  }

  func testWhenUserHasDoneChallengesWhenFetchCountThenReturnsIsDoneCount() {

    var isDoneChallenges = 0
    let expectations = XCTestExpectation(description: "No data for this user")
  
    // create 2 mock challenges
    DatabaseService.shared.createChallenge(dueDate: dateToStore, user: username, name: "testUpdate", objective: objective, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isDone: 1, isNotified: 1, isSuccess: 1, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong) {(error) in
      if error != nil {
        print(error!)}
      
    }
    
    DatabaseService.shared.createChallenge(dueDate: dateToStore, user: username, name: "testUpdate2", objective: objective, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isDone: 1, isNotified: 1, isSuccess: 1, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong) {(error) in
      if error != nil {
        print(error!)}
    }
     DatabaseService.shared.loadSuccessChallengesCount(for: self.username) { (result, error) in
      print("COUNT: \(isDoneChallenges)")
      if error != nil {
        print("ERROR")
      }
      
      isDoneChallenges = result
      
        XCTAssert(isDoneChallenges == 2)
      }
  
    expectations.fulfill()

    
    // async delay
    wait(for: [expectations], timeout: 200)
  }
  
  /// test challenge purge for one particular user
  func testGivenUserHasChallengesWhenPurgingThenBDDIsEmpty() {

   // unowned let unownedSelf = self
    
    let deadlineTime = DispatchTime.now() + .seconds(10)
    
    let expectations = XCTestExpectation(description: "No data for this user")

    var arrayOfChallenges: [Challenge] = []
    DatabaseService.shared.createChallenge(dueDate: dateToStore, user: "paul", name: challengeName, objective: objective, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isDone: 1, isNotified: 1, isSuccess: 1, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong) {(error) in
      if error != nil {
        print(error!)
      }

      DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {

        // Array to store datas
        
        DatabaseService.shared.purgeChallenges(for: "paul")
        DatabaseService.shared.loadChallenges(for: "paul") { (result) in

          guard let data = result else { return}
          arrayOfChallenges = data

        }})
      XCTAssert(arrayOfChallenges.isEmpty)
      expectations.fulfill()
    }

    // async delay !! Keep large delay to give the time to delete
    
    wait(for: [expectations], timeout: 200.0)
  }
  
  /// test Mood instantiation
  func testGivenValuesWhenInitMoodThenMoodCreated() {
    
    // create mood
    let mood = Mood(user: username, state: 0, date: dateToStore)
    // test values
    XCTAssert(mood.user == username)
    XCTAssert(mood.state == 0)
  }
  
  /// test json export before firebase Storage
  func testGivenMoodWhenToJsonTheDict() {
    // create mood
    let mood = Mood(user: username, state: 0, date: dateToStore)
    let dict = mood.toAnyObject()
    XCTAssert(dict["user"] as? String ==  "mockUser")
    XCTAssert(dict["state"] as? Int ==  0)
   
  }
  
  /// test Mood creation on BDD
  func testGivenAMoodWhenUserSaveThenEntryCreatedInBDD() {
    let expectations = XCTestExpectation(description: "Moods are not empty")
    
    // save mood in BDD
    DatabaseService.shared.saveMood(user: username, state: 0, date: dateToStore, onCompleted: { _ in})
    var arrayOfMoods = [Mood]()
    // load moods in array
    DatabaseService.shared.loadMoods(for: username) { (result,_) in
      
      arrayOfMoods = result
      // test values
      XCTAssertFalse(arrayOfMoods.isEmpty)
      expectations.fulfill()
    }
    // Async test
    wait(for: [expectations], timeout: 20)
  }
  
  /// test load Moods
  func testGivenStoredMoodsWhenFetchThenAreaIsFulfilled() {
    // Declare expectation
    let expectation = XCTestExpectation(description: "load Moods")
 
    // Array to locally store moods
    var arrayOfMood = [Mood]()
    // save mood in BDD
    DatabaseService.shared.saveMood(user: username, state: 0, date: dateToStore, onCompleted: { _ in
      
      // fetch
      DatabaseService.shared.loadMoods(for: self.username) { (result, error) in
        if error != nil {
            print(error!)
        }
        arrayOfMood = result
        XCTAssertFalse(arrayOfMood.isEmpty)
        expectation.fulfill()
      }
    })
    
    
    // Async test
    wait(for: [expectation], timeout: 20)
  }
  
  /// test Deleting moods for user
  func testWhenBDDContainsMoodsForUserWhenUserDeleteThenRemovedFromBDD() {
    let deadlineTime = DispatchTime.now() + .seconds(10)
    // Declare expectation
    let expectation = XCTestExpectation(description: "load Moods")
    
    // Array to locally store moods
    var arrayOfMood = [Mood]()
    // save mood in BDD
    DatabaseService.shared.saveMood(user: username, state: 0, date: dateToStore) { status in
      print(status)
    }
    
     DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
      // purge moods
      DatabaseService.shared.purgeMoods(for: self.username) { status in
        print(status)
        // load newmoods
        DatabaseService.shared.loadMoods(for: self.username) { (result, error) in
          if error != nil {
            XCTAssertNotNil(error)
            expectation.fulfill()
          }
          arrayOfMood = result
        }
        // make test after completion
        
      }
      XCTAssert(arrayOfMood.isEmpty)
      expectation.fulfill()
    })

    // Async test
    wait(for: [expectation], timeout: 20)
  }
  
  /// test Fetching events
  func testGivenChallengesWhenFetchEventsThenReturnsDates() {
    let expectation = XCTestExpectation(description: "event no empty")
    var events = [String]()
    
    // create a challenge to test
    DatabaseService.shared.createChallenge(dueDate: dateToStore, user: username, name: "testUpdate", objective: objective, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isDone: 1, isNotified: 1, isSuccess: 1, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong) {(error) in
      if error != nil {
        print(error!)}
    }
    
    // load events in array
    DatabaseService.shared.loadEventsDatabase(for: self.username) { (result) in
      guard let data = result else { return}
      events = data
      print("EVENTS \(events)")
      XCTAssertFalse(events.isEmpty)
      expectation.fulfill()
    }
    
    // Async test
    wait(for: [expectation], timeout: 20)
    
  }
  
  
  /// Test Date sorting array of challenge
  func testGivenAnArrayOfChallengeWhenFilterThenReturnfiltered() {
  
    let expectation = XCTestExpectation(description: "Ordered challenges")
    // init function to test
    let newChallenge1 = Challenge(user: username, name: challengeName, objective: objective, dueDate: dateToStore, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isNotified: isNotified, isDone: isDone, isSuccess: isSuccess, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong)
    // init function to test
    let newChallenge2 = Challenge(user: username, name: challengeName, objective: objective, dueDate: (dateToStore + 86400), anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isNotified: isNotified, isDone: isDone, isSuccess: isSuccess, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong)
    
    // init function to test
    let newChallenge3 = Challenge(user: username, name: challengeName, objective: objective, dueDate: (dateToStore - 86400), anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isNotified: isNotified, isDone: isDone, isSuccess: isSuccess, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong)
    
    let arrayOfChallenge = [newChallenge3,newChallenge2,newChallenge1]
    
    var results = [(Double, Double)]()
    
    DatabaseService.shared.getSucceededChallengeByDate(data: arrayOfChallenge) { (result) in
      results = result
      print(results[0].0 )
      print(results[1].0 )
      print(results[2].0 )
      XCTAssert(results[0].0 < results[1].0)
      XCTAssert(results[1].0 < results[2].0)
      expectation.fulfill()}
    
    
    // Async test
    wait(for: [expectation], timeout: 20)
  }

  /// Mock Therapist data
  let mockTherapist: [String: Any] = [ "name":"M ALLARD François","lat":"48.857","lng":"2.40394","adresse":"119 rue des Pyrénées 75020 Paris","tp":"1","s":0,"telephone":"Tel : 01 43 70 64 79    Mob :  06 08 05 49 74","profession":"Psychologue-Psychothérapeute"]

  /// test Therapist Initialization
  func testGivenDataWhenTherapistInstanceThenCreated() {
      let medic = Therapist(name: "M ALLARD François", lat: "48.857", lng: "2.40394", adresse: "119 rue des Pyrénées 75020 Paris", tel: "Tel : 01 43 70 64 79    Mob :  06 08 05 49 74", profession: "Psychologue-Psychothérapeute")
    
    XCTAssert(medic.name == "M ALLARD François")
    XCTAssert(medic.lat == "48.857")
    XCTAssert(medic.lng == "2.40394")
    XCTAssert(medic.adresse == "119 rue des Pyrénées 75020 Paris" )
    XCTAssert(medic.tel == "Tel : 01 43 70 64 79    Mob :  06 08 05 49 74")
    XCTAssert(medic.profession == "Psychologue-Psychothérapeute")
  }
  
  
  /// test therapist parsing
  func testGivenTherapistSourceWhengettingThenArrayNotEmpty() {
    var therapists = [Therapist]()
   therapists = Therapist.getTherapist()
    XCTAssertFalse(therapists.isEmpty)
  }
  
  func testGivenAChallengeWhenFormattingThenreturnFormatted() {
    // init function to test
    let newChallenge = Challenge(user: username, name: challengeName, objective: objective, dueDate: dateToStore, anxietyLevel: anxietyLevel, benefitLevel: benefitLevel, isNotified: isNotified, isDone: isDone, isSuccess: isSuccess, destination: destination, destinationLat: destinationLat, destinationLong: destinationLong)
    
    let formatted = FormattedChallenge(challenge: newChallenge)
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormat.sortingFormat.rawValue
    // Assertions
    XCTAssert(formatted.user == username)
    XCTAssert(formatted.name == challengeName)
    XCTAssert(formatted.objective == objective)
    XCTAssert(formatted.dueDate == dateToStore)
    XCTAssert(formatted.anxietyLevel == anxietyLevel)
    XCTAssert(formatted.benefitLevel == benefitLevel)
    XCTAssert(formatted.isSuccess == true)
    XCTAssert(formatted.isDone == true)
    XCTAssert(formatted.isNotified == true)
    XCTAssert(formatted.destination == destination)
    XCTAssert(formatted.destinationLat == destinationLat)
    XCTAssert(formatted.destinationLong == destinationLong)
    XCTAssert(formatted.formattedDate == formatter.string(from: Date(timeIntervalSince1970: dateToStore)))
  }
  

}

