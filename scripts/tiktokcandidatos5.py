import requests
import pyodbc
import time
import re

# --- CONFIGURACIÓN DE CONEXIÓN ---
conn_str = r"Driver={SQL Server};Server=localhost\SQLEXPRESS;Database=Elecciones2026DB17;Trusted_Connection=yes;"

def get_tiktok_data(username):
    if not username or username == "None":
        return None
    try:
        url = f"https://www.tiktok.com/@{username}"
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept-Language': 'es-ES,es;q=0.9'
        }
        
        response = requests.get(url, headers=headers, timeout=15)
        if response.status_code == 200:
            html = response.text
            # Buscamos los 3 datos clave usando expresiones regulares
            followers = re.search(r'"followerCount":(\d+)', html)
            hearts = re.search(r'"heartCount":(\d+)', html)
            videos = re.search(r'"videoCount":(\d+)', html)

            return {
                'followers': int(followers.group(1)) if followers else 0,
                'hearts': int(hearts.group(1)) if hearts else 0,
                'videos': int(videos.group(1)) if videos else 0
            }
        return None
    except Exception:
        return None

try:
    print("Conectando a SQL Server...")
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()
    
    cursor.execute("SELECT IdCandidato, Usuario FROM CandidatoRedSocial")
    candidatos = cursor.fetchall()

    print(f"Actualizando {len(candidatos)} candidatos con info completa...\n")

    for id_c, user in candidatos:
        if user:
            print(f"Procesando @{user}...", end=" ", flush=True)
            data = get_tiktok_data(user)
            
            if data:
                # 1. Actualizamos la tabla principal (Asegúrate de tener estas columnas en tu SQL)
                # Si no tienes columnas de Likes/Videos, solo se guardarán seguidores.
                try:
                    query_upd = """
                        UPDATE CandidatoRedSocial 
                        SET Seguidores=?, Likes=?, Videos=? 
                        WHERE IdCandidato=?
                    """
                    cursor.execute(query_upd, (data['followers'], data['hearts'], data['videos'], id_c))
                    
                    # 2. Insertamos en el historial
                    query_hist = """
                        INSERT INTO HistorialTikTok (IdCandidato, Usuario, Seguidores, Likes, Videos) 
                        VALUES (?,?,?,?,?)
                    """
                    cursor.execute(query_hist, (id_c, user, data['followers'], data['hearts'], data['videos']))
                    
                    print(f"✅ Seg: {data['followers']} | Likes: {data['hearts']} | Vid: {data['videos']}")
                except Exception as db_err:
                    print(f"❌ Error en SQL: Revisa si tus columnas existen.")
            else:
                print(f"❌ No se pudo leer la web.")
            
            time.sleep(5) # Mantenemos los 5 segundos para seguridad

    conn.commit()
    print("\n¡ACTUALIZACIÓN COMPLETA!")

except Exception as e:
    print(f"\nError: {e}")
finally:
    if 'conn' in locals():
        conn.close()