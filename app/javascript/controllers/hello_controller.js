// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-hello-target="output"></h1>
//   <button type="button" data-action="click->hello#testingStimmy" class="my-3 inline-flex items-center rounded-full border border-transparent bg-indigo-600 px-4 py-2 text-base font-sm text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">
//     testingStimmy
//   </button>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
    this.outputTarget.textContent = 'Hellooooo, test!'
  }

  testingStimmy(){
    console.log("hello#testingStimmy()")
  }
}
