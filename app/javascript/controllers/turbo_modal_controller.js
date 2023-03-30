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
      this.hideModal()
    }
  };

  disconnect() {
    console.log("turbo-modal#disconnect")
  };

};
