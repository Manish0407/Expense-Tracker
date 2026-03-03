# Expense Tracker (Splitwise-like)

A Rails application that tracks shared expenses between users, similar to Splitwise.

This project allows users to:
- Create itemized expenses
- Split expenses equally or unequally
- Add tax
- Track balances
- Settle up payments
- View friend-specific expenses
- View dashboard with net balances

---

## 🚀 Features Implemented

### ✅ Sharing Expenses (Itemized Bill)

- Add one or more items per expense
- Select one or multiple participants
- Each item can be:
  - Assigned to a specific person
  - Shared equally among participants
  - Shared unequally using custom share amounts
- Tax can be added and is split equally among participants
- Accurate ledger entries are created for each expense

---

### ✅ Dashboard

Displays:

- **Total Balance**
  - (Amount due to you − Amount you owe)
- **Total You Owe**
- **Total Due To You**
- List of:
  - Friends you owe
  - Friends who owe you
- Total amount spent by all users
- List of expenses paid by current user

Balances are calculated using a ledger-based netting system.

---

### ✅ Friend Page

Each user's page shows:
- All expenses paid by that user

---

### ⭐ Bonus: Settling Up

- Record payments between users
- Add optional notes
- Automatically updates balances on both dashboards
- Uses reverse ledger entries for accurate netting

---

## 🧠 Architecture & Design

- **Skinny Controllers, Fat Models**
  - All business logic lives in models
- Ledger-based accounting system
- Equal/unequal split validation
- Proper rounding & remainder handling
- Net balance calculation per friend
- Reusable methods for totals and splits
- Clean partials and DRY structure

---

## 🧪 Testing

Unit tests are written using RSpec for critical methods:

- Expense item split logic
- Tax distribution
- Ledger entry creation
- Payment settlement
- Net balance calculations
- Model validations
- Controller behavior

Run tests:

```bash
bundle exec rspec

## Assumptions Made

- Authentication was not implemented as it was not explicitly required.
- `current_user` is assumed for demonstration purposes.
- All users can view all expenses (no permission restrictions).
- Equal split occurs when share_amount is not provided.
- Unequal split requires share_amount for all participants and must sum to item amount.
- Ledger entries are used for balance calculation instead of storing derived fields.
