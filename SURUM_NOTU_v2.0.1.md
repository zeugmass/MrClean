# MrClean v2.0.1

Tweaks'e yeni **🧹 Debloat** kategorisi: Windows servislerini temiz kurulum varsayılanına göre, yedekli ve geri alınabilir şekilde kapatma. Ayrıca bütün ileti pencereleri yeni görünüme geçti ve Uygula akışı tek karta toplandı.

## 🧹 Debloat
- Servis kapatan mevcut 9 tweak bu kategoriye taşındı.
- 20 yeni "Güvenli" servis ayarı (ör. Windows Media Player ağ paylaşımı, Insider, iSCSI, Çevrimdışı Dosyalar, eşler arası ağ, Karma Gerçeklik).
- 17 yeni "Riskli" servis ayarı (ör. Yazdırma Biriktiricisi, Windows Arama, Konum, Pano Geçmişi, Bağlı Cihazlar, Kamera, Mobil Etkin Nokta, Hyper-V konuk servisleri).
- Varsayılanı "Otomatik" olan servislerde satırda **El ile | Devre dışı** seçimi.
- Geri alma, servisin değiştirilmeden önceki değerine döner; yedek yoksa Windows'un temiz kurulum varsayılanına döner.
- Bu Windows sürümünde bulunmayan servisler pasif görünür.
- Donanım / ortam algılama: yazıcı, tarayıcı, kamera, sensör, Bluetooth, hücresel modem, Wi-Fi, etki alanı, Insider, sanal makine vb. bulunursa satır kırmızı uyarılı olur ve seçince onay ister.

## Tweaks
- Yeni ayarlar: görev çubuğu bildirim rozetlerini gizle, uygulama yanıp sönmesini kapat, düşük disk alanı uyarısını kapat, masaüstü sağ tık menüsüne "BIOS / UEFI'ye yeniden başlat" (UAC onayı ister), güç menüsünden "Uyku"yu gizle.
- NetBIOS ayarı LMHOSTS aramasını da kapatıyor.
- Önerilen profiller yenilendi: v2.0.0 ayarları eklendi, donanıma göre kurallar (HDD, Ethernet, Wi-Fi, dizüstü, iki GPU, çift CCD X3D), AMD Adrenalin ayarı yalnız program kuruluysa.
- Ağ ve Ping: [SIFIRLA] Windows Varsayılanları bütün alt kategoriyi sıfırlar, etkilenen ayarlar anında görünür.
- Offload Profili / Alım Arabelleği yalnız değeri değişen ağ kartını yeniden başlatır; Uygula sırasında pencere donmuyor (önceden ~34 sn).
- RSS ayarı Realtek kartlarda doğru algılanıyor.

## Arayüz
- Uygula: ilerleme katmanı ve tek onay kartı (eşitleme, yüksek risk, GPU ve geri yükleme noktası soruları bir arada); Hızlı Geri Al aynı kartta.
- Bütün ileti ve metin giriş pencereleri programın temasında (Windows'un düz kutuları kaldırıldı).
- Defender istisnaları: oyun dışı istisnalar "Manuel" satırı ve filtresi; dar pencerede düzen düzeltildi.
- Benchmark durdurulabilir ("Durdur" düğmesi, kapatırken onay).

## Düzeltmeler
- Ağ Kalite Testi: geçmiş kaydının bozulması ve donan Kapat düğmesi.
- DNS'te "zaten uygulanmış" bildirimi, Benchmark tarih biçimi.

## Kurulum / güncelleme
- v2.0.0 kullanıcıları: durum çubuğundaki "Yeni sürüm" bildirimine tıklayın ya da Ayarlar > "Şimdi Kontrol Et".
- Yeni kurulum: `TemizlikAsistani.exe`'yi indirin, `SHA256SUMS.txt` ile doğrulayın, çalıştırın (yönetici izni ister).
- EXE imzasız olduğu için SmartScreen uyarısı çıkabilir: Ek bilgi > Yine de çalıştır.
