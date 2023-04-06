import 'package:isar/isar.dart';

part 'report_template.g.dart';

@collection
class ReportTemplate {
  final Id id = Isar.autoIncrement;
  String? text;

  ReportTemplate({required this.text});

  // DATABASE-------------------------

  static Future<List<ReportTemplate>> getAll() async {
    final isar = Isar.getInstance("reportTemplate_db") ??
        await Isar.open([ReportTemplateSchema], name: "reportTemplate_db");
    return await isar.reportTemplates.where().findAll();
  }

  static Future<int> save(ReportTemplate reportTemplate) async {
    final isar = Isar.getInstance("reportTemplate_db") ??
        await Isar.open([ReportTemplateSchema], name: "reportTemplate_db");

    return await isar.writeTxn(() => isar.reportTemplates.put(reportTemplate));
  }

  static Future<bool> delete(int id) async {
    final isar = Isar.getInstance("reportTemplate_db") ??
        await Isar.open([ReportTemplateSchema], name: "reportTemplate_db");

    return await isar.writeTxn(() => isar.reportTemplates.delete(id));
  }
}
