#!/usr/bin/env python3
"""
Fill ORION Lighting Student Template - FIXED
"""
import zipfile
import shutil
import re

def make_formula_cell(cell_ref, formula, style=None):
    """Create a cell XML element with a formula"""
    if style:
        return f'<c r="{cell_ref}" s="{style}"><f>{formula}</f></c>'
    return f'<c r="{cell_ref}"><f>{formula}</f></c>'

def add_fcf_formulas(content):
    """Add FCF formulas to Sheet 2"""
    
    replacements = {
        # Revenue row (row 3)
        'C3': 'Sheet1!$B$9',
        'D3': 'C3*(1+Sheet1!$B$10)',
        'E3': 'D3*(1+Sheet1!$B$10)',
        'F3': 'E3*(1+Sheet1!$B$10)',
        'G3': 'F3*(1+Sheet1!$B$10)',
        'H3': 'G3*(1+Sheet1!$B$10)',
        
        # Operating costs (row 4)
        'C4': 'C3*Sheet1!$B$11',
        'D4': 'D3*Sheet1!$B$11',
        'E4': 'E3*Sheet1!$B$11',
        'F4': 'F3*Sheet1!$B$11',
        'G4': 'G3*Sheet1!$B$11',
        'H4': 'G3*Sheet1!$B$11',
        
        # Depreciation (row 5)
        'C5': '(Sheet1!$B$2-Sheet1!$B$5)/Sheet1!$B$6',
        'D5': '(Sheet1!$B$2-Sheet1!$B$5)/Sheet1!$B$6',
        'E5': '(Sheet1!$B$2-Sheet1!$B$5)/Sheet1!$B$6',
        'F5': '(Sheet1!$B$2-Sheet1!$B$5)/Sheet1!$B$6',
        'G5': '(Sheet1!$B$2-Sheet1!$B$5)/Sheet1!$B$6',
        'H5': '(Sheet1!$B$2-Sheet1!$B$5)/Sheet1!$B$6',
        
        # EBIT (row 6)
        'C6': 'C3+C4+C5',
        'D6': 'D3+D4+D5',
        'E6': 'E3+E4+E5',
        'F6': 'F3+F4+F5',
        'G6': 'G3+G4+G5',
        'H6': 'H3+H4+H5',
        
        # Taxes (row 7)
        'C7': 'C6*Sheet1!$B$7',
        'D7': 'D6*Sheet1!$B$7',
        'E7': 'E6*Sheet1!$B$7',
        'F7': 'F6*Sheet1!$B$7',
        'G7': 'G6*Sheet1!$B$7',
        'H7': 'H6*Sheet1!$B$7',
        
        # NOPLAT (row 8)
        'C8': 'C6+C7',
        'D8': 'D6+D7',
        'E8': 'E6+E7',
        'F8': 'F6+F7',
        'G8': 'G6+G7',
        'H8': 'H6+H7',
        
        # Dep add-back (row 9)
        'C9': 'C5',
        'D9': 'D5',
        'E9': 'E5',
        'F9': 'F5',
        'G9': 'G5',
        'H9': 'H5',
        
        # Capex (row 10) - Year 0 only
        'B10': '-Sheet1!$B$2',
        'C10': '0',
        'D10': '0',
        'E10': '0',
        'F10': '0',
        'G10': '0',
        'H10': '0',
        
        # Change in WC (row 11)
        'B11': '0',
        'C11': '-C3*Sheet1!$B$12',
        'D11': '-(D3-C3)*Sheet1!$B$12',
        'E11': '-(E3-D3)*Sheet1!$B$12',
        'F11': '-(F3-E3)*Sheet1!$B$12',
        'G11': '-(G3-F3)*Sheet1!$B$12',
        'H11': '-(H3-G3)*Sheet1!$B$12',
        
        # FCF (row 13)
        'B13': 'B8+B9+B10+B11',
        'C13': 'C8+C9+C10+C11',
        'D13': 'D8+D9+D10+D11',
        'E13': 'E8+E9+E10+E11',
        'F13': 'F8+F9+F10+F11',
        'G13': 'G8+G9+G10+G11',
        'H13': 'H8+H9+H10+H11',
        
        # Discount factors (row 15)
        'B15': '1',
        'C15': '1/(1+Sheet1!$B$8)^1',
        'D15': '1/(1+Sheet1!$B$8)^2',
        'E15': '1/(1+Sheet1!$B$8)^3',
        'F15': '1/(1+Sheet1!$B$8)^4',
        'G15': '1/(1+Sheet1!$B$8)^5',
        'H15': '1/(1+Sheet1!$B$8)^6',
        
        # PV of FCF (row 17)
        'B17': 'B13*B15',
        'C17': 'C13*C15',
        'D17': 'D13*D15',
        'E17': 'E13*E15',
        'F17': 'F13*F15',
        'G17': 'G13*G15',
        'H17': 'H13*H15',
    }
    
    for cell_ref, formula in replacements.items():
        # Find self-closing or existing cell and replace
        # Match: <c r="C3" s="4"/> or <c r="C3" s="4"></c> or <c r="C3"><v>...</v></c>
        pattern = f'<c r="{cell_ref}"[^>]*/>'
        replacement = f'<c r="{cell_ref}"><f>{formula}</f></c>'
        content, n = re.subn(pattern, replacement, content)
        
        if n == 0:
            # Try to find existing cell with other content
            pattern2 = f'<c r="{cell_ref}"[^>]*>.*?</c>'
            content, n = re.subn(pattern2, replacement, content, flags=re.DOTALL)
        
    return content

def add_inputs_formulas(content):
    """Add NPV, IRR, PI to Sheet 1"""
    
    replacements = {
        'B13': 'Sheet2!B17+SUM(Sheet2!C17:H17)',
        'B14': 'IRR(Sheet2!B13:H13)',
        'B15': '(B13+Sheet1!$B$2)/Sheet1!$B$2',
    }
    
    for cell_ref, formula in replacements.items():
        pattern = f'<c r="{cell_ref}"[^>]*/>'
        replacement = f'<c r="{cell_ref}"><f>{formula}</f></c>'
        content, n = re.subn(pattern, replacement, content)
        
        if n == 0:
            pattern2 = f'<c r="{cell_ref}"[^>]*>.*?</c>'
            content, n = re.subn(pattern2, replacement, content, flags=re.DOTALL)
    
    return content

# Main
src = '/data/.openclaw/media/inbound/ORION_LIGHTING_STUDENT_TEMPLATE_1---bf3ba8cc-6ea8-4f7e-985c-5156a7abc4a8.xlsx'
dst = '/data/workspace/PROJECTS/ORION/ORION_LIGHTING_FILLED.xlsx'

shutil.copy(src, dst)

with zipfile.ZipFile(src, 'r') as zin:
    with zipfile.ZipFile(dst, 'w', zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            
            if item.filename == 'xl/worksheets/sheet2.xml':
                data = add_fcf_formulas(data.decode('utf-8')).encode('utf-8')
            elif item.filename == 'xl/worksheets/sheet1.xml':
                data = add_inputs_formulas(data.decode('utf-8')).encode('utf-8')
            
            zout.writestr(item, data)

print(f"Created: {dst}")

# Verify
with zipfile.ZipFile(dst, 'r') as z:
    sheet2 = z.read('xl/worksheets/sheet2.xml').decode('utf-8')
    formulas = re.findall(r'<f>([^<]+)</f>', sheet2)
    print(f"Formulas inserted: {len(formulas)}")
    print(f"First 5: {formulas[:5]}")
