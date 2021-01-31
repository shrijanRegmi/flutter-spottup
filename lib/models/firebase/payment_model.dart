class Payment {
  final String bankAcNum;
  final String easyPaisaNum;
  final int percentage;

  Payment({
    this.bankAcNum,
    this.easyPaisaNum,
    this.percentage,
  });

  static Payment fromJson(final Map<String, dynamic> data) {
    return Payment(
      bankAcNum: data['bank_ac_number'] ?? '',
      easyPaisaNum: data['easy_paisa_number'] ?? '',
      percentage: data['percentage'] ?? 0,
    );
  }
}
