import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tech_finances/database/historico/historico_model.dart';

class Grafico1 extends StatefulWidget {
  final Map<String, List<HistoricoModel>> dadosPorMes;

  const Grafico1({Key? key, required this.dadosPorMes}) : super(key: key);

  @override
  Grafico1State createState() => Grafico1State();
}

class Grafico1State extends State<Grafico1> {
  Set<DateTime> datas = {};
  List<DateTime> datasList = [];
  DateTime? data1;
  DateTime? data2;

  List<SplineSeries<Balanco, DateTime>> _getData() {
    final List<Balanco> chartData = _processData();

    return <SplineSeries<Balanco, DateTime>>[
      SplineSeries<Balanco, DateTime>(
        dataSource: chartData,
        xValueMapper: (Balanco sales, _) => sales.data,
        yValueMapper: (Balanco sales, _) => sales.valor,
        markerSettings: const MarkerSettings(
          isVisible: true,
        ),
      )
    ];
  }

  List<Balanco> _processData() {
    List<Balanco> balancoData = [];
    widget.dadosPorMes.forEach((mesAno, historicoList) {
      DateFormat formati = DateFormat('MM/yyyy');
      DateTime date = formati.parse(mesAno);

      datas.add(date);
      double total = 0;
      for (var historico in historicoList) {
        if (historico.tipo == 'RECEITA') {
          total += historico.valor!;
        } else {
          total -= historico.valor!;
        }
      }
      DateFormat format = DateFormat('MM/yyyy');
      DateTime data = format.parse(mesAno);

      balancoData.add(Balanco(data: data, valor: total));
    });
    datasList = datas.toList();
    if (datasList.isNotEmpty) {
      data1 = DateTime(datasList.first.year, datasList.first.month, 1);
      data2 = DateTime(datasList.last.year, datasList.last.month + 1, 0);
    }

    setState(() {});
    return balancoData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SfCartesianChart(
          title: ChartTitle(text: 'Evolução Patrimonial'),
          primaryYAxis: NumericAxis(
            interval: 50, // Define o intervalo entre os valores
            // Outras configurações do eixo Y, se necessário
          ),
          primaryXAxis: DateTimeAxis(
            minimum: data1,
            maximum: data2,
            intervalType: DateTimeIntervalType.months,
            majorGridLines: const MajorGridLines(width: 0),
            dateFormat: DateFormat('MM/yy'),
          ),
          series: _getData(),
        ),
      ),
    );
  }
}

class Balanco {
  final DateTime data;
  final double valor;

  Balanco({required this.data, required this.valor});
}
