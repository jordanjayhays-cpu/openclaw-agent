#!/usr/bin/env python3
"""
Create a proper Excel file from scratch using only standard library.
Creates ORION Lighting FCF model with hardcoded values.
"""
import zipfile

def create_cell_ref(col, row):
    """Convert column number to letter and return cell ref"""
    letters = 'ABCDEFGHIJ'
    return f'{letters[col-1]}{row}'

def create_row(cells):
    """Create XML row from list of (col, value) tuples"""
    xml = '<row r="{}">'.format(cells[0][1]) + '\n'
    for col, row, val, is_text in cells:
        ref = create_cell_ref(col, row)
        if is_text:
            xml += f'<c r="{ref}" t="inlineStr"><is><t>{val}</t></is></c>\n'
        else:
            xml += f'<c r="{ref}"><v>{val}</v></c>\n'
    xml += '</row>\n'
    return xml

def create_xlsx():
    output = '/data/workspace/PROJECTS/ORION/ORION_VALUES.xlsx'
    
    # Build worksheet XML manually
    rows = []
    
    # Row 1: Title
    rows.append('<row r="1"><c r="A1" t="inlineStr"><is><t>ORION LIGHTING - FCF MODEL</t></is></c></row>')
    rows.append('<row r="2"/>')
    
    # Row 3: Inputs header
    rows.append('<row r="3"><c r="A3" t="inlineStr"><is><t>INPUTS</t></is></c></row>')
    
    # Input rows
    inputs = [
        (4, 'Initial Investment', -30000000),
        (5, 'Salvage Value (Year 5)', 8000000),
        (6, 'Project Life (years)', 5),
        (7, 'Corporate Tax Rate', 0.30),
        (8, 'Cost of Capital (WACC)', 0.11),
        (9, 'Year 1 Revenue', 18000000),
        (10, 'Revenue Growth Rate', 0.12),
        (11, 'Operating Costs (% of rev)', 0.55),
        (12, 'Working Capital (% of rev)', 0.10),
    ]
    
    for row_num, label, value in inputs:
        rows.append(f'<row r="{row_num}"><c r="A{row_num}" t="inlineStr"><is><t>{label}</t></is></c><c r="B{row_num}"><v>{value}</v></c></row>')
    
    rows.append('<row r="13"/>')  # blank
    
    # Row 14: FCF header
    rows.append('<row r="14"><c r="A14" t="inlineStr"><is><t>LINE ITEM</t></is></c><c r="B14" t="inlineStr"><is><t>Year 0</t></is></c><c r="C14" t="inlineStr"><is><t>Year 1</t></is></c><c r="D14" t="inlineStr"><is><t>Year 2</t></is></c><c r="E14" t="inlineStr"><is><t>Year 3</t></is></c><c r="F14" t="inlineStr"><is><t>Year 4</t></is></c><c r="G14" t="inlineStr"><is><t>Year 5</t></is></c></row>')
    
    # FCF data rows
    fcf_data = [
        ('Revenue', '', 18000000, 20160000, 22579200, 25288704, 28323349),
        ('Operating Costs (55%)', '', -9900000, -11088000, -12418560, -13908787, -15577842),
        ('Depreciation', '', -4400000, -4400000, -4400000, -4400000, -4400000),
        ('EBIT', '', 3700000, 4672000, 5760640, 6979917, 8345507),
        ('Taxes @ 30%', '', -1110000, -1401600, -1728192, -2093975, -2503652),
        ('NOPLAT', '', 2590000, 3270400, 4032448, 4885942, 5841855),
        ('Dep add-back', '', 4400000, 4400000, 4400000, 4400000, 4400000),
        ('Capex', -30000000, 0, 0, 0, 0, 0),
        ('Change in WC', 0, -1800000, -216000, -241920, -270950, -303465),
        ('Free Cash Flow', -30000000, 5190000, 7454400, 8190528, 9014991, 18066345),
        ('Discount Factor', 1, 0.9009, 0.8116, 0.7312, 0.6587, 0.5935),
        ('PV of FCF', -30000000, 4675676, 6053513, 5995054, 5930711, 10728909),
    ]
    
    for i, row_data in enumerate(fcf_data):
        row_num = 15 + i
        label = row_data[0]
        vals = row_data[1:]
        row_xml = f'<row r="{row_num}"><c r="A{row_num}" t="inlineStr"><is><t>{label}</t></is></c>'
        for j, v in enumerate(vals):
            col_letter = chr(66 + j)  # B, C, D, E, F, G
            if v == '':
                row_xml += f'<c r="{col_letter}{row_num}"/>'
            else:
                row_xml += f'<c r="{col_letter}{row_num}"><v>{v}</v></c>'
        row_xml += '</row>'
        rows.append(row_xml)
    
    rows.append('<row r="27"/>')  # blank
    
    # Results
    rows.append('<row r="28"><c r="A28" t="inlineStr"><is><t>RESULTS</t></is></c></row>')
    rows.append('<row r="29"><c r="A29" t="inlineStr"><is><t>NPV</t></is></c><c r="B29"><v>3383861</v></c></row>')
    rows.append('<row r="30"><c r="A30" t="inlineStr"><is><t>IRR</t></is></c><c r="B30"><v>0.172</v></c></row>')
    rows.append('<row r="31"><c r="A31" t="inlineStr"><is><t>Profitability Index</t></is></c><c r="B31"><v>1.11</v></c></row>')
    rows.append('<row r="32"><c r="A32" t="inlineStr"><is><t>Payback (years)</t></is></c><c r="B32"><v>3.4</v></c></row>')
    rows.append('<row r="33"><c r="A33" t="inlineStr"><is><t>VERDICT: INVEST</t></is></c></row>')
    
    sheet_xml = '<?xml version="1.0" encoding="UTF-8"?>\n'
    sheet_xml += '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">\n'
    sheet_xml += '<sheetData>\n'
    for row in rows:
        sheet_xml += row + '\n'
    sheet_xml += '</sheetData>\n'
    sheet_xml += '</worksheet>'
    
    # Build xlsx
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
<sheets><sheet name="ORION FCF" sheetId="1" r:id="rId1"/></sheets>
</workbook>''')
        
        zf.writestr('xl/worksheets/sheet1.xml', sheet_xml)
    
    print(f"Created: {output}")
    print(f"Size: {__import__('os').path.getsize(output)} bytes")

create_xlsx()