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

extension HomeViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
  func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    let myCustomCell = cell as? CalendarCell
    
    // Setup Cell text
    myCustomCell?.dateLabel.text = cellState.text
    
    // Setup text color
    if cellState.dateBelongsTo == .thisMonth {
      myCustomCell?.dateLabel.textColor = UIColor.black
    } else {
      myCustomCell?.dateLabel.textColor = UIColor.gray
    }
  }
  
  func handleCellTextColor(for cell: CalendarCell, with state: CellState) {
    
    if state.isSelected {
      cell.dateLabel.textColor = .white
    } else {
      if state.dateBelongsTo == .thisMonth {
        cell.dateLabel.textColor = .white
      } else {
        cell.dateLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      }
    }
  }
  func handleCellSelected(for cell: CalendarCell, with state: CellState) {
    
    if state.isSelected {
      cell.selectedView.isHidden = false
    } else {
      cell.selectedView.isHidden = true
    }
  }
  
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as? CalendarCell
    cell?.dateLabel.text = cellState.text
    handleCellTextColor(for: cell!, with: cellState)
    handleCellSelected(for: cell!, with: cellState)
    return cell!
  }
  
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy MM dd"
    
    let startDate = formatter.date(from: "2018 01 01")!
    let endDate = Calendar.current.date(byAdding: .year, value: 2, to: startDate)!
    let parameters = ConfigurationParameters(startDate: startDate,
                                             endDate: endDate,
                                             numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
      calendar: Calendar.current,
      generateInDates: .forAllMonths,
      generateOutDates: .tillEndOfRow,
      firstDayOfWeek: .sunday,
      hasStrictBoundaries: false)
    return parameters
  }
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    guard let validCell = cell as? CalendarCell else {return}
    handleCellSelected(for: validCell, with: cellState)
  }
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    guard let validCell = cell as? CalendarCell else {return}
    handleCellSelected(for: validCell, with: cellState)
  }
  
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    let date = visibleDates.monthDates.first!.date
    dateFormatter.dateFormat = "MMMM yyyy"
    montDisplay.text = dateFormatter.string(from: date)
  }
}
