#!/usr/bin/env python3
"""
Create ORION Lighting FCF Model Excel file.
Run: python3 create_excel.py
Output: orion_fcf_model.xlsx
"""
import zipfile
import os

# Data
data = {
    'inputs': [
        ['ORION LIGHTING — FCF Model', ''],
        ['', ''],
        ['INPUTS', ''],
        ['Initial Investment', -30000000],
        ['Salvage Value (end of Year 5)', 8000000],
        ['Project Life (years)', 5],
        ['Corporate Tax Rate', 0.30],
        ['Cost of Capital (WACC)', 0.11],
        ['Year 1 Revenue', 18000000],
        ['Revenue Annual Growth Rate', 0.12],
        ['Operating Costs (% of revenue)', 0.55],
        ['Working Capital (% of revenue)', 0.10],
    ],
    'fcf': [
        ['YEAR', '0', '1', '2', '3', '4', '5'],
        ['Revenue', '', 18000000, 20160000, 22579200, 25288704, 28323349],
        ['Operating Costs (55%)', '', -9900000, -11088000, -12418560, -13908787, -15577842],
        ['Depreciation', '', -4400000, -4400000, -4400000, -4400000, -4400000],
        ['EBIT', '', 3700000, 4672000, 5760640, 6979917, 8345507],
        ['Taxes @ 30%', '', -1110000, -1401600, -1728192, -2093975, -2503652],
        ['NOPLAT', '', 2590000, 3270400, 4032448, 4885942, 5841855],
        ['Dep add-back', '', 4400000, 4400000, 4400000, 4400000, 4400000],
        ['Capex', -30000000, 0, 0, 0, 0, 0],
        ['Change in WC', '', -1800000, -216000, -241920, -270950, -303465],
        ['After-tax Salvage', '', 0, 0, 0, 0, 5600000],
        ['WC Recovery', '', 0, 0, 0, 0, 2527955],
        ['Free Cash Flow', -30000000, 5190000, 7454400, 8190528, 9014991, 18066345],
    ],
    'discounted': [
        ['Discount Factor', 1.0, 0.9009, 0.8116, 0.7312, 0.6587, 0.5935],
        ['PV of FCF', -30000000, 4675676, 6053512, 5995054, 5930711, 10728909],
    ],
    'outputs': [
        ['RESULTS', ''],
        ['NPV', 3383861],
        ['IRR', '17.2%'],
        ['Profitability Index', 1.11],
        ['Payback Period', '3.4 years'],
        ['', ''],
        ['VERDICT', 'INVEST — Positive NPV of €3.38M'],
    ]
}

def col_letter(n):
    """Convert 1-indexed column to letter"""
    result = ''
    while n > 0:
        n, remainder = divmod(n - 1, 26)
        result = chr(65 + remainder) + result
    return result

def create_sheet_data(data_rows):
    """Create sheetData XML"""
    xml = '<sheetData>\n'
    for r_idx, row in enumerate(data_rows):
        row_num = r_idx + 1
        xml += f'<row r="{row_num}">\n'
        for c_idx, val in enumerate(row):
            col = col_letter(c_idx + 1)
            cell_ref = f'{col}{row_num}'
            if isinstance(val, str):
                # String cell
                xml += f'<c r="{cell_ref}" t="inlineStr"><is><t>{val}</t></is></c>\n'
            elif isinstance(val, (int, float)) and val < 0:
                # Negative number
                xml += f'<c r="{cell_ref}"><v>{val}</v></c>\n'
            elif isinstance(val, float):
                # Format as number
                xml += f'<c r="{cell_ref}"><v>{val}</v></c>\n'
            elif isinstance(val, int):
                xml += f'<c r="{cell_ref}"><v>{val}</v></c>\n'
            else:
                xml += f'<c r="{cell_ref}" t="inlineStr"><is><t>{str(val)}</t></is></c>\n'
        xml += '</row>\n'
    xml += '</sheetData>'
    return xml

def create_xlsx(output_path):
    """Create a simple xlsx file"""
    
    # Create content types
    content_types = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
</Types>'''

    rels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
</Relationships>'''

    workbook = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
<sheetViews><sheetView tabSelected="1" workbookViewId="0"/></sheetViews>
<sheets><sheet name="FCF Model" sheetId="1" r:id="rId1"/></sheets>
</workbook>'''

    sheet1_data = create_sheet_data(data['inputs'] + [[]] + data['fcf'] + [[]] + data['discounted'] + [[]] + data['outputs'])
    
    worksheet = f'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
{sheet1_data}
</worksheet>'''

    with zipfile.ZipFile(output_path, 'w', zipfile.ZIP_DEFLATED) as zf:
        zf.writestr('[Content_Types].xml', content_types)
        zf.writestr('_rels/.rels', rels)
        zf.writestr('xl/workbook.xml', workbook)
        zf.writestr('xl/worksheets/sheet1.xml', worksheet)

    print(f"Created: {output_path}")

if __name__ == '__main__':
    output = '/data/workspace/PROJECTS/ORION/ORION_FCF_Model.xlsx'
    create_xlsx(output)
    print(f"\nFile saved to: {output}")
