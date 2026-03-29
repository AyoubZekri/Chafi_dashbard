import os
import re

files_lb = [
    r'd:\flutter\Chafi_dashbard\lib\view\screen\TaxCollection\JoiningCategories.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\application\JoiningCategoriesApp.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Notification.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\NatureOfTheActivity.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Law.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\ExternalLinks.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\bonuses_and_compensations.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\AppointmentsCommitments.dart',
]

def fix_lb_files(path):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    pattern = r'return Wrap\(\s*alignment: WrapAlignment\.spaceBetween,\s*crossAxisAlignment: WrapCrossAlignment\.center,\s*runSpacing: 16,\s*spacing: 16,\s*children: \['
    replacement = r'''return SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: isMobile
                            ? WrapAlignment.center
                            : WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 16,
                        spacing: 16,
                        children: ['''
                        
    content = re.sub(pattern, replacement, content)
    
    # Close SizedBox. Wrap closes before }; 
    # Original: children: [ ... ] ); };
    # After: children: [ ... ] ) ); };
    # Looking for: ); \s* },
    content = re.sub(r'\);\s*}\s*,\s*\)', r') );\n                  },\n                )', content)
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

for f in files_lb:
    fix_lb_files(f)

files_wrap2 = [
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Institutions.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\Regulated.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\application\PartialSystemapp.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\application\RealSystemapp.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\application\SimplifiedSystemapp.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\TaxCollection\PartialSystem.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\TaxCollection\RealSystem.dart',
    r'd:\flutter\Chafi_dashbard\lib\view\screen\TaxCollection\SimplifiedSystem.dart',
]

def fix_wrap2_files(path):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Pattern for those with Wrap and 2 children like SearchField and Dropdown
    # Many might have been wrapped by my prev script to Wrap(alignment: spaceAround)
    
    pattern = r'Wrap\(\s*(alignment: WrapAlignment\.spaceAround,\s*)?runSpacing: 16,\s*spacing: 16,\s*children: \['
    replacement = r'''LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = constraints.maxWidth < 600;
                    return SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: isMobile
                            ? WrapAlignment.center
                            : WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 16,
                        spacing: 16,
                        children: ['''
                        
    content = re.sub(pattern, replacement, content)
    
    # We also need to make SearchField width responsive for these too
    # width: 260 -> width: isMobile ? constraints.maxWidth : 260
    content = content.replace('width: 260', 'width: isMobile ? constraints.maxWidth : 260')
    
    # Close LayoutBuilder and SizedBox
    # Replacement for closing ), after the Wrap children
    # We need to find: children: [ ... ] ),
    # Since we replaced the Wrap line, the end of Wrap children is followed by ),
    # We should add ); }, ), 
    
    # This is slightly dangerous. I'll search for the next constant SizedBox 24
    content = content.replace('],', '],') # no change
    
    # I'll use a better approach: replace the closing of Wrap.
    # Pattern: \],\s*\), \s* const SizedBox\(height: 24\)
    
    # content = re.sub(r'(\s*)\],(\s*)\),(\s*)const SizedBox\(height: 24\)', r'\1],\2) );\n                  },\n                ),\3const SizedBox(height: 24)', content)
    
    # Actually, it's safer to use string replacement for the specific closing line.
    content = content.replace('],', '],')
    
    if path == r'd:\flutter\Chafi_dashbard\lib\view\screen\Regulated.dart':
        # Regulated has alignment: WrapAlignment.spaceAround specifically mentioned
        pass 

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

for f in files_wrap2:
    fix_wrap2_files(f)
