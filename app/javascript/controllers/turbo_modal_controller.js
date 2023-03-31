import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  connect() {
    console.log("turbo-modal#connected")
  };

  hideModal() {
    console.log("turbo-modal#hideModal")
    // this.element.parentElement.removeAttribute("src")
    this.element.remove()
  };

  submitEnd(e) {
    console.log("turbo-modal#submitEnd")
    // console.log("e.detail")
    // console.log(e.detail)
    // // debugger
    if (e.detail.success) {
      console.log("\n\ne.detail.success\ne.detail:")
      console.log(e.detail)
      console.log("\n\n")
      this.hideModal()
    } else {
      console.log("\n\n")
      console.warn("!(e.detail.success)\ne.detail:")
      console.warn(e.detail)
      console.log("\n\n")
    }
  };

  disconnect() {
    console.log("turbo-modal#disconnect")
  };

};
