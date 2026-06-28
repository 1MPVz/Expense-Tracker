# MonExs - Expense Tracker Application

A Flutter mobile application for tracking personal income and expenses with a clean dark UI.

---

## Screens

### Loading Screen (`loading_page.dart`)
- Displays the MonExs logo, app name, and subtitle on launch
- Navigates automatically to the Home screen after loading completes (This is use to simulate API call)

### Home Screen (`home_page.dart`)
- Balance card at the top showing **Total Balance**, **Income**, and **Expenses**
- Balance values recompute automatically whenever a transaction is added or deleted
- Bottom navigation bar with two tabs: **Expenses** and **Summary**
- Floating action button (bottom-right) opens the Add Transaction modal

### Expense List (`expense_list_page.dart`)
- Scrollable list of all transactions below the fixed balance card
- Each tile shows the transaction icon, title, category, amount, and date
- **Tap** a tile to navigate to the Transaction Detail screen
- **Swipe left or right** to reveal a red delete background

### Transaction Detail (`transaction_detail_page.dart`)
- Shows a full breakdown of a single transaction: icon, title, amount, type, category, and date
- Accessed by tapping any transaction tile

### Summary Screen (`summary_page.dart`)
- Present pie chart for easy to understand management
---

## Features

### Transactions
- Add income or expense transactions via the modal form
- Each transaction stores: title, category, amount, date, type (income/expense), icon, and color
- New transactions are inserted at the top of the list
- Delete transactions by swiping left or right on any tile

### Balance Card
- Always visible above the transaction list, unaffected by scrolling
- **Total Balance** = Total Income − Total Expenses
- All three values update reactively on every add or delete

### Add Transaction Modal
- Toggle between **Expense** and **Income** mode
- Fields: Title, Type (dropdown), Date (date picker), Value
- **Form validation** — Title and Value fields turn red with an error message if left empty or invalid
- Error clears as soon as the user starts typing
- Date picker styled to match the dark theme
- Category icons are resolved automatically using `expenseTypeIcon()` and `incomeTypeIcon()` utility functions

### Sumarry Page
- Pie chart to show the proportion of type of expense or income.
- Filtered transaction base in type (expense or income).

## Project Structure

```
lib/
├── main.dart
├── screens/
│   ├── loading_page.dart
│   ├── home_page.dart
│   ├── expense_list_page.dart
│   ├── transaction_detail_page.dart
│   └── summary_page.dart
└── data/
    ├── transactions.dart         # Transaction model + dummy data
    └── transaction_type.dart     # Type lists + icon utility functions
```
