import os
import socket
from datetime import datetime

import psycopg2
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)


def get_db():
    return psycopg2.connect(
        host=os.environ.get("PGHOST", "localhost"),
        port=os.environ.get("PGPORT", "5432"),
        dbname=os.environ.get("PGDATABASE", "cloudbuild"),
        user=os.environ.get("PGUSER", "cloudbuild"),
        password=os.environ.get("PGPASSWORD", "cloudbuild"),
    )


def init_db():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS messages (
            id SERIAL PRIMARY KEY,
            author VARCHAR(100) NOT NULL,
            content TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        )
    """)
    conn.commit()
    cur.close()
    conn.close()


@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        author = request.form.get("author", "").strip()
        content = request.form.get("content", "").strip()
        if author and content:
            conn = get_db()
            cur = conn.cursor()
            cur.execute(
                "INSERT INTO messages (author, content) VALUES (%s, %s)",
                (author, content),
            )
            conn.commit()
            cur.close()
            conn.close()
        return redirect(url_for("index"))

    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT id, author, content, created_at FROM messages ORDER BY created_at DESC")
    messages = cur.fetchall()
    cur.close()
    conn.close()

    return render_template(
        "index.html",
        messages=messages,
        hostname=socket.gethostname(),
        db_host=os.environ.get("PGHOST", "localhost"),
        db_name=os.environ.get("PGDATABASE", "cloudbuild"),
    )


@app.route("/health")
def health():
    try:
        conn = get_db()
        cur = conn.cursor()
        cur.execute("SELECT 1")
        cur.close()
        conn.close()
        return {"status": "ok"}, 200
    except Exception as e:
        return {"status": "error", "detail": str(e)}, 500


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=8080)
