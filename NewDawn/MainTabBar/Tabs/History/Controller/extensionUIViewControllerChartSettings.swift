///**
/**
 NewDawn
 Created by: Mathieu Janneau on 24/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import Charts

extension HistoryViewController {
  func chartSettings(chart: BarLineChartViewBase) {
    
    // general setup
    chart.chartDescription?.text = ""
    chart.drawGridBackgroundEnabled = false
    chart.legend.enabled = false
    chart.autoScaleMinMaxEnabled = false
    // User Interactions
    chart.dragEnabled = true
    chart.pinchZoomEnabled = false
    chart.scaleXEnabled = true
    
    // clamp Y scale to 1
    chart.scaleYEnabled = false
    chart.viewPortHandler.setMaximumScaleY(1)
    chart.setScaleEnabled(true)
    
    // Y Axis properties
    chart.leftAxis.granularity = 1
    chart.leftAxis.axisMinimum = 0
    chart.leftAxis.axisMaximum = 5
    chart.rightAxis.enabled = false
    chart.leftAxis.granularityEnabled = true
    
    // Custom Y axis values
    chart.leftAxis.drawLabelsEnabled = true
    
    // X Axis properties Label
    chart.xAxis.granularity = 86400
    chart.xAxis.labelPosition = .bottom
    chart.xAxis.drawGridLinesEnabled = false
    chart.xAxis.centerAxisLabelsEnabled = false
    let XLabel = XAxisFormatter()
    chart.xAxis.valueFormatter = XLabel
    
    // Reveal animation
    chart.animate(xAxisDuration: 0.5)
    chart.setNeedsDisplay()
    chart.notifyDataSetChanged()
  }
  
  
  // ////////////////////// //
  // MARK: - BARCHART SETUP //
  // ////////////////////// //
  
  
  /// Allows the user to display a set of data in a Bar chart with
  /// a time based X axis and a value Y axis
  /// - Parameter data: [Challenge]
  func shouldDisplayBarChart(with data: [Challenge]) {
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
      let value = BarChartDataEntry(x: annotedChallenges[index].0, y: annotedChallenges[index].1 )
      dataEntries.append(value)
    }
    
    // Bars setup
    let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
    chartDataSet.colors = [UIConfig.lightGreen]
    chartDataSet.drawValuesEnabled = false
    chartDataSet.barBorderColor = UIConfig.lightGreen
    chartDataSet.barBorderWidth = 10
    
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
  func handleBarChartRedraw(for index: Int) {
    guard let barValues = dataPoints else { return}
    // update data according to selected time range
    
    // redraw chart
    self.lineChart.notifyDataSetChanged()
    shouldDisplayBarChart(with: barValues)
    barChart.setNeedsLayout()
    barChart.setNeedsDisplay()
  }
  
  /// Displays a message when there is no data to display
  func handleNoData() {
    barChart.noDataText = NSLocalizedString("You need to provide data for the chart.", comment: "")
  }
  
  // /////////////////////// //
  // MARK: - LINECHART SETUP //
  // /////////////////////// //
  
  /// handles data loading and display of the data in a linechart
  ///
  /// - Parameter dataToDraw: [MoodPlot] set of data user wants to display
  func shouldDisplayLineGraph(with dataToDraw: [Mood]) {
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
  func handleLineChartRedraw(for index: Int) {
    guard let linePoints = dataSet else { return}
    
    self.lineChart.notifyDataSetChanged()
    shouldDisplayLineGraph(with: linePoints)
    lineChart.setNeedsLayout()
    lineChart.setNeedsDisplay()
  }
  
  /// allows the user to zoom on a defined time range on all the charts
  func shouldZoom(onLast index: Int) {
    // Define max range of data to users max data amount if there is not enougth
    // data to be displayed
    let center = Date().timeIntervalSince1970
    let offset = Double ((index) * 86400)
    lineChart.resetZoom()
    barChart.resetZoom()
    // set left edge
    self.lineChart.setVisibleXRange(minXRange: offset, maxXRange: offset)
    self.lineChart.moveViewToX(center )
    handleLineChartRedraw(for: index)
    self.barChart.setVisibleXRange(minXRange: offset, maxXRange: offset)
    handleBarChartRedraw(for: index)
    
  }
  
  /// Load Smiley Icons on left axis of LineChart
  ///
  /// - Parameters:
  ///   - ImageName: String
  ///   - multiplier: CGFloat y coordinates ratio
  func loadImageLabels(imageName: String, multiplier: CGFloat) {
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
  func shouldConfigLine(entry: [ChartDataEntry] ) -> LineChartDataSet {
    // Line setup
    let line = LineChartDataSet(values: entry, label: "number")
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
  func handleDataConvert(data: [Mood]) -> [ChartDataEntry] {
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
  func shouldDrawCircle(center: CGPoint, offset: CGFloat, color: CGColor) -> CAShapeLayer {
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
  func shouldAnimateCircleProgress(progress: Float) {
    
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
}
