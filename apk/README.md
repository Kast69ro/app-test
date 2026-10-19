# ActivBank QR — POS-приложение для Sunmi

Стек: **Capacitor 6 → Android WebView** + один самодостаточный HTML-файл
(`apk/www/index.html`; React-рантайм, QR-энкодер и логотип вшиты внутрь, работает офлайн).
Android Studio не нужна — папку `android` генерирует CI.

Бэкенд: `http://10.64.20.101:8888`
`POST /pos/otp/request` → `POST /pos/otp/verify` (код 6 цифр, повтор через 60 с),
`GET /pos/terminal`, `GET /pos/summary?date=YYYY-MM-DD`, `GET /pos/history?limit=50&offset=0`.

Демо-режима нет: без доступного бэкенда вход невозможен.

## 1. Что положить в репозиторий

    .github/workflows/build-apk.yml
    apk/www/index.html            приложение (перезаливать при изменении дизайна)
    apk/package.json
    apk/capacitor.config.json
    apk/native/                   MainActivity.java, SunmiPrinter.java, SunmiPrinter.stub.java
    apk/libs/printerlibrary.aar   ОПЦИОНАЛЬНО — см. п.5
    assets/activbank-qr-app.png   логотип -> иконка приложения

Структура в архиве уже такая — распакуйте в корень репозитория как есть.

## 2. Ключ подписи (нужен, чтобы Sunmi приняли APK)

Нужна только Java:

    keytool -genkeypair -v -keystore release.keystore -alias activbank \
      -keyalg RSA -keysize 2048 -validity 10000
    base64 -i release.keystore | pbcopy

В GitHub → Settings → Secrets and variables → Actions → New repository secret:

    KEYSTORE_B64        (вставить из буфера)
    KEYSTORE_PASSWORD
    KEY_ALIAS           activbank
    KEY_PASSWORD

Ключ и пароли сохраните: все будущие обновления APK должны быть подписаны им же.
Без секретов собирается только `app-debug.apk` — этого достаточно для проверки
на своём терминале.

## 3. Получить APK

1. Push в `main` — либо **Actions → Build APK → Run workflow**.
2. ~5–8 мин (первый запуск дольше: качается Android SDK).
3. Открыть запуск → блок **Artifacts** → `activbank-qr-apk.zip`:
   * `app-debug.apk` — для проверки (`adb install -r app-debug.apk`);
   * `app-release.apk` — подписанный, его отправлять саппорту Sunmi.

## 4. Обновить приложение

Заменить `apk/www/index.html`, push → новый артефакт.

## 5. Печать на встроенном принтере

Библиотеки Sunmi нет в Maven Central, поэтому сборка устроена так:

* **нет `apk/libs/printerlibrary.aar`** → собирается заглушка печати.
  APK собирается зелёным, приложение работает, кнопка печати отвечает
  «Принтер не найден». В логе шага — warning.
* **есть `apk/libs/printerlibrary.aar`** → собирается настоящая печать
  (`apk/native/SunmiPrinter.java`, шапка/реквизиты/сумма/QR/подпись).

AAR берётся из Sunmi Developer Portal (Printer SDK for Android), кладётся
в `apk/libs/` под именем `printerlibrary.aar`. Больше ничего менять не нужно.

## 6. Sunmi-нюансы

* Манифест патчится в CI: `usesCleartextTraffic="true"` (бэкенд по http),
  портретная ориентация. Экран не гаснет — флаг выставляется в `MainActivity`.
* minSdk 22+ — покрывает P2 / P2 Pro / V2 на Android 7–11.
* Киоск-режим (запрет выхода из приложения) настраивается через Sunmi MDM,
  пересборка не нужна.

## 7. Если сборка упала

Откройте упавший шаг в логе. Частые причины и что уже учтено:

| Ошибка | Причина |
|---|---|
| `Unsupported class file major version 65` | JDK 21; workflow фиксирует JDK 17 |
| `Could not resolve com.sunmi:printerlibrary` | библиотеки нет в Maven Central; заменено на AAR из `apk/libs` |
| `Attribute android:keepScreenOn not found` | невалидный атрибут манифеста; перенесён в `MainActivity` |
| `convert: unable to open image` | нет `assets/activbank-qr-app.png`; теперь шаг только предупреждает |
| `No files were found ... if-no-files-found: error` | не собрался ни один APK — смотрите шаг Build debug APK |
