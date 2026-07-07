import csv
import os
import re
from pathlib import Path

import pyodbc
from dotenv import load_dotenv


ROOT_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = Path(os.getenv("DATA_DIR", ROOT_DIR / "data"))

TABLE_LOAD_ORDER = [
    "Partido",
    "Candidato",
    "Ubicacion",
    "EducacionBasica",
    "EstudiosTecnicos",
    "EstudiosNoUniversitarios",
    "EducacionUniversitaria",
    "Posgrado",
    "ExperienciaLaboral",
    "CargoPartidario",
    "RelacionSentencias",
    "Ingresos",
    "Bien",
    "VisitaCampaña",
    "FuenteInformacion",
    "ClasificacionLegalPenal",
    "VariableSecundaria",
    "SubVariable",
    "ClasificacionVariable",
    "NoticiasPendientes",
]


def build_connection() -> pyodbc.Connection:
    server = os.environ["AZURE_SQL_SERVER"]
    database = os.environ.get("AZURE_SQL_DATABASE", "Elecciones2026DW")
    user = os.environ["AZURE_SQL_USER"]
    password = os.environ["AZURE_SQL_PASSWORD"]
    driver = os.environ.get("ODBC_DRIVER", "ODBC Driver 17 for SQL Server")

    connection_string = (
        f"DRIVER={{{driver}}};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"UID={user};"
        f"PWD={password};"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    )
    return pyodbc.connect(connection_string)


def normalize_value(value):
    if value is None:
        return None
    stripped = value.strip()
    if stripped == "":
        return None
    if stripped.lower() == "true":
        return 1
    if stripped.lower() == "false":
        return 0
    if re.fullmatch(r"-?\d+\.0", stripped):
        return int(float(stripped))
    return stripped


def load_table(cursor: pyodbc.Cursor, table_name: str, csv_path: Path) -> int:
    with csv_path.open("r", encoding="utf-8-sig", newline="") as file:
        reader = csv.DictReader(file)
        columns = reader.fieldnames or []
        rows = [
            tuple(normalize_value(row[column]) for column in columns)
            for row in reader
        ]

    if not columns or not rows:
        return 0

    column_sql = ", ".join(f"[{column}]" for column in columns)
    placeholders = ", ".join("?" for _ in columns)
    insert_sql = f"INSERT INTO dbo.[{table_name}] ({column_sql}) VALUES ({placeholders})"

    # Keep this disabled for GitHub-hosted Windows runners. With mixed-width
    # text columns, pyodbc can infer an undersized buffer and fail with
    # "String data, right truncation" before SQL Server receives the rows.
    cursor.fast_executemany = False
    cursor.executemany(insert_sql, rows)
    return len(rows)


def main() -> None:
    load_dotenv(ROOT_DIR / ".env")

    with build_connection() as connection:
        cursor = connection.cursor()
        total_rows = 0

        for table_name in reversed(TABLE_LOAD_ORDER):
            cursor.execute(f"DELETE FROM dbo.[{table_name}]")

        for table_name in TABLE_LOAD_ORDER:
            csv_path = DATA_DIR / f"{table_name}.csv"
            if not csv_path.exists():
                print(f"SKIP {table_name}: no existe {csv_path}")
                continue

            inserted = load_table(cursor, table_name, csv_path)
            total_rows += inserted
            print(f"OK {table_name}: {inserted} filas")

        connection.commit()
        print(f"Carga finalizada: {total_rows} filas")


if __name__ == "__main__":
    main()
