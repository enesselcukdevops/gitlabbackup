#!/bin/bash

# Değişkenler
backup_location="/path/to/your/backup/location"
email_recipient="your-email@example.com"
subject_success="GitLab Backup: Success"
subject_failure="GitLab Backup: Failure"

# Yedekleme işlemi
sudo gitlab-rake gitlab:backup:create
if [ $? -eq 0 ]; then
  # Yedekleri belirli bir dizine taşıma
  mv /var/opt/gitlab/backups/*.tar $backup_location

  # Yedekleme dizinine git
  cd $backup_location

  # Geçici bir dizin oluştur
  mkdir -p temp_backups

  # Son 7 günlük yedekleri kopyala
  find . -name '*.tar' -mtime -7 -exec cp {} temp_backups/ \;

  # Yedek dosyalarını birleştir ve arşivle
  merged_file="merged_backup_$(date +%Y%m%d).tar.gz"
  tar -czf $merged_file -C temp_backups .

  # Geçici dizini temizle
  rm -rf temp_backups

  # 30 günden eski yedek dosyalarını sil
  find . -name '*.tar' -mtime +30 -exec rm {} \;

  # Yedeklenen dosyanın bilgileri
  file_size=$(du -sh $merged_file | cut -f1)
  file_path=$(realpath $merged_file)

  # Başarılı e-posta bildirimi
  echo -e "Yedekleme Başarılı!\nYedeklenen Dosya: $merged_file\nDosya Boyutu: $file_size\nYedekleme Dizini: $file_path" | ssmtp $email_recipient
else
  # Başarısız e-posta bildirimi
  echo "Yedekleme Başarısız!" | ssmtp $email_recipient
fi