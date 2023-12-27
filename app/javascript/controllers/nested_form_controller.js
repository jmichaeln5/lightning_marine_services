import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nested-form"
export default class extends Controller {
  static values = {
    connectedTimeStamp: { type: Number, default: 0 },
  }

  static targets = ["addItem", "position", "template", "nestedField", "removeNestedFieldBtn", "descriptionField"]

  connect() {
    this.connectedTimeStampValue = this.timeStamp()
  }

  timeStamp(){
    return (new Date().getTime())
  }

  descriptionFieldTargetConnected(element) {
    if ((element.value == null || element.value == '')) {
      element.value = this.descriptionFieldTargets.length
    }
  }

  nestedFieldTargetConnected(element) {
    element.classList.add(`nestedField_${this.connectedTimeStampValue}`)
  }

  removeNestedFieldBtnTargetConnected(element) {
    element.classList.add(`removeNestedFieldBtn_${this.connectedTimeStampValue}`)
  }

  add_association(event) {
    event.preventDefault()

    this.connectedTimeStampValue = this.timeStamp()

    var content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD/g, this.timeStamp())
    this.addItemTarget.insertAdjacentHTML('afterend', content)
  }

  remove_association(event) {
    event.preventDefault()

    let nestedFieldToRemoveName
    for (var i = 0; i < event.target.classList.length; i++) {
      nestedFieldToRemoveName = event.target.classList[i]
      if (event.target.classList[i].includes('removeNestedFieldBtn')) {
        nestedFieldToRemoveName = event.target.classList[i].replace('removeNestedFieldBtn_', 'nestedField_')
      }
    }

    let item = this.element.querySelectorAll(`.${nestedFieldToRemoveName}`)[0]

    item.querySelector("input[name*='_destroy']").value = 1
    item.style.display = 'none'
  }

}
