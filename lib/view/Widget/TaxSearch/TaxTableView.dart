import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/Colorapp.dart';
import '../../../data/model/TaxArticleModel.dart';
import 'TaxTableEditor.dart' show TaxTableColors;

/// أبعاد أعمدة وصفوف الجدول محسوبة بقياس النصوص عبر TextPainter
/// (بدون intrinsic layout)، ومشتركة بين العرض والتعديل.
class TaxTableLayout {
  static const double padH = 12;
  static const double padV = 12;

  final List<double> colWidths;
  final List<double> rowHeights;
  final List<double> colX;
  final List<double> rowY;

  TaxTableLayout._(this.colWidths, this.rowHeights)
      : colX = _prefix(colWidths),
        rowY = _prefix(rowHeights);

  double get width => colX.last;
  double get height => rowY.last;

  static List<double> _prefix(List<double> v) {
    final out = <double>[0];
    for (final x in v) {
      out.add(out.last + x);
    }
    return out;
  }

  static TextStyle textStyle(bool header) => TextStyle(
        fontSize: 13.5,
        height: 1.55,
        color: header ? TaxTableColors.headerText : Colors.black87,
        fontWeight: header ? FontWeight.bold : FontWeight.normal,
      );

  static TaxTableLayout compute(
    TaxArticleTable table,
    TextDirection direction, {
    double minCol = 110,
    double maxCol = 320,
    double minRow = 44,
    double maxRow = double.infinity,
  }) {
    final painter = TextPainter(textDirection: direction);
    Size measure(TaxTableCell c, double? maxWidth) {
      painter.text = TextSpan(
          text: c.text.isEmpty ? ' ' : c.text, style: textStyle(c.isHeader));
      painter.layout(maxWidth: maxWidth ?? double.infinity);
      return painter.size;
    }

    final cols = List<double>.filled(table.nCols, minCol);
    for (final c in table.cells) {
      if (c.colSpan != 1) continue;
      final w = measure(c, null).width + padH * 2 + 4;
      cols[c.col] = math.max(cols[c.col], math.min(w, maxCol));
    }

    double spanWidth(TaxTableCell c) {
      double w = 0;
      for (int k = c.col; k < c.col + c.colSpan; k++) {
        w += cols[k];
      }
      return w;
    }

    final rows = List<double>.filled(table.nRows, minRow);
    for (final c in table.cells) {
      if (c.rowSpan != 1) continue;
      final h = measure(c, spanWidth(c) - padH * 2 - 4).height + padV * 2;
      rows[c.row] = math.max(rows[c.row], math.min(h, maxRow));
    }
    // الخلية المدمجة عمودياً: إذا لم تكفها الصفوف نزيد آخر صف فيها
    for (final c in table.cells) {
      if (c.rowSpan == 1) continue;
      final h = math.min(
          measure(c, spanWidth(c) - padH * 2 - 4).height + padV * 2, maxRow);
      double have = 0;
      for (int r = c.row; r < c.row + c.rowSpan; r++) {
        have += rows[r];
      }
      if (h > have) rows[c.row + c.rowSpan - 1] += h - have;
    }
    painter.dispose();
    return TaxTableLayout._(cols, rows);
  }

  Rect rectOf(TaxTableCell c) => Rect.fromLTWH(
        colX[c.col],
        rowY[c.row],
        colX[c.col + c.colSpan] - colX[c.col],
        rowY[c.row + c.rowSpan] - rowY[c.row],
      );
}

/// عرض جدول مادة للقراءة فقط، مع الخلايا المدمجة كخلية واحدة
class TaxTableView extends StatefulWidget {
  final TaxArticleTable table;
  final int index;
  final bool showTitle;

  const TaxTableView({
    super.key,
    required this.table,
    required this.index,
    this.showTitle = true,
  });

  @override
  State<TaxTableView> createState() => _TaxTableViewState();
}

class _TaxTableViewState extends State<TaxTableView> {
  final ScrollController horizontalController = ScrollController();

  @override
  void dispose() {
    horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final table = widget.table;
    final layout = TaxTableLayout.compute(table, Directionality.of(context));

    final grid = Container(
      decoration: BoxDecoration(
        border: Border.all(color: TaxTableColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: layout.width,
        height: layout.height,
        child: Stack(
          children: [
            for (final cell in table.cells)
              PositionedDirectional(
                start: layout.rectOf(cell).left,
                top: layout.rectOf(cell).top,
                width: layout.rectOf(cell).width,
                height: layout.rectOf(cell).height,
                child: _cell(cell),
              ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showTitle) ...[
          Row(
            children: [
              const Icon(Icons.table_chart_outlined,
                  size: 18, color: AppColor.typography),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  table.title.isEmpty
                      ? '${'جدول'.tr} ${widget.index + 1}'
                      : table.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.typography,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Scrollbar(
          controller: horizontalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: horizontalController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 12),
            child: grid,
          ),
        ),
      ],
    );
  }

  Widget _cell(TaxTableCell cell) {
    final header = cell.isHeader;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: TaxTableLayout.padH, vertical: TaxTableLayout.padV),
      decoration: BoxDecoration(
        color: header
            ? TaxTableColors.header
            : cell.row.isOdd
                ? TaxTableColors.stripe
                : Colors.white,
        border: BorderDirectional(
          start: cell.col == 0
              ? BorderSide.none
              : const BorderSide(color: TaxTableColors.line),
          top: cell.row == 0
              ? BorderSide.none
              : BorderSide(
                  color: header ? Colors.white24 : TaxTableColors.line),
        ),
      ),
      alignment: header
          ? Alignment.center
          : AlignmentDirectional.centerStart,
      child: Text(
        cell.text,
        textAlign: header ? TextAlign.center : TextAlign.start,
        style: TaxTableLayout.textStyle(header),
      ),
    );
  }
}
