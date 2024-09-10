import 'package:sqlparser/sqlparser.dart';

class SqlUtil{
  static final engine = SqlEngine();

  static String formatMybatis(String sql){
    sql = """
select a1 from
(
    select * from a where b = 1 order by f
) c
where d like '%1%' order by e desc

""";
    AnalysisContext context  = engine.analyze(sql);
    final select = context.root as SelectStatement;
    print(select.orderBy.toString() + "123");
    // parseResult.rootNode.
    return "";
  }
}