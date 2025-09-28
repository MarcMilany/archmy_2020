############# Справка Fastfetch ##############

Fastfetch
https://github.com/fastfetch-cli/fastfetch

Fastfetch Configuration
https://github.com/fastfetch-cli/fastfetch/wiki/Configuration

Глубокое погружение с Fastfetch: альтернатива Neofetch
https://itsfoss.com/fine-control-fastfetch/

Как использовать команду fastfetch (с примерами)
https://commandmasters.com/commands/fastfetch-common/

####################################

Конфигурация
Картер Ли отредактировал эту страницу29 мая · 16 редакций
В этом документе содержится подробное руководство по настройке Fastfetch в соответствии с вашими потребностями.

Базовая конфигурация
Fastfetch использует JSONC (JSON с комментариями) для настройки. Файл конфигурации по умолчанию находится здесь:~/.config/fastfetch/config.jsonc

Вы можете создать файл конфигурации по умолчанию, используя:

fastfetch --gen-config
Настоятельно рекомендуется использовать редактор с поддержкой JSON-схем. Если вы не уверены, рекомендую использовать vscode .

Структура конфигурации
Файл конфигурации состоит из следующих основных разделов:

{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json", // Optional: Provides IDE intelligence
    "logo": { /* Logo configuration */ },
    "display": { /* Display settings */ },
    "modules": [ /* Modules to display */ ]
}
Конфигурация логотипа
Настройте внешний вид логотипа:

"logo": {
    "type": "auto",        // Logo type: auto, builtin, small, file, etc.
    "source": "arch",      // Built-in logo name or file path
    "width": 65,           // Width in characters (for image logos)
    "height": 35,          // Height in characters (for image logos)
    "padding": {
        "top": 0,          // Top padding
        "left": 0,         // Left padding
        "right": 2         // Right padding
    },
    "color": {             // Override logo colors
        "1": "blue",
        "2": "green"
    }
}
Конфигурация дисплея
Управление отображением информации:

"display": {
    "separator": ": ",     // Separator between keys and values
    "color": {
        "keys": "blue",    // Key color
        "title": "red"     // Title color
    },
    "key": {
        "width": 12,       // Aligns keys to this width
        "type": "string"   // string, icon, both, or none
    },
    "bar": {
        "width": 10,       // Width of percentage bars
        "charElapsed": "¦", // Character for elapsed portion
        "charTotal": "-"   // Character for total portion
    },
    "percent": {
        "type": 9,         // 1=number, 2=bar, 3=both, 9=colored number
        "color": {
            "green": "green",
            "yellow": "light_yellow",
            "red": "light_red"
        }
    }
}
Конфигурация модуля
Укажите, какие модули отображать и их конфигурацию:

"modules": [
    "title",
    "separator",
    {
        "type": "os",
        "key": "OS",
        "keyColor": "blue",
        "format": "{name} {version}"
    },
    {
        "type": "kernel",
        "key": "Kernel"
    },
    {
        "type": "memory",
        "key": "Memory",
        "percent": {
            "type": 3,     // Show both percentage number and bar
            "green": 30,   // Values below 30% in green
            "yellow": 70   // 30-70% in yellow, >70% in red
        }
    }
]
Форматировать строки
Многие модули поддерживают пользовательские форматы строк. Например:

{
    "type": "cpu",
    "format": "{name} ({cores-physical}C/{cores-logical}T) @ {freq-max}"
}
Используйте fastfetch -h <module>-formatдля просмотра доступных вариантов форматирования для каждого модуля.

Советы по лучшей настройке
Начните с предустановки : используйте ее fastfetch --config examples/X, чтобы начать с минимальной конфигурации и затем продолжить ее.

Использовать схему JSON : добавление $schemaстроки включает автодополнение кода и проверку в редакторах, таких как VSCode.

Тестирование отдельных модулей : используйте командную строку для тестирования определенных конфигураций перед добавлением их в файл.

fastfetch --structure memory --memory-percent-type 3
Общие улучшения отображения :

Установите одинаковую ширину ключа:"key": { "width": 12 }
Используйте яркие цвета:"brightColor": true
Отрегулируйте отступ логотипа для лучшего выравнивания:"padding": { "left": 4 }
Документация
См.: https://gitlab.com/CarterLi/fastfetch/-/wikis/Json-Schema ( ссылка Gitlab используется из-за ограничений Github Wiki )

Сгенерировано с использованием json-schema-for-humans с

generate-schema-doc ~/fastfetch/doc/json_schema.json --config template_name=md Json-Schema.md
Также обратитесь к fastfetch --helpдля более подробного объяснения.

Примеры
*.jsoncв https://github.com/fastfetch-cli/fastfetch/tree/dev/presets/examples

Вы можете проверить это с помощьюfastfetch --config examples/x.jsonc

Примечания
Смешивание флагов командной строки с вариантами config.jsonc«может/не может» работает. Как правило, флаги параметров командной строки модуля не работают, если config.jsonc«не работает». Другие флаги должны работать.
Специальные символы должны быть закодированы как \uXXXXв JSON. В частности, \eили \033должны быть \u001b.

