# MrClean v2.0.0

v1.2.30'dan bu yana en büyük güncelleme: arayüz baştan tasarlandı, Tweaks bölümü 93'ten 210 ayara çıktı, sık kullanılan işlemler belirgin şekilde hızlandı.

## Yeni arayüz
- Bütün sayfalar yeni koyu tasarımda: sol menü, sayfa başına özet kutuları, alttan açılan işlem kayıtları paneli, ince durum çubuğu.
- Arayüz yazı tipi Inter (programa gömülü, ayrı kurulum gerekmez).
- Bütün alt pencereler (Ayarlar, profil, Winget listesi, DNS / ağ testleri vb.) aynı görünüme getirildi.
- Yeni program simgesi.
- Temizlik: dört sekme tek sayfada, öğe başına boyut, seçili özet ve son temizlikler.
- Onarım, Araçlar, Winget, Başlangıç, Dosya Boyutu, Çökme Analizi ve Genel Bakış sayfaları yeniden düzenlendi.
- Tweak satırlarında açıklama kutusu: üzerine gelince ayarın ne yaptığı ve risk düzeyi görünür.

## Tweaks
- 210 ayar (v1.2.30'da 93): gizlilik, telemetri, reklam ve öneriler, görev çubuğu, arama, Windows Update, ağ ve ping, Wi-Fi, ses, GPU / ekran, güvenlik sıkılaştırma, düşük gecikme / oyun.
- Her ayarın bu bilgisayardaki gerçek durumu denetlenir; Uygula sonrası değişenler yeniden doğrulanır.
- Her ayarın risk etiketi ve açıklaması var; bu Windows sürümünde ya da donanımda çalışmayanlar ayrıca belirtilir.
- Güç planı değişince plana bağlı ayarlar yeni plana taşınır.
- Bu sürümde eklenen ayarlarda "YENİ" rozeti.
- Oyun ayarları (Windows'un kendi mekanizmalarıyla, ek program gerektirmez):
  - İşlemci minimum durumu %100, yalnız oyun açıkken (prizde).
  - Oyunlara yüksek işlemci önceliği.
  - CS2: işlemci çekirdeği 0'ı oyundan ayırma (geliştiricinin sisteminde gerçek CS2 ölçümü: ortalama FPS +%3,9, 1% low +%9,2).

## Ses
- Otomatik Ses: kulaklık / hoparlör / mikrofon için EQ profilleri (Equalizer APO), oyun açılınca "Oyun" modu, kapanınca varsayılan mod.

## Hız (geliştiricinin sisteminde ölçüldü)
- Açılış: ~6 sn → ~2,9 sn.
- Tweak denetimi (208 ayar): 11,9 sn → 3,7 sn.
- Dosya Boyutu taraması (C:\): 18,7 sn → 2,9 sn.
- Genel Bakış canlı güncellemesi: tik başına ~130 ms → 0,5 ms.

## Düzeltmeler
- SFC / DISM sırasında pencerenin donması giderildi.
- Kullanıcı ayar dosyası tweak risk etiketlerini ezmiyor.
- Yeni sürüm bildirimi doğru yere yönlendiriyor (durum çubuğuna tıklayın ya da Ayarlar > Şimdi Kontrol Et).
- Görünüm ayarlarından sonra masaüstü ve açık Gezgin pencereleri yenileniyor.

## Kaldırılanlar
- Araçlar menüsündeki MSI Utility, NVIDIA Profile Inspector girişi ve web araçları (Sürücü Yedeği artık Araçlar sayfasında kart).

## Kurulum / güncelleme
- v1.2.30 EXE kullanıcıları: program açılınca durum çubuğunda güncelleme bildirimi gelir; Tools menüsü > Programı Güncelle ile kurulur.
- Yeni kurulum: `TemizlikAsistani.exe`'yi indirin, `SHA256SUMS.txt` ile doğrulayın, çalıştırın (yönetici izni ister).
- EXE imzasız olduğu için SmartScreen uyarısı çıkabilir: Ek bilgi > Yine de çalıştır.
