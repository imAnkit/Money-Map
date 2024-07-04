import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:expense_tracker_project/screens/stats/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StatsScreeen extends StatefulWidget {
  const StatsScreeen({super.key});

  @override
  _StatsScreeenState createState() => _StatsScreeenState();
}

class _StatsScreeenState extends State<StatsScreeen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 60,
          toolbarHeight: 60,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 212, 212, 212),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
          title: const Text(
            'Login And Security',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.tertiary,
                              ], transform: const GradientRotation(3.14 / 4))),
                          // indicatorColor: Colors.white,
                          dividerColor: Colors.white,
                          controller: _tabController,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: const [
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Income',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Expenses',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                          controller: _tabController,
                          children: const [IncomePage(), ExpensesPage()])),
                ],
              ),
            ),
          ),
        ));
  }
}

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 15, right: 15, bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                child: ExpenseChart(),
              ),
            ),
          ),
          // const SizedBox(
          //   height: 0,
          // ),
          BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
            if (state is ExpenseLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ExpenseLoaded) {
              final List<Expense> expenses =
                  state.expenses.where((expense) => expense.isExpense).toList();
              return Expanded(
                  child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (context, int i) {
                  final expense = expenses[i];
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 10,
                      left: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          color: Color(expense.category.color),
                                          shape: BoxShape.circle),
                                    ),
                                    Image.asset(
                                      'assets/${expense.category.icon}.png',
                                      scale: 2,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  expense.category.name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    expense.isExpense
                                        ? const Text(
                                            '-',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : const Text(
                                            '+',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                    Icon(
                                      Icons.currency_rupee,
                                      size: 14,
                                      color: expense.isExpense
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                    Text(
                                      '${expense.amount}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: expense.isExpense
                                              ? Colors.red
                                              : Colors.green),
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(expense.date),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
            } else if (state is ExpenseError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No expenses'));
            }
          })
        ],
      ),
    );
  }
}

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 15, right: 15, bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                child: IncomeChart(),
              ),
            ),
          ),
          BlocBuilder<ExpenseBloc, ExpenseState>(builder: (context, state) {
            if (state is ExpenseLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ExpenseLoaded) {
              final List<Expense> expenses = state.expenses
                  .where((expense) => !expense.isExpense)
                  .toList();
              return Expanded(
                  child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (context, int i) {
                  final expense = expenses[i];
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 10,
                      left: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          color: Color(expense.category.color),
                                          shape: BoxShape.circle),
                                    ),
                                    Image.asset(
                                      'assets/${expense.category.icon}.png',
                                      scale: 2,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  expense.category.name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    expense.isExpense
                                        ? const Text(
                                            '-',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : const Text(
                                            '+',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                    Icon(
                                      Icons.currency_rupee,
                                      size: 14,
                                      color: expense.isExpense
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                    Text(
                                      '${expense.amount}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: expense.isExpense
                                              ? Colors.red
                                              : Colors.green),
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(expense.date),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
            } else if (state is ExpenseError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No expenses'));
            }
          })
        ],
      ),
    );
  }
}
