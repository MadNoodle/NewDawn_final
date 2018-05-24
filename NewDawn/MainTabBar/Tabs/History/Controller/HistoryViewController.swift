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

/** Handle the User's Challenges Data visualization in different charts
 Rely on Charts Pods https://github.com/danielgindi/Charts. Documentation
 can be found https://github.com/PhilJay/MPAndroidChart/wiki
 **/
class HistoryViewController: UIViewController, ChartViewDelegate  {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //

  // Get data
  
  // TO DO OPTIONNEL
  internal var dataSet: [Mood]?
  internal var dataPoints: [Challenge]?
  var amountOfSucceededChallenge: Int = 0
  var progress = 0.0
  var currentUser = ""
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var rangeSelector: UISegmentedControl!
  @IBOutlet weak var lineChart: LineChartView!
  @IBOutlet weak var barChart: BarChartView!
  @IBOutlet weak var progressCircle: UIView!
  @IBOutlet weak var progressLabel: UILabel!
 
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set up delegation
    lineChart.delegate = self
    barChart.delegate = self
    // UI Setup
    setupButtons()
    
    // load logged user
    if let user = UserDefaults.standard.object(forKey: UIConfig.currentUserKey) as? String {
      currentUser = user
    }
    

   
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // load challenges
    DispatchQueue.main.async {
      DatabaseService.shared.loadChallenges(for: self.currentUser) { (result) in
     
        if let data = result {
          self.dataPoints = data
        
        }
      }
      // load moods
      DatabaseService.shared.loadMoods(for: self.currentUser) { (result, error) in
        if error != nil {
          UserAlert.show(title: "Error", message: error!.localizedDescription, controller: self)
        }
        let moodData = result
        self.dataSet = moodData
        DatabaseService.shared.loadSuccessChallengesCount(for: self.currentUser, completion: { (result, error) in
          if error != nil {
            UserAlert.show(title: "Error", message: error!.localizedDescription, controller: self)
          }
          self.amountOfSucceededChallenge = result
         self.shouldLoadUI()
        })
        // display UI on completion
        
      }
    }
  }

  private func shouldLoadUI() {
    guard let linePoints = dataSet, let barValues = dataPoints else { return}
      shouldDisplayLineGraph(with: linePoints)
      shouldDisplayBarChart(with: barValues)
      if barValues.isEmpty { progress = 0
      } else {
        
        progress = Double(amountOfSucceededChallenge) / (Double(barValues.count) / 100.0)
      }
      shouldAnimateCircleProgress(progress: Float(progress))
      shouldZoom(onLast: HistoryRange.week.rawValue)
    
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

  
  
  // ////////////////////// //
  // MARK: - BARCHART SETUP //
  // ////////////////////// //
  
  
  /// Allows the user to display a set of data in a Bar chart with
  /// a time based X axis and a value Y axis
  /// - Parameter data: [Challenge]
  private func shouldDisplayBarChart(with data: [Challenge]) {
    // grab succeeded challenges
    var annotedChallenges = [(Double,Double)]()
   DatabaseService.shared.getSucceededChallengeByDate(data: data) {(result) in
      annotedChallenges = result
    }
   
    // if no data display a message
    if data.isEmpty {
      handleNoData()
    }

    // Populate data in BarChart matrix
    var dataEntries: [BarChartDataEntry] = []
    for index in 0..<annotedChallenges.count {
      let value = BarChartDataEntry(x: annotedChallenges[index].0, y: annotedChallenges[index].1 - 0.6)
      dataEntries.append(value)
    }
   
    // Bars setup
    let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
    chartDataSet.colors = [UIConfig.lightGreen]
    chartDataSet.drawValuesEnabled = false
    chartDataSet.barBorderColor = UIConfig.lightGreen
    chartDataSet.barBorderWidth = 50
   
    // injectData in chart
    let chartData = BarChartData(dataSet: chartDataSet)
    barChart.data = chartData
    // General chart Settings
    chartSettings(chart: barChart)
    // Remove decimal for left axis tags
    let leftAxisFormatter = NumberFormatter()
    leftAxisFormatter.minimumFractionDigits = 0
    leftAxisFormatter.maximumFractionDigits = 0
    // define range and interval for left axis
    barChart.leftAxis.axisMinimum = 0
    barChart.leftAxis.axisMaximum = 4
    barChart.leftAxis.granularity = 1
    
    barChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
    // Set interval between point around 1 day
    barChart.xAxis.granularity = 43200
    barChart.xAxis.granularityEnabled = true
    // Sets visible range if there is data
    if !annotedChallenges.isEmpty {
    barChart.xAxis.axisMinimum = annotedChallenges[0].0 - 43200
    barChart.xAxis.axisMaximum = (annotedChallenges.last?.0)! + 86400
      
    }
  }
  
  /// Handles data update and charts redrawinf when user
  /// select a different time range option
  /// - Parameter index: Int number of days user wants to display data
  private func handleBarChartRedraw(for index: Int) {
    guard let barValues = dataPoints else { return}
    // update data according to selected time range
    if index >= barValues.count {
      dataPoints = barValues.getLast(barValues.count)
    } else {
      dataPoints = barValues.getLast(index)
    }
    // redraw chart
    self.lineChart.notifyDataSetChanged()
    shouldDisplayBarChart(with: barValues)
    barChart.setNeedsDisplay()
  }
  
  /// Displays a message when there is no data to display
  private func handleNoData() {
    barChart.noDataText = LocalisationString.noDataText
  }
  
  // /////////////////////// //
  // MARK: - LINECHART SETUP //
  // /////////////////////// //
  
  /// handles data loading and display of the data in a linechart
  ///
  /// - Parameter dataToDraw: [MoodPlot] set of data user wants to display
  private func shouldDisplayLineGraph(with dataToDraw: [Mood]) {
    chartSettings(chart: lineChart)
    // Custom Y axis values
    lineChart.leftAxis.drawLabelsEnabled = false
    leftAxisIconSetup()
    
    // Insert Data in LineChart
    let lineChartEntry = handleDataConvert(data: dataToDraw)
    let line1 = shouldConfigLine(entry: lineChartEntry)
    let data = LineChartData()
    data.addDataSet(line1)
    // set data source
    lineChart.data = data
    // update visible range
    
  }
  
  /// Handles line chart display update when user select a different time Range
  private func handleLineChartRedraw(for index: Int) {
    guard let linePoints = dataSet else { return}
    self.lineChart.notifyDataSetChanged()
    shouldDisplayLineGraph(with: linePoints)
    lineChart.setNeedsDisplay()
  }
  
  /// allows the user to zoom on a defined time range on all the charts
  private func shouldZoom(onLast index: Int) {
    guard let linePoints = dataSet else { return}
    // Define max range of data to users max data amount if there is not enougth
    // data to be displayed
    if index >= linePoints.count {
      handleLineChartRedraw(for: linePoints.count)
      handleBarChartRedraw(for: linePoints.count)
    } else {
      dataSet = linePoints.getLast(index)
      handleLineChartRedraw(for: index)
      handleBarChartRedraw(for: index)
      
    }
  }
  
  /// Load Smiley Icons on left axis of LineChart
  ///
  /// - Parameters:
  ///   - ImageName: String
  ///   - multiplier: CGFloat y coordinates ratio
  private func loadImageLabels(imageName: String, multiplier: CGFloat) {
    let iconOffset: CGFloat = -20
    let imageLabel = UIImageView()
    imageLabel.image = UIImage(named: imageName)
    imageLabel.frame = CGRect(x: iconOffset, y: multiplier * (lineChart.frame.height / 14), width: 15, height: 15)
    lineChart.addSubview(imageLabel)
  }
  
  /// Display Y axis Icons for LineChart
  func leftAxisIconSetup() {
    // left labels images
    let icons: [(Icons, Offset)] = [(.superHappy, .step1),
                                    (.happy, .step2),
                                    (.neutral, .step3),
                                    (.sad, .step4),
                                    (.dead, .step5)]
    // place icons according to chart
    for icon in icons {
      loadImageLabels(imageName: icon.0.rawValue, multiplier: icon.1.rawValue)
    }
  }
  
  /// This function sends all needed parameters to setup a line Chart
  ///
  /// - Parameter entry: Data to be displayed
  /// - Returns: LineChartDataSet
  private func shouldConfigLine(entry: [ChartDataEntry] ) -> LineChartDataSet {
    // Line setup
    let line = LineChartDataSet(values: entry, label: LocalisationString.dataLabel)
    // Line color
    line.colors = [UIConfig.lightGreen]
    // remove circles on line
    line.drawCirclesEnabled = false
    // remove values above line
    line.drawValuesEnabled = false
    // Curvature option
    line.mode = .linear
    // Line weigth
    line.lineWidth = 3.0
    //Fill color under the linechart
    line.fill = Fill(CGColor: UIConfig.lightGreen.cgColor)
    line.drawFilledEnabled = true
    return line
  }
  
  /// Convert Raw Data in Charts friendly Data set
  ///
  /// - Parameter data: Raw Data
  /// - Returns: [ChartDataEntry] formatted data
  private func handleDataConvert(data: [Mood]) -> [ChartDataEntry] {
    var lineChartEntry = [ChartDataEntry]()
    // send data to chart
    for index in 0..<data.count {
      let value = ChartDataEntry(x: data[index].date, y: Double(data[index].state))
      lineChartEntry.append(value)
    }
    return lineChartEntry
  }
  
  // ///////////////////////////// //
  // MARK: - PROGRESS CIRCLE SETUP //
  // ///////////////////////////// //
  
  /// Draw the a circle and sets up all the display paraleters
  ///such as color, range, center
  /// - Parameters:
  ///   - center: CGPoint
  ///   - offset: CGFLoat
  ///   - color: CGColor
  /// - Returns: CAShapeLayer
  private func shouldDrawCircle(center: CGPoint, offset: CGFloat, color: CGColor) -> CAShapeLayer {
    let circle = CAShapeLayer()
    // circle path with a beginning a 12:00
    let circularPath = UIBezierPath(arcCenter: center,
                                    radius: (progressCircle.frame.width / 2) - offset,
                                    startAngle: (-1 / 2) * CGFloat.pi,
                                    endAngle: (3 / 2) * CGFloat.pi,
                                    clockwise: true)
    circle.path = circularPath.cgPath
    circle.strokeColor = color
    circle.lineWidth = 3.0
    circle.lineCap = kCALineCapRound
    circle.fillColor = UIColor.clear.cgColor
    return circle
  }
  
  /// Animate the fill Around the progress circle until a given number
  ///
  /// - Parameter progress: CGFloat target amount
  private func shouldAnimateCircleProgress(progress: Float) {
    
    // Common Center
    let center = CGPoint(x: progressCircle.frame.width / 2, y: progressCircle.frame.height / 2)
    // Reference circle
    let insideCircle = shouldDrawCircle(center: center, offset: 15, color: UIConfig.ultraDarkGreen.cgColor)
    progressCircle.layer.addSublayer(insideCircle)
    // progress circle
    let outsideCircle = self.shouldDrawCircle(center: center, offset: 8, color: UIConfig.lightGreen.cgColor)
    progressCircle.layer.addSublayer(outsideCircle)
    // initial state
    outsideCircle.strokeEnd = 0
    // update label
    let roundedProgress = Int(self.progress)
    self.progressLabel.text = "\(String(roundedProgress)) %"
    // Animation
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.toValue = progress / 100
    animation.duration = 2
    animation.fillMode = kCAFillModeForwards
    animation.isRemovedOnCompletion = false
    outsideCircle.add(animation, forKey: "anim")
  }
  
  // //////////////////////// //
  // MARK: - PDF EXPORT METHODS //
  // //////////////////////// //
  
  /// Selector for the share button in the navigation bar
  @objc func shareChallenge() {
    //send comment from text view to model
    // instantiate pdfCreator
    let pdfCreator = PDFCreator()
    var array = [Challenge]()
    
    DatabaseService.shared.challengeRef.observe(.value, with: { (snapshot) in
      var newItems = [Challenge]()
      for item in snapshot.children {
        let newChallenge = Challenge(snapshot: (item as? DataSnapshot)!)
        newItems.insert(newChallenge, at: 0)
      }
      for item in newItems where item.user == self.currentUser {
        array.insert(item, at: 0)
      }
    })
    array.sort(by: {$0.dueDate < $1.dueDate})
    let pages = pdfCreator.pdfLayout(for: array,
                                     mapView: nil,
                                     display: .multipleSummariesReport)
    // Instantiate the PDF previewer
    if let controller = pdfCreator.generatePDF(for: pages) {
      present(controller, animated: true, completion: nil)
      
    }
  }
}

