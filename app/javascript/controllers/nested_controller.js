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
  }

  addAssignment(event) {
    // find the item container
    const itemEl = event.target.closest(".item")
    const assignmentsEl = itemEl.querySelector(".assignments")

    // get item index from first input/select name
    const anyField = itemEl.querySelector("input, select")
    const match = anyField.name.match(/expense_items_attributes\]\[(\d+)\]/)
    const itemIndex = match ? match[1] : null

    const tpl = document.getElementById("assignment-template").innerHTML
    const newIndex = Date.now() // unique
    const html = tpl
      .replaceAll("ITEM_INDEX", itemIndex)
      .replaceAll("NEW_INDEX", newIndex)

    assignmentsEl.insertAdjacentHTML("beforeend", html)
  }

  remove(event) {
    event.target.closest(".participant, .item, .assignment").remove()
  }
}
