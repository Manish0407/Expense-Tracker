import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["participants", "items"]

  connect() {
    this.participantIndex = 0
    this.itemIndex = 0
  }

  addParticipant() {
    const tpl = document.getElementById("participant-template").innerHTML
    const html = tpl.replaceAll("NEW_INDEX", this.participantIndex++)
    this.participantsTarget.insertAdjacentHTML("beforeend", html)
  }

  addItem() {
    const tpl = document.getElementById("item-template").innerHTML
    const html = tpl.replaceAll("NEW_INDEX", this.itemIndex++)
    this.itemsTarget.insertAdjacentHTML("beforeend", html)

    const lastItem = this.itemsTarget.querySelector(".item:last-child")
    const splitSelect = lastItem.querySelector('select[name*="[split_type]"]')
    this.applyAssignmentsVisibility(lastItem, splitSelect.value)
  }

  toggleAssignments(event) {
    const itemEl = event.target.closest(".item")
    this.applyAssignmentsVisibility(itemEl, event.target.value)
  }

  applyAssignmentsVisibility(itemEl, splitType) {
    const assignmentUI = itemEl.querySelector(".assignment-ui")
    const assignmentsEl = itemEl.querySelector(".assignments")
    const addBtn = itemEl.querySelector(".assignment-ui .btn")

    if (!assignmentUI || !assignmentsEl || !addBtn) return

    if (splitType === "shared") {
      // shared => disable button + hide area + clear assignments
      addBtn.disabled = true
      addBtn.classList.add("is-disabled")

      assignmentUI.style.display = "none"
      assignmentsEl.innerHTML = ""
    } else {
      // assigned => enable button + show area
      addBtn.disabled = false
      addBtn.classList.remove("is-disabled")

      assignmentUI.style.display = "block"
    }
  }

  addAssignment(event) {
    const itemEl = event.target.closest(".item")
    const assignmentsEl = itemEl.querySelector(".assignments")

    const anyField = itemEl.querySelector("input, select")
    const match = anyField.name.match(/expense_items_attributes\]\[(\d+)\]/)
    const itemIndex = match ? match[1] : null
    const splitSelect = itemEl.querySelector('select[name*="[split_type]"]')
    if (splitSelect && splitSelect.value === "shared") return

    const tpl = document.getElementById("assignment-template").innerHTML
    const newIndex = Date.now()
    const html = tpl
      .replaceAll("ITEM_INDEX", itemIndex)
      .replaceAll("NEW_INDEX", newIndex)

    assignmentsEl.insertAdjacentHTML("beforeend", html)
  }

  remove(event) {
    event.target.closest(".participant, .item, .assignment").remove()
  }
}
