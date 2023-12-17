import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="number-field-input"
export default class extends Controller {
  rejectLetters(){
    let alphabet = 'abcdefghijklmnopqrstuvwxyz'
    let addedCharacter = event.data

    let isLetterInInputValue = (
      alphabet.split('').includes(addedCharacter) || alphabet.toUpperCase().split('').includes(addedCharacter)
    )

    if (isLetterInInputValue) {
      this.element.value = this.element.value.replace(addedCharacter, "")
    }
  }
}
