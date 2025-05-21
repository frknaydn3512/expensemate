#!/bin/bash

# Flutter SQLite dosyasını terminalde görüntülemek için betik
# Kullanım: ./dump_db.sh

DB_PATH="$HOME/Library/Developer/CoreSimulator/Devices/*/data/Containers/Data/Application/*/Documents/expenses.db"

echo "SQLite dosya yolunu arıyor..."
db_file=$(find $HOME -type f -name "expenses.db" 2>/dev/null | head -n 1)

if [ -z "$db_file" ]; then
  echo "❌ expenses.db bulunamadı. Uygulamayı çalıştırıp en az bir kayıt oluşturmuş musunuz?"
  exit 1
fi

echo "✅ Veritabanı bulundu: $db_file"
echo "🔍 İçerik gösteriliyor..."
sqlite3 "$db_file" <<EOF
.headers on
.mode column
SELECT * FROM users;
SELECT * FROM expenses;
EOF
