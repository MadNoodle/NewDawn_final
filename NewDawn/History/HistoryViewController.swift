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
    self.title = "History"
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
    chartDataSet.colors = [ColorTemplate.lightGreen]
    chartDataSet.drawValuesEnabled = false
    chartDataSet.barBorderColor = ColorTemplate.lightGreen
    chartDataSet.barBorderWidth = 5
    
    // injectData in chart
    let chartData = BarChartData( dataSet: chartDataSet)
    barChart.data = chartData
    
    chartSettings(chart: barChart)
    
  }
  
  
  func setChart(dataPoints: [String], values: [Double]) {
    barChart.noDataText = "You need to provide data for the chart."
  }
  
  // /////////////////////// //
  // MARK: - LINECHART SETUP //
  // /////////////////////// //
  
  func updateLineGraph() {
    chartSettings(chart: lineChart)
    // Custom Y axis values
    lineChart.leftAxis.drawLabelsEnabled = false
    LeftAxisIconSetup()
    
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
    let icons:[(String,CGFloat)] = [("happy-1",1),("happy",3.25),("surprised",5.5),("sad-1",7.75),("dead",10.0)]
    // place icons according to chart
    for icon in icons {
      setupImageLabels(ImageName: icon.0, multiplier: icon.1)
    }
  }
  
  
  func setupLine(entry: [ChartDataEntry] ) -> LineChartDataSet {
    // Line setup
    let line = LineChartDataSet(values: entry, label: "number")
    // Line color
    line.colors = [ColorTemplate.lightGreen]
    // remove circles on line
    line.drawCirclesEnabled = false
    // remove values above line
    line.drawValuesEnabled = false
    // Curvature option
    line.mode = .linear
    // Line weigth
    line.lineWidth = 3.0
    //Fill color under the linechart
    line.fill = Fill(CGColor: ColorTemplate.lightGreen.cgColor)
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
    let insideCircle = setupCircle(center: center, offset: 15, color: ColorTemplate.ultraDarkGreen.cgColor)
    progressCircle.layer.addSublayer(insideCircle)
    
    // progress circle
    let outsideCircle = self.setupCircle(center: center, offset: 8, color: ColorTemplate.lightGreen.cgColor)
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
