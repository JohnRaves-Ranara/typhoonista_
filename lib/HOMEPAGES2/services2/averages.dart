import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Day.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/entities2/new/Owner.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/services2/FirestoreService2.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';

class averages {
  //alldaysstream
  double getAverageDamagePerDay(List<Day> alldays) {
    Map<int, List<Day>> groupeddays = {};

    for (Day day in alldays) {
      groupeddays.putIfAbsent(day.dayNum!, () => []);
      groupeddays[day.dayNum]!.add(day);
    }

    List<double> totalOfAllDaysEachGroup = [];
    groupeddays.forEach((key, value) {
      double total = 0;
      for (Day day in value) {
        total += day.damageCost!;
      }
      totalOfAllDaysEachGroup.add(total);
    });

    print(totalOfAllDaysEachGroup);
    double total = 0;
    for (double num in totalOfAllDaysEachGroup) {
      total += num;
    }

    return total / groupeddays.length;
  }

  //alldaysstream
  double bruh(List<Day> days) {
    double total = 0;
    for (Day day in days) {
      total += day.damageCost!;
    }

    return total / days.length;
  }

  double avgDamageIncreasePerDay(List<Day> allDays) {
    double totalDamageIncrease = 0;

    // Iterate through each day
    for (int i = 1; i < allDays.length; i++) {
      // Calculate damage increase for each day and add it to the total
      double damageIncrease = allDays[i].damageCost! - allDays[i - 1].damageCost!;
      totalDamageIncrease += damageIncrease;
    }

    return totalDamageIncrease / (allDays.length - 1);
  }

  //streamallowners
  double avgDamagePerDayFormulaNiGerome(List<Owner> owners) {
    double allOwnersAvgDamagePerDayTotal = 0;

    owners.forEach((owner) {
      allOwnersAvgDamagePerDayTotal +=
          (owner.totalDamageCost / owner.daysCount!);
    });

    return allOwnersAvgDamagePerDayTotal / owners.length;
  }
}
