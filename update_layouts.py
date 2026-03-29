import os

files = [
    r'd:\flutter\Chafi_dashbard\lib\view\screen\TaxCollection\JoiningCategories.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Notification.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\NatureOfTheActivity.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Law.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\ExternalLinks.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\bonuses_and_compensations.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\AppointmentsCommitments.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\application\JoiningCategoriesApp.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Institutions.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\different.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Exclusive.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Reports.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Regulated.dart'
]

old_row = """                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'show'.tr,
                          style: const TextStyle(color: Color(0xFF5A6A85)),
                        ),
                        SizedBox(
                          width: 140,
                          child: CustemDropDownField(
                            items: [10, 25, 50, 100].map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            value: controller.rowsPerPage,
                            onChanged: (value) {
                              setState(() {
                                controller.rowsPerPage = value!;
                                controller.currentPage = 0;
                              });
                            },
                          ),
                        ),
                        Text(
                          'entries'.tr,
                          style: const TextStyle(color: Color(0xFF5A6A85)),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 260,
                      child: SearchField(
                        onChanged: controller.filterData,
                        hint: "search".tr,
                      ),
                    ),
                  ],
                ),"""

new_row = """                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = constraints.maxWidth < 600;
                    return Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 16,
                      spacing: 16,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'show'.tr,
                              style: const TextStyle(color: Color(0xFF5A6A85)),
                            ),
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: CustemDropDownField(
                                items: [10, 25, 50, 100].map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                                value: controller.rowsPerPage,
                                onChanged: (value) {
                                  setState(() {
                                    controller.rowsPerPage = value!;
                                    controller.currentPage = 0;
                                  });
                                },
                              ),
                            ),
                            Text(
                              'entries'.tr,
                              style: const TextStyle(color: Color(0xFF5A6A85)),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: isMobile ? constraints.maxWidth : 260,
                          child: SearchField(
                            onChanged: controller.filterData,
                            hint: "search".tr,
                            vertical: 5,
                          ),
                        ),
                      ],
                    );
                  },
                ),"""

for file in files:
    try:
        if not os.path.exists(file):
            print(f'File {file} not found')
            continue

        with open(file, 'r', encoding='utf-8') as f:
            content = f.read()

        new_content = content.replace('padding: const EdgeInsets.all(24.0),', 'padding: const EdgeInsets.all(16.0),')
        new_content = new_content.replace('margin: const EdgeInsets.all(24.0),', 'margin: const EdgeInsets.all(16.0),')
        
        # also reduce any padding inner the tables and cards if they're 24
        
        if old_row in new_content:
            new_content = new_content.replace(old_row, new_row)
            with open(file, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f'Successfully FULLY updated: {file}')
        else:
            print(f'Row layout not found or slightly different in: {file}')
            with open(file, 'w', encoding='utf-8') as f:
                f.write(new_content) # still write margin/padding updates
    except Exception as e:
        print(f'Error with {file}: {e}')
