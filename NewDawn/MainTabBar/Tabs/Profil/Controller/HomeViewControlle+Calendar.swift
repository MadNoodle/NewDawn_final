///**
/**
NewDawn
Created by: Mathieu Janneau on 26/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace

import Foundation
import UIKit
import JTAppleCalendar


extension HomeViewController: JTAppleCalendarViewDelegate,JTAppleCalendarViewDataSource {
  
  func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    configureCell(view: cell, cellState: cellState)
  }

  
  
  
  
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormat.annual.rawValue
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Calendar.current.locale
    
    let startDate = formatter.date(from: "2018 01 01")! // You can use date generated from a formatter
    let endDate = Calendar.current.date(byAdding: .year, value: 2, to: startDate)!// You can also use dates created from this function
    let parameters = ConfigurationParameters(startDate: startDate,
                                             endDate: endDate,
                                             numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
      calendar: Calendar.current,
      generateInDates: .forAllMonths,
      generateOutDates: .tillEndOfRow,
      firstDayOfWeek: .monday,
      hasStrictBoundaries: false)
    return parameters
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    setupViewsOfCalendar(from: visibleDates)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    configureCell(view: cell, cellState: cellState)
    guard let validCell = cell as? CalendarCell else { return}
    if !validCell.eventDotView.isHidden{
      print("challenge at this date")
      let dateToCheck = dateFormatter.string(from: cellState.date)

      for item in data {
        let dateForItem = dateFormatter.string(from: Date(timeIntervalSince1970: item.dueDate))
        if dateForItem == dateToCheck {
          print("search CoreData")
          selectedChallenge = item
           showChallenge()
        }
      }
    }
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    configureCell(view: cell, cellState: cellState)
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    calendarView.viewWillTransition(to: size, with: coordinator, anchorDate: iii)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
    let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "header", for: indexPath) as! headerView
    return header
  }
  func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
    return MonthSize(defaultSize: 50)
  }

  func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
    guard let startDate = visibleDates.monthDates.first?.date else {
      return
    }
    let month = Calendar.current.dateComponents([.month], from: startDate).month!
    let monthName = DateFormatter().monthSymbols[(month-1) % 12]
    // 0 indexed array
    let year = Calendar.current.component(.year, from: startDate)
    montDisplay.text = monthName + " " + String(year)
  }

  func handleCellEvent(for cell: CalendarCell, with state : CellState) {
    cell.eventDotView.isHidden = !events.contains {$0 == dateFormatter.string(for: state.date)}
    
  }
  
  func configureCell(view: JTAppleCell?, cellState: CellState) {
    guard let myCustomCell = view as? CalendarCell  else { return }
    handleCellTextColor(for: myCustomCell, with: cellState)
    handleCellSelected(for: myCustomCell, with: cellState)
    handleCellEvent(for: myCustomCell, with: cellState)
  }
  func handleCellTextColor(for cell: CalendarCell, with state : CellState) {
    
    if state.isSelected {
      cell.dateLabel.textColor = .white
    }
    else {
      if state.dateBelongsTo == .thisMonth {
        cell.dateLabel.textColor = .white
      } else {
        cell.dateLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.eventDotView.isHidden = true
        cell.isUserInteractionEnabled = false
      }
    }
  }
  func handleCellSelected(for cell: CalendarCell, with state : CellState) {
    
    if state.isSelected {
      cell.selectedView.isHidden = false
    } else {
      cell.selectedView.isHidden = true
    }
  }
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarCell
    
    cell.dateLabel.text = cellState.text
    configureCell(view: cell, cellState: cellState)
    
    return cell
  }
  
}

