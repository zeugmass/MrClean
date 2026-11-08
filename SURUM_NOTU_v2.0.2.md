# MrClean v2.0.2

Bu sürümdeki ayarların çoğu eklenmeden önce ve sonra ölçüldü; kazancı görünmeyen ya da yan etkisi olan ayarlar programa alınmadı. Yeni **🧩 Uygulamalar** kategorisi, Intel / AMD üretici servisleri ve yer değiştiren güncelleme düğmeleri de bu sürümde.

## Yeni ayarlar
- **Servis İşlemlerini Birleştir (svchost):** servisler 3,5 GB altı bilgisayarlardaki gibi gruplanır. Ölçüm (32 GB): svchost 72 → 40, toplam işlem 192 → 158, kullanılan RAM ~370 MB az. Ping ve ortalama FPS değişmedi.
- MMCSS arka plan payı %10, masaüstü vsync boşta zaman aşımı, Hata Toleranslı Yığın (FTH), Uyku İzleme Günlüğü (SleepStudy), Windows Arama'nın konum / web kullanımı, Ethernet gönderim arabelleği, Depolama Algısı. Ölçümde performans farkı görülmedi; tercih olarak sunuluyor, açıklamalarında yazıyor.
- **NVIDIA tweak'i:** ekran kartı sürücüsü değişince ayarlar bir kez doğrulanır (kayıt defteri hemen, profil arka planda).

## 🧩 Uygulamalar (yeni kategori)
- **Discord:** Windows ile başlamasın; donanım hızlandırmayı kapat (ölçüm: özel bellek 896 → 577 MB, ekran kartı belleği 162 → 0 MB). Discord açıksa onay istenir, kapatılıp yeniden açılır; ayar dosyasında yalnız ilgili ayar değişir.
- **Chrome:** kapatınca arka planda çalışmasın; yazım denetimi ve geri bildirim verisini göndermesin.
- **Çevre birimleri:** Logitech G HUB sanal kumanda sürücüleri, SteelSeries Sonar sanal ses sürücüsü (riskli, yalnız kuruluysa).
- Satırlar yalnız ilgili program kuruluysa etkin.

## 🧹 Debloat
- **Intel / AMD üretici servisleri** (yalnız kuruluysa görünür): Intel Driver & Support Assistant, Graphics Command Center, ME WMI, AMD Crash Defender; riskli: Intel AMT, RST arayüzü, Optane, içerik koruma.
- Yazdırma, Windows Arama, Pano Geçmişi ve Bağlı Cihazlar satırları artık yalnız "Devre dışı" yapıyor: test sanal makinesinde "El ile" ya özelliği bozdu ya da hiçbir kazanç sağlamadı.
- Bir servis geri alınınca servis yöneticisi de güncelleniyor; servis başlamazsa nedeni kayda yazılıyor (önceden Windows Arama geri alınınca durmuş kalabiliyordu).
- Ölçüm: bu PC'de 20 Debloat satırı ~60 MB RAM ve 2 işlem kazandırdı; Debloat'ın asıl faydası arka plan işlerini ve saldırı yüzeyini azaltmak.

## Arayüz
- Sol menüdeki düğme artık **Program Güncelle:** yeni sürümü kontrol eder, yeni sürüm varsa "🔔 Yeni sürüm" olur ve güncelleme penceresini açar.
- **Ayarlar > Temizlik Veritabanı (Winapp2.ini):** yüklü / sunucu sürümü, yeni sürümde "YENİ" etiketi; güncelleme, listeyi yenileme ve klasör kartın içinde.
- **Ayar denetimi:** sürücü / Windows güncellemesinden sonra çıkan uyarı, ayarların değişiklikle ilgisi olmayabileceğini söylüyor; "Hayır" denen ayarlar bir daha sorulmuyor.

## Eklenmeyenler (ölçüldü ya da riskli)
Ethernet kesme birleştirme, UDP (AFD) eşiği, NTFS memoryusage, Steam GPU hızlandırma kapatma (RAM'i ~520 MB artırıyordu), Stix çekirdek / zamanlayıcı paketi (15 değer, kazanç yok), Intel MSR betiği, EPP.

## Kurulum / güncelleme
- v2.0.1 kullanıcıları: durum çubuğundaki "Yeni sürüm" bildirimine ya da sol menüdeki **Program Güncelle**'ye tıklayın (v2.0.1'de: Ayarlar > "Şimdi Kontrol Et").
- Yeni kurulum: `TemizlikAsistani.exe`'yi indirin, `SHA256SUMS.txt` ile doğrulayın, çalıştırın (yönetici izni ister).
- EXE imzasız olduğu için SmartScreen uyarısı çıkabilir: Ek bilgi > Yine de çalıştır.
