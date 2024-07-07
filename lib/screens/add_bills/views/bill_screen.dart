// import 'package:expense_repository/expense_repository.dart';
// import 'package:expense_tracker_project/blocs/bills_bloc/bills_bloc.dart';
// import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
// import 'package:expense_tracker_project/screens/add_bills/views/add_bills.dart';
// import 'package:expense_tracker_project/screens/add_bills/views/edit_bill.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:intl/intl.dart';

// import '../../../blocs/category_bloc/category_bloc.dart';

// class BillScreen extends StatefulWidget {
//   const BillScreen({super.key});

//   @override
//   State<BillScreen> createState() => _BillScreenState();
// }

// class _BillScreenState extends State<BillScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     context.read<BillsBloc>().add(LoadBills());
//   }

//   int days = 0;
//   final List<String> _frequencies = [
//     'Daily',
//     'Weekly',
//     'Monthly',
//     'Yearly',
//     'None'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final billsBloc = BlocProvider.of<BillsBloc>(context);
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 60,
//         toolbarHeight: 60,
//         automaticallyImplyLeading: false,
//         backgroundColor: Theme.of(context).colorScheme.background,
//         title: const Padding(
//           padding: EdgeInsets.only(left: 30.0, top: 20),
//           child: Text(
//             'Your Bills',
//             style: TextStyle(
//               fontSize: 22,
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       body: BlocBuilder<BillsBloc, BillsState>(
//         builder: (context, state) {
//           if (state is BillsLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (state is BillsLoaded) {
//             return Column(
//               children: [
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Expanded(
//                     child: ListView.builder(
//                   itemCount: state.bills.length,
//                   itemBuilder: (context, index) {
//                     final bill = state.bills[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(
//                           bottom: 16.0, left: 15, right: 15),
//                       child: GestureDetector(
//                         onTap: () {
//                           Slidable.of(context)?.close();
//                           showModalBottomSheet(
//                               shape: const RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20),
//                                   topRight: Radius.circular(20),
//                                 ),
//                               ),
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   padding: const EdgeInsets.all(20),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           bill.isPaid
//                                               ? const Row(
//                                                   children: [
//                                                     Icon(
//                                                       Icons.done_rounded,
//                                                       color: Colors.green,
//                                                     ),
//                                                     Text(
//                                                       'Paid',
//                                                       style: TextStyle(
//                                                           color: Colors.green),
//                                                     )
//                                                   ],
//                                                 )
//                                               : const Text(
//                                                   'Unpaid',
//                                                   style: TextStyle(
//                                                       color: Colors.grey),
//                                                 ),
//                                           IconButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           MultiBlocProvider(
//                                                             providers: [
//                                                               BlocProvider(
//                                                                 create: (context) =>
//                                                                     CategoryBloc(
//                                                                         FirebaseExpenseReport()),
//                                                               ),
//                                                               BlocProvider(
//                                                                 create: (context) =>
//                                                                     BillsBloc(
//                                                                         FirebaseExpenseReport()),
//                                                               ),
//                                                             ],
//                                                             child:
//                                                                 EditBillsScreen(
//                                                                     bill: bill),
//                                                           ))).then((_) {
//                                                 billsBloc.add(LoadBills());
//                                               });
//                                             },
//                                             icon: Icon(
//                                               Icons.edit,
//                                               color: Colors.grey.shade500,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         children: [
//                                           Stack(
//                                             alignment: Alignment.center,
//                                             children: [
//                                               Container(
//                                                 width: 50,
//                                                 height: 50,
//                                                 decoration: BoxDecoration(
//                                                     color: Colors.grey.shade200,
//                                                     shape: BoxShape.circle),
//                                               ),
//                                               Image.asset(
//                                                 'assets/${bill.category.icon}.png',
//                                                 scale: 2,
//                                               )
//                                             ],
//                                           ),
//                                           Text(
//                                             bill.name,
//                                             style: TextStyle(fontSize: 24),
//                                           ),
//                                           Container(
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(15),
//                                                 color:
//                                                     Color(bill.category.color)),
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 2.0,
//                                                       horizontal: 7),
//                                               child: Text(
//                                                 bill.category.name,
//                                                 style: TextStyle(
//                                                     fontSize: 10,
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                         Colors.grey.shade700),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             '₹' + bill.amount.toString(),
//                                             style: TextStyle(
//                                                 fontSize: 30,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Column(
//                                             children: [
//                                               Text(
//                                                 'Due On',
//                                                 style: TextStyle(
//                                                     fontSize: 18,
//                                                     color:
//                                                         Colors.grey.shade600),
//                                               ),
//                                               Text(DateFormat('dd/MM/yyyy')
//                                                   .format(bill.date)),
//                                               Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   bill.remind
//                                                       ? Icon(
//                                                           Icons.notifications,
//                                                           color: Colors
//                                                               .grey.shade500,
//                                                         )
//                                                       : Icon(
//                                                           Icons
//                                                               .notifications_off_sharp,
//                                                           color: Colors
//                                                               .grey.shade500,
//                                                         ),
//                                                   const SizedBox(
//                                                     width: 20,
//                                                   ),
//                                                   _frequencies.contains(
//                                                           bill.frequency)
//                                                       ? Column(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Icon(
//                                                               CupertinoIcons
//                                                                   .repeat,
//                                                               color: Colors.grey
//                                                                   .shade500,
//                                                             ),
//                                                             const SizedBox(
//                                                               width: 5,
//                                                             ),
//                                                             Text(
//                                                               bill.frequency,
//                                                               style: TextStyle(
//                                                                   fontSize: 10),
//                                                             )
//                                                           ],
//                                                         )
//                                                       : Stack(
//                                                           alignment:
//                                                               Alignment.center,
//                                                           children: [
//                                                             Icon(
//                                                               CupertinoIcons
//                                                                   .repeat,
//                                                               color: Colors.grey
//                                                                   .shade500,
//                                                             ),
//                                                             Positioned(
//                                                               child: Transform
//                                                                   .rotate(
//                                                                 angle:
//                                                                     0.785398, // Rotate by -45 degrees (in radians)
//                                                                 child:
//                                                                     Container(
//                                                                   width: 28.0,
//                                                                   height: 3.0,
//                                                                   color: Colors
//                                                                       .grey
//                                                                       .shade500,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         )
//                                                 ],
//                                               )
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                       bill.note.toString().isNotEmpty
//                                           ? Padding(
//                                               padding: const EdgeInsets.all(10),
//                                               child: Text(
//                                                 bill.note.toString(),
//                                                 style: TextStyle(
//                                                     fontSize: 14,
//                                                     color:
//                                                         Colors.grey.shade600),
//                                               ),
//                                             )
//                                           : SizedBox(
//                                               height: 20,
//                                             )
//                                     ],
//                                   ),
//                                 );
//                               });
//                         },
//                         child: Slidable(
//                           key: Key(bill.billId),
//                           startActionPane: ActionPane(
//                               motion: const StretchMotion(),
//                               extentRatio: 0.3,
//                               children: [
//                                 SlidableAction(
//                                   onPressed: (context) {
//                                     context
//                                         .read<BillsBloc>()
//                                         .add(MarkBillPaid(bill));
//                                   },
//                                   icon: Icons.done,
//                                   backgroundColor: Colors.green,
//                                   borderRadius: BorderRadius.circular(12),
//                                 )
//                               ]),
//                           endActionPane: ActionPane(
//                               motion: const StretchMotion(),
//                               extentRatio: 0.3,
//                               children: [
//                                 SlidableAction(
//                                   onPressed: (context) {
//                                     context
//                                         .read<BillsBloc>()
//                                         .add(DeleteBill(bill.billId));
//                                   },
//                                   icon: Icons.delete,
//                                   backgroundColor: Colors.red,
//                                   borderRadius: BorderRadius.circular(12),
//                                 )
//                               ]),
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12)),
//                             child: Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Container(
//                                             width: 50,
//                                             height: 50,
//                                             decoration: BoxDecoration(
//                                                 color: Colors.grey.shade200,
//                                                 shape: BoxShape.circle),
//                                           ),
//                                           Image.asset(
//                                             'assets/${bill.category.icon}.png',
//                                             scale: 2,
//                                           )
//                                         ],
//                                       ),
//                                       const SizedBox(
//                                         width: 12,
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             bill.name,
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Theme.of(context)
//                                                     .colorScheme
//                                                     .onBackground),
//                                           ),
//                                           Container(
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(15),
//                                                 color:
//                                                     Color(bill.category.color)),
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 2.0,
//                                                       horizontal: 7),
//                                               child: Text(
//                                                 bill.category.name,
//                                                 style: TextStyle(
//                                                     fontSize: 8,
//                                                     fontWeight: FontWeight.w500,
//                                                     color:
//                                                         Colors.grey.shade700),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Text('₹${bill.amount}',
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.black)),
//                                       Text(
//                                         'Due on  ' +
//                                             DateFormat('dd/MM/yyyy')
//                                                 .format(bill.date),
//                                         style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w400,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .outline),
//                                       ),
//                                       bill.frequency != 'None'
//                                           ? Row(
//                                               children: [
//                                                 Icon(
//                                                   CupertinoIcons.repeat,
//                                                   size: 15,
//                                                   color: Colors.grey.shade500,
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 3,
//                                                 ),
//                                                 Text('${bill.frequency}',
//                                                     style: TextStyle(
//                                                         fontSize: 10,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         color: Colors
//                                                             .grey.shade500)),
//                                               ],
//                                             )
//                                           : Container()
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 )),
//               ],
//             );
//           } else if (state is BillsFailure) {
//             return Center(child: Text(state.message));
//           } else {
//             return const Center(child: Text('No expenses'));
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/bills_bloc/bills_bloc.dart';
import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:expense_tracker_project/screens/add_bills/views/add_bills.dart';
import 'package:expense_tracker_project/screens/add_bills/views/edit_bill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../blocs/category_bloc/category_bloc.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<BillsBloc>().add(LoadBills());
  }

  int days = 0;
  final List<String> _frequencies = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'None'
  ];

  @override
  Widget build(BuildContext context) {
    final billsBloc = BlocProvider.of<BillsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Padding(
          padding: EdgeInsets.only(left: 30.0, top: 20),
          child: Text(
            'Your Bills',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: BlocBuilder<BillsBloc, BillsState>(
        builder: (context, state) {
          if (state is BillsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BillsLoaded) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: state.bills.length,
                  itemBuilder: (context, index) {
                    final bill = state.bills[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16.0, left: 15, right: 15),
                      child: GestureDetector(
                        onTap: () {
                          Slidable.of(context)?.close();
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          bill.isPaid
                                              ? const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.done_rounded,
                                                      color: Colors.green,
                                                    ),
                                                    Text(
                                                      'Paid',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  ],
                                                )
                                              : const Text(
                                                  'Unpaid',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MultiBlocProvider(
                                                            providers: [
                                                              BlocProvider(
                                                                create: (context) =>
                                                                    CategoryBloc(
                                                                        FirebaseExpenseReport()),
                                                              ),
                                                              BlocProvider(
                                                                create: (context) =>
                                                                    BillsBloc(
                                                                        FirebaseExpenseReport()),
                                                              ),
                                                            ],
                                                            child:
                                                                EditBillsScreen(
                                                                    bill: bill),
                                                          ))).then((_) {
                                                billsBloc.add(LoadBills());
                                              });
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    shape: BoxShape.circle),
                                              ),
                                              Image.asset(
                                                'assets/${bill.category.icon}.png',
                                                scale: 2,
                                              )
                                            ],
                                          ),
                                          Text(
                                            bill.name,
                                            style: TextStyle(fontSize: 24),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                    Color(bill.category.color)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 7),
                                              child: Text(
                                                bill.category.name,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Colors.grey.shade700),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '₹' + bill.amount.toString(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Due On',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                              Text(DateFormat('dd/MM/yyyy')
                                                  .format(bill.date)),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  bill.remind
                                                      ? Icon(
                                                          Icons.notifications,
                                                          color: Colors
                                                              .grey.shade500,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .notifications_off_sharp,
                                                          color: Colors
                                                              .grey.shade500,
                                                        ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  _frequencies.contains(
                                                          bill.frequency)
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .repeat,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              bill.frequency,
                                                              style: TextStyle(
                                                                  fontSize: 10),
                                                            )
                                                          ],
                                                        )
                                                      : Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .repeat,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                            Positioned(
                                                              child: Transform
                                                                  .rotate(
                                                                angle:
                                                                    0.785398, // Rotate by -45 degrees (in radians)
                                                                child:
                                                                    Container(
                                                                  width: 28.0,
                                                                  height: 3.0,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      bill.note.toString().isNotEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                bill.note.toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                            )
                                          : SizedBox(
                                              height: 20,
                                            )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Slidable(
                          key: Key(bill.billId),
                          startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.3,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    context
                                        .read<BillsBloc>()
                                        .add(UpdatePaidStatus(bill));
                                  },
                                  icon: bill.isPaid ? Icons.close : Icons.done,
                                  backgroundColor:
                                      bill.isPaid ? Colors.red : Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                )
                              ]),
                          endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              extentRatio: 0.3,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    context
                                        .read<BillsBloc>()
                                        .add(DeleteBill(bill.billId));
                                  },
                                  icon: Icons.delete,
                                  backgroundColor: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                )
                              ]),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: bill.isPaid
                                                    ? Colors.green
                                                    : Colors.grey.shade200,
                                                shape: BoxShape.circle),
                                          ),
                                          !bill.isPaid
                                              ? Image.asset(
                                                  'assets/${bill.category.icon}.png',
                                                  scale: 2,
                                                )
                                              : Icon(
                                                  Icons.done_rounded,
                                                  color: Colors.white,
                                                )
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bill.name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                    Color(bill.category.color)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 7),
                                              child: Text(
                                                bill.category.name,
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        Colors.grey.shade700),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('₹${bill.amount}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      Text(
                                        'Due on  ' +
                                            DateFormat('dd/MM/yyyy')
                                                .format(bill.date),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
                                      ),
                                      bill.frequency != 'None'
                                          ? Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.repeat,
                                                  size: 15,
                                                  color: Colors.grey.shade500,
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text('${bill.frequency}',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors
                                                            .grey.shade500)),
                                              ],
                                            )
                                          : Container()
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ],
            );
          } else if (state is BillsFailure) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No expenses'));
          }
        },
      ),
    );
  }
}
