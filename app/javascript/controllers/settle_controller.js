import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["paidTo", "amount", "submit"]

  connect() {
    this.validate()
  }

  autofill() {
    const opt = this.paidToTarget.selectedOptions[0]
    if (!opt) return

    const max = parseFloat(opt.dataset.max || "0")

    this.amountTarget.value = max > 0 ? max.toFixed(2) : ""
    this.amountTarget.max = max > 0 ? max.toString() : ""
    this.amountTarget.min = "0"

    this.validate()
  }

  validate() {
    const opt = this.paidToTarget.selectedOptions[0]
    const max = opt?.dataset?.max ? parseFloat(opt.dataset.max) : 0

    const raw = this.amountTarget.value
    const val = raw === "" ? NaN : parseFloat(raw)

    const invalid =
      !opt?.value ||
      Number.isNaN(val) ||
      val < 0 ||
      (max > 0 && val > max) ||
      max <= 0

    this.submitTarget.disabled = invalid
    this.submitTarget.classList.toggle("is-disabled", invalid)
  }
}
