class InvitationFrom {
  final String uid;
  final String bookingId;
  final bool isConfirmed;
  final bool isDeclined;

  InvitationFrom({
    this.uid,
    this.bookingId,
    this.isConfirmed,
    this.isDeclined,
  });

  static InvitationFrom fromJson(final Map<String, dynamic> data) {
    return InvitationFrom(
      uid: data['uid'],
      bookingId: data['booking_id'] ?? '',
      isConfirmed: data['is_confirmed'] ?? false,
      isDeclined: data['is_declined'] ?? false,
    );
  }
}
