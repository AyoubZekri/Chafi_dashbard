import os
import re

def patch_ui(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'TaxArticleModel.dart' not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:chafi_dashboard/data/model/TaxArticleModel.dart';")

    ui_addition = """const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Dropdownfild(
                                      label: "«·„·›".tr,
                                      hintText: "≈Œ — «·„·›".tr,
                                      items: controller.documents
                                          .map(
                                            (f) => DropdownMenuItem<int>(
                                              value: f.id,
                                              child: Text(
                                                f.title ?? '',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      value: lawItem['document_id'],
                                      onChanged: (val) {
                                        controller.updateLawDocumentId(
                                          index,
                                          val as int?,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 1,
                                    child: Dropdownfild(
                                      label: "«·„«œ…".tr,
                                      hintText: "≈Œ — «·„«œ…".tr,
                                      items: (lawItem['articles'] as List<TaxArticleModel>?)
                                          ?.map(
                                            (f) => DropdownMenuItem<int>(
                                              value: f.id,
                                              child: Text(
                                                f.label,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList() ?? [],
                                      value: lawItem['article_id'],
                                      onChanged: (val) {
                                        controller.updateLawArticleId(
                                          index,
                                          val as int?,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 48),"""

    if 'controller.updateLawArticleId' not in content:
        content = content.replace("""                            ],
                          ),
                        );
                      }),
                    ],

                    const SizedBox(height: 48),""", ui_addition)
        content = content.replace("""                            ],\r
                          ),\r
                        );\r
                      }),\r
                    ],\r
\r
                    const SizedBox(height: 48),""", ui_addition)

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

uis = [
    r"d:\MyProject\flutter\Chafi_dashbard\lib\view\screen\application\Addapp.dart",
    r"d:\MyProject\flutter\Chafi_dashbard\lib\view\screen\application\Editapp.dart"
]

for u in uis:
    if os.path.exists(u):
        patch_ui(u)
        print(f"Patched {u}")
