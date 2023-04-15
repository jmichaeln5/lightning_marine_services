import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  static targets = ["modal"]

  connect() {
    console.log("turbo-modal#connected")
  };

  // hideModal() {
  //   console.log("turbo-modal#hideModal")
  //   // this.element.parentElement.removeAttribute("src")
  //   this.element.remove()
  // };

  hideModal() {
    console.log("turbo-modal#hideModal")
    this.element.parentElement.removeAttribute("src")
    this.element.remove()
  };

  submitEnd(e) {
    console.log("turbo-modal#submitEnd")
    if (e.detail.success) {
      console.log("e.detail.success\ne.detail:")
      console.log(e.detail)
      this.hideModal()
    } else {
      console.warn("!(e.detail.success)\ne.detail:")
      console.warn(e.detail)
    }
  };

  // hide modal when clicking ESC
  // action: "keyup@window->turbo-modal#closeWithKeyboard"
  closeWithKeyboard(e) {
    if (e.code == "Escape") {
      this.hideModal()
    }
  };

  // hide modal when clicking outside of modal
  // action: "click@window->turbo-modal#closeBackground"
  closeBackground(e) {
    if (e && this.modalTarget.contains(e.target)) {
      return
    }
    this.hideModal()
  };


  disconnect() {
    console.log("turbo-modal#disconnect")
  };

};
