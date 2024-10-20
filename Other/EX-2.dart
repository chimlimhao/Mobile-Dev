class BankAccount {
  // TODO
  final int accountId;
  final String accountName;
  double _balance = 0.0;

  BankAccount(this.accountId, this.accountName);

  double get balance => _balance;

  void withdraw(double amount) {
    if (amount > balance) {
      throw Exception('Insufficient balance for withdrawal!');
    }
    _balance -= amount;
  }

  void credit(double amount) {
    _balance += amount;
  }
}

class Bank {
  // TODO
  final String name;
  List<BankAccount> accounts = [];

  Bank({required this.name});

  BankAccount createAccount(int accountId, String accountName) {
    if (accounts.any((account) => account.accountId == accountId)) {
      throw Exception('The account with ID $accountId already exists!');
    }
    BankAccount newAccount = BankAccount(accountId, accountName);
    accounts.add(newAccount);
    return newAccount;
  }
}

void main() {
  Bank myBank = Bank(name: "CADT Bank");
  BankAccount ronanAccount = myBank.createAccount(100, 'Ronan');

  print('Balance: ${ronanAccount.balance}'); // Balance: $0
  ronanAccount.credit(100);
  print('Balance: ${ronanAccount.balance}'); // Balance: $100
  ronanAccount.withdraw(50);
  print('Balance: ${ronanAccount.balance}'); // Balance: $50

  try {
    ronanAccount.withdraw(75); // This will throw an exception
  } catch (e) {
    print(e); // Output: Insufficient balance for withdrawal!
  }

  try {
    myBank.createAccount(100, 'Honlgy'); // This will throw an exception
  } catch (e) {
    print(e); // Output: Account with ID 100 already exists!
  }
}
