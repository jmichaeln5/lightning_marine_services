import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="table"
export default class extends Controller {
  static values = {
    tableHeaderAmount: { type: Number, default: 0 },
    tableRowAmount: { type: Number, default: 0 },
    tableDataCellAmount: { type: Number, default: 0 },
  }

  static targets = [
    "rootElement",
    "tableHeader",
    "tableRow",
    "tableDataCell",
  ]

  static classes = [
    "tableHeader",
    "tableHeaderFirst",
    "tableHeaderLast",
    "cheveronActive",
    "cheveronInactive",
    "tableDataCell",
    "tableDataCellFirst",
    "tableDataCellLast",
  ]

  initialize() {
    console.clear()
  }

  connect() {
    // console.log('this.tableHeaderFirstClasses')
    // console.log(this.tableHeaderFirstClasses)
    //
    // console.log('this.tableHeaderClasses')
    // console.log(this.tableHeaderClasses)
    //
    // console.log('this.tableHeaderLastClasses')
    // console.log(this.tableHeaderLastClasses)
    //
    // console.log('this.tableDataCellFirstClasses')
    // console.log(this.tableDataCellFirstClasses)
    //
    // console.log('this.tableDataCellClasses')
    // console.log(this.tableDataCellClasses)
    //
    // console.log('this.tableDataCellLastClasses')
    // console.log(this.tableDataCellLastClasses)
  }

  rootElementTargetConnected(element) {
    // console.log('table#rootElementTargetConnected')
    // console.log(element)
  }

  tableHeaderTargetConnected(element) {
    // console.log('table#tableHeaderTargetConnected')
    // console.log(element)
    // this.tableHeaderAmountValue += 1
  }

  tableHeaderTargetDisconnected(element) {
    // console.log('table#tableHeaderTargetDisconnected')
    // console.log(element)
    // this.tableHeaderAmountValue -= 1
  }

  tableRowTargetConnected(element) {
    // console.log('table#tableRowTargetConnected')
    // console.log(element)
    // this.tableRowAmountValue += 1
  }

  tableRowTargetDisconnected(element) {
    // console.log('table#tableRowTargetDisconnected')
    // console.log(element)
    // this.tableRowAmountValue -= 1
  }

  tableDataCellTargetConnected(element) {
    // console.log('table#tableDataCellTargetConnected')
    // console.log(element)
    // this.tableDataCellTargetAmountValue += 1
  }

  tableDataCellTargetDisconnected(element) {
    // console.log('table#tableDataCellTargetDisconnected')
    // console.log(element)
    // this.tableDataCellTargetAmountValue -= 1
  }

}
