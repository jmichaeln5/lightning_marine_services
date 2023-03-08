import { Controller } from "stimulus"
import CheckboxSelectAll from "stimulus-checkbox-select-all"
import { FetchRequest, put, get, post, patch, destroy } from "@rails/request.js"

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



    let data = new FormData()
    if (this.checked.length == this.checkboxTargets.length) {
      data.append("all", true)
    } else {
      this.checked.forEach((checkbox) => data.append("ids[]", checkbox.value))
    }
    // this.checked.forEach((checkbox) => console.log( checkbox.value) ) // IDS match
    for (let pair of data.entries()) {
      console.log(`${pair[0]}, ${pair[1]}`);
    }
    // Rails.ajax({
    //   // url: "/posts/bulk",
    //   // url: "/orders/bulk",
    //   url: "/orders/bulk",
    //   // url: "/orders",
    //   type: "DELETE",
    //   data: data
    // })

    let token = document.querySelector('meta[name="csrf-token"]').content
    fetch("/orders/bulk", {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": token,
      },
      body: data,
    })
    .then((response) => {
      if (response.redirected) {
      window.location.href = response.url
    }
    })
  };

};
