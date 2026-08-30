# STARDY - Star Space Runner

**Flutter** ve **Flame Game Engine** kullanılarak geliştirilmiş 2D sonsuz koşu (endless runner) oyunudur.

---

## 🚀 Özellikler & Oyun Mekanikleri

- **Flame Component System (FCS):** Oyuncu (`Player`), engeller (`Obstacle`), arkaplan parallax efekti ve spawn mekanizmaları modüler bileşen mimarisiyle ayrılmıştır.
- **Karakter Kontrolü:** Ekrana dokunma ve sürükleme (`DragCallbacks`) ile akıcı roket hareketi.
- **Çarpışma Tespiti (Collision Detection):** Flame'in yerleşik `Hitbox` ve `HasCollisionDetection` mekanizmalarıyla optimize edilmiş çarpışma algılama.
- **Dinamik Zorluk Seviyesi:** Hayatta kalınan süreye bağlı olarak engellerin hızının ve çıkış sıklığının kademeli olarak artması.
- **State Management (Provider):** Oyun dışı UI durumları, ses/ayarlar ve en yüksek skor (High Score) yönetimi.
- **Asset Preload:** Bellek sızıntılarını ve takılmaları önlemek adına görsel varlıkların oyun öncesi önbelleğe alınması (`images.loadAll`).
- **Cyberpunk / Retro HUD:** Özel neon arayüzler (Main Menu, HUD, Pause ve Game Over ekranları).

---

## 🛠️ Kullanılan Teknolojiler & Paketler

- **Flutter SDK:** ^3.6.0
- **Flame Engine:** ^1.30.1
- **State Management:** Provider
- **İkon & Araçlar:** flutter_launcher_icons

---

## 📁 Proje Dizin Yapısı

```text
lib/
├── game/
│   ├── components/
│   │   ├── obstacle.dart
│   │   ├── obstacle_spawner.dart
│   │   └── player.dart
│   └── stardy_game.dart
├── state/
│   └── game_state_provider.dart
├── ui/
│   ├── game_hud.dart
│   ├── game_over_overlay.dart
│   ├── main_menu.dart
│   └── pause_overlay.dart
└── main.dart