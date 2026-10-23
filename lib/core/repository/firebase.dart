// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:finoco/core/models/iteration.dart';
// import 'package:finoco/core/models/type_transaction.dart';
// import '../models/client.dart'; // Assuming you have these models created
// import '../models/dossier.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<int> getNextAutoIncrementID() async {
//     final counterDoc =
//         FirebaseFirestore.instance.collection('counters').doc('itemCount');

//     return FirebaseFirestore.instance.runTransaction((transaction) async {
//       // Retrieve the current counter
//       final snapshot = await transaction.get(counterDoc);

//       int newID;
//       if (snapshot.exists) {
//         // Increment the counter if it exists
//         newID = snapshot.data()['value'] + 1;
//         transaction.update(counterDoc, {'value': newID});
//       } else {
//         // Initialize the counter if it doesn't exist
//         newID = 1;
//         transaction.set(counterDoc, {'value': newID});
//       }

//       return newID;
//     });
//   }
//   // ----------- Client CRUD operations ----------- //

//   // Add a client
//   Future<void> addClient(Client client) async {
//     final newID = await getNextAutoIncrementID();
//     client.id = newID.toString();
//     await _firestore
//         .collection('clients')
//         .doc(newID.toString())
//         .set(client.toJson());
//   }

//   // Update a client
//   Future<void> updateClient(Client client) async {
//     await _firestore
//         .collection('clients')
//         .doc(client.id.toString())
//         .update(client.toJson());
//   }

//   // Delete a client
//   Future<void> deleteClient(String clientId) async {
//     await _firestore.collection('clients').doc(clientId).delete();
//   }

//   // Get all clients as a stream
//   Stream<List<Client>> getClients() {
//     return _firestore.collection('clients').snapshots().map((snapshot) =>
//         snapshot.docs.map((doc) => Client.fromJson(doc.data())).toList());
//   }

//   // Get a single client by ID
//   Future<Client> getClientById(String clientId) async {
//     DocumentSnapshot doc =
//         await _firestore.collection('clients').doc(clientId).get();
//     if (doc.exists) {
//       return Client.fromJson(doc.data() as Map<String, dynamic>);
//     }
//     return null;
//   }

//   // ----------- Dossier CRUD operations ----------- //

//   // Add a dossier
//   Future<void> addDossier(Dossier dossier) async {
//     final newID = await getNextAutoIncrementID();
//     dossier.id = newID.toString();
//     await _firestore
//         .collection('dossiers')
//         .doc(newID.toString())
//         .set(dossier.toJson());
//   }

//   // Update a dossier
//   Future<void> updateDossier(Dossier dossier) async {
//     await _firestore
//         .collection('dossiers')
//         .doc(dossier.id.toString())
//         .update(dossier.toJson());
//   }

//   // Delete a dossier
//   Future<void> deleteDossier(String dossierId) async {
//     await _firestore.collection('dossiers').doc(dossierId).delete();
//   }

//   // Get all dossiers for a specific client
//   Stream<List<Dossier>> getDossiersByClient(String clientId, bool isOpen) {
//     return _firestore
//         .collection('dossiers')
//         .where('id_client', isEqualTo: clientId)
//         .where('status_folder', isEqualTo: isOpen)
//         .snapshots()
//         .map((snapshot) =>
//             snapshot.docs.map((doc) => Dossier.fromJson(doc.data())).toList());
//   }

//   // ----------- Paiement CRUD operations ----------- //

//   // // Add a paiement
//   // Future<void> addPaiement(Paiement paiement) async {
//   //   await _firestore.collection('paiements').doc(paiement.id).set(paiement.toMap());
//   // }

//   // // Update a paiement
//   // Future<void> updatePaiement(Paiement paiement) async {
//   //   await _firestore.collection('paiements').doc(paiement.id).update(paiement.toMap());
//   // }

//   // // Delete a paiement
//   // Future<void> deletePaiement(String paiementId) async {
//   //   await _firestore.collection('paiements').doc(paiementId).delete();
//   // }

//   // // Get all paiements for a specific dossier
//   // Stream<List<Paiement>> getPaiementsByDossier(String dossierId) {
//   //   return _firestore
//   //       .collection('paiements')
//   //       .where('id_folder_pay', isEqualTo: dossierId)
//   //       .snapshots()
//   //       .map((snapshot) => snapshot.docs.map((doc) => Paiement.fromMap(doc.data())).toList());
//   // }

//   // ----------- Iteration CRUD operations ----------- //

//   // Add a Iteration
//   Future<void> addIteration(Iteration iteration) async {
//     final newID = await getNextAutoIncrementID();
//     iteration.id = newID.toString();
//     await _firestore
//         .collection('iterations')
//         .doc(newID.toString())
//         .set(iteration.toMap());
//   }

//   // Update a Iteration
//   Future<void> updateIteration(Iteration iteration) async {
//     await _firestore
//         .collection('iterations')
//         .doc(iteration.id.toString())
//         .update(iteration.toMap());
//   }

//   // Delete a Iteration
//   Future<void> deleteIteration(String iteration) async {
//     await _firestore.collection('iterations').doc(iteration).delete();
//   }

//   // Get all Iterations for a specific dossier by type
//   Stream<List<Iteration>> getIterationsByDossier(
//       String dossierId, TypeTransaction type) {
//     return _firestore
//         .collection('iterations')
//         .where('id_folder', isEqualTo: dossierId)
//         .where('type', isEqualTo: type.name)
//         .snapshots()
//         .map((snapshot) =>
//             snapshot.docs.map((doc) => Iteration.fromMap(doc.data())).toList());
//   }
// }
