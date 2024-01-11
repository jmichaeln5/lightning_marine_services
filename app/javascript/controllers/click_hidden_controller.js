import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="click-hidden"
export default class extends Controller {
  static targets = [ "clickable" ]

  clickElement(){
    this.clickableTargets.forEach((el) => {
      el.click()
    });
  }
}
