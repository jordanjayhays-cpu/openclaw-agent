#!/usr/bin/env python3
"""
Fill ORION template PROPERLY - matching exact row/column structure
"""
import zipfile
import shutil
import re

def fill_cell(content, cell_ref, value):
    """Replace empty cell with value/formula"""
    # Match self-closing empty cell like <c r="C3" s="4"/>
    pattern = f'<c r="{cell_ref}"[^/]*/>'
    replacement = f'<c r="{cell_ref}"><v>{value}</v></c>'
    content = re.sub(pattern, replacement, content)
    return content

def fill_formula(content, cell_ref, formula):
    """Replace empty cell with formula"""
    pattern = f'<c r="{cell_ref}"[^/]*/>'
    replacement = f'<c r="{cell_ref}"><f>{formula}</f><v>0</v></c>'
    content = re.sub(pattern, replacement, content)
    return content

def fill_sheet2(content):
    """Fill Sheet 2 - FCF Model"""
    
    # Revenue - Row 3 (C3:H3 for Years 1-5)
    for col, yr in [('C','1'), ('D','2'), ('E','3'), ('F','4'), ('G','5')]:
        if yr == '1':
            content = fill_formula(content, f'{col}3', 'Sheet1!$B$9')
        else:
            prev = chr(ord(col)-1)
            content = fill_formula(content, f'{col}3', f'{prev}3*(1+Sheet1!$B$10)')

    # Operating costs - Row 4 (C4:H4)
    for col in ['C', 'D', 'E', 'F', 'G']:
        content = fill_formula(content, f'{col}4', f'{col}3*Sheet1!$B$11')

    # Depreciation - Row 5 (C5:G5)
    for col in ['C', 'D', 'E', 'F', 'G']:
        content = fill_formula(content, f'{col}5', '(Sheet1!$B$2-Sheet1!$B$3)/Sheet1!$B$4')

    # EBIT - Row 6 (B6:G6) - Year 0 is empty for EBIT
    for col in ['C', 'D', 'E', 'F', 'G']:
        content = fill_formula(content, f'{col}6', f'{col}3+{col}4+{col}5')

    # Taxes - Row 7 (B7:G7)
    for col in ['C', 'D', 'E', 'F', 'G']:
        content = fill_formula(content, f'{col}7', f'{col}6*Sheet1!$B$5')

    # NOPLAT - Row 8 (B8:G8) 
    for col in ['C', 'D', 'E', 'F', 'G']:
        content = fill_formula(content, f'{col}8', f'{col}6+{col}7')

    # Dep add-back - Row 9 (B9:G9)
    for col in ['C', 'D', 'E', 'F', 'G']:
        content = fill_formula(content, f'{col}9', f'{col}5')

    # Capex - Row 10 (B10:G10) - Year 0 gets -Initial
    content = fill_formula(content, 'B10', '-Sheet1!$B$2')
    for col in ['C', 'D', 'E', 'F', 'G']:
        content = fill_formula(content, f'{col}10', '0')

    # Change in WC - Row 11 (B11:G11)
    content = fill_formula(content, 'B11', '0')
    content = fill_formula(content, 'C11', '-C3*Sheet1!$B$10')
    content = fill_formula(content, 'D11', '-(D3-C3)*Sheet1!$B$10')
    content = fill_formula(content, 'E11', '-(E3-D3)*Sheet1!$B$10')
    content = fill_formula(content, 'F11', '-(F3-E3)*Sheet1!$B$10')
    content = fill_formula(content, 'G11', '-(G3-F3)*Sheet1!$B$10')

    # FCF - Row 13 (B13:G13)
    content = fill_formula(content, 'B13', 'B8+B9+B10+B11')
    for col in ['C', 'D', 'E', 'F', 'G']:
        content = fill_formula(content, f'{col}13', f'{col}8+{col}9+{col}10+{col}11')

    # Discount factors - Row 15 (B15:G15)
    content = fill_formula(content, 'B15', '1')
    content = fill_formula(content, 'C15', '1/(1+Sheet1!$B$6)^1')
    content = fill_formula(content, 'D15', '1/(1+Sheet1!$B$6)^2')
    content = fill_formula(content, 'E15', '1/(1+Sheet1!$B$6)^3')
    content = fill_formula(content, 'F15', '1/(1+Sheet1!$B$6)^4')
    content = fill_formula(content, 'G15', '1/(1+Sheet1!$B$6)^5')

    # PV of FCF - Row 17 (B17:G17)
    for col in ['B', 'C', 'D', 'E', 'F', 'G']:
        content = fill_formula(content, f'{col}17', f'{col}13*{col}15')

    return content

def fill_sheet1(content):
    """Fill Sheet 1 - Inputs and Outputs"""
    
    # NPV (B13)
    content = fill_formula(content, 'B13', 'Sheet2!B17+SUM(Sheet2!C17:G17)')
    
    # IRR (B14)
    content = fill_formula(content, 'B14', 'IRR(Sheet2!B13:G13)')
    
    # PI (B15)
    content = fill_formula(content, 'B15', '(B13+Sheet1!$B$2)/Sheet1!$B$2')
    
    return content

# Main
src = '/data/.openclaw/media/inbound/ORION_LIGHTING_FILLED_1---59f68735-0eb9-4cc7-ae0f-8f71185d6f27.xlsx'
dst = '/data/workspace/PROJECTS/ORION/ORION_LIGHTING_FILLED.xlsx'

shutil.copy(src, dst)

with zipfile.ZipFile(src, 'r') as zin:
    with zipfile.ZipFile(dst, 'w', zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            
            if item.filename == 'xl/worksheets/sheet2.xml':
                data = fill_sheet2(data.decode('utf-8')).encode('utf-8')
            elif item.filename == 'xl/worksheets/sheet1.xml':
                data = fill_sheet1(data.decode('utf-8')).encode('utf-8')
            
            zout.writestr(item, data)

print(f"Created: {dst}")

# Verify formulas
with zipfile.ZipFile(dst, 'r') as z:
    sheet2 = z.read('xl/worksheets/sheet2.xml').decode('utf-8')
    formulas = re.findall(r'<f>([^<]+)</f>', sheet2)
    print(f"Formulas in Sheet 2: {len(formulas)}")
    print(f"Sample: {formulas[:5]}")
