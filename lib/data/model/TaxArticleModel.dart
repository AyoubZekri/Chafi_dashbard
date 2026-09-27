int? _toInt(dynamic v) => v == null ? null : int.tryParse(v.toString());

bool _toBool(dynamic v) => v == true || v.toString() == '1';

class TaxArticleModel {
  final int id;
  final int documentId;
  final int? nodeId;
  final String part;
  final String label;
  final String? number;
  final int? numberInt;
  final int sortOrder;
  final String text;
  final bool isRepealed;
  final int? pageStart;
  final int? pageEnd;
  final String? documentTitle;
  final String? nodeLabel;
  final List<String> notes;
  final List<TaxArticleTable> tables;
  final DateTime updatedAt;

  TaxArticleModel({
    required this.id,
    required this.documentId,
    this.nodeId,
    required this.part,
    required this.label,
    this.number,
    this.numberInt,
    required this.sortOrder,
    required this.text,
    required this.isRepealed,
    this.pageStart,
    this.pageEnd,
    this.documentTitle,
    this.nodeLabel,
    required this.notes,
    required this.tables,
    required this.updatedAt,
  });

  int get tablesCount => tables.length;

  factory TaxArticleModel.fromJson(Map<String, dynamic> json) {
    final document = json['document'];
    final node = json['node'];
    final notes = json['notes'];
    final tables = json['tables'];
    return TaxArticleModel(
      id: _toInt(json['id'])!,
      documentId: _toInt(json['document_id']) ?? 0,
      nodeId: _toInt(json['node_id']),
      part: json['part'] ?? 'code',
      label: json['label'] ?? '',
      number: json['number']?.toString(),
      numberInt: _toInt(json['number_int']),
      sortOrder: _toInt(json['sort_order']) ?? 0,
      text: json['text'] ?? '',
      isRepealed: _toBool(json['is_repealed']),
      pageStart: _toInt(json['page_start']),
      pageEnd: _toInt(json['page_end']),
      documentTitle: document is Map ? document['title_ar'] : null,
      nodeLabel: node is Map
          ? [node['label'], node['title']]
              .where((e) => e != null && e.toString().isNotEmpty)
              .join(' - ')
          : null,
      notes: notes is List
          ? notes.map((e) => (e is Map ? e['text'] : e).toString()).toList()
          : [],
      tables: tables is List
          ? (tables
              .whereType<Map>()
              .map((e) => TaxArticleTable.fromJson(
                  Map<String, dynamic>.from(e)))
              .toList()
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)))
          : [],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}

class TaxTableCell {
  int row;
  int col;
  int rowSpan;
  int colSpan;
  bool isHeader;
  String text;

  TaxTableCell({
    required this.row,
    required this.col,
    this.rowSpan = 1,
    this.colSpan = 1,
    this.isHeader = false,
    this.text = '',
  });

  bool get isMerged => rowSpan > 1 || colSpan > 1;

  bool covers(int r, int c) =>
      r >= row && r < row + rowSpan && c >= col && c < col + colSpan;

  factory TaxTableCell.fromJson(Map<String, dynamic> json) {
    return TaxTableCell(
      row: _toInt(json['row_idx']) ?? 0,
      col: _toInt(json['col_idx']) ?? 0,
      rowSpan: _toInt(json['row_span']) ?? 1,
      colSpan: _toInt(json['col_span']) ?? 1,
      isHeader: _toBool(json['is_header']),
      text: json['text']?.toString() ?? '',
    );
  }

  TaxTableCell copy() => TaxTableCell(
        row: row,
        col: col,
        rowSpan: rowSpan,
        colSpan: colSpan,
        isHeader: isHeader,
        text: text,
      );

  Map<String, dynamic> toJson() => {
        'row_idx': row,
        'col_idx': col,
        'row_span': rowSpan,
        'col_span': colSpan,
        'is_header': isHeader ? 1 : 0,
        'text': text,
      };
}

/// جدول مرفق بمادة. الخلايا المدمجة تُخزَّن كخلية واحدة (anchor) مع
/// row_span/col_span، والمواضع التي تغطيها لا تملك خلايا خاصة بها.
class TaxArticleTable {
  int sortOrder;
  String title;
  int? pageStart;
  int? pageEnd;
  int nRows;
  int nCols;
  List<TaxTableCell> cells;

  TaxArticleTable({
    this.sortOrder = 0,
    this.title = '',
    this.pageStart,
    this.pageEnd,
    required this.nRows,
    required this.nCols,
    required this.cells,
  });

  factory TaxArticleTable.empty({int rows = 3, int cols = 3}) {
    final table = TaxArticleTable(nRows: rows, nCols: cols, cells: []);
    table.normalize();
    table.setRowHeader(0, true);
    return table;
  }

  factory TaxArticleTable.fromJson(Map<String, dynamic> json) {
    final cellsJson = json['cells'];
    final cells = cellsJson is List
        ? cellsJson
            .whereType<Map>()
            .map((e) => TaxTableCell.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <TaxTableCell>[];

    // إذا كانت n_rows/n_cols غير دقيقة نحسبها من الخلايا
    int rows = _toInt(json['n_rows']) ?? 0;
    int cols = _toInt(json['n_cols']) ?? 0;
    for (final c in cells) {
      if (c.row + c.rowSpan > rows) rows = c.row + c.rowSpan;
      if (c.col + c.colSpan > cols) cols = c.col + c.colSpan;
    }

    final table = TaxArticleTable(
      sortOrder: _toInt(json['sort_order']) ?? 0,
      title: json['title']?.toString() ?? '',
      pageStart: _toInt(json['page_start']),
      pageEnd: _toInt(json['page_end']),
      nRows: rows,
      nCols: cols,
      cells: cells,
    );
    table.normalize();
    return table;
  }

  TaxArticleTable copy() => TaxArticleTable(
        sortOrder: sortOrder,
        title: title,
        pageStart: pageStart,
        pageEnd: pageEnd,
        nRows: nRows,
        nCols: nCols,
        cells: cells.map((c) => c.copy()).toList(),
      );

  Map<String, dynamic> toJson(int order) {
    normalize();
    return {
      'sort_order': order,
      'title': title.trim().isEmpty ? null : title.trim(),
      'n_rows': nRows,
      'n_cols': nCols,
      'page_start': pageStart,
      'page_end': pageEnd,
      'cells': cells.map((c) => c.toJson()).toList(),
    };
  }

  /// الخلية التي تبدأ في هذا الموضع (null إذا كان الموضع مغطى أو فارغ)
  TaxTableCell? anchorAt(int r, int c) {
    for (final cell in cells) {
      if (cell.row == r && cell.col == c) return cell;
    }
    return null;
  }

  /// الخلية التي تغطي هذا الموضع (سواء كانت تبدأ فيه أم لا)
  TaxTableCell? cellCovering(int r, int c) {
    for (final cell in cells) {
      if (cell.covers(r, c)) return cell;
    }
    return null;
  }

  bool isRowHeader(int r) {
    final rowCells = cells.where((c) => c.row == r);
    return rowCells.isNotEmpty && rowCells.every((c) => c.isHeader);
  }

  /// يقص الامتدادات الخارجة عن الحدود، يحذف الخلايا المتداخلة،
  /// ويملأ المواضع الفارغة بخلايا جديدة.
  void normalize() {
    if (nRows < 1) nRows = 1;
    if (nCols < 1) nCols = 1;
    cells.removeWhere(
        (c) => c.row < 0 || c.col < 0 || c.row >= nRows || c.col >= nCols);
    cells.sort((a, b) =>
        a.row != b.row ? a.row.compareTo(b.row) : a.col.compareTo(b.col));

    final covered = List.generate(nRows, (_) => List.filled(nCols, false));
    final kept = <TaxTableCell>[];
    for (final c in cells) {
      if (covered[c.row][c.col]) continue;
      c.rowSpan = c.rowSpan.clamp(1, nRows - c.row);
      c.colSpan = c.colSpan.clamp(1, nCols - c.col);
      // تقليص الامتداد إذا اصطدم بخلية سابقة
      while (c.colSpan > 1 &&
          _anyCovered(covered, c.row, c.col, c.rowSpan, c.colSpan)) {
        c.colSpan--;
      }
      while (c.rowSpan > 1 &&
          _anyCovered(covered, c.row, c.col, c.rowSpan, c.colSpan)) {
        c.rowSpan--;
      }
      for (int r = c.row; r < c.row + c.rowSpan; r++) {
        for (int k = c.col; k < c.col + c.colSpan; k++) {
          covered[r][k] = true;
        }
      }
      kept.add(c);
    }

    for (int r = 0; r < nRows; r++) {
      for (int k = 0; k < nCols; k++) {
        if (!covered[r][k]) {
          final rowHeader = kept.any((c) => c.row == r && c.isHeader);
          kept.add(TaxTableCell(row: r, col: k, isHeader: rowHeader));
        }
      }
    }
    kept.sort((a, b) =>
        a.row != b.row ? a.row.compareTo(b.row) : a.col.compareTo(b.col));
    cells = kept;
  }

  static bool _anyCovered(
      List<List<bool>> covered, int row, int col, int rowSpan, int colSpan) {
    for (int r = row; r < row + rowSpan; r++) {
      for (int k = col; k < col + colSpan; k++) {
        if (covered[r][k]) return true;
      }
    }
    return false;
  }

  void insertRow(int at) {
    for (final c in cells) {
      if (c.row >= at) {
        c.row++;
      } else if (c.row + c.rowSpan > at) {
        c.rowSpan++;
      }
    }
    nRows++;
    normalize();
  }

  void removeRow(int r) {
    if (nRows <= 1) return;
    cells.removeWhere((c) => c.row == r && c.rowSpan == 1);
    for (final c in cells) {
      if (c.row == r) {
        c.rowSpan--; // الخلية المدمجة تنتقل للصف التالي
      } else if (c.row < r && c.row + c.rowSpan > r) {
        c.rowSpan--;
      } else if (c.row > r) {
        c.row--;
      }
    }
    nRows--;
    normalize();
  }

  void insertColumn(int at) {
    for (final c in cells) {
      if (c.col >= at) {
        c.col++;
      } else if (c.col + c.colSpan > at) {
        c.colSpan++;
      }
    }
    nCols++;
    normalize();
  }

  void removeColumn(int k) {
    if (nCols <= 1) return;
    cells.removeWhere((c) => c.col == k && c.colSpan == 1);
    for (final c in cells) {
      if (c.col == k) {
        c.colSpan--;
      } else if (c.col < k && c.col + c.colSpan > k) {
        c.colSpan--;
      } else if (c.col > k) {
        c.col--;
      }
    }
    nCols--;
    normalize();
  }

  void setRowHeader(int r, bool value) {
    for (final c in cells) {
      if (c.row == r) c.isHeader = value;
    }
  }

  void unmerge(TaxTableCell cell) {
    cell.rowSpan = 1;
    cell.colSpan = 1;
    normalize();
  }

  /// الخلايا التي سيتم دمجها مع [cell] أفقياً، أو null إذا كان الدمج غير ممكن
  List<TaxTableCell>? _mergeTargets(TaxTableCell cell, {required bool across}) {
    final targets = <TaxTableCell>{};
    if (across) {
      final k = cell.col + cell.colSpan;
      if (k >= nCols) return null;
      for (int r = cell.row; r < cell.row + cell.rowSpan; r++) {
        final t = cellCovering(r, k);
        if (t == null) return null;
        targets.add(t);
      }
      for (final t in targets) {
        if (t.col != k ||
            t.row < cell.row ||
            t.row + t.rowSpan > cell.row + cell.rowSpan ||
            t.colSpan != targets.first.colSpan) {
          return null;
        }
      }
    } else {
      final r = cell.row + cell.rowSpan;
      if (r >= nRows) return null;
      for (int k = cell.col; k < cell.col + cell.colSpan; k++) {
        final t = cellCovering(r, k);
        if (t == null) return null;
        targets.add(t);
      }
      for (final t in targets) {
        if (t.row != r ||
            t.col < cell.col ||
            t.col + t.colSpan > cell.col + cell.colSpan ||
            t.rowSpan != targets.first.rowSpan) {
          return null;
        }
      }
    }
    return targets.toList();
  }

  /// يوسّع المستطيل حتى يحتوي كل خلية مدمجة تتقاطع معه بالكامل
  ({int r1, int c1, int r2, int c2}) expandRange(
      int r1, int c1, int r2, int c2) {
    int top = r1 < r2 ? r1 : r2, bottom = r1 < r2 ? r2 : r1;
    int left = c1 < c2 ? c1 : c2, right = c1 < c2 ? c2 : c1;
    bool grew = true;
    while (grew) {
      grew = false;
      for (final c in cells) {
        final cBottom = c.row + c.rowSpan - 1;
        final cRight = c.col + c.colSpan - 1;
        final intersects = c.row <= bottom &&
            cBottom >= top &&
            c.col <= right &&
            cRight >= left;
        if (!intersects) continue;
        if (c.row < top) {
          top = c.row;
          grew = true;
        }
        if (cBottom > bottom) {
          bottom = cBottom;
          grew = true;
        }
        if (c.col < left) {
          left = c.col;
          grew = true;
        }
        if (cRight > right) {
          right = cRight;
          grew = true;
        }
      }
    }
    return (r1: top, c1: left, r2: bottom, c2: right);
  }

  /// الخلايا الموجودة داخل المستطيل (بعد توسيعه)
  List<TaxTableCell> cellsInRange(int r1, int c1, int r2, int c2) {
    final r = expandRange(r1, c1, r2, c2);
    return cells
        .where((c) =>
            c.row >= r.r1 && c.row <= r.r2 && c.col >= r.c1 && c.col <= r.c2)
        .toList();
  }

  /// يدمج كل الخلايا داخل المستطيل في خلية واحدة ويعيدها.
  /// نصوص الخلايا غير الفارغة تُجمع بالترتيب في الخلية الناتجة.
  TaxTableCell mergeRange(int r1, int c1, int r2, int c2) {
    final r = expandRange(r1, c1, r2, c2);
    final inside = cellsInRange(r.r1, r.c1, r.r2, r.c2)
      ..sort((a, b) =>
          a.row != b.row ? a.row.compareTo(b.row) : a.col.compareTo(b.col));
    final anchor = inside.first;
    anchor.text = inside
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .join(' ');
    anchor.rowSpan = r.r2 - r.r1 + 1;
    anchor.colSpan = r.c2 - r.c1 + 1;
    cells.removeWhere((c) => c != anchor && inside.contains(c));
    normalize();
    return anchor;
  }

  bool canMerge(TaxTableCell cell, {required bool across}) =>
      _mergeTargets(cell, across: across) != null;

  void merge(TaxTableCell cell, {required bool across}) {
    final targets = _mergeTargets(cell, across: across);
    if (targets == null) return;
    final extraText = targets
        .map((t) => t.text.trim())
        .where((t) => t.isNotEmpty)
        .join(' ');
    if (extraText.isNotEmpty) {
      cell.text = cell.text.trim().isEmpty ? extraText : '${cell.text} $extraText';
    }
    if (across) {
      cell.colSpan += targets.first.colSpan;
    } else {
      cell.rowSpan += targets.first.rowSpan;
    }
    cells.removeWhere((c) => targets.contains(c));
    normalize();
  }
}
