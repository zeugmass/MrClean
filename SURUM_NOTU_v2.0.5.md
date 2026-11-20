# MrClean v2.0.5

Bu sürüm, program güncellendikten sonra yeniden uygulanması gereken ayarları ilk açılışta bildiriyor ve eski sürümün "Sensör Servislerini Kapat" ayarının bıraktığı sorunu kendiliğinden düzeltiyor. Yeni tweak eklenmedi.

## Güncelleme sonrası ayar denetimi
- Program, güncellendiğini ilk açılışta algılıyor ve daha önce uyguladığınız ayarları hemen kontrol ediyor (eskiden yalnız Windows / sürücü güncellemesinden sonra ya da haftada bir yapılıyordu).
- Uygulanmış görünmeyen ayar varsa "Ayar Denetimi" penceresi açılır: Evet ile Tweaks sekmesinde işaretlenir, UYGULA ile yeniden uygularsınız. Hayır derseniz bu ayarlar "uyguladıklarım" listesinden çıkarılır ve bir daha sorulmaz.
- Bir ayarın uygulanmış görünmemesinin nedeni, yeni sürümde o ayarın denetiminin değişmesi ya da bir Windows / sürücü güncellemesinin ayarı geri alması olabilir.

## Sensör Servislerini Kapat
- v2.0.3 ve öncesinde bu ayar SensorService'i de kapatıyordu; kapalıyken Windows Ayarlar > Sistem > Güç sayfası çöküyordu (v2.0.4'te ayar düzeltildi).
- Bu ayarı eski sürümde uyguladıysanız, SensorService ilk açılışta kendiliğinden eski ayarına döndürülür ve bir iletiyle bildirilir. Yalnız MrClean'in kapattığı servis açılır; başka bir araçla kapatılmışsa dokunulmaz. Diğer iki sensör servisi kapalı kalır.

## v2.0.4'ten gelenler için
- v2.0.4'te denetimi değişen ayarlar (oyun ajanı "İşlemci Minimum Durumu %100 — Yalnız Oyun Açıkken", Copilot ve Recall sabitlemeleri, Görsel Efektler: Özel) yeniden uygulanmadıysa ilk açılıştaki pencerede listelenir.

## Kurulum / güncelleme
- v2.0.4 ve öncesi kullanıcıları: sol menüdeki **Program Güncelle**'ye ya da durum çubuğundaki "Yeni sürüm" bildirimine tıklayın.
- Yeni kurulum: `TemizlikAsistani.exe`'yi indirin, `SHA256SUMS.txt` ile doğrulayın, çalıştırın (yönetici izni ister).
- EXE imzasız olduğu için SmartScreen uyarısı çıkabilir: Ek bilgi > Yine de çalıştır.
