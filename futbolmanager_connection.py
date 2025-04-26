import psycopg2
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

try:
    # Connect to the database using environment variables
    conn = psycopg2.connect(
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT")
    )
    print("✅ Connection successful!")

    # Optional: run a simple query
    cur = conn.cursor()
    cur.execute('SELECT version();')
    db_version = cur.fetchone()
    print(f"PostgreSQL Database Version: {db_version}")

    cur.close()
    conn.close()

except Exception as e:
    print("❌ Connection failed.")
    print(e)
