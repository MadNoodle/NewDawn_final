//
//  HistoryViewController.swift
//  NewDawn
//
//  Created by Mathieu Janneau on 18/03/2018.
//  Copyright © 2018 Mathieu Janneau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit
import Charts
import Firebase
import FirebaseDatabase
import PDFGenerator

/** Handle the User's Challenges Data visualization in different charts
 Rely on Charts Pods https://github.com/danielgindi/Charts. Documentation
 can be found https://github.com/PhilJay/MPAndroidChart/wiki
 **/
class HistoryViewController: UIViewController, ChartViewDelegate {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  internal var dataSet: [Mood]?
  internal var dataPoints: [Challenge]?
  internal var history: [Challenge] = []
  var amountOfSucceededChallenge: Int = 0
  var progress = 0.0
  var currentUser = ""
  let reuseId = "myCell"
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var rangeSelector: UISegmentedControl!
  @IBOutlet weak var lineChart: LineChartView!
  @IBOutlet weak var barChart: BarChartView!
  @IBOutlet weak var progressCircle: UIView!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var moodHistoryLabel: UILabel!
  @IBOutlet weak var doneChallenges: UILabel!
  @IBOutlet weak var weeklyProgressLabel: UILabel!
  @IBOutlet weak var challengesHistory: UILabel!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set up delegation
    lineChart.delegate = self
    barChart.delegate = self
    scrollView.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
    
    // load logged user
    if let user = UserDefaults.standard.object(forKey: UIConfig.currentUserKey) as? String {
      currentUser = user
    }
    // Display UI
    shouldDisplayUI()
    shouldLoadTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loadDataInCharts()
  }
  
  // ////////////////// //
  // MARK: - UI METHODS //
  // ////////////////// //
  
  /// Displays UI
  fileprivate func shouldDisplayUI() {
    // load label's text
    moodHistoryLabel.text = NSLocalizedString("Mood History", comment: "")
    doneChallenges.text = NSLocalizedString("Done Challenges", comment: "")
    weeklyProgressLabel.text = NSLocalizedString("Weekly progress", comment: "")
    challengesHistory.text = NSLocalizedString("Challenges History", comment: "")
    rangeSelector.setTitle(NSLocalizedString("week", comment: ""), forSegmentAt: 0)
    rangeSelector.setTitle(NSLocalizedString("month", comment: ""), forSegmentAt: 1)
    rangeSelector.setTitle(NSLocalizedString("trimester", comment: ""), forSegmentAt: 2)
    rangeSelector.setTitle(NSLocalizedString("all time", comment: ""), forSegmentAt: 3)
    
    // UI Setup
    setupButtons()
  }
  
  /// Display Challenges history tableView
  fileprivate func shouldLoadTableView() {
    tableView.register(UINib(nibName: "ChallengeDetailCell", bundle: nil), forCellReuseIdentifier: reuseId)
    // Load challenges for user from firebase
    DatabaseService.shared.loadChallenges(for: currentUser) { (challengeArray) in
      
      guard let loadedChallenges = challengeArray else { return}
      self.history = loadedChallenges
      self.tableView.reloadData()
    }
  }
  
  /// Draw all bar chart, line Chart and progress circle
  private func shouldLoadGraph() {
    guard let linePoints = dataSet, let barValues = dataPoints else { return}
    // display charts
    shouldDisplayLineGraph(with: linePoints)
    shouldDisplayBarChart(with: barValues)
    shouldAnimateCircleProgress(progress: Float(progress))
    
    // update charts
    barChart.setNeedsLayout()
    lineChart.setNeedsLayout()
    progressCircle.setNeedsLayout()
    progressLabel.setNeedsLayout()
    
  }
  
  /// Load Circle animation to show progress
  func loadDataCircle() {
    DispatchQueue.main.async {
      // load data from firebase
      DatabaseService.shared.loadChallenges(for: self.currentUser) { (result) in
        
        if let data = result {
          // Load data for progress circle
          if data.isEmpty {
            self.progress = 0
          } else {
            self.progress = Double(self.amountOfSucceededChallenge) / (Double(data.count) / 100.0)
          }
          // update and animate views
          self.shouldAnimateCircleProgress(progress: Float(self.progress))
          self.progressCircle.setNeedsLayout()
          self.progressLabel.setNeedsLayout()
        }
      }
    }
  }
  
  /// Inject All data for a user in charts
  func loadDataInCharts() {
    // load challenges async
    DispatchQueue.main.async {
      DatabaseService.shared.loadChallenges(for: self.currentUser) { (result) in
        
        if let data = result {
          // load data for succeed challenge bar chart
          self.dataPoints = data.filter({$0.isDone == 1})
          
          // Load data for progress circle
          if data.isEmpty {
            self.progress = 0
          } else {
            self.progress = Double(self.amountOfSucceededChallenge) / (Double(data.count) / 100.0)
          }
        }
      }
      
      // load moods
      DatabaseService.shared.loadMoods(for: self.currentUser) { (result, error) in
        if error != nil {
          UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
        }
        let moodData = result
        self.dataSet = moodData
        DatabaseService.shared.loadSuccessChallengesCount(for: self.currentUser, completion: { (result, error) in
          if error != nil {
            UserAlert.show(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, controller: self)
          }
          self.amountOfSucceededChallenge = result
          self.shouldLoadGraph()
        })
      }
    }
  }
  
  
  // /////////////// //
  // MARK: - ACTIONS //
  // /////////////// //
  
  /// Displays the former week data visualization
  @IBAction func chooseRange(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex
    {
    case 0:
      shouldZoom(onLast: HistoryRange.week.rawValue)
    case 1:
      shouldZoom(onLast: HistoryRange.month.rawValue)
    case 2:
      shouldZoom(onLast: HistoryRange.trimester.rawValue)
    case 3:
      shouldZoom(onLast: HistoryRange.year.rawValue)
    default:
      break
    }
  }
  
  
  // ////////////////// //
  // MARK: - UI METHODS //
  // ////////////////// //
  
  /// Handles buttons behavior and color scheme
  private func setupButtons() {
    
    // add share button to navigation
    let rightButton: UIBarButtonItem =
      UIBarButtonItem(image: #imageLiteral(resourceName: "upload"), style: .plain, target: self, action: #selector(shareChallenge))
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  
 
  
  // //////////////////////// //
  // MARK: - PDF EXPORT METHODS //
  // //////////////////////// //
  
  /// Selector for the share button in the navigation bar
  @objc func shareChallenge() {
    //send comment from text view to model
    // instantiate pdfCreator
    let pdfCreator = PDFCreator()
    let snapshotter = ScrollViewSnapshotter()
    let data = snapshotter.PDFWithScrollView(scrollview: scrollView)
      if let controller = pdfCreator.scrollViewToPdf(data: data){
      present(controller, animated: true, completion: nil)}
    }
 
}

