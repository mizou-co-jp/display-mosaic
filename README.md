# DisplayMosaic

[![GitHub stars](https://img.shields.io/github/stars/mizou-co-jp/display-mosaic?style=social)](https://github.com/mizou-co-jp/display-mosaic/stargazers)
[![GitHub downloads](https://img.shields.io/github/downloads/mizou-co-jp/display-mosaic/total)](https://github.com/mizou-co-jp/display-mosaic/releases)
[![GitHub release](https://img.shields.io/github/v/release/mizou-co-jp/display-mosaic)](https://github.com/mizou-co-jp/display-mosaic/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A macOS menu bar app that applies mosaic effects to your entire display. Useful for privacy protection during screen sharing or when stepping away from your desk.

## Features

- **Menu Bar Resident** — No dock icon, quick access from the menu bar
- **One-Click Mosaic** — Apply mosaic to the entire screen with a single button
- **Escape to Dismiss** — Instantly remove the mosaic with one key press
- **3 Mosaic Effects**
  - Pixellate (blocky / dot-style)
  - Gaussian Blur
  - Crystallize
- **Adjustable Intensity** — Slider from 1 to 100
- **Persistent Settings** — Mosaic type and intensity are saved automatically
- **Multi-Display Support** — Applies mosaic across all connected displays

## Requirements

- macOS 13.0 (Ventura) or later
- Screen Recording permission (the system will prompt on first launch)

## Install

### Homebrew

```bash
brew install mizou-co-jp/tap/display-mosaic
```

### Manual

1. Download the latest `.app.zip` from [Releases](https://github.com/mizou-co-jp/display-mosaic/releases)
2. Unzip and move `DisplayMosaic.app` to `/Applications`
3. Launch the app

## Build from Source

```bash
git clone https://github.com/mizou-co-jp/display-mosaic.git
cd display-mosaic
xcodebuild -scheme DisplayMosaic -configuration Release build
```

## Usage

1. Launch the app — an icon appears in the menu bar
2. Click the icon to open the settings popover
3. Select mosaic type and adjust intensity
4. Click "Enable Mosaic"
5. Press **Escape** to dismiss

---

## 日本語

macOS のディスプレイ全体にモザイクをかけるメニューバー常駐アプリです。画面共有中のプライバシー保護や、離席時のスクリーン保護に使えます。

### 機能

- **メニューバー常駐** — ドックに表示されず、メニューバーから素早くアクセス
- **ワンクリックでモザイク** — ボタン一つで画面全体にモザイクを適用
- **Escape キーで解除** — キーボード一つで即座にモザイクを解除
- **3 種類のモザイクエフェクト**
  - ピクセレート（ドット風）
  - ぼかし（ガウスぼかし）
  - クリスタライズ（結晶風）
- **強度調整** — スライダーで 1〜100 の範囲で調整
- **設定の永続化** — モザイクの種類と強度は自動保存
- **マルチディスプレイ対応** — 接続された全てのディスプレイにモザイクを適用

### 必要条件

- macOS 13.0 (Ventura) 以降
- 画面収録の許可（初回起動時にシステムが要求します）

### インストール

```bash
brew install mizou-co-jp/tap/display-mosaic
```

または [Releases](https://github.com/mizou-co-jp/display-mosaic/releases) から `.app.zip` をダウンロードしてください。

## License

[MIT](LICENSE)
