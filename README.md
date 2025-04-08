<img src="https://i.postimg.cc/K8ZcLZQz/AZGif3.gif" alt="" align="center" width="500" height="auto">
## Scriptonitus V10 Update
<p align="center"><a href="#project-description">Project Description</a> - <a href="#key-features">Key Features</a> - <a href="#technology-stack">Tech Stack</a></p>

<img src="https://i.postimg.cc/d0fJzGFk/AZGif-Install1.gif" alt="" align="center" width="200" height="auto">

## Project Description

# Scriptonitus - Помощник Автоматизированной Настройки Windows

Это набор VBScript и PowerShell скриптов, предназначенный для автоматизации процесса настройки, конфигурации и обновления окружения Windows. Он ориентирован на сценарии развертывания или первичной настройки рабочих станций.

## Основные Возможности

*   **Автоматическая Установка ПО:** Устанавливает и настраивает Zscaler, Microsoft Office по желанию (включая языковой пакет RU), Barco ClickShare, Zoom и специфичные драйверы Lenovo (Hotkey Features Integration).
*   **Конфигурация Системы:**
    *   Устанавливает системную локаль, язык интерфейса и языки ввода (ru-RU, en-US).
    *   Устанавливает часовой пояс (Russian Standard Time).
    *   Стандартизирует имя компьютера по шаблону `AZAPXL<СерийныйНомер>`.
    *   Включает отображение значка "Этот компьютер".
*   **Проверка Состояния Оборудования:**
    *   Определяет температуру процессора.
    *   Генерирует отчет о состоянии батареи и вычисляет процент "здоровья".
    *   Проверяет состояние диска с использованием CrystalDiskInfo (если доступен).
*   **Самообновление:** Проверяет наличие обновлений для себя и дополнительных компонентов в репозиториях GitHub и применяет их.
*   **Интерактивность:**
    *   Отображает анимированные индикаторы загрузки (`Loading.exe`, `AZGifUp.exe`, `AZGifIn.exe`).
    *   Показывает информационное окно с состоянием оборудования (CPU, Батарея, Диск) и кнопками действий ("Update Windows", "Okay", "Cancel").
    *   Предлагает пользователю проверить Камеру, Звук и Микрофон через соответствующие системные приложения.
    *   Запрашивает подтверждение перед возможным выключением компьютера.

## Как это работает (Обзор)

1.  **Инициация (VBS):** Запуск начинается с VBScript (`Scriptonitus.vbs`). Он показывает анимацию, копирует рабочую папку `OS11` в `C:\TempProfile`, завершает старые процессы `START.exe` и запускает `START.exe` из `C:\TempProfile`. Также динамически создает скрипт `Update.ps1`.
2.  **Обновление (`Update.ps1`):** Этот PowerShell скрипт (запускаемый, вероятно, через `START.exe`) проверяет интернет, скачивает обновления с GitHub для основного скрипта и компонентов, обновляет файлы на USB-накопителях в папке `GenScriptus_V10`.
3.  **Основная Логика (PowerShell):** Следующий этап (вероятно, запускаемый `START.exe` или скрипт `General.exe`) выполняет основную массу задач:
    *   Запускает скрипт обновления (`Update.ps1`).
    *   Проводит проверки оборудования (CPU, Батарея, Диск).
    *   Отображает GUI с информацией и опциями (включая запуск Windows Update).
    *   Устанавливает недостающее ПО (ClickShare, Zoom, Office Lang Pack и т.д.).
    *   Применяет системные настройки (язык, локаль, имя ПК).
    *   Предлагает проверить устройства (камера, звук, микрофон).
    *   Генерирует и отправляет отчет на GitHub (через динамически создаваемый `SendGH.ps1`).
    *   Показывает финальное окно со статусом и запросом на выключение.
4.  **Завершение:** Скрипт ожидает сигнала от `General.exe` (через файл `2PRT.txt`), проводит очистку временных папок и, если пользователь согласился, выключает компьютер (через проверку файла `Off.txt`).
5.

## Использование

1.  Разместите скрипт и папку `OS11` в корневой директории (например, на USB-накопителе).
2.  Убедитесь, что необходимые исполняемые файлы (CrystalDiskInfo, инсталляторы ПО) находятся в правильных подпапках внутри `OS11`.
3.  Запустите основной VBScript (`Scriptonitus.vbs`)
4.  Следуйте инструкциям на экране

## Key Components

*   ОС Windows (10/11) с правами Администратора.
*   PowerShell (рекомендуется v5.1 или новее).
*   Подключение к Интернету (для обновлений).
*   Начальная структура папок (папка `OS11` рядом с запускающим VBS).
*   CrystalDiskInfo (`DiskInfo64.exe`) в `C:\TempProfile\OS1\APP\CD` для проверки диска.

## Key Features

## Tech Stack

<img src="https://i.postimg.cc/ncWpPvGy/1.jpg" alt="">

<img src="https://i.postimg.cc/05WszpFz/2.jpg" alt="">

<img src="https://i.postimg.cc/s2rFkKQN/3.jpg" alt="">

<img src="https://i.postimg.cc/WbNwHZ1w/41.jpg" alt=""> 
<img src="https://i.postimg.cc/mD4HFxcy/42.jpg" alt="">
