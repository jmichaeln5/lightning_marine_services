import { Controller } from "@hotwired/stimulus"

// import { useClickOutside } from "stimulus-use";
// yarn add stimulus-use
// to close showing elements when clicked outside controller

export default class extends Controller {
  static values = { toggled: Boolean }
  static targets = [ "hideable" ]

  connect() {
    console.log("visibility#connect()")
  };

  showTargets() {
    console.log("visibility#showTargets()")
    this.hideableTargets.forEach(el => {
      el.hidden = false
    });
  };

  hideTargets() {
    console.log("visibility#hideTargets()")
    this.hideableTargets.forEach(el => {
      el.hidden = true
    });
  };

  toggleTargets() {
    console.log("visibility#toggleTargets()")
    this.toggledValue = !this.toggledValue

    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  };

  toggledValueChanged(value, previousValue) {
    // console.log("toggledValueChanged()")
    if (previousValue != undefined) {
      console.log("\n")
      console.log("toggledValueChanged()")
      // console.warn("toggledValueChanged()")
      console.log("previousValue:")
      console.log(previousValue)
      console.log("\n")

      console.log("value:")
      console.log(value)
      console.log("\n")
    }
  };
}
