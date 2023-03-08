import { Controller } from "stimulus"
import CheckboxSelectAll from "stimulus-checkbox-select-all"

export default class extends CheckboxSelectAll {
  connect() {
    console.log("orders_bulk#connect()")
    super.connect()
  }

  destroy(event) {
    console.log("orders_bulk#destroy()")
    console.log("this.checked:")
    console.log(this.checked)
    console.log("\n")

    event.preventDefault()

    // let data = new FormData()
    // if (this.checked.length == this.checkboxTargets.length) {
    //   data.append("all", true)
    // } else {
    //   this.checked.forEach((checkbox) => data.append("ids[]", checkbox.value))
    // }
    //
    // Rails.ajax({
    //   // url: "/posts/bulk",
    //   // url: "/orders/bulk",
    //   url: "/orders/bulk",
    //   // url: "/orders",
    //   type: "DELETE",
    //   data: data
    // })
  }

}
