# MrClean Sistem Bakım Aracı

Windows 10 / 11 için sistem temizliği, bakım, onarım ve ince ayar (tweak) aracı. PowerShell 5.1 + WPF ile yazılmıştır; tek dosya EXE olarak dağıtılır. Arayüz Türkçe, İngilizce ve Fransızca.

## Özellikler

| Sayfa | Ne yapar |
|---|---|
| **Genel Bakış** | Sistem durumu, disk / bellek / ağ özeti, son işlemler ve öneriler |
| **Temizlik** | Tarayıcı, uygulama ve sistem artıkları (Winapp2 kuralları), ShellBags; önce analiz, sonra temizlik; isteğe bağlı güvenli silme |
| **Onarım** | SFC, DISM, ağ / DNS sıfırlama gibi hazır onarım komutları |
| **Araçlar** | Mağazada olmayan yardımcı araçları resmi kaynaklarından indirme, sürücü yedeği |
| **Winget** | Kurulu uygulamaları güncelleme, kaldırma, toplu kurulum listesi |
| **Tweaks** | 200'ü aşkın Windows ayarı: gizlilik, telemetri, görev çubuğu, Windows Update, ağ, ses, düşük gecikme / oyun ayarları. Her ayarın şu anki durumu canlı denetlenir; risk etiketi ve açıklaması vardır; geri alınabilir |
| **Başlangıç** | Windows ile açılan programlar ve görevler |
| **Dosya Boyutu** | Diskteki büyük dosya ve klasörleri hızlıca bulur |
| **Çökme Analizi** | Uygulama ve sistem çökmelerini olay günlüğünden toplar, olası nedeni gösterir |

Ayrıca: zamanlanmış kapatma / indirme takibi, profil dışa / içe aktarma, Tweak işlemlerinden önce isteğe bağlı sistem geri yükleme noktası, otomatik güncelleme.

## Kullanıcılar için

### Kurulum
1. [Releases](https://github.com/zeugmass/MrClean/releases) sayfasından en son sürümün dosyalarını indirin:
   - `TemizlikAsistani.exe`: tek dosya program (önerilen)
   - `TemizlikAsistani.ps1`: kaynak kod (EXE yerine doğrudan çalıştırmak için)
   - `Baslat.cmd`: yönetici izniyle başlatıcı (isteğe bağlı)
   - `SHA256SUMS.txt`: dosya bütünlüğü doğrulama
   - `BeniOku.txt`: kısa kullanım kılavuzu
2. Hash doğrulama (önerilen):
   ```powershell
   Get-FileHash TemizlikAsistani.exe -Algorithm SHA256
   # SHA256SUMS.txt içindeki değerle karşılaştırın
   ```
3. EXE'yi çalıştırın. Program yönetici izni ister (UAC).

### Otomatik güncelleme
Program açılışta arka planda GitHub'daki son sürümü denetler:
- Yeni sürüm varsa alttaki durum çubuğunda `🔔 Yeni sürüm: vX.Y.Z` yazar; tıklayınca güncelleme penceresi açılır.
- Elle denetim: **Ayarlar > Şimdi Kontrol Et**.
- "Güncelle" dosyayı indirir, SHA256 ile doğrular ve programı yeniden başlatır.
- İstemediğiniz bir sürümü "Bu sürümü atla" ile susturabilirsiniz.

### SmartScreen / Akıllı Uygulama Denetimi
EXE imzasız olduğu için ilk açılışta "Windows bilgisayarınızı korudu" uyarısı çıkabilir: **Ek bilgi > Yine de çalıştır**.
Virüs programı yanlış alarm verirse `%APPDATA%\MrClean` klasörünü istisnalara ekleyin.

## Geliştiriciler için

### Yeni sürüm yayınlama
```bash
# 1. TemizlikAsistani.ps1 içinde: $global:AppVersion = "2.0.1"
git add -A
git commit -m "v2.0.1: ..."
git push

# 2. Etiket: GitHub Actions'ı tetikler
git tag v2.0.1
git push origin v2.0.1
```
Birkaç dakika sonra Releases'ta yeni sürüm oluşur: `TemizlikAsistani.exe` (PS2EXE), `TemizlikAsistani.ps1`, `SHA256SUMS.txt`, `Baslat.cmd`, `BeniOku.txt`.

`$global:AppVersion` ile etiket (`v2.0.1`) **aynı olmalı**; değilse iş akışı durur. Tweak tanımlarındaki `Since="X.Y.Z"` değeri, ana ve ara sürümü `AppVersion` ile aynıysa programda "YENİ" rozeti gösterir.

### Sürüm kuralı ([SemVer](https://semver.org/lang/tr/))
- **Major** (`2.0.0`): büyük / geriye uyumsuz değişiklik
- **Minor** (`2.1.0`): yeni özellik
- **Patch** (`2.0.1`): hata düzeltmesi

### Yerel derleme
`Build-Local.ps1`: PS2EXE ile yerelde EXE üretir (yayından önce deneme için).

### Geliştirme kuralları
- `TemizlikAsistani.ps1` **UTF-8 BOM + CRLF** olmalı (`.gitattributes` CRLF'i zorlar).
- Sözdizimi denetimi:
  ```powershell
  $e = $null; [void][System.Management.Automation.Language.Parser]::ParseFile("TemizlikAsistani.ps1", [ref]$null, [ref]$e); $e.Count
  ```
- Kod içi gezinme: `KOD_HARITASI.md`.

### CI (GitHub Actions)
`.github/workflows/build-release.yml`, `v*` etiketiyle çalışır: sözdizimi denetimi → sürüm / etiket eşleşmesi → PS2EXE derleme → SHA256 → Release.

## Güvenlik

| Katman | Açıklama |
|---|---|
| **HTTPS / TLS 1.2+** | GitHub API ve indirmeler TLS üzerinden |
| **SHA256 doğrulama** | İndirilen dosyanın hash'i `SHA256SUMS.txt` ile eşleşmezse güncelleme iptal |
| **Boyut denetimi** | Beklenmeyen boyuttaki dosya reddedilir |
| **Atomik değişim** | Eski dosya yedeğe alınır, yenisi yerleştirilir, program yeniden başlar |

EXE imzasızdır; kod imzalama sertifikası olmadan SmartScreen uyarısı tamamen kalkmaz.

## Depo yapısı

```
MrClean/
├── TemizlikAsistani.ps1      # Ana program (tek dosya)
├── Baslat.cmd                # Yönetici izniyle başlatıcı
├── Launcher.ps1              # EXE / PS1 başlatma köprüsü
├── Build-Local.ps1           # Yerel EXE derleme
├── mrclean.ico               # Program simgesi
├── BeniOku.txt               # Türkçe kullanım kılavuzu
├── KOD_HARITASI.md           # Geliştirici: kod haritası
├── licenses/Inter-OFL.txt    # Gömülü Inter yazı tipinin lisansı
└── .github/workflows/
    └── build-release.yml     # Etiket → EXE + Release
```

## Üçüncü taraf

- Arayüz yazı tipi **Inter** programa gömülüdür: SIL Open Font License 1.1 (`licenses/Inter-OFL.txt`).
- Temizlik kuralları: [Winapp2.ini](https://github.com/MoscaDotTo/Winapp2) topluluk veritabanı (çalışırken indirilir).
