import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="counter"
export default class extends Controller {
  static targets = [ "counterElement", "element" ]

  static values = {
    amount: Number,
  };

  add({ params: { target } }) {
    let targetCounterElement = document.querySelector(`#${target}`)
    parseInt(targetCounterElement.innerHTML)
    targetCounterElement.innerHTML = parseInt(targetCounterElement.innerHTML) + 1
  }

  subtract({ params: { target } }) {
    let targetCounterElement = document.querySelector(`#${target}`)
    parseInt(targetCounterElement.innerHTML)
    let targetCounterElementCount = parseInt(targetCounterElement.innerHTML)
    if (0 <= targetCounterElementCount) {
      targetCounterElement.innerHTML = parseInt(targetCounterElement.innerHTML) - 1
    }
  }

}
