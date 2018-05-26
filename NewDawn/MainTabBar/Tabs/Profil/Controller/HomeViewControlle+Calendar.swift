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
import Firebase
import FirebaseDatabase

extension HomeViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
  
  
  /// Configure Calendar Appearance
  func setupCalendarView() {
    // register cell
    let nib = UINib(nibName: "CalendarCell", bundle: nil)
    let headerNib = UINib(nibName: "headerView", bundle: nil)
    calendarView.register(nib, forCellWithReuseIdentifier: UIConfig.calendarCellId)
    calendarView.register(headerNib, forSupplementaryViewOfKind: UIConfig.calendarHeaderId, withReuseIdentifier: UIConfig.calendarHeaderId)
    // UI appearance settings
    calendarView.minimumLineSpacing = 0
    calendarView.minimumInteritemSpacing = 0
    calendarView.backgroundColor = .clear
    // delegation attribution
    calendarView.ibCalendarDelegate = self
    calendarView.ibCalendarDataSource = self
    calendarView.isScrollEnabled = false
    calendarView.scrollToDate(Date(), animateScroll: false)
    calendarView.selectDates([Date()])
    self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
      self.setupViewsOfCalendar(from: visibleDates)
    }
  }
  
  /// Handle intermeddiate states of cells
  func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    configureCell(view: cell, cellState: cellState)
  }
  
  /// Global settings for calendar
  func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
    
    // format date
    let formatter = DateFormatter()
    formatter.dateFormat = DateFormat.annual.rawValue
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Calendar.current.locale
    
    // Calendar bounds date
    let startDate = formatter.date(from: UIConfig.calendarStartDate)!
    let endDate = Calendar.current.date(byAdding: .year, value: 2, to: startDate)!
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
  
  /// Handle Scrolling behavior
  func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
    setupViewsOfCalendar(from: visibleDates)
  }
  
    /// Handle Selection of a date cell
  func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    configureCell(view: cell, cellState: cellState)
    // Initialize cell
    guard let validCell = cell as? CalendarCell else { return}
    // if there is an event do something
    if !validCell.eventDotView.isHidden {
      let dateToCheck = dateFormatter.string(from: cellState.date)
      // Grab challenges
      DispatchQueue.main.async {
        DatabaseService.shared.challengeRef.observe(.value) { (snap) in
        for item in snap.children {
          let challenge = Challenge(snapshot: (item as? DataSnapshot)!)
          // set the current challenge according to the seleccted date
          if let eventDate = challenge.dueDate {
            if self.dateFormatter.string(from: Date(timeIntervalSince1970: eventDate)) == dateToCheck {
            self.selectedChallenge = challenge

          }}
        }
      }}
    }
  }

  /// Handle DeSelection of a date cell
  func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
    configureCell(view: cell, cellState: cellState)
  }
  
  /// Handle scrol transition
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    calendarView.viewWillTransition(to: size, with: coordinator, anchorDate: iii)
  }
  
  /// Determines Calendar header cell
  func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
    // Custom header cell
    let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "header", for: indexPath) as? HeaderView
    return header!
  }
  
  /// Calendar Header cell Height
  func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
    return MonthSize(defaultSize: 50)
  }
  
  /// Header formatting
  func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
    // load visible dates
    guard let startDate = visibleDates.monthDates.first?.date else {
      return
    }
    // format month header
    let month = Calendar.current.dateComponents([.month], from: startDate).month!
    let monthName = DateFormatter().monthSymbols[(month-1) % 12]
    let year = Calendar.current.component(.year, from: startDate)
    // format string to display
    montDisplay.text = monthName + " " + String(year)
  }
  
  /// Shows a dot if the cell/ date contains an event
  func handleCellEvent(for cell: CalendarCell, with state: CellState) {
    dateFormatter.dateFormat = DateFormat.annual.rawValue
    // check if there is an event
    cell.eventDotView.isHidden = !events.contains {$0 == dateFormatter.string(for: state.date)}
  }
  
  /// Configure cell display (text/selecction and event)
  func configureCell(view: JTAppleCell?, cellState: CellState) {
    guard let myCustomCell = view as? CalendarCell  else { return }
    handleCellTextColor(for: myCustomCell, with: cellState)
    handleCellSelected(for: myCustomCell, with: cellState)
    handleCellEvent(for: myCustomCell, with: cellState)
  }
  
  /// Handles the the behavior that greys out the non current month date
  func handleCellTextColor(for cell: CalendarCell, with state: CellState) {
    // set text color to white for current Month and currently selected date
    if state.isSelected {
      cell.dateLabel.textColor = .white
    } else {
      if state.dateBelongsTo == .thisMonth {
        cell.dateLabel.textColor = .white
      } else {
        // other monthes are greyed
        cell.dateLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.eventDotView.isHidden = true
        cell.isUserInteractionEnabled = false
      }
    }
  }
  
  /// Handles selection behavior
  func handleCellSelected(for cell: CalendarCell, with state: CellState) {
    if state.isSelected {
      cell.selectedView.isHidden = false
      // if there is an event show detail challenge view
      if !cell.eventDotView.isHidden {
        showChallenge()
      }
    } else {
      cell.selectedView.isHidden = true
    }
  }
  
  /// CollectionView cellForItemAt Method
  func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
    let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as? CalendarCell
    cell?.dateLabel.text = cellState.text
    configureCell(view: cell!, cellState: cellState)
    return cell!  }
  
}
