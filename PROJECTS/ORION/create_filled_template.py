#!/usr/bin/env python3
"""
Fill ORION Lighting Student Template with formulas.
"""
import zipfile
import shutil
import re

def add_inputs_formulas(content):
    """Add NPV, IRR, PI, Payback formulas to Sheet 1"""
    formulas = {
        'B13': 'Sheet2!B14+SUM(Sheet2!C14:G14)',
        'B14': 'IRR(Sheet2!B12:G12)',
        'B15': '(B13+Sheet1!$B$2)/Sheet1!$B$2',
    }
    for cell_ref, formula in formulas.items():
        formula_xml = f'<f>{formula}</f>'
        if f'r="{cell_ref}"' in content:
            content = re.sub(
                f'(<c r="{cell_ref}"[^>]*>)(?:<f>[^<]*</f>)?(?:<v>[^<]*</v>)?(</c>)',
                f'\\1{formula_xml}\\2',
                content
            )
    return content

def add_fcf_formulas(content):
    """Add FCF formulas to main calculation sheet"""
    formulas = {
        'C3': 'Sheet1!$B$9',
        'D3': 'C3*(1+Sheet1!$B$10)',
        'E3': 'D3*(1+Sheet1!$B$10)',
        'F3': 'E3*(1+Sheet1!$B$10)',
        'G3': 'F3*(1+Sheet1!$B$10)',
        'C4': 'C3*Sheet1!$B$11',
        'D4': 'D3*Sheet1!$B$11',
        'E4': 'E3*Sheet1!$B$11',
        'F4': 'F3*Sheet1!$B$11',
        'G4': 'G3*Sheet1!$B$11',
        'C5': '(Sheet1!$B$2-Sheet1!$B$5)/Sheet1!$B$6',
        'D5': 'C5', 'E5': 'C5', 'F5': 'C5', 'G5': 'C5',
        'C6': 'C3+C4+C5', 'D6': 'D3+D4+D5', 'E6': 'E3+E4+E5', 'F6': 'F3+F4+F5', 'G6': 'G3+G4+G5',
        'C7': 'C6*Sheet1!$B$7', 'D7': 'D6*Sheet1!$B$7', 'E7': 'E6*Sheet1!$B$7', 'F7': 'F6*Sheet1!$B$7', 'G7': 'G6*Sheet1!$B$7',
        'C8': 'C6+C7', 'D8': 'D6+D7', 'E8': 'E6+E7', 'F8': 'F6+F7', 'G8': 'G6+G7',
        'C9': 'C5', 'D9': 'D5', 'E9': 'E5', 'F9': 'F5', 'G9': 'G5',
        'B10': '-Sheet1!$B$2', 'C10': '0', 'D10': '0', 'E10': '0', 'F10': '0', 'G10': '0',
        'B11': '0', 'C11': '-C3*Sheet1!$B$12', 'D11': '-(D3-C3)*Sheet1!$B$12', 'E11': '-(E3-D3)*Sheet1!$B$12', 'F11': '-(F3-E3)*Sheet1!$B$12', 'G11': '-(G3-F3)*Sheet1!$B$12',
        'B12': 'B8+B9+B10+B11', 'C12': 'C8+C9+C10+C11', 'D12': 'D8+D9+D10+D11', 'E12': 'E8+E9+E10+E11', 'F12': 'F8+F9+F10+F11', 'G12': 'G8+G9+G10+G11',
        'B13': '1', 'C13': '1/(1+Sheet1!$B$8)^1', 'D13': '1/(1+Sheet1!$B$8)^2', 'E13': '1/(1+Sheet1!$B$8)^3', 'F13': '1/(1+Sheet1!$B$8)^4', 'G13': '1/(1+Sheet1!$B$8)^5',
        'B14': 'B12*B13', 'C14': 'C12*C13', 'D14': 'D12*D13', 'E14': 'E12*E13', 'F14': 'F12*F13', 'G14': 'G12*G13',
    }
    for cell_ref, formula in formulas.items():
        formula_xml = f'<f>{formula}</f>'
        if f'r="{cell_ref}"' in content:
            content = re.sub(
                f'(<c r="{cell_ref}"[^>]*>)(?:<f>[^<]*</f>)?(?:<v>[^<]*</v>)?(</c>)',
                f'\\1{formula_xml}\\2',
                content
            )
    return content

def add_bookvalue_formulas(content):
    formulas = {
        'B3': 'Sheet1!$B$2', 'C3': 'B5', 'D3': 'C5', 'E3': 'D5', 'F3': 'E5', 'G3': 'F5',
        'B4': '0', 'C4': 'Sheet2!C5', 'D4': 'Sheet2!D5', 'E4': 'Sheet2!E5', 'F4': 'Sheet2!F5', 'G4': 'Sheet2!G5',
        'B5': 'B3-B4', 'C5': 'C3-C4', 'D5': 'D3-D4', 'E5': 'E3-E4', 'F5': 'F3-F4', 'G5': 'G3-G4',
    }
    for cell_ref, formula in formulas.items():
        formula_xml = f'<f>{formula}</f>'
        if f'r="{cell_ref}"' in content:
            content = re.sub(
                f'(<c r="{cell_ref}"[^>]*>)(?:<f>[^<]*</f>)?(?:<v>[^<]*</v>)?(</c>)',
                f'\\1{formula_xml}\\2',
                content
            )
    return content

def add_wc_formulas(content):
    formulas = {
        'C3': 'Sheet2!C3', 'D3': 'Sheet2!D3', 'E3': 'Sheet2!E3', 'F3': 'Sheet2!F3', 'G3': 'Sheet2!G3',
        'B4': '0', 'C4': 'C3*Sheet1!$B$12', 'D4': 'D3*Sheet1!$B$12', 'E4': 'E3*Sheet1!$B$12', 'F4': 'F3*Sheet1!$B$12', 'G4': 'G3*Sheet1!$B$12',
        'B5': '0', 'C5': '-C4', 'D5': '-(D4-C4)', 'E5': '-(E4-D4)', 'F5': '-(F4-E4)', 'G5': '-(G4-F4)',
    }
    for cell_ref, formula in formulas.items():
        formula_xml = f'<f>{formula}</f>'
        if f'r="{cell_ref}"' in content:
            content = re.sub(
                f'(<c r="{cell_ref}"[^>]*>)(?:<f>[^<]*</f>)?(?:<v>[^<]*</v>)?(</c>)',
                f'\\1{formula_xml}\\2',
                content
            )
    return content

def add_liquidation_formulas(content):
    formulas = {
        'B2': '0', 'C2': '0', 'D2': '0', 'E2': '0', 'F2': '0', 'G2': 'Sheet1!$B$5*(1-Sheet1!$B$7)',
        'B3': '0', 'C3': '0', 'D3': '0', 'E3': '0', 'F3': '0', 'G3': 'Sheet2!G4',
        'B4': '0', 'C4': '0', 'D4': '0', 'E4': '0', 'F4': '0', 'G4': 'G2+G3',
    }
    for cell_ref, formula in formulas.items():
        formula_xml = f'<f>{formula}</f>'
        if f'r="{cell_ref}"' in content:
            content = re.sub(
                f'(<c r="{cell_ref}"[^>]*>)(?:<f>[^<]*</f>)?(?:<v>[^<]*</v>)?(</c>)',
                f'\\1{formula_xml}\\2',
                content
            )
    return content

# MAIN
src = '/data/.openclaw/media/inbound/ORION_LIGHTING_STUDENT_TEMPLATE_1---bf3ba8cc-6ea8-4f7e-985c-5156a7abc4a8.xlsx'
dst = '/data/workspace/PROJECTS/ORION/ORION_LIGHTING_FILLED.xlsx'
shutil.copy(src, dst)

with zipfile.ZipFile(src, 'r') as zin:
    with zipfile.ZipFile(dst, 'w', zipfile.ZIP_DEFLATED) as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            if item.filename == 'xl/worksheets/sheet2.xml':
                data = add_fcf_formulas(data.decode('utf-8')).encode('utf-8')
            elif item.filename == 'xl/worksheets/sheet3.xml':
                data = add_bookvalue_formulas(data.decode('utf-8')).encode('utf-8')
            elif item.filename == 'xl/worksheets/sheet4.xml':
                data = add_wc_formulas(data.decode('utf-8')).encode('utf-8')
            elif item.filename == 'xl/worksheets/sheet5.xml':
                data = add_liquidation_formulas(data.decode('utf-8')).encode('utf-8')
            elif item.filename == 'xl/worksheets/sheet1.xml':
                data = add_inputs_formulas(data.decode('utf-8')).encode('utf-8')
            zout.writestr(item, data)

print(f"Created: {dst}")
