(function () {
  function initExpenseForm() {
    const form = document.getElementById("expense-form")
    if (!form) return

    const participantsEl = document.getElementById("participants")
    const itemsEl = document.getElementById("items")

    const participantTpl = document.getElementById("participant-template")
    const itemTpl = document.getElementById("item-template")
    const assignmentTpl = document.getElementById("assignment-template")

    if (!participantsEl || !itemsEl || !participantTpl || !itemTpl || !assignmentTpl) return

    let participantIndex = 0
    let itemIndex = 0

    function renderTemplate(tpl, replacements) {
      let html = tpl.innerHTML
      Object.entries(replacements).forEach(([key, val]) => {
        html = html.replaceAll(key, val)
      })
      return html
    }

    function applyAssignmentsVisibility(itemEl, splitType) {
      const ui = itemEl.querySelector(".assignment-ui")
      const assignmentsEl = itemEl.querySelector(".assignments")
      const btn = itemEl.querySelector(".js-add-assignment")
      if (!ui || !assignmentsEl || !btn) return

      if (splitType === "shared") {
        btn.disabled = true
        btn.classList.add("is-disabled")
        ui.style.display = "none"
        assignmentsEl.innerHTML = ""
      } else {
        btn.disabled = false
        btn.classList.remove("is-disabled")
        ui.style.display = "block"

        if (assignmentsEl.children.length === 0) {
          btn.click()
        }
      }
    }

    // Prevent double binding on turbo visits
    if (form.dataset.bound === "1") return
    form.dataset.bound = "1"

    document.getElementById("add-participant")?.addEventListener("click", () => {
      const html = renderTemplate(participantTpl, { "NEW_INDEX": participantIndex++ })
      participantsEl.insertAdjacentHTML("beforeend", html)
    })

    document.getElementById("add-item")?.addEventListener("click", () => {
      const html = renderTemplate(itemTpl, { "NEW_INDEX": itemIndex })
      itemsEl.insertAdjacentHTML("beforeend", html)

      const itemEl = itemsEl.querySelector(`.item[data-item-index="${itemIndex}"]`)
      itemIndex++

      if (itemEl) applyAssignmentsVisibility(itemEl, "shared")
    })

    form.addEventListener("click", (e) => {
      const removeBtn = e.target.closest(".js-remove")
      if (removeBtn) {
        const row = removeBtn.closest(".participant, .assignment, .item")
        if (row) row.remove()
        return
      }

      const addAssignBtn = e.target.closest(".js-add-assignment")
      if (addAssignBtn) {
        const itemEl = addAssignBtn.closest(".item")
        if (!itemEl) return

        const splitSelect = itemEl.querySelector(".js-split-type")
        if (splitSelect && splitSelect.value === "shared") return

        const idx = itemEl.getAttribute("data-item-index")
        const assignmentsEl = itemEl.querySelector(".assignments")
        if (!assignmentsEl) return

        const html = renderTemplate(assignmentTpl, {
          "ITEM_INDEX": idx,
          "NEW_INDEX": Date.now().toString()
        })

        assignmentsEl.insertAdjacentHTML("beforeend", html)
      }
    })

    form.addEventListener("change", (e) => {
      const split = e.target.closest(".js-split-type")
      if (!split) return

      const itemEl = split.closest(".item")
      if (!itemEl) return

      applyAssignmentsVisibility(itemEl, split.value)
    })
  }

  document.addEventListener("turbo:load", initExpenseForm)
  document.addEventListener("DOMContentLoaded", initExpenseForm)
})()