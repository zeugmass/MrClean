# MrClean v2.0.6

Bu sürüm, eski sürümlerden kalan ayar dosyasında bulunan eski bir tweak satırının listede yeniden görünmesini düzeltiyor. Yeni tweak eklenmedi.

## Düzeltme
- Programı Ekim 2026'dan önce kullananlarda Tweaks listesinde **"İşlemci Minimum Durumu %100 (Prizde, Kare Tutarlılığı)"** adlı eski bir satır görünebiliyordu. Bu satır, bugünkü "İşlemci Minimum Durumu %100 — Yalnız Oyun Açıkken (Prizde)" ayarının eski, kalıcı sürümüydü: oyun açık olsun olmasın güç planını sürekli %100'de tutuyordu. Ayar dosyasında kaldığı için program onu kullanıcının kendi eklediği bir ayar sanıyordu.
- Bu sürümle eski satır listeden kalkar.
- Eski satırı uygulamışsanız, ilk açılıştaki "Ayar Denetimi" penceresi "İşlemci Minimum Durumu %100 — Yalnız Oyun Açıkken" ayarını yeniden uygulamanızı önerir. Uyguladığınızda yalnız oyun açıkken çalışan ajan kurulur ve eski kalıcı %100 ayarı Windows'un varsayılan değerine döner.

## Kurulum / güncelleme
- v2.0.5 ve öncesi kullanıcıları: sol menüdeki **Program Güncelle**'ye ya da durum çubuğundaki "Yeni sürüm" bildirimine tıklayın.
- Yeni kurulum: `TemizlikAsistani.exe`'yi indirin, `SHA256SUMS.txt` ile doğrulayın, çalıştırın (yönetici izni ister).
- EXE imzasız olduğu için SmartScreen uyarısı çıkabilir: Ek bilgi > Yine de çalıştır.
