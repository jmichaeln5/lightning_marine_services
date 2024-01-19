import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="table"
export default class extends Controller {
  static values = {
    // url: String,
    // sortableUrl: String,
    thAmount: { type: Number, default: 0 },
    tdAmount: { type: Number, default: 0 },
  }

  static targets = [
    "rootElement",
    "th",
    "td"
  ]

  static classes = [
    "th",
    "thFirst",
    "thLast",
    "cheveronActive",
    "cheveronInactive",
    "td",
    "tdFirst",
    "tdLast",
  ]

  connect() {
    // console.log('table#connect')
    //
    // console.log('this.thClasses')
    // console.log(this.thClasses)
    //
    // console.log('this.thFirstClasses')
    // console.log(this.thFirstClasses)
    //
    // console.log('this.thLastClasses')
    // console.log(this.thLastClasses)
    //
    // console.log('this.cheveronActiveClasses')
    // console.log(this.cheveronActiveClasses)
    //
    // console.log('this.cheveronInactiveClasses')
    // console.log(this.cheveronInactiveClasses)
    //
    //
    // console.log('this.tdClasses')
    // console.log(this.tdClasses)
    //
    // console.log('this.tdFirstClasses')
    // console.log(this.tdFirstClasses)
    //
    // console.log('this.tdLastClasses')
    // console.log(this.tdLastClasses)
  }

  rootElementTargetConnected(element) {
    // console.log('table#rootElement')
    // console.log(element)
  }

  thTargetConnected(element) {
    // console.log('\n\ntable#th')
    // console.log(element)
    // console.log(`thTargetConnected\nthis.thTargets.length: ${this.thTargets.length}`);
    this.thAmountValue += 1
    console.log(`\n this.thAmountValue ${this.thAmountValue}`);
  }

  tdTargetConnected(element) {
    this.tdAmountValue += 1
    console.log(`\n this.tdAmountValue ${this.tdAmountValue}`);
  }
}
