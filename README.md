# libdav1d-static

## 1. 目次

<!-- TOC depthFrom:2 -->

- [1. 目次](#1-目次)
- [2. 概要](#2-概要)
- [3. 動作環境](#3-動作環境)
- [4. 前提](#4-前提)
- [5. ライブラリの更新方法](#5-ライブラリの更新方法)
- [6. 旧 README の内容](#6-旧-readme-の内容)
    - [6.1. dav1d のアップデートをする方へ](#61-dav1d-のアップデートをする方へ)

<!-- /TOC -->

<br/>

## 2. 概要

dav1d を static リンクしたライブラリ

<br/>

## 3. 動作環境

* Xcode 14
* Xcode 15

<br/>

## 4. 前提

```bash
brew install meson nasm zip
```

<br/>

## 5. ライブラリの更新方法

1. submodule update をしておく

    ```bash
    git submodule update --init --recursive
    ```

2. `build-8bit.sh` を実行する

    ```bash
    bahs build-8bit.sh
    ```

3. `lipo.sh` を実行する。

   ```bash
   bash lipo.sh
   ```

4. すると、`artifacts` ディレクトリに `libdav1d.xcframework.zip` と `libdav1d.xcframework.zip.checksum` が出来上がっているので確認する

5. `Package.swift` の `binaryTarget` の `checksum` を `libdav1d.xcframework.zip.checksum` の内容に書き換えて comit & push する

6. `git tag` コマンドで新たなタグを付けて push する

7. GitHub 上で ↑ で指定したタグのリリース作業をする

8. リリース時に `artifacts` ディレクトリの中の `libdav1d.xcframework.zip` をブラウザからアップロードする

<br/><br/><br/>

## 6. 旧 README の内容

### 6.1. dav1d のアップデートをする方へ

SDK のバージョンを確認し、[constants.meson](./build/crossfiles/constants.meson) を編集してください

```
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs
```

と

```
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs
```

に SDK が置いてあります
