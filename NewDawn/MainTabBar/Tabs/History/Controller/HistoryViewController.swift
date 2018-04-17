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

/// Time range that user can select to display challenges
enum HistoryRange: Int {
  case week = 7
  case month = 31
  case trimester = 100
  case year = 365
}

/** Handle the User's Challenges Data visualization in different charts
 Rely on Charts Pods https://github.com/danielgindi/Charts. Documentation
 can be found https://github.com/PhilJay/MPAndroidChart/wiki
 **/
class HistoryViewController: UIViewController, ChartViewDelegate {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  // Get data
  private var dataSet = MoodPlot.getMockData()
  private var dataPoints = MoodPlot.getMockData()
  private let progressData = MoodPlot.getChallenges()
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var lineChart: LineChartView!
  @IBOutlet weak var barChart: BarChartView!
  @IBOutlet weak var progressCircle: UIView!
  @IBOutlet weak var progressLabel: UILabel!
  @IBOutlet var buttons: [CustomUIButtonForUIToolbar]!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupButtons()
    
    // Set up delegation
    lineChart.delegate = self
    barChart.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    shouldDisplayLineGraph(with: dataSet)
    shouldDisplayBarChart(with: dataPoints)
    shouldAnimateCircleProgress(progress: progressData.2)
  }
  
  // /////////////// //
  // MARK: - ACTIONS //
  // /////////////// //
  
  /// Displays the former week data visualization
  @IBAction func viewLastWeek(_ sender: CustomUIButtonForUIToolbar) {
    evaluateState()
    sender.userDidSelect()
    shouldZoom(onLast: HistoryRange.week.rawValue)
  }
  
  /// Displays the former month data visualization
  @IBAction func viewLastMonth(_ sender: CustomUIButtonForUIToolbar) {
    evaluateState()
    sender.userDidSelect()
    shouldZoom(onLast: HistoryRange.month.rawValue)
  }
  
  /// Displays the former trimester data visualization
  @IBAction func viewLastTrimester(_ sender: CustomUIButtonForUIToolbar) {
    evaluateState()
    sender.userDidSelect()
    shouldZoom(onLast: HistoryRange.trimester.rawValue)
  }
  
  /// Displays all time data visualization
  @IBAction func viewAllTime(_ sender: CustomUIButtonForUIToolbar) {
    evaluateState()
    sender.userDidSelect()
    shouldZoom(onLast: HistoryRange.year.rawValue)
  }
  
  // ////////////////// //
  // MARK: - UI METHODS //
  // ////////////////// //
  
  /// Handles buttons behavior and color scheme
  private func setupButtons() {
    for button in buttons {
      button.typeOfButton = .textButton
      button.layer.borderColor = UIColor(white: 0.5, alpha: 1).cgColor
      button.layer.borderWidth = 1
      button.layer.cornerRadius = 5
      button.layer.masksToBounds = true
    }
    
    // initially select week display
    buttons[0].choosen = true
    buttons[0].layer.borderColor = UIConfig.darkGreen.cgColor
    buttons[0].backgroundColor = UIConfig.darkGreen
    buttons[0].setTitleColor(.white, for: .normal)
    
    // add share button to navigation
    let rightButton: UIBarButtonItem =
      UIBarButtonItem(image: #imageLiteral(resourceName: "upload"), style: .plain, target: self, action: #selector(shareChallenge))
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  /// Reset all buttons to initial color scheme
  private func evaluateState() {
    for button in buttons where button.choosen {
      button.reset()
    }
  }
  
  // ////////////////////// //
  // MARK: - BARCHART SETUP //
  // ////////////////////// //
  
  /// Allows the user to display a set of data in a Bar chart with
  /// a time based X axis and a value Y axis
  /// - Parameter data: [MoodPlot]
  private func shouldDisplayBarChart(with data: [MoodPlot]) {
    
    if data.isEmpty { handleNoData()}
    var dataEntries: [BarChartDataEntry] = []
    
    // Populate data in BarChart matrix
    for index in 0..<data.count {
      let value = BarChartDataEntry(x: dataSet[index].date, y: dataSet[index].value)
      dataEntries.append(value)
    }
    
    // Bars setup
    let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
    chartDataSet.colors = [UIConfig.lightGreen]
    chartDataSet.drawValuesEnabled = false
    chartDataSet.barBorderColor = UIConfig.lightGreen
    chartDataSet.barBorderWidth = 5
    
    // injectData in chart
    let chartData = BarChartData( dataSet: chartDataSet)
    barChart.data = chartData
    chartSettings(chart: barChart)
  }
  
  /// Handles data update and charts redrawinf when user
  /// select a different time range option
  /// - Parameter index: Int number of days user wants to display data
  private func handleBarChartRedraw(for index: Int) {
    // reset data
    dataPoints = MoodPlot.getMockData()
    // update data according to selected time range
    dataPoints = dataSet.getLast(index)
    // redraw chart
    self.lineChart.notifyDataSetChanged()
    shouldDisplayBarChart(with: dataPoints)
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
  private func shouldDisplayLineGraph(with dataToDraw: [MoodPlot]) {
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
    self.lineChart.notifyDataSetChanged()
    shouldDisplayLineGraph(with: dataSet)
    lineChart.setNeedsDisplay()
  }
  
  /// allows the user to zoom on a defined time range on all the charts
  private func shouldZoom(onLast index: Int) {
    dataSet = MoodPlot.getMockData()
    // Define max range of data to users max data amount if there is not enougth
    // data to be displayed
    if index >= dataSet.count {
      handleLineChartRedraw(for: dataSet.count)
      handleBarChartRedraw(for: dataSet.count)
    } else {
      
      dataSet = dataSet.getLast(index)
      handleLineChartRedraw(for: index)
      handleBarChartRedraw(for: index)}
    
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
  private func leftAxisIconSetup() {
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
    line.mode = .cubicBezier
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
  private func handleDataConvert(data: [MoodPlot]) -> [ChartDataEntry] {
    var lineChartEntry = [ChartDataEntry]()
    // send data to chart
    for index in 0..<data.count {
      let value = ChartDataEntry(x: data[index].date, y: data[index].value)
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
    progressLabel.text = "\(Int(progressData.2)) %"
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
    
    let pages = pdfCreator.pdfLayout(for: CoreDataService.loadData(filter: nil),
                                     mapView: nil,
                                     display: .multipleSummariesReport)
    // Instantiate the PDF previewer
    if let controller = pdfCreator.generatePDF(for: pages) {
      present(controller, animated: true, completion: nil)
      
    }
  }
}
