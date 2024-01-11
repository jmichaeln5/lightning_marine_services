// NOTE- USE app/javascript/controllers/toggle_controller.js INSTEAD
// TODO: REMOVE THIS FILE

import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use";

export default class extends Controller {
  static values = {
    toggled: Boolean,
    closeOnOutsideClick: { type: Boolean, default: true }
  }
  static targets = [ "hideable" ]

  connect() {
    useClickOutside(this)
  };

  disconnect() {
    useClickOutside(this)
    this.hideTargets()
  };

  showTargets() {
    this.hideableTargets.forEach(el => {
      el.hidden = false
    })
    this.toggledValue = true
  };

  hideTargets() {
    this.hideableTargets.forEach(el => {
      el.hidden = true
    })
    this.toggledValue = false
  };

  toggleTargets() {
    this.toggledValue = !this.toggledValue

    this.hideableTargets.forEach((el) => {
      el.hidden = !el.hidden
    });
  };

  clickOutside(event) {
    if (this.data.get("clickOutside") === "add") {
      this.toggleableTargets.forEach((target) => {
        target.classList.add(target.dataset.cssClass);
      })
    } else if (this.data.get("clickOutside") === "remove") {
      this.toggleableTargets.forEach((target) => {
        target.classList.remove(target.dataset.cssClass);
      })
    }

    return (this.closeOnOutsideClickValue != true)  ? true : this.hideTargets();
  };

};
