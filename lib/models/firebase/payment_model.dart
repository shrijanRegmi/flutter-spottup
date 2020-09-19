class Payment {
  final String bankAcNum;
  final String easyPaisaNum;

  Payment({this.bankAcNum, this.easyPaisaNum});

  static Payment fromJson(final Map<String, dynamic> data) {
    return Payment(
      bankAcNum: data['bank_ac_number'] ?? '',
      easyPaisaNum: data['easy_paisa_number'] ?? '',
    );
  }
}
