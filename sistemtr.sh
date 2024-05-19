#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'

REPO_API="https://api.github.com/repos/HasakiR10/SistemYoneticisiTR/releases/latest"
LATEST_RELEASE=$(curl -s $REPO_API | grep -Po '"tag_name": "\K.*?(?=")')
if [ -z "$LATEST_RELEASE" ]; then
  LATEST_RELEASE="Güncelleme bilgisi alınamadı"
fi

function menu {
  clear
  echo -e "${BLUE}SistemYoneticisiTR Sistem Asistanı v1.2${RESET}"
  echo -e "${CYAN}https://github.com/HasakiR10/SistemYoneticisiTR${RESET}"
  echo -e "${CYAN}En son sürüm: $LATEST_RELEASE${RESET}"
  echo -e "${GREEN}Coded By Hasaki${RESET}"
  echo -e "${YELLOW}Lütfen yapmak istediğiniz işlemi seçin:${RESET}"
  echo -e "${MAGENTA}1. Dosya İşlemleri${RESET}"
  echo -e "${MAGENTA}2. Sistem İzleme ve Yedekleme${RESET}"
  echo -e "${MAGENTA}3. Ekstra Araçlar${RESET}"
  echo -e "${MAGENTA}4. Gelişmiş Özellikler${RESET}"
  echo -e "${RED}0. Çıkış${RESET}"
  read -p "Seçim yapmak için numara girin: " main_choice
}

function dosya_islemleri_menu {
  clear
  echo -e "${YELLOW}Dosya İşlemleri${RESET}"
  echo -e "${GREEN}1. Dosya sistemi tarama aracı${RESET}"
  echo -e "${GREEN}2. Dosya yöneticisi${RESET}"
  echo -e "${GREEN}3. Dosya adı değiştirme ve sıralama${RESET}"
  echo -e "${GREEN}4. Belirli bir dosya boyutunu aşan dosyaları silme aracı${RESET}"
  echo -e "${GREEN}5. Dosya veya klasör izinlerini ayarlama aracı${RESET}"
  echo -e "${RED}0. Ana Menüye Dön${RESET}"
  read -p "Seçim yapmak için numara girin: " file_choice
}

function sistem_izleme_yedekleme_menu {
  clear
  echo -e "${YELLOW}Sistem İzleme ve Yedekleme${RESET}"
  echo -e "${GREEN}1. Otomatik yedekleme işlemi${RESET}"
  echo -e "${GREEN}2. Sistem performansı izleme aracı${RESET}"
  echo -e "${GREEN}3. Veritabanı yedekleme aracı${RESET}"
  echo -e "${GREEN}4. Dosyaları düzenleme tarihine göre sıralama${RESET}"
  echo -e "${GREEN}5. Sistem günlüğü izleyici${RESET}"
  echo -e "${RED}0. Ana Menüye Dön${RESET}"
  read -p "Seçim yapmak için numara girin: " sys_choice
}

function ekstra_araclar_menu {
  clear
  echo -e "${YELLOW}Ekstra Araçlar${RESET}"
  echo -e "${GREEN}1. Hız testi aracı${RESET}"
  echo -e "${GREEN}2. Dosya şifreleme aracı${RESET}"
  echo -e "${GREEN}3. Dosya çözme aracı${RESET}"
  echo -e "${GREEN}4. Dosya kurtarma aracı${RESET}"
  echo -e "${GREEN}5. Kullanıcı takip aracı${RESET}"
  echo -e "${GREEN}6. Asistan güncelleme aracı${RESET}"
  echo -e "${RED}0. Ana Menüye Dön${RESET}"
  read -p "Seçim yapmak için numara girin: " extra_choice
}

function gelismis_ozellikler_menu {
  clear
  echo -e "${YELLOW}Gelişmiş Özellikler${RESET}"
  echo -e "${GREEN}1. Otomatik Sistem Yeniden Başlatma${RESET}"
  echo -e "${GREEN}2. Günlük Raporlama${RESET}"
  echo -e "${GREEN}3. Ağ Bilgisi${RESET}"
  echo -e "${GREEN}4. Otomatik Dosya Arşivleme${RESET}"
  echo -e "${GREEN}5. Güvenlik Denetimleri${RESET}"
  echo -e "${GREEN}6. Zamanlanmış Görevler${RESET}"
  echo -e "${GREEN}7. Otomatik Veritabanı Bakımı${RESET}"
  echo -e "${GREEN}8. Etkinlik Günlüğü İzleme${RESET}"
  echo -e "${RED}0. Ana Menüye Dön${RESET}"
  read -p "Seçim yapmak için numara girin: " adv_choice
}

function dosya_tarama {
  read -p "Dosya uzantısı girin: " extension
  echo -e "${CYAN}Taranıyor...${RESET}"
  find / -name "*.$extension" 2>/dev/null
}

function yedekle {
  read -p "Yedeklemek istediğiniz klasörün yolunu girin: " folder
  read -p "Yedeklemeyi kaydetmek istediğiniz klasörün yolunu girin: " backup_dir
  date=$(date +%F)
  tar -czf "$backup_dir/backup-$date.tar.gz" "$folder"
  echo -e "${GREEN}Yedekleme tamamlandı: $backup_dir/backup-$date.tar.gz${RESET}"
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
  echo -e "${BLUE}CPU Kullanımı: $cpu${RESET}"
  echo -e "${BLUE}RAM Kullanımı: $mem${RESET}"
  echo -e "${BLUE}Disk Kullanımı: $disk${RESET}"
}

function veritabani_yedekle {
  read -p "Yedeklemek istediğiniz veritabanının adını girin: " db_name
  read -p "Yedeklemeyi kaydetmek istediğiniz klasörün yolunu girin: " backup_dir
  date=$(date +%F)
  mysqldump -u root -p "$db_name" | gzip > "$backup_dir/$db_name-$date.sql.gz"
  echo -e "${GREEN}Yedekleme tamamlandı: $backup_dir/$db_name-$date.sql.gz${RESET}"
}

function buyuk_dosyalari_sil {
  read -p "Silmek istediğiniz dosya boyutunu MB cinsinden girin: " size
  read -p "Hangi klasördeki dosyaları silmek istiyorsunuz? " folder
  find "$folder" -type f -size +"$size"M -delete
  echo -e "${RED}$size MB'dan büyük dosyalar silindi.${RESET}"
}

function izin_ayarla {
  read -p "Hangi dosya/klasör için izinleri değiştirmek istiyorsunuz? " file_or_folder
  read -p "Dosya için izinleri ayarlamak için 1, klasör için 2 girin: " option
  case $option in
     1)
       read -p "Dosya için yeni izinleri girin (örn. 644): " permissions
       chmod "$permissions" "$file_or_folder"
       echo -e "${GREEN}Dosya izinleri güncellendi.${RESET}"
       ;;
     2)
       read -p "Klasör için yeni izinleri girin (örn. 755): " permissions
       chmod -R "$permissions" "$file_or_folder"
       echo -e "${GREEN}Klasör izinleri güncellendi.${RESET}"
       ;;
     *)
       echo -e "${RED}Geçersiz seçenek.${RESET}" ;;
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
      echo -e "${RED}speedtest-cli yüklenmemiş, yükleniyor...${RESET}"
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

function asistan_guncelle {
  repository_url="https://github.com/HasakiR10/SistemYoneticisiTR.git"
  git -C "$repository_url" pull
  last_updated=$(git -C "$repository_url" log -1 --format="%cd" --date=short)
  echo -e "${GREEN}Son güncelleme: $last_updated${RESET}"
}

function otomatik_sistem_yeniden_baslatma {
  sudo reboot
}

function gunluk_raporlama {
  REPORT="/var/log/daily_report.log"
  echo "Disk Kullanımı:" > $REPORT
  df -h >> $REPORT

  echo "Bellek Kullanımı:" >> $REPORT
  free -h >> $REPORT

  echo "Çalışan Süreçler:" >> $REPORT
  ps aux >> $REPORT

  echo -e "${GREEN}Günlük rapor oluşturuldu: $REPORT${RESET}"
}

function ag_yonetimi {
  ifconfig -a
}

function otomatik_dosya_arsivleme {
  tar -czf /backup/home_backup_$(date +%F).tar.gz /home
  echo -e "${GREEN}Dosyalar arşivlendi: /backup/home_backup_$(date +%F).tar.gz${RESET}"
}

function guvenlik_denetimleri {
  echo "Açık bağlantı noktaları:" > /var/log/security_audit.log
  netstat -tuln >> /var/log/security_audit.log

  echo "Yüklü paketler:" >> /var/log/security_audit.log
  dpkg -l >> /var/log/security_audit.log

  echo -e "${GREEN}Güvenlik denetimi tamamlandı: /var/log/security_audit.log${RESET}"
}

function zamanlanmis_gorevler {
  crontab -l
}

function otomatik_veritabani_bakimi {
  mysqlcheck -u root -p --optimize --all-databases
  echo -e "${GREEN}Veritabanı bakımı tamamlandı.${RESET}"
}

function etkinlik_gunlugu_izleme {
  tail -f /var/log/syslog
}

while true
do
  menu
  case $main_choice in
    1)
      dosya_islemleri_menu
      case $file_choice in
        1) dosya_tarama ;;
        2) dosya_yoneticisi ;;
        3) dosya_degistirme ;;
        4) buyuk_dosyalari_sil ;;
        5) izin_ayarla ;;
        0) continue ;;
        *) echo -e "${RED}Geçersiz seçim, lütfen tekrar deneyin.${RESET}" ;;
      esac
      ;;
    2)
      sistem_izleme_yedekleme_menu
      case $sys_choice in
        1) yedekle ;;
        2) performans_izleme ;;
        3) veritabani_yedekle ;;
        4) dosya_siralama ;;
        5) sistem_izleyici ;;
        0) continue ;;
        *) echo -e "${RED}Geçersiz seçim, lütfen tekrar deneyin.${RESET}" ;;
      esac
      ;;
    3)
      ekstra_araclar_menu
      case $extra_choice in
        1) hiz_testi ;;
        2) dosya_sifreleme ;;
        3) dosya_sifre_cozme ;;
        4) dosya_kurtarma ;;
        5) kullanici_takip ;;
        6) asistan_guncelle ;;
        0) continue ;;
        *) echo -e "${RED}Geçersiz seçim, lütfen tekrar deneyin.${RESET}" ;;
      esac
      ;;
    4)
      gelismis_ozellikler_menu
      case $adv_choice in
        1) otomatik_sistem_yeniden_baslatma ;;
        2) gunluk_raporlama ;;
        3) ag_yonetimi ;;
        4) otomatik_dosya_arsivleme ;;
        5) guvenlik_denetimleri ;;
        6) zamanlanmis_gorevler ;;
        7) otomatik_veritabani_bakimi ;;
        8) etkinlik_gunlugu_izleme ;;
        0) continue ;;
        *) echo -e "${RED}Geçersiz seçim, lütfen tekrar deneyin.${RESET}" ;;
      esac
      ;;
    0) echo -e "${GREEN}Program sonlandırıldı.${RESET}" && exit ;;
    *) echo -e "${RED}Geçersiz seçim, lütfen tekrar deneyin.${RESET}" ;;
  esac
  read -p "Devam etmek için herhangi bir tuşa basın..."
done
