# MrClean — Kod Haritası (v2.0.3 + §167)

**Dosya:** `TemizlikAsistani.ps1` · **33.072 satır** · 4,2 MB · 458 üst düzey fonksiyon · PowerShell 5.1 + WPF · PS2EXE (`-NoConsole -RequireAdmin`) ile tek EXE.
**Üretim:** 16 Kasım 2026, v2.0.3 Release kaynağı (SHA256 doğrulandı) + §167 düzeltmeleri üzerinden AST ile çıkarıldı. Fonksiyon dizini (§4) otomatiktir; satır numaraları bu andaki dosyaya aittir.
**Kullanım:** buradan bölümü / fonksiyonu bul → konumu `Grep "function Ad"` ile teyit et (satırlar her düzenlemede kayar) → yalnız ilgili ±30–60 satırı oku → Edit. Tüm dosyayı okuma.
**Güncelleme:** yapısal değişiklikten sonra §4 yeniden üretilir: `Parser::ParseFile` → üst düzey `FunctionDefinitionAst` → `# #region N --` satırlarına göre gruplanır.

---

## 1. GENEL AKIŞ

```
Açılış:  Region 1–3 (interop, yönetici, globaller) → Region 4 veri tanımları → Region 5 XAML here-string'leri
         → Region 6 XamlReader.Load + FindName → Region 7–13 fonksiyon tanımları → Region 14 olay bağlamaları
         → Region 15: $Win.Add_Loaded (32941) → Resume-MrCleanBoot (32909) → $Win.ShowDialog() (33067)
Add_Loaded: Load-Tweak-Tree (ilk ziyarette), Start-Winapp2-Process, Test-AppUpdate (arka plan),
            DriftStartTimer 6 sn sonra: Update-MrCleanAdminLauncherCopy, Start-MrCleanDriftCheck, Invoke-MrCleanAudioMaintain …
Kapanış: $Win.Add_Closing (32564) — runspace havuzu / zamanlayıcılar / ajanlar temizlenir, ayar kaydı
```

**Tweak yaşam döngüsü (en sık dokunulan yol):**
`Get-Default-Tweaks` (veri) → `Set-MrCleanTweakLayout` (kategori düzeni) → `Load-All-Settings` (user_config.json ile birleştirme, `$retiredOfficialTweaks`) → `Load-Tweak-Tree` / `Create-Tweak-Item` (arayüz) → `Check-Tweak-Status` (önbellekli, parça parça tarama) → `Get-Tweak-IsActive` (tespit; `DetectScript` öncelikli) → **Uygula:** `btnApplyTweaks` → `Apply-System-Tweaks` (onay kartı `Show-ApplyConfirm`, ilerleme `Show-ApplyOverlay`, Inspector ön indirme, `Invoke-MrCleanPowerPlanFirst`, iç fonksiyon `Process-TweakItem` → `Invoke-TweakCommand`) → `Update-TweakStatusAfterApply` (canlı doğrulama, `[DOĞRULAMA]` satırları) → `Update-MrCleanAppliedList` + `Write-TweakAuditLog`.
**Geri al:** `Invoke-QuickUndo` (iç `Invoke-TweakAction` — Process-TweakItem'in kopyası), Aktivite Log'dan `Invoke-SingleActivityReverse`.

---

## 2. REGION HARİTASI

| Region | Satır | İçerik |
|---|---|---|
| 1 C# INTEROP | 49–423 | `Add-Type` sınıfları: NativeMethods (ShowWindow, SendMessageTimeout, SystemParametersInfo, SHChangeNotify, FindWindow/PostMessage), FileSelector, SecureWiper, RamCleaner, RamInfo, ProcessMonitor, TimerRes, CpuStress. Konsol gizleme, PS2EXE `Out-Default`/`Write-Host` susturma |
| 2 YÖNETİCİ / POOL / TEMA | 424–502 | Yönetici denetimi + RunAs yeniden başlatma, `MrCleanPool` runspace havuzu, `Refresh-WindowsTheme` |
| 3 GLOBALLER & YOLLAR | 503–822 | `$AppDataPath` = `%APPDATA%\MrClean`, `Migrate-AppDataLayout`, kapsam kuralları (588), `AppVersion` (633), `AppRepo` (646), NVIDIA NIP (668), Start2.bin base64 (716) |
| 3B DİL / i18n | 823–1262 | TR/EN/FR dil tablosu, `Initialize-Language`, `T` (anahtar → metin), `Localize-Xaml` |
| 4 VARSAYILAN VERİLER | 1263–6361 | `Set-MrCleanTweakLayout` (1269), **`Get-Default-Tweaks` (1308–6285, ~4.980 satır)**, `Get-Default-WingetApps`, `Load-Repair-Tree` |
| 5 XAML | 6362–9757 | Ana pencere `$xaml` (6368) + 12 alt pencere here-string'i (§5) |
| 6 XAML YÜKLEME & SAYFALAR | 9758–11285 | Yazı tipi, `Initialize-SubWindow`, `Show-MrCleanMessage`/`Show-MrCleanInput`, FindName bağlamaları, **tasarım E sayfa yardımcıları**: Temizlik (`*-Clean*`), Onarım, Winget, Başlangıç, Dosya Boyutu (`*-Lf*`) |
| 7 ÇEKİRDEK | 11286–11417 | `Do-Events`, `WpfLog`, `Format-Size`, açılış ölçümü (`Measure-BootStep`, `Start/Stop-MrCleanMeasure`) |
| 8 AYAR | 11418–11870 | `Load-All-Settings` (birleştirme + `$retiredOfficialTweaks` 11627), `Save-User-Config`, `Invoke-TweakCommand` (Command çalıştırıcı, Write-Host → kayıt) |
| 9 TWEAK SİSTEMİ | 11871–19426 | En büyük mantık bölgesi: geri alma yardımcıları, servis / görev / ağ / DNS / Wi-Fi, oyun ajanları, NVIDIA Inspector, güncelleme, geri yükleme noktası, timer, `Get-Tweak-IsActive`, ağaç + filtre + rozet, Uygula / katman, Tweak Yöneticisi, benchmark, AMD yonga seti onarımı, Hızlı Geri Al, sürüm sonrası denetim, emekli tweak'ler, durum önbelleği |
| 10 TEMİZLİK MOTORU | 19427–20363 | Tarayıcı güvenliği, Winapp2 indir / ayrıştır (`Start-Winapp2-Process`, `Parse-Winapp2`), Appx, `Load-Winget-Tree`, `Resolve-ComplexPath`, `Run-CMD-Realtime`, `Process-Tree` (temizlik yürütücü) |
| 11 WORKER | 20364–20674 | `Start-Worker-Process` (async + zaman aşımı + durdur), kurulu uygulama tespiti, `Refresh-Winget-Status` |
| 12 BAŞLANGIÇ | 20675–20879 | `Refresh-StartupView` (kayıt defteri + WMI + klasör + görev + UWP) |
| 13 UI / MODAL | 20880–29997 | Profiller, Winapp2 editörü, geri bildirim, güncelleme penceresi, donanım detayı, Genel Bakış (`Load-DashboardData`), benchmark pencereleri, Aktivite Log, Sistem & Güvenlik, DNS benchmark, Ağ Kalite Testi, **Otomatik Ses + mikrofon zinciri** (26117–27775), oyun algılama + Defender istisnaları, Timer pencereleri, Bloatware, Dosya Boyutu tarayıcı |
| 14 OLAY BAĞLAMALARI | 29998–32560 | Başlangıç sağ tık, Çökme Analizi tarama motoru (`btnScanCrashes` 30445), Onarım düğmeleri, araç düğmeleri, Tweaks düğmeleri (31271–31299), Winget, Ayarlar (`btnSettings` 31935), RAM temizle, Temizlik Analiz / Çalıştır (32349 / 32415) |
| 15 YAŞAM DÖNGÜSÜ | 32561–33072 | `Add_Closing`, sekme değişimi (32639), Gece Modu, Dosya Boyutu olayları, `Resume-MrCleanBoot`, `Add_Loaded`, `ShowDialog` |

---

## 3. VERİ: TWEAK VERİTABANI (`Get-Default-Tweaks`, 1308–6285)

Kaynaktaki kategori anahtarları (satır = anahtarın başı). Arayüzdeki son düzen `Set-MrCleanTweakLayout` (1269, 38 adlık tablo) ile oluşur: bazı satırlar başka kategoriye taşınır ve `SubCategory` alır.

| Satır | Kategori | Satır | Kategori |
|---|---|---|---|
| 1311 | Görsel Performans | 3620 | 🧹 Debloat (servisler — Güvenli / Riskli) |
| 1466 | Kişiselleştirme (görev çubuğu, Başlat, arama) | 4323 | 🧩 Uygulamalar (Discord, Chrome, çevre birimi) |
| 1960 | Oyun | 4392 | Uygulama Kaldırma |
| 1982 | Gizlilik ve Telemetri | 4460 | Ağ ve DNS Ayarları |
| 2689 | 🤖 Windows AI | 4604 | Gelişmiş Sistem (Windows Update, Güvenlik Sıkılaştırma) |
| 2857 | Windows Gezgini | 4904 | 🎮 Low Latency (Ağ ve Ping, Wi-Fi, Ses, Giriş ve İşlemci, Depolama) |
| 3073 | Sistem | 5961 | 🎮 GPU Ayarları (NVIDIA / AMD; NVIDIA Optimizasyonu 6125) |
| 3509 | Güç Planı | | |

Tweak alanları ve kurallar: `CLAUDE.md` › "Tweak tanımları". Ek tablolar: `$script:MrCleanSvcDefaults` (11951, servis varsayılanları), `$script:PlanBoundPowerTweaks` (15338), `$script:TweakSideEffects` (15351), `Get-RetiredTweakDefs` (emekli tweak tanımları), `Get-ProfileTweaks` (20941, önerilen profiller).

---

## 4. FONKSİYON DİZİNİ (otomatik)

Biçim: `Ad` başlangıç satırı; **kalın** = 150+ satır (parantezde uzunluk). İç içe fonksiyonlar listelenmez (ör. `Apply-System-Tweaks` › `Process-TweakItem` 16294, `Scan-Nodes`; `Invoke-QuickUndo` › `Invoke-TweakAction`; `Show-NetworkQualityTest` › `LoadTest`, `Probe`, `TcpRtt`).

### Region 1 — C# INTEROP (Native Methods, SecureWiper, RamCleaner, vb.) · satır 49–423 · 0 fonksiyon

### Region 2 — YONETICI KONTROL, RUNSPACE POOL, TEMA · satır 424–502 · 1 fonksiyon

`Refresh-WindowsTheme` 427

### Region 3 — GLOBAL DEGISKENLER & DOSYA YOLLARI · satır 503–822 · 1 fonksiyon

`Migrate-AppDataLayout` 524

### Region 3B — DIL / i18n (FR/TR/EN) — Faz 1 · satır 823–1262 · 3 fonksiyon

`Initialize-Language` 1215 · `T` 1237 · `Localize-Xaml` 1247

### Region 4 — VARSAYILAN VERILER (Tweak DB, Winget DB, Repair Tree) · satır 1263–6361 · 4 fonksiyon

`Set-MrCleanTweakLayout` 1269 · **`Get-Default-Tweaks`** 1308 (4978) · `Get-Default-WingetApps` 6295 · `Load-Repair-Tree` 6320

### Region 5 — XAML TANIMLARI (Ana pencere + Alt pencereler) · satır 6362–9757 · 0 fonksiyon

### Region 6 — XAML YUKLEME & FINDNAME BAGLAMALARI · satır 9758–11285 · 63 fonksiyon

`Initialize-UiFont` 9762 · `Set-UiFont` 9781 · `Initialize-SubWindow` 9800 · `Get-MrCleanMsgOwner` 9841 · `Show-MrCleanMessage` 9853 · `Show-MrCleanInput` 9926 · `Sync-NavToTab` 10030 · `Set-LogPanelVisible` 10052 · `Set-LogUnread` 10071 · `Update-PageChrome` 10080 · `New-ClBrush` 10314 · `Get-CleanSections` 10322 · `Format-CleanSize` 10331 · `Format-CleanAge` 10337 · `Get-CleanItemPath` 10346 · `Convert-CleanRow` 10362 · `Update-CleanRowWidths` 10409 · `Add-TreeWheelForward` 10418 · `Update-CleanRows` 10430 · `Get-CleanSizeBlock` 10435 · `Set-CleanBadge` 10444 · `Set-CleanItemMeasure` 10455 · `Reset-CleanSizeText` 10463 · `Reset-CleanMeasures` 10471 · `Measure-CleanItems` 10477 · `Update-CleanSubtitle` 10503 · `Update-CleanSummary` 10512 · `Get-CleanHistory` 10572 · `Update-CleanHistoryView` 10580 · `Add-CleanHistory` 10612 · `Filter-CleanNodes` 10623 · `Reset-CleanNodes` 10641 · `Apply-CleanView` 10646 · `Set-CleanChecks` 10657 · `Set-CleanChecksVisible` 10665 · `Sync-CleanDelMethod` 10672 · `Update-CleanPage` 10684 · `Set-RepairNotes` 10741 · `Update-RepairRows` 10756 · `Get-RepairChecked` 10763 · `Update-RepairSummary` 10771 · `Update-RepairPage` 10797 · `Test-WingetInstalled` 10824 · `Set-WingetNotes` 10826 · `Update-WingetRows` 10851 · `Update-WingetSummary` 10863 · `Apply-WingetView` 10880 · `Update-WingetPage` 10903 · `Get-StartupSourceText` 10935 · `Get-StartupDelayText` 10948 · `Set-StartupItemDisplay` 10955 · `Update-StartupSummary` 10966 · `Update-StartupSelection` 10974 · `Apply-StartupView` 11001 · `Set-StartupList` 11019 · `Switch-StartupItem` 11026 · `Test-LfVisible` 11103 · `Update-LfSummary` 11109 · `Update-LfSelection` 11131 · `Apply-LfSort` 11147 · `Apply-LfView` 11155 · `Set-LfList` 11169 · `Load-EmbeddedImage` 11249

### Region 7 — CEKIRDEK HELPERLAR (Do-Events, WpfLog, Format-Size) · satır 11286–11417 · 10 fonksiyon

`Pump-BootUi` 11289 · `Do-Events` 11313 · `Set-BootProgress` 11333 · `Test-BootOverlayVisible` 11340 · `Start-MrCleanMeasure` 11348 · `Stop-MrCleanMeasure` 11349 · `Measure-BootStep` 11358 · `Complete-TweakTreeFirstVisit` 11367 · `WpfLog` 11376 · `Format-Size` 11405

### Region 8 — AYAR YONETIMI (Config Save/Load/Restore) · satır 11418–11870 · 8 fonksiyon

`Save-App-State` 11421 · `Show-ConfigRecoveryDialog` 11445 · `Get-TweakField` 11504 · `Invoke-TweakCommand` 11514 · **`Load-All-Settings`** 11523 (215) · `Save-User-Config` 11741 · `Mark-ConfigDirty` 11839 · `Restore-Checkboxes` 11844

### Region 9 — TWEAK SISTEMI (IsActive, Apply, Check, Manager) · satır 11871–19426 · 220 fonksiyon

`Get-System-Gpu-Vendors` 11880 · `Backup-TweakRegValue` 11906 · `Restore-TweakRegValue` 11925 · `Test-MrCleanServicesExist` 11964 · `Test-MrCleanServicesStart` 11969 · `Set-MrCleanSvcStartSc` 11983 · `Set-MrCleanServicesStart` 11997 · `Restore-MrCleanServicesStart` 12019 · `Get-MrCleanSvcMode` 12051 · `Set-MrCleanSvcMode` 12056 · `Test-MrCleanAppInstalled` 12063 · `Close-MrCleanApp` 12073 · `Start-MrCleanApp` 12088 · `Test-MrCleanDiscordSetting` 12095 · `Set-MrCleanDiscordSetting` 12101 · `Get-MrCleanHwWarnings` 12129 · `Get-TweakHwWarning` 12174 · `Get-PowerSettingIndex` 12198 · `Backup-PowerSettingIndex` 12207 · `Restore-PowerSettingIndex` 12216 · `Test-IsLaptop` 12229 · `Get-MrCleanPhysicalAdapters` 12247 · `Get-MrCleanNicFast` 12264 · `Get-MrCleanNicAdvancedFast` 12282 · `Get-MrCleanNicParamsFast` 12293 · `Get-MrCleanServicesFast` 12311 · `Test-MrCleanTasksDisabled` 12314 · `Set-MrCleanTasksEnabled` 12333 · `Get-MrCleanTasksDenied` 12365 · `Get-MrCleanVendorTelemetry` 12374 · `Get-MrCleanVpnState` 12404 · `Get-MrCleanDnsGuard` 12433 · `Test-MrCleanDnsBlocked` 12471 · `Backup-MrCleanDnsStatic` 12480 · `Restore-MrCleanDnsStatic` 12494 · `Set-MrCleanDnsPreset` 12517 · `Set-MrCleanWifiProperty` 12534 · `Restore-MrCleanWifiProperties` 12558 · `Test-MrCleanWifiProperty` 12576 · `Invoke-MrCleanNicRestartAsync` 12597 · `Restart-MrCleanWifi` 12614 · `Set-MrCleanEthProperty` 12620 · `Restart-MrCleanEthernet` 12639 · `Restart-MrCleanNicsAndWait` 12646 · `Measure-MrCleanRtt` 12672 · `Test-IsAmdCpu` 12683 · `Get-MrCleanVirtContent` 12693 · `Get-MrCleanVirtFeatures` 12730 · `Confirm-VirtHeavyTweak` 12738 · `Confirm-IdleDisableTweak` 12760 · `Confirm-WuLockTweak` 12774 · `Get-MrCleanGameExeNames` 12797 · `Test-MrCleanGameCpuAgent` 12805 · `Install-MrCleanGameCpuAgent` 12813 · `Stop-MrCleanGameCpuAgentProcess` 12874 · `Remove-MrCleanGameCpuAgent` 12878 · `Set-MrCleanGamePriority` 12905 · `Remove-MrCleanGamePriority` 12921 · `Test-MrCleanGamePriority` 12944 · `Test-MrCleanCs2Cpu0` 12967 · `Stop-MrCleanCs2Cpu0AgentProcess` 12975 · `Install-MrCleanCs2Cpu0` 12979 · `Remove-MrCleanCs2Cpu0` 13020 · `Convert-MrCleanLegacyProcMin` 13033 · `Confirm-LaptopPowerTweak` 13048 · `Get-DualCcdX3DName` 13062 · `Confirm-DualCcdX3DPowerTweak` 13074 · `Get-NvidiaInspectorPath` 13096 · `Invoke-NvidiaInspector` 13178 · `Backup-NvidiaProfiles` 13201 · `Compare-NvidiaBaseProfile` 13216 · `Test-NvidiaProfileApplied` 13230 · `Get-NvidiaDriverVersion` 13252 · `Test-NvidiaTweakCurrent` 13267 · `Complete-NvidiaTweakCheck` 13325 · `Open-NvidiaSettingsApp` 13362 · `Invoke-StartMenuLayoutImport` 13376 · `Compare-Version` 13517 · `Get-AppExeDirectory` 13535 · `Cleanup-OldUpdateFiles` 13555 · `Get-Winapp2LocalVersion` 13580 · `Get-Winapp2OnlineVersion` 13591 · `Invoke-Winapp2Download` 13604 · `Set-MrCleanAppUpdateButton` 13637 · `Invoke-MrCleanAppUpdateButton` 13657 · `Test-AppUpdate` 13677 · `Invoke-AppUpdate` 13831 · `Add-SkippedVersion` 13948 · `Get-MrCleanDesktopView` 13968 · `Invoke-ShellSoftRefresh` 13985 · `Invoke-ExplorerHardRestart` 14007 · `Test-VssServiceRunning` 14064 · `Get-LastRestorePointDate` 14074 · `Create-Restore-Point` 14089 · `Test-RestorePointWillAsk` 14154 · `Invoke-RestorePointAsync` 14164 · `Invoke-HiddenCommand` 14298 · `Get-TRTSettings` 14333 · `Save-TRTSettings` 14357 · `Invoke-TimerResHelperSetup` 14369 · `Remove-TimerResHelper` 14459 · `Get-MrCleanTimerTarget` 14490 · `Enable-MrCleanTimerResolution` 14497 · `Disable-MrCleanTimerResolution` 14517 · `Refresh-PowerCfg-Cache` 14540 · `Refresh-BcdEdit-Cache` 14544 · `Refresh-NetshTcp-Cache` 14548 · **`Get-Tweak-IsActive`** 14552 (210) · `Load-Tweak-Tree` 14764 · `Attach-ToolTip` 14879 · `Sync-Children` 14963 · `New-TreeItem` 14965 · `Get-CheckFromItem` 14984 · `Get-TweakDisplayName` 14993 · `Find-TweakNameBlock` 15011 · `Get-WinReleaseLabel` 15029 · `Get-MrCleanHwProfile` 15041 · `Get-MrCleanHwSummary` 15100 · `Get-TweakHardwareReason` 15110 · `Test-TweakBuildCompatible` 15141 · `Get-TweakBuildRequirement` 15151 · `Test-TweakNeedsReboot` 15175 · `Get-TweakSummaryLine` 15183 · `Test-TweakIsNew` 15192 · `Normalize-SearchText` 15199 · `Apply-TweakFilter` 15208 · `Update-TweakCategoryList` 15275 · `Test-TweakLeafActive` 15311 · `Get-TweakAppliedForApply` 15318 · `Get-MrCleanPlanBoundAppliedNames` 15369 · `Get-MrCleanActiveSchemeGuid` 15380 · `Sync-MrCleanPlanBoundPower` 15388 · `Invoke-MrCleanPowerPlanFirst` 15407 · `Get-MrCleanTweakDependents` 15430 · `Update-TweakStatusAfterApply` 15442 · `Update-TweakSummary` 15504 · `New-TweakBadge` 15536 · `Get-TweakPendingBadge` 15555 · `Update-TweakApplyCount` 15560 · `Set-TweakPendingState` 15566 · `Update-TweakPendingMark` 15573 · `Set-TweakModePill` 15586 · `Invoke-TweakModePillClick` 15600 · `New-TweakModePill` 15611 · **`Create-Tweak-Item`** 15645 (189) · `Show-Privacy-Warning` 15835 · `Get-ApovBrush` 15865 · `Invoke-ApplyOverlayRender` 15871 · `Get-ApovBarMax` 15876 · `Test-TweakNeedsRebootFlag` 15881 · `Show-ApplyConfirm` 15889 · `Test-TweakRestartsNic` 16021 · `Show-ApplyOverlay` 16027 · `Set-ApplyOverlayStep` 16059 · `Set-ApplyOverlayStepDone` 16074 · `Set-ApplyOverlayVerifying` 16086 · `Hide-ApplyOverlay` 16091 · `Complete-ApplyOverlay` 16101 · **`Apply-System-Tweaks`** 16158 (368) · **`Show-TweakManager`** 16527 (549) · `Write-TweakAuditLog` 17082 · `Test-TimerPrecision` 17124 · `Test-LoopbackPing` 17148 · `Test-GatewayPing` 17181 · `Test-DnsResolve` 17216 · `Test-Disk4kRead` 17241 · `Test-ProcessStartLatency` 17287 · `Test-DpcTime` 17314 · `Get-SystemSnapshot` 17345 · `Get-MrCleanBenchTool` 17628 · `Invoke-MrCleanBenchProcess` 17651 · `Test-SystemLatency` 17676 · `Test-GameLoad` 17682 · `Get-MrCleanBenchGpuTools` 17701 · `Test-GpuFrameTime` 17725 · `ConvertTo-MsiPackedGuid` 17769 · `Get-AmdChipsetInstallState` 17778 · `Get-AmdChipsetStaleFolders` 17808 · `Get-AmdChipsetStaleStateKey` 17827 · `Get-AmdOrphanComponentRefs` 17839 · `Invoke-AmdChipsetRepair` 17858 · `Compare-AmdVersion` 17941 · `Get-AmdChipsetPackage` 17952 · `Expand-AmdChipsetPackage` 17963 · `Install-AmdDriverPlan` 17972 · `Get-AmdInstallerSummary` 17995 · `Get-AmdChipsetDevices` 18003 · `Get-AmdDriverPlan` 18023 · **`Show-AmdChipsetRepair`** 18052 (169) · `Get-Median` 18227 · `Merge-BenchRuns` 18237 · `Get-BenchSnapshot` 18280 · `Format-BenchTime` 18346 · `Save-BenchSnapshot` 18356 · `Get-BenchSnapshots` 18374 · `Remove-BenchSnapshot` 18387 · `Set-BenchSnapshotLabel` 18395 · `Get-BenchMetricCatalog` 18410 · `Compare-BenchSnapshots` 18447 · `Invoke-QuickUndo` 18493 · `Get-MrCleanEnvFingerprint` 18635 · `Update-MrCleanAppliedList` 18643 · `Get-MrCleanAdminLauncherState` 18665 · `Enable-MrCleanAdminLauncher` 18672 · `Disable-MrCleanAdminLauncher` 18708 · `Update-MrCleanAdminLauncherCopy` 18721 · `Request-MrCleanAdminLauncherOnce` 18735 · `Convert-MrCleanAppliedAliases` 18750 · `Start-MrCleanDriftCheck` 18770 · `Set-MrCleanPendingReapply` 18857 · `Get-TweakStatusCachePath` 18883 · `Load-TweakStatusCache` 18889 · `Save-TweakStatusCache` 18910 · `Get-AllTweakItems` 18923 · **`Get-RetiredTweakDefs`** 18945 (236) · `Invoke-RetiredTweakCleanup` 19182 · `Test-TweakApplied` 19245 · `Set-TweakItemUI` 19259 · `Update-Parent-Headers-Recursive` 19278 · `Check-Tweak-Status` 19298

### Region 10 — TEMIZLIK MOTORU (Winapp2, Resolve-ComplexPath, Process-Tree) · satır 19427–20363 · 18 fonksiyon

`Check-And-Close-Browsers` 19430 · `Check-Browser-Safety` 19442 · `Get-AppEnvFingerprint` 19460 · `Update-Cache` 19480 · `Test-BrowserInstalled` 19498 · `Flush-Buffers-To-Tree` 19528 · `Add-To-Buffer` 19555 · `Load-System-Tree` 19562 · `Start-Winapp2-Process` 19594 · `Parse-Winapp2` 19725 · `Get-AppxPackageForTree` 19846 · `Ensure-WingetAppxLoaded` 19898 · `Load-Winget-Tree` 19905 · `Remove-Empty-Folders-Recursive` 20002 · `Secure-Remove-Item` 20007 · `Resolve-ComplexPath` 20027 · **`Run-CMD-Realtime`** 20145 (160) · `Process-Tree` 20306

### Region 11 — WORKER & KOMUT CALISTIRMA (Start-Worker-Process) · satır 20364–20674 · 4 fonksiyon

**`Start-Worker-Process`** 20367 (167) · `Get-InstalledAppRegistry` 20540 · `Normalize-AppNameForMatch` 20581 · `Refresh-Winget-Status` 20587

### Region 12 — BASLANGIC YONETICISI (Refresh-StartupView) · satır 20675–20879 · 1 fonksiyon

**`Refresh-StartupView`** 20678 (197)

### Region 13 — UI / MODAL FONKSIYONLARI · satır 20880–29997 · 106 fonksiyon

**`Get-ProfileTweaks`** 20941 (177) · **`Show-RecommendedProfiles`** 21119 (383) · `Show-ExportSourceDialog` 21514 · `Show-ImportConfirmDialog` 21567 · **`Show-ProfileManager`** 21660 (404) · `Check-BlackBoxStatus` 22066 · `Start-ShutdownCountdown` 22119 · `Show-Winapp2Editor` 22161 · `Send-Feedback` 22289 · **`Show-FeedbackWindow`** 22382 (151) · **`Show-AppUpdateWindow`** 22535 (186) · `Get-Winapp2Diff` 22723 · `New-Winapp2DiffReport` 22758 · `Show-RestartDialog` 22786 · **`Show-HardwareDetail`** 22855 (442) · `Get-DashBrush` 23300 · `Get-DashBarBrush` 23301 · **`Load-DashboardData`** 23303 (396) · `Get-DashAgeText` 23701 · `Get-DashStartupEnabledCount` 23708 · `Read-WingetUpdateCache` 23747 · `Save-WingetUpdateCache` 23759 · `Start-WingetUpdateCheck` 23767 · `Open-DashTarget` 23812 · `Add-DashRecRow` 23820 · `Get-DashHistoryItems` 23875 · `Update-DashHistory` 23903 · `Update-DashRecommendations` 23936 · `Show-BenchDiffModal` 24002 · **`Show-BenchDiffChart`** 24135 (239) · **`Get-BenchMetricToTweakMap`** 24380 (155) · `Show-BenchMetricGuide` 24536 · **`Show-BenchmarkPanel`** 24647 (313) · `Find-TweakByName` 24970 · `Get-ActivityLogEntries` 24987 · `Invoke-SingleActivityReverse` 25056 · **`Show-SystemSecurityDetail`** 25106 (202) · `Get-DnsServersToTest` 25315 · `Get-IspDns` 25332 · `Test-DnsServer` 25349 · `Set-PreferredDns` 25390 · `Test-PreferredDnsApplied` 25416 · **`Show-DnsBenchmark`** 25433 (286) · **`Show-NetworkQualityTest`** 25728 (379) · `Install-MrCleanZipMember` 26195 · `Install-MrCleanMicComponents` 26244 · `Get-MrCleanEndpointFormat` 26254 · `Get-MrCleanMicType` 26264 · `Get-MrCleanDfnChunk` 26272 · `Measure-MrCleanMicEnvironment` 26282 · `ConvertTo-MrCleanFloatChunk` 26301 · `Get-MrCleanMicChainLines` 26308 · `Write-MrCleanAudioLog` 26332 · `Get-MrCleanEapoInstallDir` 26336 · `Get-MrCleanEapoConfigDir` 26344 · `Initialize-MrCleanAudioNative` 26352 · `Get-MrCleanSpatialFormat` 26454 · `Get-MrCleanAudioDevices` 26469 · `Get-MrCleanAutoEqIndex` 26523 · `Find-MrCleanAutoEqMatch` 26545 · `Get-MrCleanAutoEqFilters` 26564 · `Get-MrCleanAudioCurve` 26590 · `Format-MrCleanEqFilter` 26627 · `Set-MrCleanFxValue` 26638 · `Install-MrCleanEapoDevice` 26645 · `Test-MrCleanApoClsid` 26713 · `Repair-MrCleanAudioEndpoints` 26726 · `Restart-MrCleanAudioService` 26755 · `Uninstall-MrCleanEapoDevice` 26761 · `Test-MrCleanEapoDevices` 26785 · `Install-MrCleanEapoPackage` 26803 · `Install-MrCleanClipOnly` 26846 · `Get-MrCleanAudioSettings` 26898 · `Get-MrCleanAudioDevicePref` 26919 · `Set-MrCleanAudioDevicePref` 26925 · `Test-MrCleanGhubPresent` 26935 · `Get-MrCleanAudioDevicePlan` 26940 · `Write-MrCleanAudioConfig` 26969 · `Register-MrCleanAudioModeTask` 27078 · `Unregister-MrCleanAudioModeTask` 27162 · `Invoke-MrCleanAudioSetup` 27168 · `Remove-MrCleanAudioAll` 27242 · `Invoke-MrCleanAudioMaintain` 27280 · `ConvertFrom-MrCleanEqLine` 27299 · `Measure-MrCleanEqPeak` 27310 · **`Show-AudioProfileTool`** 27336 (440) · `Get-SteamGames` 27786 · `Get-EpicGames` 27822 · `Get-EADesktopGames` 27840 · `Get-RiotGames` 27876 · `Get-BattleNetGames` 27895 · `Get-UbisoftGames` 27940 · `Get-GogGames` 27970 · `Get-AllDetectedGames` 27990 · `Get-MrCleanGameExes` 28012 · `Set-MrCleanGameGpuPreference` 28029 · `Remove-MrCleanGameGpuPreference` 28051 · `Get-DefenderExclusions` 28069 · `Add-DefenderExclusion` 28073 · `Remove-DefenderExclusion` 28078 · **`Show-DefenderExclusionManager`** 28085 (267) · **`Show-ActivityLog`** 28353 (342) · **`Show-TimerResolutionSettings`** 28700 (222) · **`Show-TimerResolutionTest`** 28924 (620) · **`Show-BloatwareManager`** 29546 (155) · **`Start-LargeFileScan`** 29703 (286)

### Region 14 — EVENT HANDLERS (Butonlar, Context Menus, Tab Selection) · satır 29998–32560 · 14 fonksiyon

`Get-DumpPath` 30485 · `New-Row` 30493 · `Get-Prop` 30498 · `Get-Raw` 30500 · `Set-CrashDisplay` 30845 · `Test-CrashVisible` 30858 · `Apply-CrashFilter` 30877 · `Update-CrashEmpty` 30894 · `Get-CrashCopyText` 30903 · `Update-CrashSelection` 30916 · `Ping-IP` 31336 · `Find` 31443 · `Find` 31507 · `Refresh-FileList` 32224

### Region 15 — PENCERE YASAM DONGUSU (Add_Closing, Add_Loaded, ShowDialog) · satır 32561–33072 · 1 fonksiyon

`Resume-MrCleanBoot` 32909

---

## 5. XAML PENCERELERİ

**Region 5 (genel):** `$xaml` 6368 ana pencere (tüm sayfalar) · `$xamlSettings` 8965 · `$xamlNightMode` 9104 · `$xamlCountdown` 9214 · `$xamlExport` 9234 · `$xamlWingetMgr` 9261 · `$xamlTweakMgr` 9309 · `$xamlPrivacyWarn` 9523 · `$xamlBlacklist` 9548 · `$xamlCustomMgr` 9571 · `$xamlFeedback` 9597 · `$xamlAddCustom` 9687 · `$xamlPathEdit` 9725.

**Fonksiyon içi:** geri yükleme noktası `$xamlRP` 14168 · AMD yonga seti 18053 · önerilen profiller 21126 · dışa / içe aktar `$xamlEx` 21520 / `$xamlIm` 21580 · Profil Yöneticisi 21688 · Winapp2 editörü `$xamlEdit` 22162 · program güncelleme `$xamlAU` 22542 · yeniden başlatma `$xamlRestart` 22787 · donanım `$xamlHW` 22859 · bench fark `$xamlD` 24005 / grafik `$xamlC` 24174 / rehber `$xamlG` 24537 / panel `$xamlB` 24648 · Sistem & Güvenlik `$xamlSS` 25108 · DNS `$xamlDns` 25479 · Ağ Testi `$xamlNq` 25729 · Otomatik Ses `$xamlAs` 27337 / okuma `$xamlRead` 27476 · Defender `$xamlDE` 28086 · Aktivite Log `$xamlAL` 28354 · Timer ayar `$xamlTRS` 28701 / test `$xamlTRT` 28940 · Bloatware `$xamlBloat` 29549 · açıklama editörü `$xamlDesc` 30359.

Alt pencereler `Initialize-SubWindow` ile ortak temayı (`$global:SubTheme`) alır. Ana `$xaml`'e dokunulursa `XamlReader.Parse` ile gerçekten yüklenip denenir (parse / AMSI XAML hatasını yakalamaz).

**Tweaks sekmesi satır hiyerarşisi (dokunmadan önce):** `TreeViewItem.Header = StackPanel(yatay) → CheckBox(.Content = dikey StackPanel → [yatay StackPanel{nokta, isim TextBlock Tag=TweakName, rozetler…}, özet TextBlock Tag=TweakSub])`. İsim okumak / yazmak için `Find-TweakNameBlock`.

---

## 6. TEMA ALANLARINA GÖRE "NEREDE?" (Grep anahtarları)

| Konu | Fonksiyon / anahtar |
|---|---|
| Tweak tespiti | `Get-Tweak-IsActive` (DetectScript → NetProfile → registry/servis/komut sezgileri), `Test-TweakApplied` |
| Uygula / doğrulama | `Apply-System-Tweaks`, `Show-ApplyConfirm`, `Show-ApplyOverlay`, `Complete-ApplyOverlay`, `Update-TweakStatusAfterApply`, `Get-MrCleanTweakDependents` |
| Güç planı | `Invoke-MrCleanPowerPlanFirst`, `Sync-MrCleanPlanBoundPower`, `Get/Backup/Restore-PowerSettingIndex` |
| Geri alma yedekleri | `Backup/Restore-TweakRegValue` (HKLM\SOFTWARE\MrClean\ValueBackup) |
| Servisler | `Set/Restore/Test-MrCleanServicesStart`, `Set-MrCleanSvcStartSc` (korumalı anahtar → sc.exe), `Get/Set-MrCleanSvcMode` |
| Zamanlanmış görevler | `Test-MrCleanTasksDisabled -Skip`, `Set-MrCleanTasksEnabled`, `Get-MrCleanTasksDenied` |
| Ağ / DNS / Wi-Fi | `Get-MrCleanPhysicalAdapters`, `Get-MrCleanNicFast`, `Restart-MrCleanNicsAndWait`, `Get-MrCleanDnsGuard`, `Test-MrCleanDnsBlocked`, `Set-MrCleanDnsPreset`, `Set/Restore/Test-MrCleanWifiProperty`, `Get-MrCleanVpnState` |
| Donanım uygunluğu | `Get-MrCleanHwProfile`, `Get-TweakHardwareReason` (`Requires`), `Test-TweakBuildCompatible` (`MinBuild`/`MaxBuild`), `Get-MrCleanHwWarnings` |
| Oyun | `Get-MrCleanGameExeNames`, `Install/Remove/Test-MrCleanGameCpuAgent` (görev MrClean-OyunIslemci), `Set/Remove/Test-MrCleanGamePriority` (IFEO), `Install/Remove/Test-MrCleanCs2Cpu0`, `Get-AllDetectedGames`, `Set-MrCleanGameGpuPreference` |
| NVIDIA | `Get-NvidiaInspectorPath` (v3.0.2.1 sabit + SHA256, ağ beklemeli yeniden deneme), `Invoke-NvidiaInspector`, `Backup-NvidiaProfiles`, `Test-NvidiaProfileApplied`, `Test-NvidiaTweakCurrent` / `Complete-NvidiaTweakCheck` (sürücü değişince doğrulama) |
| AMD | `Show-AmdChipsetRepair`, `Invoke-AmdChipsetRepair`, `Get-AmdDriverPlan`, `Test-IsAmdCpu`, `Confirm-DualCcdX3DPowerTweak` |
| Timer resolution | `Invoke-TimerResHelperSetup`, `Enable/Disable-MrCleanTimerResolution`, `Show-TimerResolutionSettings/Test` (görev MrClean-TimerRes) |
| Güncelleme sonrası denetim | `Start-MrCleanDriftCheck`, `Get-MrCleanEnvFingerprint`, `Set-MrCleanPendingReapply`, `Update-MrCleanAppliedList` |
| Emekli tweak'ler | `Get-RetiredTweakDefs`, `Invoke-RetiredTweakCleanup`, `$retiredOfficialTweaks`, `Convert-MrCleanAppliedAliases` (`Aliases`) |
| Yönetici başlatıcı | `Get/Enable/Disable-MrCleanAdminLauncher`, `Update-MrCleanAdminLauncherCopy` (kopya `C:\Program Files\MrClean\`) |
| Program güncelleme | `Test-AppUpdate` → `Show-AppUpdateWindow` → `Invoke-AppUpdate` (indir + SHA256 + `update_runner.ps1` takası), `Set-MrCleanAppUpdateButton` |
| Winapp2 güncelleme | `Get-Winapp2Local/OnlineVersion`, `Invoke-Winapp2Download`, `Get-Winapp2Diff`, `New-Winapp2DiffReport` (Ayarlar › Temizlik Veritabanı kartı) |
| Geri yükleme noktası | `Create-Restore-Point`, `Invoke-RestorePointAsync`, `Test-RestorePointWillAsk` |
| Gezgin yenileme | `Invoke-ShellSoftRefresh` (Soft), `Invoke-ExplorerHardRestart` (Hard) |
| Benchmark | `Get-BenchSnapshot`, `Test-*` metrikleri, `Test-GameLoad`, `Test-GpuFrameTime` (FurMark 2 + PresentMon), `Compare-BenchSnapshots`, `Show-BenchmarkPanel` |
| Otomatik Ses / mikrofon | `$global:MrCleanEapoConst` (26117), `$global:MrCleanMicConst` (26172), `Initialize-MrCleanAudioNative`, `Invoke-MrCleanAudioSetup` (worker), `Write-MrCleanAudioConfig`, `Register-MrCleanAudioModeTask` (görev "MrClean Ses Modu"), `Show-AudioProfileTool` — worker'a yeni yardımcı eklenirse `$runWorker` listesine de |
| Ağ Kalite Testi | `Show-NetworkQualityTest` (iç: `LoadTest`, `Probe`, `TcpRtt`), geçmiş HKCU\Software\MrClean NetTestHistory |
| Ortak pencereler | `Show-MrCleanMessage`, `Show-MrCleanInput`, `Initialize-SubWindow`, `Get-MrCleanMsgOwner` |

---

## 7. KALICI DURUM: KAYIT DEFTERİ, DOSYALAR, GÖREVLER

**HKCU\Software\MrClean:** `AppliedTweaks` (MultiString), `Env*` (sürüm sonrası denetim parmak izi), `AudioPreset` / `AudioAutoEq*`, `NetTestHistory`; alt anahtarlar `AppliedMarkers` (NvidiaProfileVer, NvidiaDriverVer, AmdProfileVer, TelemetryTasksDenied …), `Audio` (+ `\Devices\{guid}`), `SvcMode`, `GpuPrefAdded`.
**HKLM\SOFTWARE\MrClean (geri alma yedekleri):** `ValueBackup`, `PowerBackup`, `ServiceStartBackup`, `NicPowerBackup`, `AudioPowerBackup`, `DnsBackup`, `WifiBackup`, `GamePriorityBackup`, `GameInputStartBackup`, `VendorTelBackup`.
**%APPDATA%\MrClean:** `config\user_config.json`, `cache\` (tweak_status_cache.json 30 dk, app_cache.json, wg_upgrade.json), `database\Winapp2.ini`, `logs\` (session.log, tweak_history.log), `benchmarks\` (+ `tools\`), `nvidiaProfileInspector\`, `GameCpu\`, `Cs2Cpu0\`, `fonts\`, `update_runner.ps1`. Ses: `%LOCALAPPDATA%\MrClean\autoeq\` + EAPO config klasöründeki `MrClean-*.txt`.
**Zamanlanmış görevler:** `MrClean-App` (yönetici başlatıcı), `MrClean-OyunIslemci`, `MrClean-CS2Cpu0`, `MrClean-TimerRes`, `MrClean Ses Modu`.

---

## 8. 🌍 DİL / KÜLTÜR DUYARLI NOKTALAR

- **Çökme Analizi** (`btnScanCrashes` olayı, Region 14 ~30445–30940): tarama motoru olay özelliklerini ve `$L.cr_*` dil anahtarlarını kullanır (eski "Hatalı uygulama adı" metin ayrıştırması yok). Kalan tek metin eşleşmesi GPU TDR yedeği: `$e.Message -match 'yanıt vermeyi kesti|stopped responding'` (~30574; asıl koşul `Id -eq 4101`, FR'de yalnız bu yedek kaçar).
- **Türkçe-i tuzağı:** `.ToLower()` / `.ToUpper()` ve kültüre duyarlı `-match` (ör. "inspector" — Get-NvidiaInspectorPath bu yüzden dosya filtresi kullanır). Karşılaştırmada `ToLowerInvariant`; arama için `Normalize-SearchText`.
- **Doğru yapılmış:** DetectScript'ler, enum karşılaştırmaları, registry / CIM, `ParseExact(…, InvariantCulture)`, EAPO / AutoEq sayıları `InvariantCulture`.
- **i18n:** arayüz metinleri `T 'anahtar'` + `Localize-Xaml` (Region 3B); tweak Ad / Açıklama yalnız Türkçe.

---

## 9. İKİ AYRI GÜNCELLEME SİSTEMİ (karıştırma)

- **Program (EXE):** açılışta `Test-AppUpdate` (GitHub Releases, async) → `$global:UpdateAvailable` → sol menü "Program Güncelle" (`Set-MrCleanAppUpdateButton`) → `Show-AppUpdateWindow` → `Invoke-AppUpdate` (indir, `SHA256SUMS.txt` ile doğrula, `update_runner.ps1` ile dosya takası, yeniden başlat). Sürüm atlama: `Add-SkippedVersion`.
- **Winapp2 (temizlik veritabanı):** `Start-Winapp2-Process` açılışta yükler / denetler; güncelleme Ayarlar › Temizlik Veritabanı kartında (`Invoke-Winapp2Download`, fark raporu `New-Winapp2DiffReport` → `%APPDATA%\MrClean\winapp2_diff_<tarih>.txt`).

---

## 10. GEÇMİŞ

Eski sürüm notları (v1.2.29 – v1.3.0 turları, §57 raporu, §93–§106 ekleri) bu haritadan çıkarıldı; gerekçeler ve ayrıntı `DEGISIKLIKLER_v1.3.0.md` içinde `§NNN` ile aranır. Önceki harita: scratchpad `yedek73\KOD_HARITASI.md`.
