import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use";

export default class extends Controller {
  static values = {
    toggled: Boolean,
    closeOnOutsideClick: { type: Boolean, default: true }
  }
  static targets = [ "hideable" ]

  connect() {
    // console.log("visibility#connect()")
    useClickOutside(this)
  };

  disconnect() {
    // console.log("visibility#disconnect()")
    // this.hideTargets()
    useClickOutside(this)
    this.hideTargets()
  };

  showTargets() {
    // console.log("visibility#showTargets()")
    this.hideableTargets.forEach(el => {
      el.hidden = false
    })
    this.toggledValue = true
  };

  hideTargets() {
    // console.log("visibility#hideTargets()")
    this.hideableTargets.forEach(el => {
      el.hidden = true
    })
    this.toggledValue = false
  };

  toggleTargets() {
    // console.log("visibility#toggleTargets()")
    this.toggledValue = !this.toggledValue

    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  };

  // toggledValueChanged(value, previousValue) {
  //   if (previousValue != undefined) {
  //     console.log("visibility#toggleTargets()")
  //     // console.warn("visibility#toggleTargets()")
  //     console.log("previousValue:")
  //     console.log(previousValue)
  //     console.log("\n")
  //
  //     console.log("value:")
  //     console.log(value)
  //     console.log("\n")
  //   }
  // };

  clickOutside(event) {
    // console.log("visibility#clickOutside()")
    if (this.data.get("clickOutside") === "add") {
      this.toggleableTargets.forEach((target) => {
        target.classList.add(target.dataset.cssClass);
      })
    } else if (this.data.get("clickOutside") === "remove") {
      this.toggleableTargets.forEach((target) => {
        target.classList.remove(target.dataset.cssClass);
      })
    }

    if (this.closeOnOutsideClickValue != true) {
      return
    }

    if (this.toggledValue === true) {
      this.hideTargets()
    }
  };

};
