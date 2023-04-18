#!/bin/bash

function menu {
  clear
  echo "SistemYoneticisiTR Sistem Asistanı v1.2"
  echo "https://github.com/HasakiR10/SistemYoneticisiTR"
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
  echo "9. Dosyaları düzenleme tarihine göre sıralama"
  echo "10. Sistem günlüğü izleyici"
  echo "11. Hız testi aracı"
  echo "12. Dosya şifreleme aracı"
  echo "13. Dosya çözme aracı"
  echo "14. Dosya kurtarma aracı"
  echo "15. Kullanıcı takip aracı"
  echo "16. Asistan güncelleme aracı"
  echo "0. Çıkış"
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

function dosya_siralama {
  read -p "Dosyaları hangi klasöre göre sıralamak istersiniz? " folder
  ls -lt "$folder"
}


function sistem_izleyici {
  tail -f /var/log/syslog | grep "critical"
}

function hiz_testi {
  if ! command -v speedtest-cli &> /dev/null; then
      echo "speedtest-cli yüklenmemiş, yükleniyor..."
      sudo apt-get install speedtest-cli
  fi
  speedtest-cli
}

function dosya_sifreleme {
  read -p "Şifrelenecek dosyanın adını girin: " dosya
  gpg -c $dosya
}

function dosya_sifre_cozme {
  read -p "Çözülecek dosyanın adını girin: " dosya
  gpg -d $dosya
}

function dosya_kurtarma {
  read -p "Kurtarma klasörünün tam yolunu girin: " kurtarma_klasoru
  read -p "Kurtarılacak dosyanın tam yolunu girin: " dosya_yolu
  read -p "Dosyanın nereye taşınacağını girin: " hedef_klasor
  mv "$kurtarma_klasoru/$(basename "$dosya_yolu")" "$hedef_klasor/"
}

function kullanici_takip {
  read -p "Kullanıcı adını girin: " user
  login_time=$(last | grep $user | head -n 1 | awk '{print $4" "$5}')
  echo "Kullanıcı oturum açtı: $login_time" >> /home/$user/login_time.txt
}

function asistan_guncelle() {
  repository_url="https://github.com/HasakiR10/SistemYoneticisiTR.git"
  git -C "$repository_url" pull
  last_updated=$(git -C "$repository_url" log -1 --format="%cd" --date=short)
  echo "Son güncelleme: $last_updated"
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
    9) dosya_siralama ;;
    10) sistem_izleyici ;;
    11) hiz_testi ;;
    12) dosya_sifreleme ;;
    13) dosya_sifre_cozme ;;
    14) dosya_kurtarma ;;
    15) kullanici_takip ;;
    16) asistan_guncelle ;;
    0) echo "Program sonlandırıldı." && exit ;;
    *) echo "Geçersiz seçim, lütfen tekrar deneyin." ;;
  esac
  read -p "Devam etmek için herhangi bir tuşa basın..."
done
