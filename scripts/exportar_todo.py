import pyodbc
import pandas as pd
import os

conn_str = (
    "Driver={SQL Server};" 
    r"Server=localhost\SQLEXPRESS;"
    "Database=Elecciones2026DB17;"
    "Trusted_Connection=yes;"
)

def exportar_base_completa():
    try:
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        
  
        query_tablas = "SELECT name FROM sys.tables WHERE type = 'U'"
        cursor.execute(query_tablas)
        tablas = [row[0] for row in cursor.fetchall()]
        
        print(f"Se encontraron {len(tablas)} tablas. Iniciando exportación...")

   
        if not os.path.exists('data'):
            os.makedirs('data')

        for tabla in tablas:
            print(f"Exportando: {tabla}...", end="\r")
            query_datos = f"SELECT * FROM {tabla}"
            df = pd.read_sql(query_datos, conn)
            
      
            ruta = os.path.join("data", f"{tabla}.csv")
            df.to_csv(ruta, index=False, encoding='utf-8-sig')
            
        conn.close()
        print(f"\n ¡Éxito! Las {len(tablas)} tablas están en la carpeta /data")
        
    except Exception as e:
        print(f"\n Error: {e}")

if __name__ == "__main__":
    exportar_base_completa()