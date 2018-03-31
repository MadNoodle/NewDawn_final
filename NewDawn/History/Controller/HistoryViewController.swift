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

class HistoryViewController: UIViewController, ChartViewDelegate {
  
  // ////////////////// //
  // MARK: - PROPERTIES //
  // ////////////////// //
  
  let dataSet = MoodPlot.getMockData()
  let dataPoints = MoodPlot.getMockData()
  let progressData = MoodPlot.getChallenges()
  
  // /////////////// //
  // MARK: - OUTLETS //
  // /////////////// //
  
  @IBOutlet weak var lineChart: LineChartView!
  @IBOutlet weak var barChart: BarChartView!
  @IBOutlet weak var progressCircle: UIView!
  @IBOutlet weak var progressLabel: UILabel!
  
  // ///////////////////////// //
  // MARK: - LIFECYCLE METHODS //
  // ///////////////////////// //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    lineChart.delegate = self
    barChart.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    updateLineGraph()
    setupBarChart()
    animateCircleProgress(progress: progressData.2)
  }
  
  // ////////////////////// //
  // MARK: - BARCHART SETUP //
  // ////////////////////// //
  
  fileprivate func setupBarChart() {
    
    var dataEntries: [BarChartDataEntry] = []
    
    // Populate data in BarChart matrix
    for i in 0..<dataPoints.count {
      let value = BarChartDataEntry(x: dataSet[i].date, y: dataSet[i].value)
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
  
  
  func setChart(dataPoints: [String], values: [Double]) {
    barChart.noDataText = LocalisationString.noDataText
  }
  
  // /////////////////////// //
  // MARK: - LINECHART SETUP //
  // /////////////////////// //
  
  func updateLineGraph() {
    chartSettings(chart: lineChart)
    // Custom Y axis values
    lineChart.leftAxis.drawLabelsEnabled = false
    LeftAxisIconSetup()
    
    // Insert Data in LineChart
    let lineChartEntry = populateData()
    let line1 = setupLine(entry: lineChartEntry)
    let data = LineChartData()
    data.addDataSet(line1)
    lineChart.data = data
  }
  
  func setupImageLabels(ImageName:String, multiplier: CGFloat){
    let iconOffset: CGFloat = -20
    let imageLabel = UIImageView()
    imageLabel.image = UIImage(named: ImageName)
    imageLabel.frame = CGRect(x: iconOffset, y:   multiplier * (lineChart.frame.height / 14), width: 15, height: 15)
    lineChart.addSubview(imageLabel)
  }
  
  func LeftAxisIconSetup() {
    // left labels images
    let icons:[(Icons,Offset)] = [(.superHappy,.step1),(.happy,.step2),(.neutral,.step3),(.sad,.step4),(.dead,.step5)]
    // place icons according to chart
    for icon in icons {
      setupImageLabels(ImageName: icon.0.rawValue, multiplier: icon.1.rawValue)
    }
  }
  
  
  func setupLine(entry: [ChartDataEntry] ) -> LineChartDataSet {
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
  
  func populateData() -> [ChartDataEntry] {
    var lineChartEntry = [ChartDataEntry]()
    // send data to chart
    for i in 0..<dataSet.count {
      let value = ChartDataEntry(x: dataSet[i].date, y: dataSet[i].value)
      lineChartEntry.append(value)
    }
    return lineChartEntry
  }
  
  // ///////////////////////////// //
  // MARK: - PROGRESS CIRCLE SETUP //
  // ///////////////////////////// //
  
  func setupCircle(center: CGPoint, offset: CGFloat, color: CGColor) -> CAShapeLayer {
    let circle = CAShapeLayer()
    // circle path with a beginning a 12:00
    let circularPath = UIBezierPath(arcCenter: center, radius: (progressCircle.frame.width / 2) - offset, startAngle: (-1 / 2) * CGFloat.pi, endAngle: (3 / 2) * CGFloat.pi, clockwise: true)
    circle.path = circularPath.cgPath
    circle.strokeColor = color
    circle.lineWidth = 3.0
    circle.lineCap = kCALineCapRound
    circle.fillColor = UIColor.clear.cgColor
    return circle
  }
  
  func animateCircleProgress(progress: Float) {
    // Common Center
    let center = CGPoint(x: progressCircle.frame.width / 2, y: progressCircle.frame.height / 2)
    // Reference circle
    let insideCircle = setupCircle(center: center, offset: 15, color: UIConfig.ultraDarkGreen.cgColor)
    progressCircle.layer.addSublayer(insideCircle)
    
    // progress circle
    let outsideCircle = self.setupCircle(center: center, offset: 8, color: UIConfig.lightGreen.cgColor)
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
  
  
}
