# MrClean — Kod Haritası (v1.3.0)

**Dosya:** `TemizlikAsistani.ps1` · **20.437 satır** · ~1 MB · PowerShell 5.1 + WPF · PS2EXE ile derlenir.
**Amaç:** Değişiklik yapmadan önce buraya bak → fonksiyonu/bölümü satır no ile bul → sadece ilgili ±30 satırı oku → Edit. Tüm dosyayı okuma.
**Not:** Satır numaraları büyük edit'lerden sonra kayar; yapısal değişiklikte bu haritayı güncelle.

---

## 1. BÖLÜM (REGION) HARİTASI

| # | Satır | Bölüm | İçerik |
|---|-------|-------|--------|
| 1 | 49–406 | C# INTEROP | Native sınıflar (aşağıda) + `Add-Type` (394) + konsol gizleme |
| 2 | 411–475 | YÖNETİCİ / POOL / TEMA | Admin check + RunAs relaunch, PS2EXE output susturma, `MrCleanPool` runspace pool (1-5) |
| 3 | 478–743 | GLOBAL DEĞİŞKENLER & YOLLAR | AppData yolları, tüm `$global:*` (aşağıda) |
| 4 | 748–3022 | VARSAYILAN VERİLER | Tweak DB, Winget DB, Onarım ağacı (VERİ — çok uzun) |
| 5 | 3027–4666 | XAML TANIMLARI | Ana pencere + 14 alt pencere here-string (aşağıda) |
| 6 | 4671–4892 | XAML YÜKLEME & FINDNAME | `$Win = XamlReader.Load` + tüm `$btn*/$tv*/$txt*` bağlamaları |
| 7 | 4898–4948 | ÇEKİRDEK HELPER | `Do-Events`(4901), `WpfLog`(4913), `Format-Size`(4940) |
| 8 | 4953–5331 | AYAR YÖNETİMİ | Config save/load/restore |
| 9 | 5337–8538 | TWEAK SİSTEMİ | Apply/Check/Manager + Benchmark + Timer + Update kontrol |
| 10 | 8543–9391 | TEMİZLİK MOTORU | Winapp2, Resolve-ComplexPath, Process-Tree |
| 11 | 9396–9698 | WORKER & KOMUT | `Start-Worker-Process` + Winget detection |
| 12 | 9704–9919 | BAŞLANGIÇ YÖNETİCİSİ | `Refresh-StartupView` |
| 13 | 9921–17280 | UI / MODAL FONKSİYONLARI | Tools, Profiller, Dashboard, tüm dialog'lar (en büyük bölüm) |
| 14 | 17288–19941 | EVENT HANDLERS | Buton click'leri, context menu, tab değişimi, çökme tarama |
| 15 | 19946–20436 | PENCERE YAŞAM DÖNGÜSÜ | `Add_Loaded`, `Add_Closing`, `ShowDialog` |

---

## 2. C# NATIVE SINIFLAR (Region 1, satır 52–392)

| Sınıf | Ne yapar |
|-------|----------|
| `NativeMethods` | ShowWindow, GetConsoleWindow, AllocConsole/FreeConsole, SendMessageTimeout (tema refresh), SystemParametersInfo (wallpaper), SHChangeNotify |
| `FileSelector` | `Select(path)` → Explorer'da dosya seçili aç (SHOpenFolderAndSelectItems) |
| `SecureWiper` | `WipeFile(path, passes)` → güvenli üzerine yazma silme |
| `RamCleaner` | `CleanAll()` → EmptyWorkingSet + NtSetSystemInformation (Standby/Modified purge, RAMMap tarzı) |
| `RamInfo` | `GetRamUsageGB()` → GlobalMemoryStatusEx (total/used/percent) |
| `ProcessMonitor` | `GetProcessTotalIo(pid)` → IO counters |
| `TimerRes` | NtSetTimerResolution + QPC. `Set/Release/QueryMs/QueryMaxMs/MeasureOnce/SetRealtime/High/NormalPriority` |
| `CpuStress` | Native tight-loop CPU stress (`Start/Stop`, volatile flag) |

---

## 3. GLOBAL DEĞİŞKENLER & YOLLAR (Region 3)

**Yollar:**
- `$AppDataPath` = `%APPDATA%\MrClean` (489) — eski `GeminiCare`'den migrasyon (481-487)
- `$UserConfigPath` = `...\user_config.json` (493)
- `$CachePath` = `...\app_cache.json` (495) — uygulama tarama önbelleği
- `$Winapp2Path` = `...\Winapp2.ini` (492)
- `$Winapp2Sources` (517) = jsdelivr CDN + raw.githubusercontent (MoscaDotTo/Winapp2)
- `$NoCacheFlag` (514) → `$global:IsCacheDisabled` (515)
- `$global:UpdateSkippedFile` (498/568), `$global:UpdateStagingDir` (499), `$global:BenchDir` (538), `$global:TweakStatusCachePath` (8322)

**Durum/veri globalleri:** `Winapp2Rules`(522), `ShowPrivacyWarning`(523), `Blacklist`(524), `PathOverrides`(525), `CustomRules`(526), `AppLayout`(527), `CustomAppx`(528), `MyProfile`(529), `AppCounter`(530), `StopOperation`(531), `TweaksLoaded`(532), `RestorePointMode`(534), `LastTweakOperation`(535), `ConfigDirty`(539), `DashResult/DashCache/DashCacheTime`(540-542), `ActiveRunspaces`(544), `DetectedGpuVendors`(552), `TweakList`(739), `WingetApps`(2960), `ToolDownloadPath`(config'den).

**Kimlik/sürüm:** `$global:AppVersion="1.2.28"`(558), `$global:AppRepo="zeugmass/MrClean"`(561), `$global:UpdateAvailable`(565), `$global:FeedbackWebhookUrl` (Discord, 573).

**Gömülü kaynaklar:** `NvidiaInspectorOptimizedNip`(581)/`EmptyNip`(625) NIP profilleri, `Win11Start2BinBase64`(639) Başlat menü layout.

---

## 4. FONKSİYON DİZİNİ (bölüm bölüm)

**Region 2:** `Refresh-WindowsTheme`(414)

**Region 4 — Veri:** `Get-Default-Tweaks`(751, DEV — tüm tweak DB), `Get-Default-WingetApps`(2961), `Load-Repair-Tree`(2985, onarım ağacı + SFC/WinHTTP)

**Region 6:** `Load-EmbeddedImage`(4857)

**Region 7:** `Do-Events`(4901), `WpfLog`(4913), `Format-Size`(4940)

**Region 8 — Config:** `Save-App-State`(4956), `Show-ConfigRecoveryDialog`(4980), `Load-All-Settings`(5045), `Save-User-Config`(5205), `Mark-ConfigDirty`(5305), `Restore-Checkboxes`(5310)

**Region 9 — Tweak + Update + Benchmark + Timer:**
- GPU/NVIDIA: `Get-System-Gpu-Vendors`(5346), `Get-NvidiaInspectorPath`(5375), `Invoke-StartMenuLayoutImport`(5461)
- **Program güncelleme:** `Compare-Version`(5602), `Get-AppExeDirectory`(5620), `Cleanup-OldUpdateFiles`(5640), `Test-AppUpdate`(5664, GitHub release async), `Invoke-AppUpdate`(5816, indir+SHA256+swap), `Add-SkippedVersion`(5933)
- Shell/restore: `Invoke-ShellSoftRefresh`(5952), `Invoke-ExplorerHardRestart`(5968), `Test-VssServiceRunning`(6025), `Get-LastRestorePointDate`(6035), `Create-Restore-Point`(6050), `Invoke-RestorePointAsync`(6112)
- Timer resolution: `Invoke-HiddenCommand`(6232), `Get/Save-TRTSettings`(6267/6291), `Invoke-TimerResHelperSetup`(6307), `Remove-TimerResHelper`(6387)
- Cache refresh: `Refresh-PowerCfg-Cache`(6419), `Refresh-BcdEdit-Cache`(6423), `Refresh-NetshTcp-Cache`(6427)
- **Tweak çekirdek:** `Get-Tweak-IsActive`(6431, tweak durum tespiti — DetectScript'ler burada), `Load-Tweak-Tree`(6643), `Attach-ToolTip`(6716), `Sync-Children`(6744), `New-TreeItem`(6746), `Get-CheckFromItem`(6765), `Get-TweakDisplayName`(6774), `Create-Tweak-Item`(6788), `Show-Privacy-Warning`(6862), `Apply-System-Tweaks`(6885, ana apply motoru), `Show-TweakManager`(7178), `Write-TweakAuditLog`(7710)
- **Benchmark:** `Test-TimerPrecision`(7752), `Test-LoopbackPing`(7776), `Test-GatewayPing`(7809), `Test-DnsResolve`(7844), `Test-Disk4kRead`(7869), `Test-ProcessStartLatency`(7915), `Test-DpcTime`(7942), `Get-SystemSnapshot`(7973), `Get-Median`(8000), `Merge-BenchRuns`(8010), `Get-BenchSnapshot`(8053), `Save/Get/Remove-BenchSnapshot`(8113/8131/8144), `Set-BenchSnapshotLabel`(8152), `Get-BenchMetricCatalog`(8167), `Compare-BenchSnapshots`(8188)
- **Quick undo + tweak durum cache:** `Invoke-QuickUndo`(8234), `Get-TweakStatusCachePath`(8327), `Load/Save-TweakStatusCache`(8333/8352), `Get-AllTweakItems`(8365), `Test-TweakApplied`(8382), `Set-TweakItemUI`(8396), `Update-Parent-Headers-Recursive`(8435), `Check-Tweak-Status`(8455)

**Region 10 — Temizlik motoru:**
- `Check-And-Close-Browsers`(8546), `Check-Browser-Safety`(8558), `Get-AppEnvFingerprint`(8575, tarayıcı imza — cache geçersizleştirme), `Update-Cache`(8595), `Test-BrowserInstalled`(8613, v1.2.27 kalıntı tespiti), `Flush-Buffers-To-Tree`(8643), `Add-To-Buffer`(8669), `Load-System-Tree`(8676)
- **`Start-Winapp2-Process`(8707)** — winapp2 yükle (cache/disk/indir) + **`$CheckUpdateBlock`(8715-8771) açılış otomatik güncelleme kontrolü** (ilk satır kıyas → `txtWinappStatus`)
- `Parse-Winapp2`(8836), `Load-Winget-Tree`(8957), `Remove-Empty-Folders-Recursive`(9043), `Secure-Remove-Item`(9048), `Resolve-ComplexPath`(9068), `Run-CMD-Realtime`(9184), `Process-Tree`(9339, ana temizlik yürütücü)

**Region 11 — Worker:** `Start-Worker-Process`(9399, async+timeout+stop), `Get-InstalledAppRegistry`(9570, Winget tespit registry), `Normalize-AppNameForMatch`(9611), `Refresh-Winget-Status`(9617)

**Region 12:** `Refresh-StartupView`(9707, başlangıç öğeleri: registry+WMI+klasör)

**Region 13 — UI/Modal (en büyük):**
- `Get-WebLink`, `Refresh-Tools-Menu`, `Show-ToolManager` §77–§78'de kaldırıldı; sürücü yedeği `$script:ExportDriversBlock` → Araçlar sayfası `btnDriverBackup`.
- Profiller: `Get-ProfileTweaks`(10583), `Show-RecommendedProfiles`(10692), `Show-ExportSourceDialog`(11132), `Show-ImportConfirmDialog`(11173), `Show-ProfileManager`(11263)
- `Check-BlackBoxStatus`(11713), `Start-ShutdownCountdown`(11762), `Show-Winapp2Editor`(11803)
- Feedback: `Send-Feedback`(11927, Discord webhook), `Show-FeedbackWindow`(12020)
- **Güncelleme pencereleri:** `Show-AppUpdateWindow`(12172, PROGRAM), **`Show-UpdateWindow`(12384, WINAPP2 — btnRefreshApp buna gider)**, `Show-RestartDialog`(12636)
- `Show-HardwareDetail`(12697), `Load-DashboardData`(13140, Genel Bakış + 5dk cache)
- Bench görsel: `Show-BenchDiffModal`(13528), `Show-BenchDiffChart`(13666, WPF Canvas bar), `Get-BenchMetricToTweakMap`(13907), `Show-BenchMetricGuide`(14017), `Show-BenchmarkPanel`(14124)
- Aktivite log: `Find-TweakByName`(14439), `Get-ActivityLogEntries`(14454), `Invoke-SingleActivityReverse`(14523), `Show-ActivityLog`(15710)
- `Show-SystemSecurityDetail`(14573, Sistem&Güvenlik detay — async lazy load)
- DNS: `Get-DnsServersToTest`(14778), `Get-IspDns`(14794), `Test-DnsServer`(14811), `Set-PreferredDns`(14852), `Show-DnsBenchmark`(14876, paralel runspace)
- Oyun/Defender: `Get-SteamGames`(15190), `Get-EpicGames`(15226), `Get-EADesktopGames`(15244), `Get-RiotGames`(15280), `Get-BattleNetGames`(15299), `Get-UbisoftGames`(15344), `Get-GogGames`(15374), `Get-AllDetectedGames`(15394), `Get/Add/Remove-DefenderExclusion`(15409/15413/15418), `Show-DefenderExclusionManager`(15425)
- `Show-TimerResolutionSettings`(16124), `Show-TimerResolutionTest`(16371), `Show-BloatwareManager`(17003), `Start-LargeFileScan`(17125)

**Region 14 — Event handlers:** Butonların `.Add_Click` bağlamaları (17288+). `btnRefreshApp.Add_Click → Show-UpdateWindow`(18763). `Apply-CrashFilter`(18239, canlı filtre). **Çökme tarama handler'ı (btnScanCrashes) ~17913-18220** (Event log parse).

**Region 15:** `Add_Loaded`(içinde `Start-Winapp2-Process` 20342 vb.), `Add_Closing`, `ShowDialog`.

---

## 5. XAML PENCERELERİ (15 here-string)

| Değişken | Satır | Pencere |
|----------|-------|---------|
| `$xaml` | 3033 | **ANA PENCERE** (tüm sekmeler) |
| `$xamlToolMgr` | 3805 | Araç Yöneticisi |
| `$xamlSettings` | 3810 | Ayarlar |
| `$xamlNightMode` | 3933 | Gece Modu / Kapatma zamanlayıcı |
| `$xamlCountdown` | 4064 | Geri sayım |
| `$xamlExport` | 4106 | Dışa aktar |
| `$xamlWingetMgr` | 4131 | Winget Yöneticisi |
| `$xamlTweakMgr` | 4187 | Tweak Yöneticisi |
| `$xamlPrivacyWarn` | 4408 | Gizlilik uyarısı |
| `$xamlBlacklist` | 4430 | Kara liste |
| `$xamlCustomMgr` | 4450 | Özel kural yöneticisi |
| `$xamlFeedback` | 4473 | Geri bildirim |
| `$xamlAddCustom` | 4606 | Özel kural ekle |
| `$xamlPathEdit` | 4641 | Yol düzenle |

**Ayrıca fonksiyon-içi inline XAML** (modallar): `$xamlVersionSelect`(10129), profil(10702/11135/11185/11291), Winapp2Editor(11804), Feedback(12020 içi), AppUpdate(12179), UpdateWindow(12386), Restart(12637), HardwareDetail(12701), BenchDiff(13531/13705), BenchGuide(14018), Benchmark(14125), SystemSecurity(14575), DNS(14923), DefenderExc(15426), ActivityLog(15711), TimerRes(16125/16387), Bloatware(17006), RestorePoint(6116), CrashDesc(17693).

---

## 6. ANA PENCERE SEKMELERİ (`$xaml`, 3286 `tabControl`)

| Sekme | x:Name | Satır | İçerik |
|-------|--------|-------|--------|
| Genel Bakış | `tabDashboard` | 3288 | Dashboard kartları |
| Tarayıcılar | `tabBrowsers` / `tvBrowser` | 3427 | |
| Uygulamalar | `tabApps` / `tvApps` | 3428 | |
| Sistem | `tabSystem` / `tvSystem` | 3429 | |
| ShellBags | `tabShellBags` | 3430 | |
| Onarım | `tabRepair` | 3439 | |
| Araçlar | `tabTools` | 3461 | Benchmark/Timer/Log/Defender |
| Winget | `tabWinget` | 3479 | |
| Tweaks | `tabTweaks` | 3493 | `tvTweaks` |
| Başlangıç | `tabStartup` | 3515 | |
| Dosya Boyutu | `tabLargeFiles` | 3568 | |
| Çökme Analizi | `tabCrash` | 3637 | `lvCrashes`, `txtCrashFilter` |

---

## 7. 🌍 LOKALE / DİL-DUYARLI NOKTALAR (#3 Fransızca + #4 için KRİTİK)

### 🔴 Fransızca'da GERÇEKTEN KIRILAN (Windows'un lokalize metnini ayrıştıran)
- **17925-17931** — Çökme Analizi Event 1000 mesaj parse: `'Hatalı uygulama adı'` / `'Faulting application name'` (TR+EN). **FR mesaj tutmaz → app/modül "Bilinmiyor", RAM/CPU deseni kaçar.** Çökmez, sonuç boşalır. → FR kalıpları eklenmeli veya event'in dil-bağımsız alanları kullanılmalı.
- **17913-18220 çökme tarama bloğu** — aynı riskli metin-ayrıştırma bölgesi (Event 1000/1002/TDR).

### 🟡 Türkçe-"i" tuzağı (`.ToLower()`/`.ToUpper()` — FR'de DAHA güvenli, TR'de riskli)
- 8614 (browser vendor), 9093 & 15591 (path karşılaştırma), 9614 (Normalize-AppNameForMatch), 13064-13094 (GPU isim eşleştirme), 15963-15970 & 17810 & 18242-18248 (arama/filtre). → İdeal: `ToLowerInvariant`. FR'de patlamaz.
- 5844, 13005 = hex `.ToUpper()` → güvenli.

### 🟢 Doğru yapılmış (dokunma)
- **14468** — `[DateTime]::ParseExact(..., InvariantCulture)` (activity log ts) ✓
- 14719-14722 — HotFix `InstalledOn.ToString('dd.MM.yyyy')` sabit format ✓
- 14654 — `(Get-Culture).DisplayName` sadece gösterim ✓
- Get-Tweak-IsActive DetectScript'leri, enum karşılaştırmaları (`Status -eq "Up"`, `"Running"`, `"Disabled"`), registry/CIM/WMI → dil-bağımsız ✓
- Winapp2 → tamamen evrensel ✓

**#3 SONUÇ:** Fransızca'da program AÇILIR ve ÇALIŞIR. Tek zayıflayan: Çökme Analizi (17913-18220). Düzeltmesi = FR event kalıpları eklemek (#4 kapsamında).

---

## 8. 🈳 i18n (#4) — KULLANICI METNİ NEREDE?

- **XAML statik metin** (~486 `Content=`/`Header=`/`Text=`/`ToolTip=`): Region 5 (3033-4666) + fonksiyon-içi inline XAML'ler (Bölüm 5 listesi). → token-replace (`@key@`) `XamlReader.Load` öncesi.
- **MessageBox** (~110 `[Windows.MessageBox]::Show`): kod içine dağılmış (özellikle Apply-System-Tweaks, config, güncelleme). → `$L.key` / `-f` placeholder.
- **Tweak Name/Description** (~80, UZUN teknik metin): Region 4 `Get-Default-Tweaks`(751+). → çeviri emeği en yüksek burada (Faz 2).
- **WpfLog mesajları + dinamik string** ("Sistemde X program…") → `$L.key -f ...`.
- **Varsayılan dil:** `Get-UICulture` ile otomatik (FR→fr, TR→tr, diğer→en), Ayarlar'dan override, config'e kaydet.

---

## 9. GÜNCELLEME SİSTEMİ ÖZETİ (iki ayrı sistem — karıştırma!)

**A) PROGRAM güncellemesi** (EXE, GitHub release tag):
`Test-AppUpdate`(5664, açılış async) → `$global:UpdateAvailable` → (Ayarlar "Şimdi Kontrol Et" kendi kodunu kullanır) → `Show-AppUpdateWindow`(12172) → `Invoke-AppUpdate`(5816: indir+SHA256+`update_runner.ps1` swap+restart).

**B) WINAPP2 (temizlik veritabanı) güncellemesi:**
- Açılış otomatik kontrol: `Start-Winapp2-Process`(8707) içindeki `$CheckUpdateBlock`(8715-8771) — yerel+uzak **sadece ilk satırı** okur, kıyaslar, `txtWinappStatus`(3775) yazısını "Yeni Sürüm Mevcut!" yapar (silik gri etiket → görünürlük zayıf).
- Manuel: `btnRefreshApp`(♻ Güncelle, XAML 3258) `.Add_Click`(18763) → `Show-UpdateWindow`(12384): ilk-satır sürüm kıyas + GÜNCELLE butonu (`.old` yedek → indir → cache sil → yeniden yükle, 12578-12612).

---

## 10. v1.2.29 DEĞİŞİKLİKLERİ (LOKAL — winapp2 görünürlük + diff)

**⚠️ Satır kayması:** `Show-UpdateWindow` öncesine ~62 satır (2 fonksiyon) + birkaç küçük ekleme yapıldı → bu bölümden SONRAKİ satır no'ları ~+60-70 kaymış olabilir. Kesin konum için Grep kullan.

- **#1 Buton görünürlüğü:** `Start-Winapp2-Process`→`$CheckUpdateBlock` tick'inde açılış güncelleme tespiti artık `btnRefreshApp`'i değiştiriyor: güncelleme varsa "🔔 Güncelle (Yeni!)" + yeşil #137333 + tooltip; güncelse "♻ Güncelle" + #4f0707'ye döner. `$btnRef = $btnRefreshApp` closure'a eklendi (~8720). `$global:Winapp2UpdateAvailable` bayrağı (init satır 566).
- **#2 Diff:** Yeni fonksiyonlar `Show-UpdateWindow` ÖNCESİNDE: `Get-Winapp2Diff($OldPath,$NewPath)` ([Section] bazlı Added/Removed/Changed) + `New-Winapp2DiffReport($OldPath,$NewPath,$OnlineVer)` (txt yazar → `%APPDATA%\MrClean\winapp2_diff_<stamp>.txt`, döner @{Path;Added;Changed;Removed}). `Show-UpdateWindow` GÜNCELLE handler'ı başarı dalında (btnUpd) `.old` silinmeden diff üretir, txt'yi `Invoke-Item` ile açar, eski sürümü `Winapp2.prev.ini` olarak saklar, `$script:LastWinapp2DiffPath` set eder, durum metnine sayaç yazar.
- Grep anahtarları: `Get-Winapp2Diff`, `New-Winapp2DiffReport`, `Winapp2UpdateAvailable`, `LastWinapp2DiffPath`, `btnRef`.

---

## 11. v1.3.0 DEĞİŞİKLİKLERİ — Windows 11 24H2 / 25H2 / 26H2 Tweaks güncellemesi

**⚠️ Satır kayması:** Dosya ~21.777 satır. Aşağıdaki numaralar v1.3.0 anına göredir; kesin konum için Grep kullan.

### Yeni tweak alanları (hepsi opsiyonel)
| Alan | Örnek | Etki |
|------|-------|------|
| `MinBuild` | `26100` | Bu build'den eski Windows'ta tweak gri + tıklanamaz + kırmızı "24H2+" rozeti; `Apply-System-Tweaks`→`Scan-Nodes` ayrıca atlar (profil/import ile işaretlense bile) |
| `MaxBuild` | `22631` | Bu build'den YENİ Windows'ta pasif (kaldırılmış özellikler için) |
| `Since` | `"1.3.0"` | `AppVersion` ile aynı major.minor ise yeşil "YENİ" rozeti (bir sonraki minor sürümde kendiliğinden kaybolur) |

Build referansı: 22621=22H2, 22631=23H2, **26100=24H2, 26200=25H2, 26300=26H2** (24H2/25H2/26H2 ortak servis dalı, eKB).

### Yeni globaller / fonksiyonlar
- `$global:WinBuild`, `$global:WinUBR`, `$global:WinDisplayVersion` (~594, AppVersion'ın hemen altında, açılışta 1 kez okunur)
- Region 9, `Create-Tweak-Item` öncesi (~7784-7908): `Get-WinReleaseLabel`, `Test-TweakBuildCompatible`, `Get-TweakBuildRequirement`, `Test-TweakIsNew`, `Normalize-SearchText` (Türkçe katlama: sifre→Şifresiz), `Apply-TweakFilter`, `Update-TweakSummary`, `New-TweakBadge`
- Rozetler isim TextBlock'unun SAĞINA **Border** içinde eklenir → `Get-TweakDisplayName` / `Set-TweakItemUI` (ilk TextBlock = isim) etkilenmez.

### Tweaks sekmesi UI (XAML ~4455)
- Üst bant: `txtTweakSearch` (canlı filtre, Esc temizler) + `btnTweakSearchClear` + `txtTweakFilterCount` + `txtTweakWinInfo` ("🪟 Windows 11 25H2 · 26200.x  ✅ X / Y aktif  ⛔ Z pasif")
- Grid satırları: 0=bant, 1=`tvTweaks`, 2=butonlar
- Handler'lar: `btnCheckTweaks.Add_Click` hemen altında (~20030)
- Alt kategori onay kutusu artık sadece **görünen + uyumlu** çocukları değiştirir
- `Check-Tweak-Status` bitince ve cache ön-yüklemesinde `Update-TweakSummary` çağrılır; `Load-Tweak-Tree` sonunda bant + aktif filtre yeniden uygulanır
- Dil anahtarları (TR/EN/FR): `tw_filter`, `tw_filter_tip`, `tw_filter_clear`, `tw_filter_count`, `tw_active_count`, `tw_incompat_count`, `tw_badge_new`, `tw_incompat_tip`

### Yeni / değişen tweak'ler (39 yeni, Grep: `Since="1.3.0"`)
- **Yeni kategori** `🤖 Windows AI (24H2 / 25H2 / 26H2)` (~2081): Recall, Click to Do, Gezgin AI Eylemleri, WSAIFabricSvc, Notepad AI, Paint AI, Edge AI, Chrome AI
- Kişiselleştirme: End Task, saniyeli saat, asla birleştirme, Web/Bing policy, Arama Vurguları, Başlat Phone Link paneli, kilit ekranı widget kartları
- Gizlilik: Reklam/Öneri paketi (10 değer), M365 reklamları, Ayarlar Home gizle (`SettingsPageVisibility` birleştirmeli), Etkinlik geçmişi, Mürekkep/Yazma, Geri bildirim, Telemetri zamanlanmış görevleri
- Gezgin: Bu Bilgisayar ile aç, Galeri/Home gizle, Compact, LongPaths
- Sistem ve Oyun: Pencereli oyun optimizasyonu (`DirectXUserGlobalSettings` birleştirmeli), Fast Startup, Startup Delay, Edge arka plan, Ayrılmış Depolama, BitLocker oto-şifreleme, HVCI (High risk)
- Gelişmiş Sistem → `Windows Update` alt kategorisi: **Sürüm Kilidi** (TargetReleaseVersion, mevcut DisplayVersion'ı okur), Erken Erişim kapat, oto-restart engelle, Teslim İyileştirme, sürücü hariç tut
- **Düzeltme:** "Kilit Ekranında Eğlenceli Bilgileri Kapat" yanlış değeri (RotatingLockScreenEnabled = Spotlight döngüsü) yazıyordu → artık `RotatingLockScreenOverlayEnabled` + `SubscribedContent-338387Enabled`
- **Güncelleme:** "Copilot Tamamen Kapat" → 25H2 `RemoveMicrosoftCopilotApp` policy (HKCU\...\WindowsAI) + provisioned paket silme + ShowCopilotButton=0; Undo WindowsAI anahtarını silmez (Recall/ClickToDo orada)
- Önerilen profiller (`Get-ProfileTweaks`) yeni tweak'lerle genişletildi (HVCI hariç)

### ⚠️ Yeni tweak eklerken
- Mevcut tweak **isimlerini değiştirme** — profiller, config ve aktivite logu isimle eşleşir.
- `Command`/`Batch` tweak'lerinde `DetectScript` yoksa `Get-Tweak-IsActive` isim-tabanlı sezgiselleri dener (`Widget`, `Tanılama`, `OneDrive`, `Nihai`, `HPET`, `TCP`...). Bu kelimeleri isimde kullanma ya da `DetectScript` ver. Process-TweakItem'da isimde `TCP`/`Win32`/`HPET` yeniden başlatma diyaloğunu tetikler.
- 26H2'de **WMIC tamamen kaldırıldı** — kodda WMIC yok, ekleme (CIM kullan).

### 11b. v1.3.0 — İkinci tur (tweaqas incelemesi + topluluk araştırması, hata düzeltmeleri)

Ayrıntılı gerekçeler, reddedilen tweak'ler ve kaynaklar için: **`DEGISIKLIKLER_v1.3.0.md`**. Dosya ~21.998 satır.

| Ne | Nerede (yaklaşık satır) |
|----|------|
| `SystemParametersInfoInts` (SPI_SETMOUSE, int[] overload) | C# `NativeMethods` (~77) |
| NVIDIA NIP — G-SYNC/V-Sync/OpenGL GPU satırları çıkarıldı | `$global:NvidiaInspectorOptimizedNip` (~629) |
| `Get-DualCcdX3DName`, `Confirm-DualCcdX3DPowerTweak` (çift CCD X3D uyarısı) | Region 9, `Get-System-Gpu-Vendors` altı (~6537) |
| Gereksiz servisler → El ile (yedekli) | "Sistem ve Oyun" (~2435) |
| Güvenlik Sıkılaştırma alt kategorisi | "Gelişmiş Sistem (Batch)" (~2962) |
| Ağ kartı güç tasarrufu (yedek/geri yükleme) | Low Latency → Ağ ve Ping (~3202) |
| Offload (LSO kapalı, RSS/Checksum açık) | (~3287) |
| MMCSS Games görevi | Low Latency → Ses (~3659) |
| NVIDIA Telemetri | GPU → NVIDIA (~4059) |

**Yeni kayıt defteri yedek konumları** (tweak'ler geri alınırken orijinali geri yükler):
`HKLM\SOFTWARE\MrClean\NicPowerBackup\<0000..>` · `HKLM\SOFTWARE\MrClean\ServiceStartBackup` · `HKLM\SOFTWARE\MrClean\UsbPowerMgmtDisabled` (MultiString)

**Kural (yeni hata dersi):** `Command='...'` / `UndoCommand='...'` / `DetectScript='...'` tek tırnaklı dizelerdir — içlerindeki yorumlarda bile **kesme işareti (') kullanma** (ör. `Undo'daki`) → tüm dosya parse hatası verir.

### 11c. v1.3.0 — Üçüncü tur (13 aracın kaynak kodu denetimi, GPU profilleri, sekme yeniden tasarımı)

Gerekçeler için: **`DEGISIKLIKLER_v1.3.0.md` §13–15**. Dosya ~22.574 satır, 153 tweak (`Since="1.3.0"`: 60).

| Ne | Nerede (yaklaşık satır) |
|----|------|
| NVIDIA NIP (AF/MSAA → uygulama kontrolü; Threaded Opt / Present Method kaldırıldı) | `$global:NvidiaInspectorOptimizedNip` (~629) |
| `Get-NvidiaInspectorPath` (önce resmi Orbmu2k v3 zip, sonra FR33THY; önbellek `%APPDATA%\MrClean\nvidiaProfileInspector\`) | Region 9 (~6950) |
| `Invoke-NvidiaInspector` (60 sn zaman aşımı + Kill), `Backup-NvidiaProfiles` (`-exportCustomized`), `Open-NvidiaSettingsApp` (NVIDIA App → NVCP) | ~7036 / ~7054 / ~7068 |
| Geri yükleme noktası: `SystemRestorePointCreationFrequency` geçici olarak 0 | `Invoke-RestorePointAsync` runspace bloğu (~7785) |
| UAC (EnableLUA=1 + ConsentPromptBehaviorAdmin=0) | "Sistem ve Oyun" (~2394) |
| Power Throttling (doğru yol `SYSTEM\CurrentControlSet\Control\Power\PowerThrottling`) | (~2479) |
| Edge reklam paketi | "Windows AI" → Tarayıcılar (~2282) |
| Güvenlik Sıkılaştırma (+WPBT, Device Metadata, RegBack) | "Gelişmiş Sistem" (~3119) |
| Ses Kartı güç tasarrufu (`AudioPowerBackup`) + Ducking | Low Latency → Ses (~3840–3910) |
| AMD profil işareti / NVIDIA profil işareti | `HKCU\Software\MrClean\AppliedMarkers` → `AmdProfileVer` / `NvidiaProfileVer` = 130 |

**Sekme UI (yeniden tasarım):**
| Ne | Nerede |
|----|------|
| `ChipStyle` (RadioButton pill), `TweakCatHeaderTemplate` (DataTemplate), modern `ToggleSwitch` | Window.Resources (~4480–4560) |
| Bant: arama + çipler `chipTwAll/Active/Passive/New/Risky/Reboot` + `bdTweakProgressTrack/Fill` | Tweaks TabItem XAML (~4958–5003) |
| Buton çubuğu (6 kolon, Uygula 1.6*) | aynı TabItem `Grid.Row="2"` |
| FindName + `TweakSubMaxWidth` kaynağı + ilerleme `SizeChanged` + `$script:TweakChips` | `$tvTweaks = $Win.FindName('tvTweaks')` altı (~6302) |
| `Find-TweakNameBlock` (isim TextBlock'u `Tag="TweakName"`) | `Get-TweakDisplayName` altı (~8444) |
| `$script:TweakRowHoverBrush/SubBrush/SubCatBrush`, `$script:TweakChipMode`, `Test-TweakNeedsReboot`, `Get-TweakSummaryLine` | ~8487–8515 |
| `Apply-TweakFilter` (`$chipFn`), `Test-TweakLeafActive`, `Update-TweakSummary` (animasyonlu dolgu, `$script:TweakActiveRatio`) | ~8532 / ~8597 / ~8606 |
| `Create-Tweak-Item` (iki satırlı satır, hover, ↻ rozeti) | ~8653 |
| `Load-Tweak-Tree` (HeaderTemplate, alt kategori stili, fade-in) | ~8274 |
| Çip işleyicileri | `btnTweakSearchClear` işleyicisinin altı (~20830) |
| Tarama bitince Aktif/Pasif çipini yenileme | `Save-TweakStatusCache` çağrısının hemen altı |

**Başlık hiyerarşisi (DOKUNMADAN önce oku):** `TreeViewItem.Header = StackPanel(yatay) → CheckBox(.Content = dikey StackPanel → [yatay StackPanel{nokta, isim TextBlock Tag=TweakName, rozetler...}, özet TextBlock Tag=TweakSub])`. Tıklama işleyicisi `$me.Parent.Parent` ile TreeViewItem'a ulaşır. İsim okumak/yazmak için her zaman `Find-TweakNameBlock` kullan.

**Yeni yedek konumu:** `HKLM\SOFTWARE\MrClean\AudioPowerBackup\<0000..>` (ConservationIdleTime / IdlePowerState / PerformanceIdleTime, Binary).

### 11d. v1.3.0 — Dördüncü tur (derin tarama: 153 → 213 tweak, geri alma yardımcıları)

Gerekçeler için bkz. **`DEGISIKLIKLER_v1.3.0.md` §16**. Dosya ~23.900 satır.

| Ne | Nerede (yaklaşık satır) |
|----|------|
| Geri alma yardımcıları: `Backup/Restore-TweakRegValue` (`HKLM\SOFTWARE\MrClean\ValueBackup`) | ~7923 |
| Güç planı dizini: `Get/Backup/Restore-PowerSettingIndex` (dil bağımsız; `…\PowerBackup`; yedek yoksa fallback -1 = dokunma) | ~7966 |
| `Test-IsLaptop`, `Test-IsAmdCpu`, `Confirm-LaptopPowerTweak` | ~7995 / ~8182 |
| `Get-MrCleanPhysicalAdapters` (Ethernet/Wi-Fi, durumdan bağımsız, sanal/VPN/Tailscale hariç) | ~8008 |
| DNS: `Backup/Restore-MrCleanDnsStatic`, `Set-MrCleanDnsPreset` (`…\DnsBackup`) | ~8020-8065 |
| Wi-Fi/Ethernet gelişmiş ayar: `Set/Restore/Test-MrCleanWifiProperty` (görünen ada göre), `Set-MrCleanEthProperty`, `Restart-MrCleanWifi/Ethernet` (`…\WifiBackup`) | ~8070-8160 |
| `Measure-MrCleanRtt` (IPv4 tercihi ölçümü) | ~8162 |
| Timer yardımcısı: conhost --headless başlatıcı + IGNORE_TIMER_RESOLUTION | `Invoke-TimerResHelperSetup` (~9203) |
| Profiller: AMD/dizüstünde Nihai plan atlanır | `Get-ProfileTweaks` (~13811) |
| Debloat paket desenleri + `$neverRemove` + "Tümünü seç" sadece Sponsorlu | ~20380-20440 |
| Yeni tweak'ler (örnek konumlar) | Sanal Makine Platformu (~2832), DoH (~3493), RSS (~4145), Wi-Fi (~4297), USB3 LPM (~4637) |

**Yeni alt kategori:** Low Latency → `Wi-Fi (Kablosuz)`.

**Yeni yedek konumları:** `HKLM\SOFTWARE\MrClean\ValueBackup`, `…\PowerBackup`, `…\DnsBackup`, `…\WifiBackup` (Wi-Fi + Ethernet; değer adı `Id|ArayüzGUID|Anahtar`, `*` yerine `~`).

**Kurallar (4. tur dersleri):**
- Sürücü / güç / servis değeri değiştiren tweak'te **sabit "varsayılan" yazma**; yukarıdaki yardımcılarla yedekle ve geri yükle.
- Ağ ayarlarını `Get-NetAdapter | Where Status -eq Up` ile değil `Get-MrCleanPhysicalAdapters` ile seç. Up filtresi VPN'e dokunur ve kopuk Wi-Fi'yi atlar.
- Wi-Fi sürücü ayarı anahtar adları üreticiye göre değişir: `RegistryKeyword` sabitleme, görünen ad regex'i kullan (TR + EN).
- DNS ön ayar Command'ında `address=x.x.x.x` yorumu kalmalı; `Get-Tweak-IsActive` DNS sezgiseli bu metni okuyor.
- Yeni tweak isminde `TCP` / `Win32` / `HPET` kullanma (sezgisel tespit + reboot diyaloğu tetiklenir); gerekiyorsa `DetectScript` + `SkipRebootDialog`.

### 11e. v1.3.0 — Beşinci tur (kullanıcı geri bildirimi)
Gerekçeler için bkz. `DEGISIKLIKLER_v1.3.0.md` §17. Konum bulmak için Grep kullanın:

| Grep | Ne |
|---|---|
| `function Get-MrCleanDnsGuard` / `Test-MrCleanDnsBlocked` | 3. parti DNS/DPI araç algılama + DNS komutlarında koruma |
| `function Get-MrCleanHwProfile` / `Get-TweakHardwareReason` / `Get-MrCleanHwSummary` | Donanım profili + `Requires` / `Vendor` gerekçesi (Test-TweakBuildCompatible bunu da kontrol eder) |
| `function Enable-MrCleanTimerResolution` / `Disable-…` / `Get-MrCleanTimerTarget` | Timer'ın tam kurulumu (Araçlar > Timer Testi) |
| `function Get-MrCleanGameExes` / `Set-MrCleanGameGpuPreference` / `Remove-…` | Oyunlara yüksek performans GPU (UserGpuPreferences; `HKCU\Software\MrClean\GpuPrefAdded`) |

**Yeni tweak alanı:** `Requires=@(...)` — değerler: `WiFi`, `Ethernet`, `Laptop`, `HDD`, `SSD`, `Cores4`, `NoDnsTool`, `WiFiBand`, `WiFiAdv`, `VendorTel`, `CABC`.

**Kural:**
- Tek tırnaklı PS dizelerinde tipografik kesme işareti (’) de tırnak sayılır. Dil tablosunda `''` kullanın.
- DNS'e dokunan yeni kod `Test-MrCleanDnsBlocked` ile başlamalı.

### 11f. v1.3.0 — Altıncı tur
| Grep | Ne |
|---|---|
| `function Start-MrCleanDriftCheck` / `Get-MrCleanEnvFingerprint` / `Update-MrCleanAppliedList` / `Set-MrCleanPendingReapply` | Güncelleme sonrası denetim (`$Win.Add_Loaded` → 6 sn gecikmeli `DriftStartTimer`) |
| `function Show-NetworkQualityTest` | Ağ Kalite Testi (Araçlar > `btnNetQuality`) |
| `WifiBandPref` / `WifiAdv` | Wi-Fi sürücü yetenekleri (`Requires`: `WiFiBand`, `WiFiAdv`) |

Kayıt defteri: `HKCU\Software\MrClean` → `AppliedTweaks` (MultiString), `EnvWin` / `EnvGpu` / `EnvNic` / `EnvCheckedAt`.


### 11g. v1.3.0 — Yedinci tur (VPN uyumu, Ağ Testi v2, Ses Profili, üretici telemetrisi)
- `Get-MrCleanVpnState` → `@{ Installed; Connected }`. Konumu: `Get-MrCleanPhysicalAdapters`'ın hemen altı. Kullanan: `Get-MrCleanDnsGuard` (bağlı tünel = DNS'e dokunma) ve Ağ Testi.
- `Get-MrCleanVendorTelemetry [-Fresh]` → üretici telemetri bileşenleri. `$global:MrCleanVendorTel` önbelleğinde tutulur. `Requires="VendorTel"` → `tw_hw_vendortel`.
- **Ağ Testi v2** (`Show-NetworkQualityTest`):
  - Worker'daki fonksiyonlar `Med`, `Jit`, `TcpRtt`, `Probe` (ICMP veya `-Tcp`) ve `LoadTest(urls, mode, streams, maxSec, capBytes, pingIp)`.
  - Sonuçlar `$script:NqSync` içinde: Colo, Idle, Regions, Dom, Intl, Up.
  - Geçmiş `HKCU\Software\MrClean\NetTestHistory` (JSON, son 6).
  - Sunucu URL'leri worker içinde `$srv` altında. Değiştirmeden önce User-Agent ile `Range` isteğinin 206 döndüğünü test edin.
  - Cloudflare `__down`: tek istekte en fazla 25 MB (100 MB ve üstü 403 döner).
- **Ses Profili:**
  - Fonksiyonlar: `Get-MrCleanEapoConfigDir`, `Get-MrCleanAudioEndpoints` (CoreAudio COM sınıfı `MrCleanDefAudio`), `ConvertFrom-MrCleanEqLine`, `Measure-MrCleanEqPeak` (RBJ biquad), `Get-MrCleanEqPreset(id, bass, hasAutoEq)`, `Show-AudioProfileTool`.
  - Kayıt: `HKCU\Software\MrClean` altında `AudioPreset`, `AudioAutoEqName`, `AudioAutoEqUrl`.
  - Dosyalar: EAPO config klasöründe `MrClean-Ses.txt`, `config.txt` ve `config.mrclean-yedek.txt`.
  - Düğme `btnAudioProfile`; dil anahtarı `btn_audio` (TR/EN/FR).
- **Ağ Sıfırlama:** `$s` betiğindeki `__SKIPDNS__` / `__DNSTOOLS__` yer tutucuları, worker başlamadan önce click handler'da doldurulur.
- **Kural:** EAPO / AutoEq filtre sayıları her zaman `[Globalization.CultureInfo]::InvariantCulture` ile yazılır ve okunur.


### 11h. v1.3.0 — Sekizinci tur (Otomatik Ses)
- **Bölüm başlığı:** `v1.3.0 (8. tur): OTOMATIK SES SISTEMI`.
- **Sabitler:** `$global:MrCleanEapoConst` içinde CLSID'ler, yuva / PKEY adları, URL'ler, SHA-256, görev adı ve ayar anahtarı (`HKCU\Software\MrClean\Audio`; aygıtlar `\Devices\{guid}`).
- **Native (C#):** `MrCleanAudioV2.Native`
  - `DefaultId(flow)`
  - `OpenShared(fullId)`: paylaşımlı modda `Initialize` → APO yüklenir.
  - `ProbeEapo(pipe, ids, ms)`: EAPO test kanalı dinleyicisi.
- **Aygıt ve model:** `Get-MrCleanAudioDevices`, `Get-MrCleanAutoEqIndex [-Offline]`, `Find-MrCleanAutoEqMatch`, `Get-MrCleanAutoEqFilters`.
  - Filtre önbelleği: `%LOCALAPPDATA%\MrClean\autoeq\`.
- **Kurulum:** `Install-MrCleanEapoDevice` / `Uninstall-MrCleanEapoDevice` (EAPO `DeviceAPOInfo` ile uyumlu biçim), `Test-MrCleanEapoDevices`, `Install-MrCleanEapoPackage`, `Install-MrCleanClipOnly`.
- **Ses dengeleyici (10. tur):** sabitler `LevUrl/LevMember/LevFile/LevSha/LevFull/LevLight` (`$global:MrCleanEapoConst`), ayar `Leveler` (auto/full/light/off). İndirme `Invoke-MrCleanAudioSetup` içinde (`Install-MrCleanZipMember`); satır `Write-MrCleanAudioConfig` içinde, `MrClean-user.txt` ile ClipOnly2 arasında. Arayüz: `cbAsLev`.
- **Ayar dosyaları:** `Get-MrCleanAudioCurve`, `Format-MrCleanEqFilter`, `Write-MrCleanAudioConfig`.
  - EAPO config klasöründeki dosyalar: `MrClean-dev-<guid>.txt`, `MrClean-hp-{balanced,music,game,active}.txt`, `MrClean-default-mode.txt`, `MrClean-games.txt`, `MrClean-AudioMode.ps1`.
- **Akış:** `Invoke-MrCleanAudioSetup` (worker), `Remove-MrCleanAudioAll`, `Invoke-MrCleanAudioMaintain` (açılışta, DriftStartTimer içinde).
- **Arayüz:** `Show-AudioProfileTool`. Satırlar `$script:AsRows` listesinde (Plan / Chk / Kind / Info / ModelBtn).
  - Worker, `InitialSessionState` + `SessionStateFunctionEntry` ile kurulur. Yeni bir yardımcı fonksiyon eklerseniz `$runWorker` içindeki listeye de ekleyin.
- **Kurallar:**
  - EAPO dosyalarına yalnızca ASCII ve InvariantCulture sayılar yazılır.
  - Audiosrv'yi yeniden başlatırken bağımlı servisler de yeniden başlatılır.
  - Varsayılan olmayan HDMI/DP aygıtı otomatik seçilmez.
- **Ağ testi:**
  - Cloudflare isteklerine `Referer` / `Origin` başlıkları eklenir. 429 / 403 gelen akış durur.
  - Yurt dışı karar ortanca tabanlı; `Get-ProfileTweaks`'te Wi-Fi kartı varsa Wi-Fi tweak'leri eklenir.
- **8. tur eki:**
  - Ses türüne "Voice" (sohbet kanalı) eklendi; `MrCleanAudioV2.Native.DefaultIdRole(flow, role)` ile iletişim varsayılanı okunur.
  - Tek seferlik yönetici izni:
    - Fonksiyonlar `Get-MrCleanAdminLauncherState`, `Enable-` / `Disable-MrCleanAdminLauncher`, `Update-MrCleanAdminLauncherCopy`, `Request-MrCleanAdminLauncherOnce` (Start-MrCleanDriftCheck'in hemen üstünde).
    - Açılıştaki yönetici kontrolünde görev denemesi var.
    - Ayarlar > `chkAdminLauncher`; dil anahtarları `set_adminlauncher` / `set_adminlauncher_tip`.
    - Görev adı `$global:MrCleanElevTask`.
- **Mikrofon zinciri (8. tur):**
  - `$global:MrCleanMicConst`: URL, zip üyesi, SHA-256, RNNoise / DFN ChunkData, Airwindows float parametreleri.
  - Fonksiyonlar: `Install-MrCleanZipMember` (genel Range zip çıkarıcı), `Install-MrCleanMicComponents`, `Get-MrCleanEndpointFormat`, `Get-MrCleanMicType`, `ConvertTo-MrCleanFloatChunk`, `Get-MrCleanMicChainLines`.
  - Eğriler `mic_headset`, `mic_desk`, `mic_laptop`.
  - Planda `MicType` alanı var; tercih kaydında mikrofonlar için `Model` alanında saklanır.
  - Ayarlar: `MicEngine` (rnnoise / dfn / off) ve `MicLevel`.
  - Ölçüm düzeneği proje dışında, scratchpad `micbench` klasöründe: `MicBench.cs`, `bench.ps1`, `e2e.ps1`.
- **Mikrofon zinciri (son durum):**
  - Zincir: HP → DFN3 (gücü `MicAtten`, varsayılan 30; Mikrofon Testi odaya göre seçer) → hafif EQ → ADClip8 (kazanç 0, tavan -1).
  - Kompresör ve DeEss YOK; seviye dengelemeyi Discord'un Otomatik Kazanç Kontrolü yapar.
  - Fonksiyonlar `Get-MrCleanDfnChunk`, `Measure-MrCleanMicEnvironment`; C# sınıfı `MrCleanAudioV2.Capture` (RAW kayıt).

> §96 (14 Ekim 2026): D1–D6 ölü kod temizliği — genel arama şeridi (`grdGlobalSearch`, `txtSearch`, Tümünü Seç / Sekme Seç / Tümünü Kaldır, `Select-SafeTweaks`, arama zamanlayıcısı), hiç çağrılmayan 5 fonksiyon, okunmayan 5 değişken, XAML'de olmayan 6 `FindName` + işleyicileri (eski SFC düğmesi dahil), `Set-TweakItemUI` eski "(Aktif)" dalı, Başlangıç `StatusColor` / `DelayColor`, 67 dil anahtarı silindi. Satır numaraları yaklaşık ~570 satır kaydı.

> **15 Ekim 2026 eki (§93–§106) — satır numarası yerine `function` adıyla arayın:**
> - Güç planı / doğrulama: `Invoke-MrCleanPowerPlanFirst`, `Sync-MrCleanPlanBoundPower`, `Get-MrCleanPlanBoundAppliedNames`, `Get-MrCleanActiveSchemeGuid`, `Get-MrCleanTweakDependents`, `Update-TweakStatusAfterApply` (Uygula sonrası canlı doğrulama); tablolar `$script:PlanBoundPowerTweaks`, `$script:PlanBoundBackupIds`, `$script:TweakSideEffects`.
> - Uyumsuz ama aktif tweak: `$script:TweakIncompatNames` + `Set-TweakItemUI`.
> - Gezgin yenileme: `Get-MrCleanDesktopView`, `Invoke-ShellSoftRefresh` (NativeMethods: FindWindow / FindWindowEx / PostMessage).
> - Açıklama kutusu: `Attach-ToolTip` (Placement Bottom, `$script:TipTemplate`, `$script:TipBrushes`, 1 sn gecikme, `$script:TipWheelTimer` kaydırma sonrası açma).
> - Oyun: `Get-MrCleanGameExeNames`; `Install / Remove / Test-MrCleanGameCpuAgent` (+ `Convert-MrCleanLegacyProcMin`); `Set / Remove / Test-MrCleanGamePriority` (IFEO); `Install / Remove / Test-MrCleanCs2Cpu0`.
> - Dosya Boyutu: C# `MrCleanLf.Scanner` (`Start-LargeFileScan` içindeki `$lfScannerCs`).
> - Winget: ilk ziyarette `Refresh-Winget-Status -Silent` (`$script:WingetStatusScanned`), `Open-DashTarget` "Kurulu" süzgeci.
