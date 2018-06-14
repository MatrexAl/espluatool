# ESPLuaTool
Программа для заливки LUA скриптов NodeMCU (https://en.wikipedia.org/wiki/NodeMCU) в микроконтроллер ESP8622 из командной строки. 

Разработана на FreePascal, IDE Lazarus (https://www.lazarus-ide.org/index.php?page=downloads).

Для компиляции и сборки требуется компонент Cportlaz_v1.0.0 (https://sourceforge.net/projects/cportlaz/). В случае возникновения ошибок компиляции в компоненте при установке в IDE - строки с ошибками необходимо закомментировать (изменить) по смыслу.

Разработано специально для использования совместно с notepad++ в качестве дополнения.

Для подключения к notepad++ воспользуйтесь следующей инструкцией:
- Скачайте последнюю версию notepad++ (https://notepad-plus-plus.org/download/).
- Скачайте дополнение NppExec к notepad++ (https://sourceforge.net/projects/npp-plugins/files/NppExec/).
- Установите дополнене NppExec, распаковав содержимое архива в папку "plugins" notepad++.
- Скачайте последнюю версию ESPLuaTool (https://github.com/MatrexAl/espluatool/archive/master.zip).
- Распакуйте ESPLuaTool в любую директорию.
- Запустите notepad++, запустите "Плагины -> NppExec -> Execute" (или нажмите F6).
- В открывшемся окне введите стоку запуска для прошивки микроконтроллера "d:\Lazarus\!project\espluatool\bin\espluatool.exe -p COM6 -b 9600 -wc $(FULL_CURRENT_PATH)" (без кавычек). Нажмите кнопку "Save..." и введите имя скрипта для сохранения, например "LUA Запись и компиляция". Подтвердите сохранение.
- Для запуска скрипта в notepad++ запустите "Плагины -> NppExec -> Execute" (или нажмите F6), выберите нужный скрипт, нажмите "Ок".

Используйте параметры командной строки:
- для прошивки микроконтроллера: espluatool.exe -p COM6 -b 9600 -w c:\init.lua
- для прошивки микроконтроллера, компиляции и запуска: espluatool.exe -p COM6 -b 9600 -wс c:\init.lua





01.07.2018 Головейко Александр, Брест, Беларусь
