import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constant/Colorapp.dart';
import '../../../data/model/TaxArticleModel.dart';
import 'TaxTableView.dart';

/// ألوان مشتركة بين محرر الجدول وعرضه
class TaxTableColors {
  static const Color header = AppColor.typography;
  static const Color headerText = Colors.white;
  static const Color stripe = Color(0xFFF4F7FB);
  static const Color line = Color(0xFFDCE3EC);
  static const Color handle = Color(0xFFEEF2F7);
  static const Color handleText = Color(0xFF7A8699);
  static const Color bar = Color(0xFFF8FAFC);
}

/// محرر جدول واحد من جداول المادة.
///
/// الخلايا تُرسم كنص عادي وتُوضع بمواضع محسوبة مسبقاً (بدون قياس intrinsic)،
/// والخلية التي يتم النقر عليها فقط تتحول إلى حقل كتابة. هذا يبقي الواجهة
/// خفيفة حتى مع الجداول الكبيرة، ويسمح بعرض الخلايا المدمجة كخلية واحدة.
class TaxTableEditor extends StatefulWidget {
  final TaxArticleTable table;
  final int index;
  final int total;
  final VoidCallback onChanged;
  final VoidCallback onRemove;
  final void Function(int newIndex) onMove;

  const TaxTableEditor({
    super.key,
    required this.table,
    required this.index,
    required this.total,
    required this.onChanged,
    required this.onRemove,
    required this.onMove,
  });

  @override
  State<TaxTableEditor> createState() => _TaxTableEditorState();
}

class _TaxTableEditorState extends State<TaxTableEditor> {
  static const double _handleWidth = 42;
  static const double _handleHeight = 32;

  final ScrollController horizontalController = ScrollController();

  late bool editing;
  TaxTableCell? editingCell;

  // التحديد: نقر على خلية ثم Shift + نقر على خلية أخرى
  int? selRow, selCol, selEndRow, selEndCol;
  ({int r1, int c1, int r2, int c2})? _range;
  TextEditingController? editController;
  final FocusNode editFocus = FocusNode();

  // تُحسب الأبعاد في build عند الحاجة فقط (بعد تغيير هيكلي أو انتهاء كتابة)
  TaxTableLayout? _layout;

  TaxArticleTable get table => widget.table;

  @override
  void initState() {
    super.initState();
    // الجدول الجديد (فارغ) يفتح مباشرة في وضع التعديل، والموجود في وضع العرض
    editing = table.cells.every((c) => c.text.trim().isEmpty);
    editFocus.addListener(() {
      if (!editFocus.hasFocus) _finishEditing();
    });
  }

  @override
  void dispose() {
    horizontalController.dispose();
    editFocus.dispose();
    editController?.dispose();
    super.dispose();
  }

  // ============================ Layout ============================

  TaxTableLayout get layout => _layout ??= TaxTableLayout.compute(
        table,
        Directionality.of(context),
        minCol: 150,
        minRow: 48,
        maxRow: 240,
      );

  void _recomputeLayout() => _layout = null;

  // ============================ Actions ============================

  void _structural(VoidCallback change) {
    _finishEditing(notify: false);
    setState(() {
      _clearSelection();
      change();
      _recomputeLayout();
    });
    widget.onChanged();
  }

  // ============================ Selection ============================

  void _clearSelection() {
    selRow = selCol = selEndRow = selEndCol = null;
  }

  void _selectCell(TaxTableCell cell) {
    selRow = cell.row;
    selCol = cell.col;
    selEndRow = cell.row + cell.rowSpan - 1;
    selEndCol = cell.col + cell.colSpan - 1;
  }

  /// Shift + نقر: يمد التحديد من الخلية الأولى إلى هذه الخلية
  void _extendSelection(TaxTableCell cell) {
    _finishEditing(notify: false);
    setState(() {
      if (selRow == null) {
        _selectCell(cell);
      } else {
        selEndRow = cell.row + cell.rowSpan - 1;
        selEndCol = cell.col + cell.colSpan - 1;
      }
    });
  }

  ({int r1, int c1, int r2, int c2})? _computeRange() {
    if (selRow == null) return null;
    return table.expandRange(selRow!, selCol!, selEndRow!, selEndCol!);
  }

  int get _selectedCount {
    final r = _range;
    if (r == null) return 0;
    return table.cellsInRange(r.r1, r.c1, r.r2, r.c2).length;
  }

  bool _inRange(TaxTableCell cell) {
    final r = _range;
    return r != null &&
        cell.row >= r.r1 &&
        cell.row <= r.r2 &&
        cell.col >= r.c1 &&
        cell.col <= r.c2;
  }

  void _mergeSelection() {
    final r = _range;
    if (r == null) return;
    TaxTableCell? merged;
    _structural(() => merged = table.mergeRange(r.r1, r.c1, r.r2, r.c2));
    setState(() => _selectCell(merged!));
  }

  void _unmergeSelection() {
    final r = _range;
    if (r == null) return;
    _structural(() {
      for (final c in table.cellsInRange(r.r1, r.c1, r.r2, r.c2)) {
        c.rowSpan = 1;
        c.colSpan = 1;
      }
      table.normalize();
    });
  }

  void _onCellTap(TaxTableCell cell) {
    if (HardwareKeyboard.instance.isShiftPressed) {
      _extendSelection(cell);
    } else {
      _startEditing(cell);
    }
  }

  void _startEditing(TaxTableCell cell) {
    if (editingCell == cell) return;
    _finishEditing(notify: false);
    setState(() {
      _selectCell(cell);
      editingCell = cell;
      editController = TextEditingController(text: cell.text);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) editFocus.requestFocus();
    });
  }

  void _finishEditing({bool notify = true}) {
    if (editingCell == null) return;
    editingCell = null;
    final old = editController;
    editController = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => old?.dispose());
    if (notify && mounted) {
      setState(_recomputeLayout);
    } else {
      _recomputeLayout();
    }
  }

  /// الانتقال للخلية التالية/السابقة بزر Tab
  void _moveEditing(bool backwards) {
    final current = editingCell;
    if (current == null) return;
    final i = table.cells.indexOf(current); // الخلايا مرتبة صفاً بصف
    final next = i + (backwards ? -1 : 1);
    if (next >= 0 && next < table.cells.length) {
      _startEditing(table.cells[next]);
    }
  }

  Future<void> _openCellMenu(TaxTableCell cell, Offset globalPosition) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        globalPosition & const Size(1, 1),
        Offset.zero & overlay.size,
      ),
      items: [
        if (_selectedCount > 1 && _inRange(cell)) ...[
          _menuItem('merge_sel', Icons.merge_type,
              '${'دمج الخلايا المحددة'.tr} ($_selectedCount)'),
          const PopupMenuDivider(),
        ],
        _menuItem('header', Icons.title,
            cell.isHeader ? 'إلغاء خلية العنوان'.tr : 'جعلها خلية عنوان'.tr),
        const PopupMenuDivider(),
        _menuItem('across', Icons.swap_horiz, 'دمج مع الخلية المجاورة'.tr,
            enabled: table.canMerge(cell, across: true)),
        _menuItem('down', Icons.swap_vert, 'دمج مع الخلية بالأسفل'.tr,
            enabled: table.canMerge(cell, across: false)),
        if (cell.isMerged)
          _menuItem('unmerge', Icons.call_split, 'إلغاء الدمج'.tr),
        const PopupMenuDivider(),
        _menuItem('clear', Icons.backspace_outlined, 'مسح النص'.tr),
      ],
    );
    if (value == null) return;
    if (value == 'merge_sel') {
      _mergeSelection();
      return;
    }
    _structural(() {
      if (value == 'header') cell.isHeader = !cell.isHeader;
      if (value == 'across') table.merge(cell, across: true);
      if (value == 'down') table.merge(cell, across: false);
      if (value == 'unmerge') table.unmerge(cell);
      if (value == 'clear') cell.text = '';
    });
  }

  // ============================ Build ============================

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TaxTableColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          const Divider(height: 1, color: TaxTableColors.line),
          if (editing) ...[
            _buildToolbar(),
            _scrollable(_buildGrid()),
          ] else
            Padding(
              padding: const EdgeInsets.all(12),
              child: TaxTableView(
                  table: table, index: widget.index, showTitle: false),
            ),
        ],
      ),
    );
  }

  Widget _scrollable(Widget child) {
    return Scrollbar(
      controller: horizontalController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: horizontalController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        child: child,
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: TaxTableColors.bar,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.typography,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.table_chart_outlined,
                size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Text(
            '${'جدول'.tr} ${widget.index + 1}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.typography),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _smallField(
              key: ObjectKey(table),
              hint: 'عنوان الجدول (اختياري)'.tr,
              initialValue: table.title,
              onChanged: (v) {
                table.title = v;
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 95,
            child: _smallField(
              key: ValueKey('ps-${identityHashCode(table)}'),
              hint: 'من صفحة'.tr,
              initialValue: table.pageStart?.toString() ?? '',
              number: true,
              onChanged: (v) {
                table.pageStart = int.tryParse(v.trim());
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 95,
            child: _smallField(
              key: ValueKey('pe-${identityHashCode(table)}'),
              hint: 'إلى صفحة'.tr,
              initialValue: table.pageEnd?.toString() ?? '',
              number: true,
              onChanged: (v) {
                table.pageEnd = int.tryParse(v.trim());
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(width: 12),
          _modeSwitch(),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'تحريك للأعلى'.tr,
            icon: const Icon(Icons.keyboard_arrow_up),
            onPressed: widget.index > 0
                ? () => widget.onMove(widget.index - 1)
                : null,
          ),
          IconButton(
            tooltip: 'تحريك للأسفل'.tr,
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: widget.index < widget.total - 1
                ? () => widget.onMove(widget.index + 1)
                : null,
          ),
          IconButton(
            tooltip: 'حذف الجدول'.tr,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }

  Widget _modeSwitch() {
    Widget option(bool value, IconData icon, String label) {
      final selected = editing == value;
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (selected) return;
          _finishEditing(notify: false);
          setState(() => editing = value);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColor.typography : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected ? Colors.white : TaxTableColors.handleText),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : TaxTableColors.handleText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: TaxTableColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          option(false, Icons.visibility_outlined, 'عرض'.tr),
          option(true, Icons.edit_outlined, 'تعديل'.tr),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    Widget button(IconData icon, String label, VoidCallback onPressed) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.typography,
          side: const BorderSide(color: TaxTableColors.line),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      child: Row(
        children: [
          button(Icons.table_rows_outlined, 'إضافة صف'.tr,
              () => _structural(() => table.insertRow(table.nRows))),
          const SizedBox(width: 8),
          button(Icons.view_column_outlined, 'إضافة عمود'.tr,
              () => _structural(() => table.insertColumn(table.nCols))),
          const SizedBox(width: 8),
          _mergeButton(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'لدمج خلايا: انقر على خلية ثم Shift + نقر على خلية أخرى • Tab للخلية التالية'
                  .tr,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 12, color: TaxTableColors.handleText),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: TaxTableColors.handle,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${table.nRows} × ${table.nCols}',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: TaxTableColors.handleText),
            ),
          ),
        ],
      ),
    );
  }

  /// زر الدمج: يظهر "دمج" عند تحديد أكثر من خلية، و"إلغاء الدمج" لخلية مدمجة
  Widget _mergeButton() {
    _range = _computeRange();
    final count = _selectedCount;
    final r = _range;
    final singleMerged = count == 1 &&
        r != null &&
        table.anchorAt(r.r1, r.c1)?.isMerged == true;

    if (singleMerged) {
      return OutlinedButton.icon(
        onPressed: _unmergeSelection,
        icon: const Icon(Icons.call_split, size: 18),
        label: Text('إلغاء الدمج'.tr),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.orange.shade800,
          side: BorderSide(color: Colors.orange.shade200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: count > 1 ? _mergeSelection : null,
      icon: const Icon(Icons.merge_type, size: 18),
      label: Text(count > 1
          ? '${'دمج الخلايا'.tr} ($count)'
          : 'دمج الخلايا'.tr),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.typography,
        foregroundColor: Colors.white,
        disabledBackgroundColor: TaxTableColors.handle,
        disabledForegroundColor: TaxTableColors.handleText,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// شبكة الجدول: كل عنصر يوضع بموضع محسوب داخل Stack بحجم ثابت
  Widget _buildGrid() {
    final l = layout;
    _range = _computeRange();
    final multi = _selectedCount > 1;

    final children = <Widget>[
      const PositionedDirectional(
        start: 0,
        top: 0,
        width: _handleWidth,
        height: _handleHeight,
        child: ColoredBox(color: TaxTableColors.handle),
      ),
    ];

    // رؤوس الأعمدة
    for (int k = 0; k < table.nCols; k++) {
      children.add(PositionedDirectional(
        start: _handleWidth + l.colX[k],
        top: 0,
        width: l.colWidths[k],
        height: _handleHeight,
        child: _columnHandle(k),
      ));
    }

    // أرقام الصفوف
    for (int r = 0; r < table.nRows; r++) {
      children.add(PositionedDirectional(
        start: 0,
        top: _handleHeight + l.rowY[r],
        width: _handleWidth,
        height: l.rowHeights[r],
        child: _rowHandle(r),
      ));
    }

    // الخلايا (الخلية المدمجة تأخذ مساحة كل المواضع التي تغطيها)
    TaxTableCell? active;
    for (final cell in table.cells) {
      if (cell == editingCell) {
        active = cell;
        continue;
      }
      children.add(_positionedCell(cell, l, multi && _inRange(cell)));
    }
    // الخلية قيد التعديل تُرسم أخيراً حتى يظهر إطارها فوق جيرانها
    if (active != null) {
      children.add(_positionedCell(active, l, multi && _inRange(active)));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TaxTableColors.line),
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: _handleWidth + l.width,
        height: _handleHeight + l.height,
        child: Stack(children: children),
      ),
    );
  }

  Widget _positionedCell(TaxTableCell cell, TaxTableLayout l, bool selected) {
    final rect = l.rectOf(cell);
    return PositionedDirectional(
      key: ObjectKey(cell),
      start: _handleWidth + rect.left,
      top: _handleHeight + rect.top,
      width: rect.width,
      height: rect.height,
      child: _cell(cell, selected),
    );
  }

  Widget _columnHandle(int k) {
    return PopupMenuButton<String>(
      tooltip: 'خيارات العمود'.tr,
      onSelected: (v) => _structural(() {
        if (v == 'before') table.insertColumn(k);
        if (v == 'after') table.insertColumn(k + 1);
        if (v == 'delete') table.removeColumn(k);
      }),
      itemBuilder: (_) => [
        _menuItem('before', Icons.add, 'إدراج عمود قبله'.tr),
        _menuItem('after', Icons.add, 'إدراج عمود بعده'.tr),
        if (table.nCols > 1)
          _menuItem('delete', Icons.delete_outline, 'حذف العمود'.tr,
              danger: true),
      ],
      child: Container(
        decoration: const BoxDecoration(
          color: TaxTableColors.handle,
          border: BorderDirectional(
              start: BorderSide(color: TaxTableColors.line)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${k + 1}',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: TaxTableColors.handleText)),
            const Icon(Icons.arrow_drop_down,
                size: 16, color: TaxTableColors.handleText),
          ],
        ),
      ),
    );
  }

  Widget _rowHandle(int r) {
    final header = table.isRowHeader(r);
    return PopupMenuButton<String>(
      tooltip: 'خيارات الصف'.tr,
      onSelected: (v) => _structural(() {
        if (v == 'before') table.insertRow(r);
        if (v == 'after') table.insertRow(r + 1);
        if (v == 'delete') table.removeRow(r);
        if (v == 'header') table.setRowHeader(r, !header);
      }),
      itemBuilder: (_) => [
        _menuItem('header', Icons.title,
            header ? 'إلغاء صف العناوين'.tr : 'جعله صف عناوين'.tr),
        const PopupMenuDivider(),
        _menuItem('before', Icons.add, 'إدراج صف قبله'.tr),
        _menuItem('after', Icons.add, 'إدراج صف بعده'.tr),
        if (table.nRows > 1)
          _menuItem('delete', Icons.delete_outline, 'حذف الصف'.tr,
              danger: true),
      ],
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: TaxTableColors.handle,
          border: Border(top: BorderSide(color: TaxTableColors.line)),
        ),
        child: Text('${r + 1}',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: header
                    ? AppColor.typography
                    : TaxTableColors.handleText)),
      ),
    );
  }

  Widget _cell(TaxTableCell cell, bool selected) {
    final header = cell.isHeader;
    final isEditing = editingCell == cell;
    final fg = header ? TaxTableColors.headerText : Colors.black87;
    final fill = header
        ? TaxTableColors.header
        : cell.row.isOdd
            ? TaxTableColors.stripe
            : Colors.white;
    final style = TaxTableLayout.textStyle(header);
    final align = header ? TextAlign.center : TextAlign.start;

    final Widget content;
    if (isEditing) {
      content = Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.tab) {
            _moveEditing(HardwareKeyboard.instance.isShiftPressed);
            return KeyEventResult.handled;
          }
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            editFocus.unfocus();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: editController,
          focusNode: editFocus,
          expands: true,
          minLines: null,
          maxLines: null,
          textAlign: align,
          textAlignVertical: TextAlignVertical.top,
          cursorColor: fg,
          style: style,
          decoration: const InputDecoration.collapsed(hintText: ''),
          onChanged: (v) {
            cell.text = v;
            widget.onChanged();
          },
        ),
      );
    } else {
      content = Text(
        cell.text,
        textAlign: align,
        style: style,
        overflow: TextOverflow.fade,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onCellTap(cell),
      onSecondaryTapDown: (d) => _openCellMenu(cell, d.globalPosition),
      onLongPressStart: (d) => _openCellMenu(cell, d.globalPosition),
      child: MouseRegion(
        cursor: SystemMouseCursors.text,
        child: Container(
          foregroundDecoration: selected
              ? BoxDecoration(
                  color: AppColor.acteve.withOpacity(0.18),
                  border: Border.all(
                      color: AppColor.acteve.withOpacity(0.6), width: 1),
                )
              : null,
          padding: const EdgeInsets.symmetric(
              horizontal: TaxTableLayout.padH - 2,
              vertical: TaxTableLayout.padV - 2),
          decoration: BoxDecoration(
            color: isEditing && !header ? Colors.white : fill,
            border: isEditing
                ? Border.all(color: AppColor.acteve, width: 2)
                : const BorderDirectional(
                    start: BorderSide(color: TaxTableColors.line),
                    top: BorderSide(color: TaxTableColors.line),
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: content,
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label,
      {bool danger = false, bool enabled = true}) {
    final color = !enabled
        ? Colors.grey
        : danger
            ? Colors.red
            : Colors.black87;
    return PopupMenuItem<String>(
      value: value,
      enabled: enabled,
      height: 40,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Widget _smallField({
    required Key key,
    required String hint,
    required String initialValue,
    required void Function(String) onChanged,
    bool number = false,
  }) {
    return TextFormField(
      key: key,
      initialValue: initialValue,
      keyboardType: number ? TextInputType.number : null,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14),
      validator: number
          ? (v) =>
              v == null || v.trim().isEmpty || int.tryParse(v.trim()) != null
                  ? null
                  : 'رقم فقط'.tr
          : null,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: TaxTableColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: TaxTableColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColor.typography, width: 1.5),
        ),
      ),
    );
  }
}
