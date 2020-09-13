import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/review_model.dart';

class ReviewProvider {
  final String hotelId;
  final String uid;
  ReviewProvider({this.uid, this.hotelId});

  final _ref = Firestore.instance;

  // store review on firestore
  Future publishReview(Review review) async {
    try {
      final _hotelRef = _ref.collection('hotels').document(hotelId);
      final _reviewRef = _hotelRef.collection('reviews').document();

      await _reviewRef.setData(review.toJson());
      await _hotelRef.updateData({'reviews': FieldValue.increment(1)});
      print('Success: publishing review');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: publishing review');
      return null;
    }
  }

  // reviews from firestore
  List<Review> _reviewsFromFirestore(QuerySnapshot colSnap) {
    return colSnap.documents.map((doc) => Review.fromJson(doc.data)).toList();
  }

  // stream of reviews
  Stream<List<Review>> get reviewsList {
    return _ref
        .collection('hotels')
        .document(hotelId)
        .collection('reviews')
        .orderBy('milliseconds', descending: true)
        .snapshots()
        .map(_reviewsFromFirestore);
  }
}
