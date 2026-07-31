# Excel Artifacts

This folder contains Excel-specific assets for the project.

## Files
- `excel_sql_workflows.xlsx`: generated workbook with raw-data sheets, Excel Tables, exercises, and summary formulas
- `formulas-reference.md`: formula patterns mapped to SQL, Power Query, and DAX intent

## Regenerate workbook
```powershell
python scripts/generate_excel_workbook.py
```

The workbook is generated from `data/raw/*.csv` and does not require Excel automation or macros.
