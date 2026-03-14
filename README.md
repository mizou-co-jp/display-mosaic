# DisplayMosaic

macOS のディスプレイ全体にモザイクをかけるメニューバー常駐アプリです。画面共有中のプライバシー保護や、離席時のスクリーン保護に使えます。

<img width="280" alt="settings" src="https://github.com/mizou-co-jp/display-mosaic/assets/screenshot.png">

## Features

- **メニューバー常駐** — ドックに表示されず、メニューバーから素早くアクセス
- **ワンクリックでモザイク** — ボタン一つで画面全体にモザイクを適用
- **Escape キーで解除** — キーボード一つで即座にモザイクを解除
- **3 種類のモザイクエフェクト**
  - ピクセレート（ドット風）
  - ぼかし（ガウスぼかし）
  - クリスタライズ（結晶風）
- **強度調整** — スライダーで 1〜100 の範囲でモザイクの強さを調整
- **設定の永続化** — モザイクの種類と強度は自動保存
- **マルチディスプレイ対応** — 接続された全てのディスプレイにモザイクを適用

## Requirements

- macOS 13.0 (Ventura) 以降
- 画面収録の許可（初回起動時にシステムが要求します）

## Install

### Homebrew

```bash
brew install mizou-co-jp/tap/display-mosaic
```

### Manual

1. [Releases](https://github.com/mizou-co-jp/display-mosaic/releases) から最新の `.app.zip` をダウンロード
2. 解凍して `DisplayMosaic.app` を `/Applications` に移動
3. アプリを起動

## Build from Source

```bash
git clone https://github.com/mizou-co-jp/display-mosaic.git
cd display-mosaic
xcodebuild -scheme DisplayMosaic -configuration Release build
```

ビルド成果物は `DerivedData` 内に出力されます。

## Usage

1. アプリを起動するとメニューバーにアイコンが表示されます
2. アイコンをクリックして設定ポップオーバーを開きます
3. モザイクの種類と強度を選択します
4. 「モザイクを有効にする」ボタンをクリックします
5. **Escape キー**を押すとモザイクが解除されます

## License

[MIT](LICENSE)
