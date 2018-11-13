
class Transaction{
  final double amount;
  final String description;
  final String transactionDate;

  Transaction({this.amount, this.description, this.transactionDate});

  static Transaction fromJson(Map<String, dynamic> json){
    return Transaction(amount: json['amount'], description: json['description'], transactionDate: json['transactionDate']);
  }
}