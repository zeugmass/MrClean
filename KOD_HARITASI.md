# MrClean — Kod Haritası (v1.2.28)

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

**Durum/veri globalleri:** `Winapp2Rules`(522), `ShowPrivacyWarning`(523), `Blacklist`(524), `PathOverrides`(525), `CustomRules`(526), `AppLayout`(527), `CustomAppx`(528), `MyProfile`(529), `AppCounter`(530), `StopOperation`(531), `TweaksLoaded`(532), `CustomTools`(533), `RestorePointMode`(534), `LastTweakOperation`(535), `ConfigDirty`(539), `DashResult/DashCache/DashCacheTime`(540-542), `ActiveRunspaces`(544), `EmbeddedTools`(546), `DetectedGpuVendors`(552), `TweakList`(739), `WingetApps`(2960), `ToolDownloadPath`(config'den).

**Kimlik/sürüm:** `$global:AppVersion="1.2.28"`(558), `$global:AppRepo="zeugmass/MrClean"`(561), `$global:UpdateAvailable`(565), `$global:FeedbackWebhookUrl` (Discord, 573).

**Gömülü kaynaklar:** `NvidiaInspectorOptimizedNip`(581)/`EmptyNip`(625) NIP profilleri, `Win11Start2BinBase64`(639) Başlat menü layout.

---

## 4. FONKSİYON DİZİNİ (bölüm bölüm)

**Region 2:** `Refresh-WindowsTheme`(414), `Refresh-Wallpaper`(419)

**Region 4 — Veri:** `Get-Default-Tweaks`(751, DEV — tüm tweak DB), `Get-SelectedTasks`(2937), `Get-Default-WingetApps`(2961), `Load-Repair-Tree`(2985, onarım ağacı + SFC/WinHTTP)

**Region 6:** `Load-EmbeddedImage`(4857)

**Region 7:** `Do-Events`(4901), `WpfLog`(4913), `Format-Size`(4940)

**Region 8 — Config:** `Save-App-State`(4956), `Show-ConfigRecoveryDialog`(4980), `Load-All-Settings`(5045), `Save-User-Config`(5205), `Mark-ConfigDirty`(5305), `Restore-Checkboxes`(5310)

**Region 9 — Tweak + Update + Benchmark + Timer:**
- GPU/NVIDIA: `Get-System-Gpu-Vendors`(5346), `Get-NvidiaInspectorPath`(5375), `Invoke-StartMenuLayoutImport`(5461)
- **Program güncelleme:** `Compare-Version`(5602), `Get-AppExeDirectory`(5620), `Cleanup-OldUpdateFiles`(5640), `Test-AppUpdate`(5664, GitHub release async), `Invoke-AppUpdate`(5816, indir+SHA256+swap), `Add-SkippedVersion`(5933)
- Shell/restore: `Invoke-ShellSoftRefresh`(5952), `Invoke-ExplorerHardRestart`(5968), `Test-VssServiceRunning`(6025), `Get-LastRestorePointDate`(6035), `Create-Restore-Point`(6050), `Invoke-RestorePointAsync`(6112)
- Timer resolution: `Invoke-HiddenCommand`(6232), `Get/Save-TRTSettings`(6267/6291), `Get-CurrentTimerResolutionMs`(6303), `Invoke-TimerResHelperSetup`(6307), `Remove-TimerResHelper`(6387)
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
- `Get-WebLink`(9927), `Refresh-Tools-Menu`(9977), `Invoke-ManualUpdateCheck`(10053, program güncelleme manuel), `Show-ToolManager`(10493)
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
`Test-AppUpdate`(5664, açılış async) → `$global:UpdateAvailable` → `Invoke-ManualUpdateCheck`(10053) → `Show-AppUpdateWindow`(12172) → `Invoke-AppUpdate`(5816: indir+SHA256+`update_runner.ps1` swap+restart).

**B) WINAPP2 (temizlik veritabanı) güncellemesi:**
- Açılış otomatik kontrol: `Start-Winapp2-Process`(8707) içindeki `$CheckUpdateBlock`(8715-8771) — yerel+uzak **sadece ilk satırı** okur, kıyaslar, `txtWinappStatus`(3775) yazısını "Yeni Sürüm Mevcut!" yapar (silik gri etiket → görünürlük zayıf).
- Manuel: `btnRefreshApp`(♻ Güncelle, XAML 3258) `.Add_Click`(18763) → `Show-UpdateWindow`(12384): ilk-satır sürüm kıyas + GÜNCELLE butonu (`.old` yedek → indir → cache sil → yeniden yükle, 12578-12612).

---

## 10. v1.2.29 DEĞİŞİKLİKLERİ (LOKAL — winapp2 görünürlük + diff)

**⚠️ Satır kayması:** `Show-UpdateWindow` öncesine ~62 satır (2 fonksiyon) + birkaç küçük ekleme yapıldı → bu bölümden SONRAKİ satır no'ları ~+60-70 kaymış olabilir. Kesin konum için Grep kullan.

- **#1 Buton görünürlüğü:** `Start-Winapp2-Process`→`$CheckUpdateBlock` tick'inde açılış güncelleme tespiti artık `btnRefreshApp`'i değiştiriyor: güncelleme varsa "🔔 Güncelle (Yeni!)" + yeşil #137333 + tooltip; güncelse "♻ Güncelle" + #4f0707'ye döner. `$btnRef = $btnRefreshApp` closure'a eklendi (~8720). `$global:Winapp2UpdateAvailable` bayrağı (init satır 566).
- **#2 Diff:** Yeni fonksiyonlar `Show-UpdateWindow` ÖNCESİNDE: `Get-Winapp2Diff($OldPath,$NewPath)` ([Section] bazlı Added/Removed/Changed) + `New-Winapp2DiffReport($OldPath,$NewPath,$OnlineVer)` (txt yazar → `%APPDATA%\MrClean\winapp2_diff_<stamp>.txt`, döner @{Path;Added;Changed;Removed}). `Show-UpdateWindow` GÜNCELLE handler'ı başarı dalında (btnUpd) `.old` silinmeden diff üretir, txt'yi `Invoke-Item` ile açar, eski sürümü `Winapp2.prev.ini` olarak saklar, `$script:LastWinapp2DiffPath` set eder, durum metnine sayaç yazar.
- Grep anahtarları: `Get-Winapp2Diff`, `New-Winapp2DiffReport`, `Winapp2UpdateAvailable`, `LastWinapp2DiffPath`, `btnRef`.
