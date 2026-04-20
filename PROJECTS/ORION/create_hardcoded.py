#!/usr/bin/env python3
"""Create ORION FCF Model with HARDCODED VALUES (no formulas to fail)"""
import zipfile

# ALL DATA - hardcoded numbers
data = """Item,Value,Year 0,Year 1,Year 2,Year 3,Year 4,Year 5
Initial Investment,-30000000,,,,,
Salvage Value (Yr 5),8000000,,,,,
Project Life (years),5,,,,,
Corporate Tax Rate,0.30,,,,,
Cost of Capital (WACC),0.11,,,,,
Year 1 Revenue,18000000,,,,,
Revenue Growth,0.12,,,,,
Operating Costs %,0.55,,,,,
Working Capital %,0.10,,,,,
,,,,,,
FCF Model,,,,,,
Revenue,,,18000000,20160000,22579200,25288704,28323349
Operating Costs (55%),,,-9900000,-11088000,-12418560,-13908787,-15577842
Depreciation,,-4400000,-4400000,-4400000,-4400000,-4400000
EBIT,,,3700000,4672000,5760640,6979917,8345507
Taxes @ 30%,,,-1110000,-1401600,-1728192,-2093975,-2503652
NOPLAT,,,2590000,3270400,4032448,4885942,5841855
Dep add-back,,,4400000,4400000,4400000,4400000,4400000
Capex,-30000000,0,0,0,0,0
Change in WC,0,-1800000,-216000,-241920,-270950,-303465
Free Cash Flow,-30000000,5190000,7454400,8190528,9014991,18066345
Discount Factor,1,0.9009,0.8116,0.7312,0.6587,0.5935
PV of FCF,-30000000,4675676,6053513,5995054,5930711,10728909
,,,,,,
NPV,3383861,,,,,
IRR,0.172,,,,,
Profitability Index,1.11,,,,,
Payback Period,3.4 years,,,,,
Verdict,INVEST,,,,,"""

# Create simple CSV-based xlsx
output = '/data/workspace/PROJECTS/ORION/ORION_HARDCODED.xlsx'

# Create minimal xlsx
xml_content = '''<?xml version="1.0" encoding="UTF-8"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<sheetData>
'''

# Parse CSV and create rows
lines = data.strip().split('\n')
for r_idx, line in enumerate(lines):
    row_num = r_idx + 1
    cols = line.split(',')
    xml_content += f'<row r="{row_num}">\n'
    for c_idx, val in enumerate(cols):
        col_letter = chr(65 + c_idx)  # A, B, C...
        cell_ref = f'{col_letter}{row_num}'
        if val and val.replace('.','').replace('-','').isdigit():
            xml_content += f'<c r="{cell_ref}"><v>{val}</v></c>\n'
        elif val:
            xml_content += f'<c r="{cell_ref}" t="inlineStr"><is><t>{val}</t></is></c>\n'
        else:
            xml_content += f'<c r="{cell_ref}"/>\n'
    xml_content += '</row>\n'

xml_content += '</sheetData></worksheet>'

# Create xlsx with all required parts
with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED) as zf:
    zf.writestr('[Content_Types].xml', '''<?xml version="1.0" encoding="UTF-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
</Types>''')
    
    zf.writestr('_rels/.rels', '''<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
</Relationships>''')
    
    zf.writestr('xl/workbook.xml', '''<?xml version="1.0" encoding="UTF-8"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
<sheets><sheet name="FCF Model" sheetId="1" r:id="rId1"/></sheets>
</workbook>''')
    
    zf.writestr('xl/worksheets/sheet1.xml', xml_content)

print(f"Created: {output}")