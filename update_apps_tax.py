import os
import re

files = [
    r'd:\flutter\Chafi_dashbard\lib\view\screen\application\PartialSystemapp.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\application\RealSystemapp.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\application\SimplifiedSystemapp.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\TaxCollection\PartialSystem.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\TaxCollection\RealSystem.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\TaxCollection\SimplifiedSystem.dart',
]

def fix_file(path):
    if not os.path.exists(path):
        return
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    original = content
    
    end_pattern = r'\},\s*\),\s*iconData:\s*Icons\.error,'
    end_replacement = r'''},
                        );
                      },
                    ),
                    iconData: Icons.error,'''
    
    content = re.sub(end_pattern, end_replacement, content)
    
    if content != original:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {path}")
    else:
        print(f"No changes made to {path}")

for f in files:
    fix_file(f)
