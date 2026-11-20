# MrClean v2.0.4

Bu sürüm format sonrası toplu Uygula'da çıkan doğrulama hatalarını, Windows Ayarlar > Güç sayfasının çökmesini ve "Görsel Efektler: Özel" ayarını düzeltiyor; oyun ajanına EPP ayarını ve iki yeni güç tweak'ini ekliyor.

## Yeni
- **Uykuyu ve Hazırda Beklemeyi Kapat (Prizde: Asla)** ve **Ekranın Kapanmasını Engelle (Prizde: Asla)**: etkin güç planında prizdeyken uyku, hazırda bekletme ve ekran zaman aşımını "Hiçbir zaman" yapar. Geri alma önceki değere, yedek yoksa planın Windows varsayılanına döner. Ekran ayrı satır, çünkü OLED ekranlarda sabit görüntü iz bırakabilir.

## Oyun ajanı ("İşlemci Minimum Durumu %100 — Yalnız Oyun Açıkken")
- Oyun açıkken işlemci minimumunun yanında **işlemci enerji performansı tercihini (EPP) de 0** yapar; oyun kapanınca ikisi de önceki değere döner.
- Ölçüm (Ryzen 7 9800X3D, Dengeli plan, Benchmark'ın CS2 benzeri yükü, 3'er tur): minimum %100 iken EPP 25 → 0, ortalama 798 → 903 FPS, 1% low 765 → 829.
- **Bu tweak'i daha önce uyguladıysanız satır pasif görünür; yeniden Uygula** yeni ajanı kurar.
- Benchmark, bu tweak uygulanmışsa ölçüm süresince aynı oyun koşulunu kurar ve sonunda geri alır; karşılaştırma penceresinde "oyun koşulu" yazar. Önceki sürümlerde benchmark bu koşul olmadan ölçüyordu, bu yüzden eski ölçümlerle doğrudan karşılaştırmayın.

## Düzeltmeler
- **Sensör Servislerini Kapat:** artık SensorService'e dokunmuyor. Kapalıyken Windows Ayarlar > Sistem > Güç sayfası çöküyordu. Satır yeni adıyla tanınır, yeniden uygulamanız gerekmez.
- **Görsel Efektler: Özel:** menü, araç ipucu ve denetim animasyonları oturumda açık kalıyordu; artık her efekt tek tek kapatılıyor ve denetim oturumdaki gerçek durumu da kontrol ediyor.
- **NVIDIA Optimizasyonu:** ağ kartını yeniden başlatan bir tweak'ten hemen sonra Inspector indirilemiyordu. Inspector artık tweak'ler uygulanmadan önce indiriliyor; indirme başarısız olursa ağ beklenip yeniden deneniyor.
- **Tanılama Hizmet Konağını Kapat:** Windows'un korumalı servis anahtarında ayar servis yöneticisi üzerinden değiştiriliyor; geri alma da aynı yolla.
- **Telemetri Zamanlanmış Görevleri:** Windows'un yöneticiye bile kapattırmadığı görev listeden çıkarıldı; reddedilen başka bir görev olursa kayda adıyla yazılıyor ve doğrulamada atlanıyor.
- **Copilot ve Recall Görev Çubuğu Sabitlemeleri:** Explorer'ın geri çevirdiği değer düzeltildi; denetim görev çubuğundaki gerçek sabitlemeye bakıyor.

## Açıklamalar
- **Yüksek Performans Güç Planı:** yonga seti sürücüsünün güç profili planın işlemci minimumunu ve EPP'sini değiştirebiliyor (ölçülen bilgisayarda minimum %0, EPP 10). Plan tek başına oyun koşulunu kurmaz; bunu oyun ajanı yapar. Açıklama buna göre güncellendi.
- **İşlemci Boşta Durumlarını Kapat:** EPP ile ilgili cümle yeni ölçümle uyumlu hale getirildi.

## Kurulum / güncelleme
- v2.0.3 kullanıcıları: sol menüdeki **Program Güncelle**'ye ya da durum çubuğundaki "Yeni sürüm" bildirimine tıklayın.
- Yeni kurulum: `TemizlikAsistani.exe`'yi indirin, `SHA256SUMS.txt` ile doğrulayın, çalıştırın (yönetici izni ister).
- EXE imzasız olduğu için SmartScreen uyarısı çıkabilir: Ek bilgi > Yine de çalıştır.
