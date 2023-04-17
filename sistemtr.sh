#!/bin/bash

function menu {
  clear
  echo "Coded By Hasaki"
  echo "Lütfen yapmak istediğiniz işlemi seçin:"
  echo "1. Dosya sistemi tarama aracı"
  echo "2. Otomatik yedekleme işlemi"
  echo "3. Dosya yöneticisi"
  echo "4. Dosya adı değiştirme ve sıralama"
  echo "5. Sistem performansı izleme aracı"
  echo "6. Veritabanı yedekleme aracı"
  echo "7. Belirli bir dosya boyutunu aşan dosyaları silme aracı"
  echo "8. Dosya veya klasör izinlerini ayarlama aracı"
  echo "9. Çıkış"
  read -p "Seçim yapmak için numara girin: " choice
}

function dosya_tarama {
  read -p "Dosya uzantısı girin: " extension
  echo "Taranıyor..."
  find / -name "*.$extension" 2>/dev/null
}

function yedekle {
  read -p "Yedeklemek istediğiniz klasörün yolunu girin: " folder
  read -p "Yedeklemeyi kaydetmek istediğiniz klasörün yolunu girin: " backup_dir
  date=$(date +%F)
  tar -czf "$backup_dir/backup-$date.tar.gz" "$folder"
  echo "Yedekleme tamamlandı: $backup_dir/backup-$date.tar.gz"
}

function dosya_yoneticisi {
  read -p "Açmak istediğiniz program veya dosya adını girin: " file_name
  read -p "Hangi programla açmak istersiniz? " program_name
  "$program_name" "$file_name"
}

function dosya_degistirme {
  read -p "Dosyaların bulunduğu klasörün yolunu girin: " folder
  for file in "$folder"/*; do
      mv "$file" "${file%.*}-$(date +%F).${file##*.}"
  done
  ls -lt "$folder"
}

function performans_izleme {
  cpu=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
  mem=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2}')
  disk=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
  echo -e "CPU Kullanımı: $cpu\nRAM Kullanımı: $mem\nDisk Kullanımı: $disk"
}

function veritabani_yedekle {
  read -p "Yedeklemek istediğiniz veritabanının adını girin: " db_name
  read -p "Yedeklemeyi kaydetmek istediğiniz klasörün yolunu girin: " backup_dir
  date=$(date +%F)
  mysqldump -u root -p$password "$db_name" | gzip > "$backup_dir/$db_name-$date.sql.gz"
  echo "Yedekleme tamamlandı: $backup_dir/$db_name-$date.sql.gz"
}

function buyuk_dosyalari_sil {
  read -p "Silmek istediğiniz dosya boyutunu MB cinsinden girin: " size
  read -p "Hangi klasördeki dosyaları silmek istiyorsunuz? " folder
  find "$folder" -type f -size +"$size"M -delete
  echo "$size MB'dan büyük dosyalar silindi."
}


function izin_ayarla {
  read -p "Hangi dosya/klasör için izinleri değiştirmek istiyorsunuz? " file_or_folder
  read -p "Dosya için izinleri ayarlamak için 1, klasör için 2 girin: " option
  case $option in
     1)
       read -p "Dosya için yeni izinleri girin (örn. 644): " permissions
       chmod "$permissions" "$file_or_folder"
       echo "Dosya izinleri güncellendi."
       ;;
     2)
       read -p "Klasör için yeni izinleri girin (örn. 755): " permissions
       chmod -R "$permissions" "$file_or_folder"
       echo "Klasör izinleri güncellendi."
       ;;
     *)
       echo "Geçersiz seçenek." ;;
  esac
}

while true
do
  menu
  case $choice in
    1) dosya_tarama ;;
    2) yedekle ;;
    3) dosya_yoneticisi ;;
    4) dosya_degistirme ;;
    5) performans_izleme ;;
    6) veritabani_yedekle ;;
    7) buyuk_dosyalari_sil ;;
    8) izin_ayarla ;;
    9) echo "Program sonlandırıldı." && exit ;;
    *) echo "Geçersiz seçim, lütfen tekrar deneyin." ;;
  esac
  read -p "Devam etmek için herhangi bir tuşa basın..."
done
