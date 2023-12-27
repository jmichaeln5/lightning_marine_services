import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nested-form"
export default class extends Controller {
  static targets = ["addItem", "template"]

  connect() {
    console.log('nested-form connected')
  }

  add_association(event) {
    event.preventDefault()
    var content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD/g, new Date().valueOf())
    this.addItemTarget.insertAdjacentHTML('beforebegin', content)
    // this.addItemTarget.insertAdjacentHTML('afterend', content)
  }

  remove_association(event) {
    event.preventDefault()
    let item = event.target.closest(".nested-fields")

    item.querySelector("input[name*='_destroy']").value = 1
    item.style.display = 'none'
  }
}
