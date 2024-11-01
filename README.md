gitlabbackup.sh scripti on-prem ortamda kurulu gitlab makinanızın yedeğini almak için tasarlandı. 

**Adım 1: SSMTP Kurulumu**

```sudo apt update```

```sudo apt install ssmtp```

**Adım 2: SSMTP Yapılandırma Dosyasını Düzenleme**

```sudo nano /etc/ssmtp/ssmtp.conf```

```
root=postmaster
mailhub=smtp.yourmailserver.com:587
rewriteDomain=yourmailserver.com
AuthUser=your-email@example.com
AuthPass='your-email-password'
UseTLS=YES
UseSTARTTLS=YES
```

**Adım 3: SSMTP Kullanıcıları Dosyasını Düzenleme**

```sudo nano /etc/ssmtp/revaliases```

```
root:your-email@example.com:smtp.office365.com:587
```

**Adım 4: SSMTP'i Başlatma**

```sudo systemctl start ssmtp```

```sudo systemctl enable ssmtp```

**Adım 5: E-posta Gönderme Testi**

```
echo "Test email" | ssmtp recipient@example.com
```

**Adım 6: Scripti crontab'a ekleyip belirlediğiniz tarih ve saatte çalıştırabilirsiniz.**

```nano /etc/crontab```

```
00 00  * * * root /path/to/gitlabbackup.sh
```
 
