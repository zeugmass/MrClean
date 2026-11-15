# MrClean v2.0.3

Bu sürüm Tweaks sekmesini toparlıyor (kategori düzeni, adlar, risk etiketleri, önerilen profiller) ve NVIDIA optimizasyonu ile ayar denetimindeki hataları düzeltiyor. Yeni tweak eklenmedi.

## Tweaks sekmesi
- **Kategori düzeni:** "Sistem ve Oyun" ikiye ayrıldı. **Oyun** 11 satır (Oyun Özellikleri, Oyun Performansı); **Sistem** 20 satır (Klavye ve Menü, Açılış ve Oturum, Bellek ve Arka Plan, Depolama). "Gelişmiş Sistem (Batch)" artık **Gelişmiş Sistem**; bütün satırları alt başlıklı (Arama ve Copilot, Windows Update, Güvenlik Sıkılaştırma). Hiçbir ayar silinmedi, yaptıkları iş aynı.
- **Adlar:** 13 ayarın adı sadeleşti (örnek: "Çekirdek Park Etmeyi Kapat", "USB Seçici Askıya Almayı Kapat", "Şifresiz Girişi Kapat"). Daha önce uyguladığınız ayarlar yeni adlarıyla tanınır; yeniden uygulamanız gerekmez.
- **Risk etiketleri:** etiketi olmayan 48 ayara risk düzeyi yazıldı (42 düşük, 6 orta).

## Önerilen profiller
- **Oyun:** Yapışkan Tuşları Kapat eklendi. Nihai Performans planının seçildiği bilgisayarlarda "İşlemci minimum %100 — yalnız oyun açıkken" satırı artık birlikte seçilmiyor (ikisi aynı işi yapıyordu).
- **Hız:** Chrome arka planda çalışmasın, Discord donanım hızlandırması ve Debloat'taki "Servisler — Güvenli" satırlarının tamamı eklendi.
- **Gizlilik:** Wi-Fi'li dizüstülerde "Konum Hizmetlerini Tamamen Kapat" profile girmiyor.

## NVIDIA optimizasyonu
- Profil içe aktarıldıktan sonraki doğrulama sıkılaştı: yazılmamış bir ayar artık "doğrulandı" sayılmıyor.
- NVIDIA Profile Inspector sabit sürümle (v3.0.2.1) indiriliyor ve dosyanın SHA256 özeti doğrulanıyor.
- PhysX / geliştirici araçları ayarı doğru kayıt defteri yoluna yazılıyor.

## Ayar denetimi
- Sürücü ya da Windows güncellemesinden sonra çıkan denetim artık DNS ve güç planı satırlarını sormuyor (bilerek değiştirilen tercihler).
- Denetimi neyin tetiklediği (Windows, ekran kartı ya da ağ kartı; eski → yeni değer) kayda yazılıyor.
- Tweak denetimi sonundaki "değişen: yok — her şey yerinde" satırı, önceki denetim kaydı eskiyse de doğru karşılaştırma yapıyor.

## Diğer
- Timer testi penceresi sabit 0,5 ms yerine kayıtlı hedefi kullanıyor.

## Kurulum / güncelleme
- v2.0.2 kullanıcıları: sol menüdeki **Program Güncelle**'ye ya da durum çubuğundaki "Yeni sürüm" bildirimine tıklayın.
- Yeni kurulum: `TemizlikAsistani.exe`'yi indirin, `SHA256SUMS.txt` ile doğrulayın, çalıştırın (yönetici izni ister).
- EXE imzasız olduğu için SmartScreen uyarısı çıkabilir: Ek bilgi > Yine de çalıştır.
