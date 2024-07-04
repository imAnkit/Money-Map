import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_project/blocs/expense_bloc/expense_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseChart extends StatefulWidget {
  const ExpenseChart({super.key});

  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpenseLoaded) {
          final expenses =
              state.expenses.where((expense) => expense.isExpense).toList();
          return SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMMd(),
              axisLine: const AxisLine(width: 0),
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
            ),
            primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                numberFormat:
                    NumberFormat.currency(decimalDigits: 0, symbol: '₹')),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                final Expense expense = data;
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(expense.category.name.toString(),
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(
                        width: 120,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat.MMMd().format(expense.date),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Text('  :  ',
                              style: TextStyle(color: Colors.white)),
                          Text('+₹${expense.amount}',
                              style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            legend: const Legend(isVisible: false),
            series: [
              AreaSeries<Expense, DateTime>(
                dataSource: expenses,
                // borderRadius:
                //     const BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary,
                ], transform: const GradientRotation(3.14 / 40)),
                xValueMapper: (Expense expense, _) => expense.date,
                yValueMapper: (Expense expense, _) => expense.amount,
                // width: 0.08,
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('Error Loading Invome'),
          );
        }
      },
    );
  }
}

class IncomeChart extends StatefulWidget {
  const IncomeChart({super.key});

  @override
  State<IncomeChart> createState() => _IncomeChartState();
}

class _IncomeChartState extends State<IncomeChart> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpenseLoaded) {
          final expenses =
              state.expenses.where((expense) => !expense.isExpense).toList();
          return SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.MMMd(),
              axisLine: const AxisLine(width: 0),
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
            ),
            primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                numberFormat:
                    NumberFormat.currency(decimalDigits: 0, symbol: '₹')),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                final Expense expense = data;
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(expense.category.name.toString(),
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(
                        width: 120,
                        child: Divider(
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat.MMMd().format(expense.date),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Text('  :  ',
                              style: TextStyle(color: Colors.white)),
                          Text('+₹${expense.amount}',
                              style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            legend: const Legend(isVisible: false),
            series: [
              AreaSeries<Expense, DateTime>(
                dataSource: expenses,
                // borderRadius:
                //     const BorderRadius.vertical(top: Radius.circular(12)),
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary,
                ], transform: const GradientRotation(3.14 / 40)),
                xValueMapper: (Expense expense, _) => expense.date,
                yValueMapper: (Expense expense, _) => expense.amount,
                // width: 0.03,
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('Error Loading Invome'),
          );
        }
      },
    );
  }
}
