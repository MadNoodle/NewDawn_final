///**
/**
 NewDawn
 Created by: Mathieu Janneau on 24/03/2018
 Copyright (c) 2018 Mathieu Janneau
 */
// swiftlint:disable trailing_whitespace

import UIKit
import Charts

extension UIViewController {
  func chartSettings(chart: BarLineChartViewBase) {
    
    // general setup
    chart.chartDescription?.text = ""
    chart.drawGridBackgroundEnabled = false
    chart.legend.enabled = false
    
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
    chart.rightAxis.enabled = false
    chart.leftAxis.granularityEnabled = true
    
    // Custom Y axis values
    chart.leftAxis.drawLabelsEnabled = true
    
    // X Axis properties Label
    chart.xAxis.granularity = 100
    chart.xAxis.labelPosition = .bottom
    chart.xAxis.drawGridLinesEnabled = false
    chart.xAxis.centerAxisLabelsEnabled = false
    let XLabel = XAxisFormatter()
    chart.xAxis.valueFormatter = XLabel
    
    
    
    
    // Reveal animation
    chart.animate(xAxisDuration: 0.5)
    chart.setNeedsDisplay()
  }
}
