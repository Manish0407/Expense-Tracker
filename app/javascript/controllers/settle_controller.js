import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["paidTo", "amount"]

  autofill() {
    const opt = this.paidToTarget.selectedOptions[0]
    if (!opt) return

    const max = parseFloat(opt.dataset.max || "0")

    this.amountTarget.value = max > 0 ? max.toFixed(2) : ""

    this.amountTarget.max = max > 0 ? max.toString() : ""
    this.amountTarget.min = "0"
  }
}
