import { Controller } from "@hotwired/stimulus";

// Sorting children
// https://github.com/hotwired/turbo/issues/109

export default class extends Controller {
  static targets = ["query", "errorMessage", "result"]
  static values = {
    url: String,
    query: String,
  }

  connect() {
    console.log('search bar connected');
  }

  urlValueChanged(value, previousValue) {
    // can change what url form action submits request to here
  }

  update(event) {
    this.queryValue = event.target.value
    event.target.dataset.searchQueryValue = this.queryValue
    // can submit form here vs parent form element
  }
}
