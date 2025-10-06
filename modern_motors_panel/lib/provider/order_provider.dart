import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:modern_motors_panel/constants.dart';
import 'package:modern_motors_panel/model/business_models/business_area_model.dart';
import 'package:modern_motors_panel/model/handling_orders/order_model.dart';
import 'package:modern_motors_panel/model/inspection_model/inspection_model.dart';
import 'package:modern_motors_panel/model/lease_orders/lease_order_model.dart';
// ignore: depend_on_referenced_packages

class OrderProvider with ChangeNotifier {
  //final RemoteConfigService _remoteConfigService = RemoteConfigService();
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  List<OrderModel> myOrders = [];
  List<OrderModel> myCompletedOrdersOrders = [];
  List<OrderModel> myDeniedOrders = [];
  List<OrderModel> myTractorOrders = [];
  List<OrderModel> myTractorCompletedOrdersOrders = [];
  List<OrderModel> myTractorDeniedOrders = [];
  List<OrderModel> myBusinessDeniedOrders = [];
  List<OrderModel> myBusinesActiveOrders = [];
  List<OrderModel> myBusinesPendingOrders = [];
  List<OrderModel> myBusinesCompleteOrders = [];
  List<OrderModel> myBusinesDeniedOrders = [];
  List<OrderModel> myBusinesTractorActiveOrders = [];
  List<OrderModel> myBusinesTractorPendingOrders = [];
  List<OrderModel> myBusinesTractorCompleteOrders = [];
  List<OrderModel> myBusinesTractorDeniedOrders = [];
  List<InspectionModel> activeInspections = [];
  List<InspectionModel> allInspections = [];
  List<InspectionModel> activeOffloading = [];
  List<InspectionModel> allOffloading = [];
  List<OrderModel> activePackageOrders = [];
  List<OrderModel> assignedOrders = [];
  List<OrderModel> activeOrders = [];
  List<OrderModel> deniedOrders = [];
  List<OrderModel> pendingOrders = [];
  List<OrderModel> pendingPackageOrders = [];
  List<OrderModel> completedOrders = [];
  List<OrderModel> assignedTractorOrders = [];
  List<OrderModel> activeTractorOrders = [];
  List<OrderModel> deniedTractorOrders = [];
  List<OrderModel> pendingTractorOrders = [];
  List<OrderModel> completedTractorOrders = [];
  List<OrderModel> leaseActiveOrders = [];
  List<OrderModel> leasePendingOrders = [];
  List<OrderModel> leaseCompletedOrders = [];

  double labourCommission = 0;
  bool permissionRequired = false;
  bool cautionLoading = false;
  OrderModel? reportedOrder;
  OrderModel? ratingOrder;
  int count = 0;
  late Timer? timer;
  OrderModel activeOrder = OrderModel(
    businessId: "",
    duration: "",
    price: 0,
    serviceType: "",
    status: "",
    id: "",
    assignedAt: Timestamp.now(),
    startedAt: Timestamp.now(),
    endedAt: Timestamp.now(),
    assignedTo: {},
    equipmentId: "",
    warehouse: "",
    warehouseId: "",
    outdoorLocation: "",
    outdoorBuilding: "",
    outdoorlocationId: "",
    timestamp: Timestamp.now(),
    tractorOption: "",
    trailerNumber: "",
    packageId: "",
  );
  bool playAlertSound = true;
  bool isPlaying = false;
  int loopCount = 0;
  bool ratings = false;

  void setCaution() {
    int index = myBusinesActiveOrders.indexWhere(
      (item) =>
          item.caution! && item.attended == false ||
          item.pu != null &&
              item.pu!.any((palletUpdate) => palletUpdate.status == "caution"),
    );
    if (index == -1) {
      permissionRequired = false;
      reportedOrder = null;
    } else {
      reportedOrder = myBusinesActiveOrders[index];
      permissionRequired = true;
      checkOrderAlert("business");
    }

    //   permissionRequired = status;
    notifyListeners();
  }

  List<OrderModel> unratedOrders = [];
  late int unratedOrdersCount;
  void getRatings() async {
    int frequency = await getFrequency();
    //_remoteConfigService.getInt('ratings_frequency', defaultValue: 5);
    // int unratedOrdersCount = myBusinesCompleteOrders
    //     .where((item) => item.ratings != null && item.ratings == 0)
    //     .length;
    debugPrint(frequency.toString());
    final unratedOrders = myBusinesCompleteOrders
        .where((item) => item.ratings == 0)
        .toList();
    unratedOrdersCount = unratedOrders.length;
    ratings = unratedOrdersCount > 0 && unratedOrdersCount % frequency == 0;
    if (ratings && unratedOrders.isNotEmpty) {
      ratingOrder = unratedOrders.first;
    }
    notifyListeners();
  }

  Future<int> getFrequency() async {
    int frequency = 0;
    try {
      await FirebaseFirestore.instance
          .collection('appSettings')
          .doc("SaZ6tvMiAAKV5CcKvV7j")
          .get()
          .then((doc) {
            if (doc.exists) {
              frequency = int.tryParse(doc['ratingsFrequency'].toString()) ?? 0;
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return frequency;
  }

  void updateRatings() {
    ratings = false;
    unratedOrders.clear();
    unratedOrdersCount = 0;
    //getRatings();
    notifyListeners();
  }

  void updateCommission(double commission) {
    labourCommission += commission;
    notifyListeners();
  }

  // void populateOrdersList() async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   User? user = FirebaseAuth.instance.currentUser;
  //   String userID = user!.uid;
  //   //userID = "yyKu0c1WEnT2pErGVbtGurBUQzD2";
  //   firestore
  //       .collection('myOrders')
  //       .doc(userID)
  //       .collection('orders')
  //       .snapshots()
  //       .listen((userSnapshot) async {
  //     myOrders.clear();
  //     for (var orderDoc in userSnapshot.docs) {
  //       // debugPrint(
  //       //     "test_ orderID: ${orderDoc.id}, userID: $userID: status: ${orderDoc['status']}, assignedAt: ${orderDoc['assignedAt'].toString()}");
  //       Timestamp assignedAt = orderDoc['assignedAt'] ?? Timestamp.now();
  //       String status = orderDoc['status'];
  //       MyOrdersModel orderData = MyOrdersModel(
  //           id: "",
  //           driverUserId: userID,
  //           orderId: orderDoc.id,
  //           assignedAt: assignedAt.toDate(),
  //           status: status);
  //       // if (status != "ended") {
  //       //   if (status != "paused") {
  //       //     myOrders.add(orderData);
  //       //   }
  //       // }
  //     }
  //     notifyListeners();
  //     // checkOrderAlert();
  //   });
  // }

  void checkOrderAlert(String type) async {
    if (kIsWeb) {
      return;
    }
    if (type == "driver") {
      int count = myOrders
          .where(
            (order) =>
                order.status == 'assigned' ||
                (order.oldDropOffModel != null &&
                    order.oldDropOffModel!.outdoorBuilding.isNotEmpty),
          )
          .length;
      if (count > 0) {
        if (!isPlaying) {
          playAlertSound = true;
          bool hasTimeBasedOrder = myOrders.any(
            (order) => order.status == 'assigned' && order.orderBasis == "time",
          );
          //playAlert(hasTimeBasedOrder);
        }
      } else {
        stopAlert();
      }
    } else {
      int count = myBusinesActiveOrders
          .where((order) => order.caution == true && order.attended == false)
          .length;
      if (count > 0) {
        if (!isPlaying) {
          playAlertSound = true;
          // playAlert(false);
        }
      } else {
        stopAlert();
      }
    }
  }

  // void playAlert(bool clockWise) async {
  //   isPlaying = true;
  //   final session = await AudioSession.instance;
  //   await session.configure(const AudioSessionConfiguration.speech());
  //   if (await session.setActive(true)) {
  //     if (playAlertSound) {
  //       playSound(clockWise);
  //     }
  //   }
  // }

  void playSound(bool clockWise) async {
    if (loopCount < 8) {
      loopCount++;
      // await audioHandler.stop();
      // await audioHandler.rewind();
      //await audioHandler.play();
      // if (clockWise) {
      //   //await audioHandler.playFromUri(Uri.parse(Constants.clock_Alarm));
      //   // await audioHandler.playFromMediaId(Constants.clock_Alarm);
      //   await audioHandler.playFromUri(Uri.parse(Constants.clock_Alarm));
      // } else {
      //   await audioHandler.playFromUri(Uri.parse(Constants.pallet_Alarm));
      //   //await audioHandler.playFromUri(Uri.parse(Constants.pallet_Alarm));
      // }
      // await audioHandler.playFromUri(Uri.parse(Constants.pallet_Alarm));
      // await audioHandler.play();

      if (playAlertSound) {
        playSound(clockWise);
      }
    } else {
      stopAlert();
    }
  }

  void stopAlert() async {
    playAlertSound = false;
    loopCount = 0;
    isPlaying = false;
    //  await audioHandler.stop();
  }

  Future<void> inspectionsOrder() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    DateTime threeDays = DateTime(
      now.year,
      now.month,
      now.day - 6, // subtract 3 days
      0,
      0,
    );
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('gateEntry')
        //.where('status', isNotEqualTo: "")
        //.where("packageId", isEqualTo: "pUI8qWYcllHiZYBJ57CX")
        .where('timestamp', isGreaterThanOrEqualTo: threeDays)
        .where('timestamp', isLessThanOrEqualTo: today)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((userSnapshot) async {
          activeInspections.clear();
          allInspections.clear();
          allOffloading.clear();
          activeOffloading.clear();
          try {
            for (var doc in userSnapshot.docs) {
              final data = doc.data();
              List<dynamic> bArea = data['businessAreas'] ?? [];
              List<BusinessAreaModel> businessAreas = [];
              for (var element in bArea) {
                businessAreas.add(
                  BusinessAreaModel(
                    title: element['storage'],
                    value: element['title'],
                    id: element['id'],
                  ),
                );
              }
              List<dynamic> uList = data['url'] ?? [];
              List<String> url = [];
              for (var element in uList) {
                url.add(element);
              }
              //Timestamp assignedAt = doc['timestamp'];
              InspectionModel im = InspectionModel(
                id: doc.id,
                chasisNumber: data['chasisNumber'] ?? "",
                consigneeId: data['consigneeId'] ?? "",
                consigneeName: data['consigneeName'] ?? "",
                customDeclarationNumber: data['customDeclarationNumber'] ?? "",
                generatedBy: data['generatedBy'] ?? "",
                generatedByProfileId: data['generatedByProfileId'] ?? "",
                status: data['status'] ?? "",
                timestamp: data['timestamp'] ?? Timestamp.now(),
                truckCode: data['truckCode'] ?? "",
                truckCountry: data['truckCountry'] ?? "",
                truckId: data['truckId'] ?? "",
                truckNumber: data['truckNumber'] ?? "",
                truckSize: data['truckSize'] ?? "",
                type: data['type'] ?? "",
                packageId: data['packageId'] ?? "",
                timeClosed: data['timeClosed'] ?? Timestamp.now(),
                closedByUser: data['closedByuser'] ?? "",
                closedUser: data['closedUser'] ?? "",
                invoice: data['invoiceId'] ?? "",
                gatePassRef: data['gatePassRef'] ?? "",
                amount: double.tryParse(data['amount'].toString()) ?? 0,
                origin: data['origin'] ?? "",
                port: data['port'] ?? "",
                businessAreas: businessAreas,
                entryType: data['entryType'] ?? "",
                requestTime: data['requestTime'] ?? Timestamp.now(),
                approvedAt: data['approvedAt'] ?? Timestamp.now(),
                arrivedAt: data['arrivedAt'] ?? Timestamp.now(),
                approvedBy: data['approvedBy'] ?? "",
                arrivedBy: data['approvedBy'] ?? "",
                trailerNumber: data['trailerNumber'] ?? "",
                cancelAt: data['cancelAt'] ?? Timestamp.now(),
                cancelBy: data['cancelBy'] ?? "",
                exitAt: data['exitAt'] ?? Timestamp.now(),
                exitBy: data['exitBy'] ?? "",
                rejectAt: data['rejectAt'],
                rejectBy: data['rejectBy'] ?? "",
                url: url,
                editRequested: data['editRequested'],
                expirationDate: data['expirationDate'],
              );
              if (im.type == "inspection") {
                allInspections.add(im);
                if (im.status == "generated") {
                  activeInspections.add(im);
                } else {}
              } else {
                allOffloading.add(im);
              }
            }
          } catch (e) {
            debugPrint(e.toString());
          }
          notifyListeners();
        });
  }

  Future<List<InspectionModel>?> getInspectionsByBusiness(
    String businessId,
    String status,
    String type,
  ) async {
    List<InspectionModel> inspectionList = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    await FirebaseFirestore.instance
        .collection('gateEntry')
        .where('consigneeId', isEqualTo: businessId)
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
          for (var doc in value.docs) {
            InspectionModel? im = InspectionModel.getInspections(doc);
            if (im != null) {
              if (im.type == type && im.status == status) {
                inspectionList.add(im);
              }
            }
          }
        });
    return inspectionList;
  }

  void testgetOrdersList() {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('orders')
          //.where('status', isNotEqualTo: "")
          //          .orderBy("timestamp", descending: true)
          .orderBy("invoiceId", descending: true)
          .snapshots()
          .listen((userSnapshot) async {
            activePackageOrders.clear();
            assignedOrders.clear();
            activeOrders.clear();
            pendingOrders.clear();
            pendingPackageOrders.clear();
            completedOrders.clear();
            leaseActiveOrders.clear();
            leasePendingOrders.clear();
            leaseCompletedOrders.clear();
            for (var change in userSnapshot.docChanges) {
              OrderModel? orderData = OrderModel.getOrderDetails(change.doc);
              if (orderData != null) {
                addOrder(orderData);
              }
            }
            notifyListeners();
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void updateLocalOrders(OrderModel order) {
    removeOrder(order);
  }

  void runOrderStream(List<String> equipmentList) {
    if (equipmentList.contains("mJ7Yp31PmQkbeoCKZmed")) {
      getTractorDriverOrders();
    } else {
      getDriverOrders();
    }
  }

  void getDriverOrders() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('orders')
          .where(
            Filter.or(
              Filter("assignedTo.id", isEqualTo: user.uid),
              Filter("scheduledTo", isEqualTo: user.uid),
            ),
          )
          .where(
            'status',
            whereIn: [
              'assigned',
              'started',
              'ended',
              'denied',
              'pending',
              'scheduled',
            ],
          )
          // .where('assignedTo.id', isEqualTo: user.uid)
          //.where('scheduledTo', is)
          .where('timestamp', isGreaterThanOrEqualTo: today)
          //.orderBy("invoiceId", descending: true)
          .orderBy('timestamp', descending: false)
          //.orderBy('timestamp', descending: true)
          //.where('invoiceId', isEqualTo: "51540")
          .snapshots()
          .listen((userSnapshot) async {
            for (var change in userSnapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                OrderModel? order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  addBusinessOrder(order, "driver");
                }
              } else if (change.type == DocumentChangeType.modified) {
                OrderModel? order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  removeBusinessOrder(order, "driver");
                }
              } else if (change.type == DocumentChangeType.removed) {
                OrderModel? order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  removeBusinessOrder(order, "driver", add: false);
                }
              }
            }
            checkOrderAlert("driver");
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  void getTractorDriverOrders() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection(
            "tractorOrders",
            ////collectionName
            //'orders'
          )
          .where(
            Filter.or(
              Filter("assignedTo.id", isEqualTo: user.uid),
              Filter("scheduledTo", isEqualTo: user.uid),
            ),
          )
          .where(
            'status',
            whereIn: ['assigned', 'started', 'ended', 'denied', 'pending'],
          )
          // .where('assignedTo.id', isEqualTo: user.uid)
          //.where('scheduledTo', is)
          .where('timestamp', isGreaterThanOrEqualTo: today)
          //.orderBy("invoiceId", descending: true)
          .orderBy('timestamp', descending: false)
          //.orderBy('timestamp', descending: true)
          //.where('invoiceId', isEqualTo: "51540")
          .snapshots()
          .listen((userSnapshot) async {
            for (var change in userSnapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                OrderModel? order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  addBusinessOrder(order, "driver");
                }
              } else if (change.type == DocumentChangeType.modified) {
                OrderModel? order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  removeBusinessOrder(order, "driver");
                }
              } else if (change.type == DocumentChangeType.removed) {
                OrderModel? order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  removeBusinessOrder(order, "driver", add: false);
                }
              }
            }
            checkOrderAlert("driver");
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  void getBusinessOrders() {
    OrderModel? order;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('orders')
          .where('businessId', isEqualTo: Constants.businessId)
          .where(
            'status',
            whereIn: ["pending", 'assigned', 'started', 'ended', "denied"],
          )
          .where('timestamp', isGreaterThanOrEqualTo: today)
          .orderBy("timestamp", descending: true)
          //.where('invoiceId', isEqualTo: "51540")
          .snapshots()
          .listen((userSnapshot) async {
            for (var change in userSnapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  //
                  addBusinessOrder(order!, "business");
                }
              } else if (change.type == DocumentChangeType.modified) {
                OrderModel? order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  //reportedOrder = null;

                  if (order.caution! && order.attended! == false) {
                    checkOrderAlert("business");
                    addBusinessOrder(order, "business");
                  } else if (order.attended! &&
                      order.cautionPermission! == false) {
                    if (order.status == "assigned" ||
                        order.status == "started") {
                      addBusinessOrder(order, "business");
                    } else {
                      removeBusinessOrder(order, "business");
                    }
                  } else if (order.caution == false) {
                    removeBusinessOrder(order, "business");
                  } else if (order.attended! && order.cautionPermission!) {
                    if (order.status == "assigned" ||
                        order.status == "started") {
                      addBusinessOrder(order, "business");
                    } else {
                      removeBusinessOrder(order, "business");
                    }
                  }
                }
              }
              // attended = orderDoc['attended'];
            }
            setCaution();
          });
      //notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }

    // if (attended) {
    //   checkOrderAlert("business");
    // }
  }

  void getBusinessTractorOrders() {
    OrderModel? order;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('tractorOrders')
          .where('businessId', isEqualTo: Constants.businessId)
          .where(
            'status',
            whereIn: ["pending", 'assigned', 'started', 'ended', "denied"],
          )
          .where('timestamp', isGreaterThanOrEqualTo: today)
          .orderBy("timestamp", descending: true)
          //.where('invoiceId', isEqualTo: "51540")
          .snapshots()
          .listen((userSnapshot) async {
            for (var change in userSnapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  //
                  addBusinessOrder(order!, "business", tractor: true);
                }
              } else if (change.type == DocumentChangeType.modified) {
                OrderModel? order = OrderModel.getOrderDetails(change.doc);
                if (order != null) {
                  //reportedOrder = null;

                  if (order.caution! && order.attended! == false) {
                    checkOrderAlert("business");
                    addBusinessOrder(order, "business", tractor: true);
                  } else if (order.attended! &&
                      order.cautionPermission! == false) {
                    if (order.status == "assigned" ||
                        order.status == "started") {
                      addBusinessOrder(order, "business", tractor: true);
                    } else {
                      removeBusinessOrder(order, "business", tractor: true);
                    }
                  } else if (order.caution == false) {
                    removeBusinessOrder(order, "business", tractor: true);
                  } else if (order.attended! && order.cautionPermission!) {
                    if (order.status == "assigned" ||
                        order.status == "started") {
                      addBusinessOrder(order, "business", tractor: true);
                    } else {
                      removeBusinessOrder(order, "business", tractor: true);
                    }
                  }
                }
              }
              // attended = orderDoc['attended'];
            }
            setCaution();
          });
      //notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }

    // if (attended) {
    //   checkOrderAlert("business");
    // }
  }

  void getOrdersList() {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);
      //debugPrint("test_ ${today.day}");
      //DateTime yesterday = today.subtract(const Duration(days: 1));
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('orders')
          .where(
            'status',
            whereIn: [
              'assigned',
              'started',
              'pending',
              'scheduled',
              'pending-labour',
              'ended',
              'denied',
            ],
          )
          .where('timestamp', isGreaterThanOrEqualTo: today)
          .orderBy("invoiceId", descending: true)
          //.where('invoiceId', isEqualTo: "51540")
          .snapshots()
          .listen((userSnapshot) async {
            for (var change in userSnapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                OrderModel? orderData = OrderModel.getOrderDetails(change.doc);
                if (orderData != null) {
                  addOrder(orderData);
                }
              } else if (change.type == DocumentChangeType.modified) {
                OrderModel? orderData = OrderModel.getOrderDetails(change.doc);
                if (orderData != null) {
                  removeOrder(orderData);
                  //addOrder(orderData);
                }
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getTractorOrdersList() {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);
      debugPrint("test_ ${today.day}");
      //DateTime yesterday = today.subtract(const Duration(days: 1));
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore
          .collection('tractorOrders')
          .where(
            'status',
            whereIn: [
              'assigned',
              'started',
              'pending',
              'scheduled',
              'ended',
              'denied',
            ],
          )
          .where('timestamp', isGreaterThanOrEqualTo: today)
          .orderBy("invoiceId", descending: true)
          //.where('invoiceId', isEqualTo: "51540")
          .snapshots()
          .listen((userSnapshot) async {
            for (var change in userSnapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                OrderModel? orderData = OrderModel.getOrderDetails(change.doc);
                if (orderData != null) {
                  addOrder(orderData, tractor: true);
                }
              } else if (change.type == DocumentChangeType.modified) {
                OrderModel? orderData = OrderModel.getOrderDetails(change.doc);
                if (orderData != null) {
                  removeOrder(orderData, tractor: true);
                  //addOrder(orderData);
                }
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addBusinessOrder(OrderModel order, String type, {bool tractor = false}) {
    if (type == "business") {
      if (order.status == "pending") {
        if (tractor) {
          int index = getOrderIndexInList(myBusinesTractorPendingOrders, order);
          if (index > -1) {
            myBusinesTractorPendingOrders[index] = order;
          } else {
            myBusinesTractorPendingOrders.add(order);
          }
        } else {
          int index = getOrderIndexInList(myBusinesPendingOrders, order);
          if (index > -1) {
            myBusinesPendingOrders[index] = order;
          } else {
            myBusinesPendingOrders.add(order);
          }
        }
      } else if (order.status == "assigned" || order.status == "started") {
        if (tractor) {
          int index = getOrderIndexInList(myBusinesTractorActiveOrders, order);
          if (index > -1) {
            myBusinesTractorActiveOrders[index] = order;
          } else {
            myBusinesTractorActiveOrders.add(order);
          }
        } else {
          int index = getOrderIndexInList(myBusinesActiveOrders, order);
          if (index > -1) {
            myBusinesActiveOrders[index] = order;
          } else {
            myBusinesActiveOrders.add(order);
          }
        }
      } else if (order.status == "ended") {
        if (tractor) {
          int index = getOrderIndexInList(
            myBusinesTractorCompleteOrders,
            order,
          );
          if (index > -1) {
            myBusinesTractorCompleteOrders[index] = order;
          } else {
            myBusinesTractorCompleteOrders.add(order);
            getRatings();
          }
        } else {
          int index = getOrderIndexInList(myBusinesCompleteOrders, order);
          if (index > -1) {
            myBusinesCompleteOrders[index] = order;
          } else {
            myBusinesCompleteOrders.add(order);
            getRatings();
          }
        }
      } else if (order.status == "denied") {
        int index = getOrderIndexInList(myBusinesDeniedOrders, order);
        if (index > -1) {
          myBusinesDeniedOrders[index] = order;
        } else {
          myBusinesDeniedOrders.add(order);
        }
      }
      myBusinesTractorCompleteOrders.sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      );
      myBusinesTractorCompleteOrders.sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      );
      myBusinesCompleteOrders.sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      );
      myBusinesDeniedOrders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } else {
      if (order.status == "assigned" ||
          order.status == "started" ||
          order.status == "pending" ||
          order.status == "scheduled") {
        if (tractor) {
          int index = getOrderIndexInList(myTractorOrders, order);
          if (index > -1) {
            myTractorOrders[index] = order;
          } else {
            myTractorOrders.add(order);
          }
        } else {
          int index = getOrderIndexInList(myOrders, order);
          if (index > -1) {
            myOrders[index] = order;
          } else {
            myOrders.add(order);
          }
        }
      } else if (order.status == "ended") {
        if (tractor) {
          int index = getOrderIndexInList(
            myTractorCompletedOrdersOrders,
            order,
          );
          if (index > -1) {
            myTractorCompletedOrdersOrders[index] = order;
          } else {
            myTractorCompletedOrdersOrders.add(order);
          }
        } else {
          int index = getOrderIndexInList(myCompletedOrdersOrders, order);
          if (index > -1) {
            myCompletedOrdersOrders[index] = order;
          } else {
            myCompletedOrdersOrders.add(order);
          }
        }
      } else if (order.status == "denied") {
        int index = getOrderIndexInList(myDeniedOrders, order);
        if (index > -1) {
          myDeniedOrders[index] = order;
        } else {
          myDeniedOrders.add(order);
        }
      }
    }
    myTractorCompletedOrdersOrders.sort(
      (a, b) => b.timestamp.compareTo(a.timestamp),
    );
    myCompletedOrdersOrders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    myDeniedOrders.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  void removeBusinessOrder(
    OrderModel order,
    String type, {
    bool add = true,
    bool tractor = false,
  }) {
    if (type == "business") {
      if (tractor) {
        int index = getOrderIndexInList(myBusinesTractorPendingOrders, order);
        if (index > -1) {
          myBusinesTractorPendingOrders.removeAt(index);
        }
      } else {
        int index = getOrderIndexInList(myBusinesPendingOrders, order);
        if (index > -1) {
          myBusinesPendingOrders.removeAt(index);
        }
      }
      if (tractor) {
        int index1 = getOrderIndexInList(myBusinesTractorActiveOrders, order);
        if (index1 > -1) {
          myBusinesTractorActiveOrders.removeAt(index1);
        }
      } else {
        int index1 = getOrderIndexInList(myBusinesActiveOrders, order);
        if (index1 > -1) {
          myBusinesActiveOrders.removeAt(index1);
        }
      }
      if (tractor) {
        int index2 = getOrderIndexInList(myBusinesTractorCompleteOrders, order);
        if (index2 > -1) {
          myBusinesTractorCompleteOrders.removeAt(index2);
        }
      } else {
        int index2 = getOrderIndexInList(myBusinesCompleteOrders, order);
        if (index2 > -1) {
          myBusinesCompleteOrders.removeAt(index2);
        }
      }
      int index3 = getOrderIndexInList(myBusinesDeniedOrders, order);
      if (index3 > -1) {
        myBusinesDeniedOrders.removeAt(index3);
      }
    } else {
      int index = getOrderIndexInList(myOrders, order);
      if (index > -1) {
        myOrders.removeAt(index);
      }
      int index1 = getOrderIndexInList(myCompletedOrdersOrders, order);
      if (index1 > -1) {
        myCompletedOrdersOrders.removeAt(index1);
      }
      int index2 = getOrderIndexInList(myDeniedOrders, order);
      if (index2 > -1) {
        myDeniedOrders.removeAt(index2);
      }
    }
    if (add) {
      addBusinessOrder(order, type, tractor: tractor);
    } else {
      notifyListeners();
    }
  }

  void addOrder(OrderModel orderData, {bool tractor = false}) {
    if (orderData.serviceType == 'package') {
      if (orderData.status == "pending") {
        int index = getOrderIndexInList(pendingPackageOrders, orderData);
        if (index > -1) {
          pendingPackageOrders[index] = orderData;
        } else {
          pendingPackageOrders.add(orderData);
        }
      } else if (orderData.status != "pending" &&
          orderData.status != "ended" &&
          orderData.status != "incomplete" &&
          orderData.status != "duplicate" &&
          orderData.status != "cancelled") {
        int index = getOrderIndexInList(activePackageOrders, orderData);
        if (index > -1) {
          activePackageOrders[index] = orderData;
        } else {
          activePackageOrders.add(orderData);
        }
      }
    } else if (orderData.serviceType == 'outdoor' ||
        orderData.serviceType == 'indoor') {
      if (orderData.status == "pending" || orderData.status == "scheduled") {
        if (tractor) {
          int index = getOrderIndexInList(pendingTractorOrders, orderData);
          if (index > -1) {
            pendingTractorOrders[index] = orderData;
          } else {
            pendingTractorOrders.add(orderData);
          }
        } else {
          int index = getOrderIndexInList(pendingOrders, orderData);
          if (index > -1) {
            pendingOrders[index] = orderData;
          } else {
            pendingOrders.add(orderData);
          }
        }
      } else if (orderData.status == "started") {
        if (tractor) {
          int index = getOrderIndexInList(activeTractorOrders, orderData);
          if (index > -1) {
            activeTractorOrders[index] = orderData;
          } else {
            activeTractorOrders.add(orderData);
          }
        } else {
          int index = getOrderIndexInList(activeOrders, orderData);
          if (index > -1) {
            activeOrders[index] = orderData;
          } else {
            activeOrders.add(orderData);
          }
        }
      } else if (orderData.status == "assigned") {
        if (tractor) {
          int index = getOrderIndexInList(assignedTractorOrders, orderData);
          if (index > -1) {
            assignedTractorOrders[index] = orderData;
          } else {
            assignedTractorOrders.add(orderData);
          }
        } else {
          int index = getOrderIndexInList(assignedOrders, orderData);
          if (index > -1) {
            assignedOrders[index] = orderData;
          } else {
            assignedOrders.add(orderData);
          }
        }
      } else if (orderData.status == "ended") {
        if (tractor) {
          int index = getOrderIndexInList(completedTractorOrders, orderData);
          if (index > -1) {
            completedTractorOrders[index] = orderData;
          } else {
            completedTractorOrders.add(orderData);
          }
        } else {
          int index = getOrderIndexInList(completedOrders, orderData);
          if (index > -1) {
            completedOrders[index] = orderData;
          } else {
            completedOrders.add(orderData);
          }
        }
      } else if (orderData.status == "denied") {
        int index = getOrderIndexInList(deniedOrders, orderData);
        if (index > -1) {
          deniedOrders[index] = orderData;
        } else {
          deniedOrders.add(orderData);
        }
      } else if (orderData.status != "pending" &&
          orderData.status != "ended" &&
          orderData.status != "incomplete") {
        // int index = getOrderIndexInList(activeOrders, orderData);
        // if (index > -1) {
        //   activeOrders[index] = orderData;
        // } else {
        //   activeOrders.add(orderData);
        // }
      }
    } else if (orderData.serviceType == 'lease') {
      if (orderData.status == "pending") {
        int index = getOrderIndexInList(leasePendingOrders, orderData);
        if (index > -1) {
          leasePendingOrders[index] = orderData;
        } else {
          leasePendingOrders.add(orderData);
        }
      } else if (orderData.status != "pending" &&
          orderData.status != "ended" &&
          orderData.status != "incomplete") {
        int index = getOrderIndexInList(leaseActiveOrders, orderData);
        if (index > -1) {
          leaseActiveOrders[index] = orderData;
        } else {
          leaseActiveOrders.add(orderData);
        }
      }
    }
    pendingOrders.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    notifyListeners();
  }

  void removeOrder(OrderModel order, {bool tractor = false}) {
    if (tractor) {
      int index = getOrderIndexInList(activeTractorOrders, order);
      if (index > -1) {
        activeTractorOrders.removeAt(index);
      }
    } else {
      int index = getOrderIndexInList(activeOrders, order);
      if (index > -1) {
        activeOrders.removeAt(index);
      }
    }
    if (tractor) {
      int index1 = getOrderIndexInList(pendingTractorOrders, order);
      if (index1 > -1) {
        pendingTractorOrders.removeAt(index1);
      }
    } else {
      int index1 = getOrderIndexInList(pendingOrders, order);
      if (index1 > -1) {
        pendingOrders.removeAt(index1);
      }
    }

    int index2 = getOrderIndexInList(activePackageOrders, order);
    if (index2 > -1) {
      activePackageOrders.removeAt(index2);
    }
    int index3 = getOrderIndexInList(pendingPackageOrders, order);
    if (index3 > -1) {
      pendingPackageOrders.removeAt(index3);
    }
    int index4 = getOrderIndexInList(leaseActiveOrders, order);
    if (index4 > -1) {
      leaseActiveOrders.removeAt(index4);
    }
    int index5 = getOrderIndexInList(leasePendingOrders, order);
    if (index5 > -1) {
      leasePendingOrders.removeAt(index5);
    }
    if (tractor) {
      int index6 = getOrderIndexInList(assignedTractorOrders, order);
      if (index6 > -1) {
        assignedTractorOrders.removeAt(index6);
      }
    } else {
      int index6 = getOrderIndexInList(assignedOrders, order);
      if (index6 > -1) {
        assignedOrders.removeAt(index6);
      }
    }
    if (tractor) {
      int index7 = getOrderIndexInList(completedTractorOrders, order);
      if (index7 > -1) {
        completedTractorOrders.removeAt(index7);
      }
    } else {
      int index7 = getOrderIndexInList(completedOrders, order);
      if (index7 > -1) {
        completedOrders.removeAt(index7);
      }
    }

    int index8 = getOrderIndexInList(deniedOrders, order);
    if (index8 > -1) {
      deniedOrders.removeAt(index8);
    }
    addOrder(order, tractor: tractor);
  }

  int getOrderIndexInList(List<OrderModel> list, OrderModel order) {
    return list.indexWhere((o) => o.id == order.id);
  }

  void updateOrder(OrderModel order) {
    int index = -1;
    if (order.serviceType == 'package') {
      index = pendingPackageOrders.indexWhere((item) => item.id == order.id);
      pendingPackageOrders[index] = order;
      notifyListeners();
    }
  }

  Future<List<InspectionModel>?> getInspections(
    String title,
    String heading,
    String type,
    String status,
  ) async {
    List<InspectionModel>? inspectionList = [];
    try {
      await FirebaseFirestore.instance
          .collection('gateEntry')
          .where(title, isEqualTo: heading)
          .get()
          .then((value) {
            for (var doc in value.docs) {
              InspectionModel? i = InspectionModel.getInspections(doc);
              if (i != null) {
                if (i.type == "inspection") {
                  if (i.status == status) {
                    inspectionList.add(i);
                  }
                }
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return inspectionList;
  }

  Future<OrderModel?> getOrderDetails(String id) async {
    OrderModel? order;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    try {
      await FirebaseFirestore.instance.collection('orders').doc(id).get().then((
        doc,
      ) {
        if (doc.exists) {
          OrderModel? om = OrderModel.getOrderDetails(doc);
          if (om != null) {
            //activeOrderList.add(om);
            order = om;
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return order;
  }

  Future<LeaseOrderModel?> getLeaseOrderDetails(String id) async {
    LeaseOrderModel? order;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    try {
      await FirebaseFirestore.instance
          .collection('leaseOrders')
          .doc(id)
          .get()
          .then((doc) {
            if (doc.exists) {
              LeaseOrderModel? om = LeaseOrderModel.fromFirestore(doc);
              if (om.id.isNotEmpty) {
                order = om;
              }
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
    return order;
  }

  Future<List<OrderModel>?> getMyBusiness() async {
    List<OrderModel>? businessOrders;
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .where('businessId', isEqualTo: Constants.businessId)
          .get()
          .then((value) {
            // if (businessOrders != null) {
            //   businessOrders.clear();
            // }
            for (var doc in value.docs) {
              OrderModel? om = OrderModel.getOrderDetails(doc);
              if (om != null) {
                //activeOrderList.add(om);
                businessOrders!.add(om);
              }
            }
          });
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
    return businessOrders;
  }

  void getTime(int time) {
    count = time;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      count--;
    });
  }
}
