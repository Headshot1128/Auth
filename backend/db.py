import sqlite3
from fastapi import HTTPException
from contextlib import contextmanager
from pathlib import Path


@contextmanager
def connect(settings):
    db = sqlite3.connect(settings.database, timeout=10)
    db.row_factory = sqlite3.Row
    db.execute('PRAGMA foreign_keys=ON')
    try:
        # Serialize writes and authorization decisions across worker processes.
        db.execute('BEGIN IMMEDIATE')
        yield db
        db.commit()
    except HTTPException:
        # Expected denials may contain audit events, throttle counters, or replay revocations.
        db.commit()
        raise
    except BaseException:
        db.rollback()
        raise
    finally:
        db.close()


def migrate(settings):
    with sqlite3.connect(settings.database) as db:
        db.execute('PRAGMA journal_mode=WAL')
        db.execute('CREATE TABLE IF NOT EXISTS schema_migrations(version INTEGER PRIMARY KEY)')
        migrations_dir = Path(__file__).parent / 'migrations'
        for file in sorted(migrations_dir.glob('*.sql')):
            prefix = file.name.split('_')[0]
            if prefix.isdigit():
                version = int(prefix)
                if not db.execute('SELECT 1 FROM schema_migrations WHERE version=?', (version,)).fetchone():
                    sql = file.read_text()
                    db.executescript('BEGIN IMMEDIATE;\n' + sql + '\nCOMMIT;')
