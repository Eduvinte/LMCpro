//+------------------------------------------------------------------+
//|                                                      Globals.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

// Incluir constantes
#include "Constants.mqh"

// Variables actuales de color (inicialmente oscuras)
color COLOR_BG_TITLE = COLOR_BG_TITLE_DARK;
color COLOR_BG_HEADER = COLOR_BG_HEADER_DARK;  
color COLOR_BG_DROPDOWN = COLOR_BG_DROPDOWN_DARK;
color COLOR_ITEM_HOVER = COLOR_ITEM_HOVER_DARK;
color COLOR_TEXT = COLOR_TEXT_DARK;
color COLOR_BORDER = COLOR_BORDER_DARK;
color COLOR_BG_PANEL = COLOR_BG_PANEL_DARK;

// Variables globales para el panel principal
string g_panel_name;       // Nombre del panel principal
string g_title_panel;      // Panel de título
string g_help_button;      // Botón de ayuda (?)
string g_theme_button;     // Botón de tema (sol)
string g_expand_button;    // Botón de expandir (^)
string g_close_button;     // Botón de cerrar (X)
string g_drag_button;      // Botón de arrastre

// Variables globales para el selector de símbolos
string g_current_symbol = Symbol();
string g_header_panel;     // Panel de encabezado
string g_header_label;     // Etiqueta del símbolo actual
string g_arrow_button;     // Botón de flecha
string g_left_button;      // Botón de navegación izquierda (<)
string g_right_button;     // Botón de navegación derecha (>)
string g_symbols_text;     // Texto "SYMBOLS"
string g_dropdown_panel;   // Panel del dropdown
string g_symbols_list[];   // Array para almacenar los símbolos disponibles
int g_current_index = 0;   // Índice del símbolo actual
bool g_dropdown_visible = false; // Estado del dropdown
int g_max_dropdown_items = 15;   // Máximo número de elementos visibles en el dropdown
int g_dropdown_start_idx = 0;    // Índice inicial para la visualización del dropdown
int g_item_height = 22;          // Altura de cada elemento en píxeles
int g_selector_width = 350;      // Ancho del selector de símbolos (usará el ancho total del panel)
bool g_selector_created = false; // Indica si el selector ha sido creado correctamente

// Variables para el sistema de tooltips
bool g_help_active = false;          // Estado del botón de ayuda
string g_current_tooltip = "";       // Tooltip actual mostrado
string g_tooltip_object = "";        // Objeto que muestra el tooltip
string g_tooltip_text = "";          // Texto del tooltip
int g_tooltip_timeout = 0;           // Contador para ocultar tooltip
int g_tooltip_appear_delay = 0;      // Contador para mostrar tooltip
string g_hover_element = "";         // Elemento sobre el que está el cursor
int g_mouse_x = 0;                   // Posición X del mouse
int g_mouse_y = 0;                   // Posición Y del mouse
bool g_tooltip_visible = false;      // Estado de visibilidad del tooltip
datetime g_tooltip_created_time = 0; // Tiempo de creación del tooltip

// Variable para controlar el tema actual
bool g_dark_theme = true;  // Inicialmente tema oscuro

// Variable para controlar si el panel está expandido
bool g_panel_expanded = true;  // Inicialmente expandido
int g_panel_height_expanded = 450;  // Altura cuando está expandido completamente
int g_panel_height_collapsed = 46;  // Altura mínima cuando está contraído (solo barra título + selector)

// Variables para arrastrar el panel
bool g_is_dragging = false;        // Estado de arrastre del panel
int g_drag_start_x = 0;            // Posición X inicial del mouse al arrastrar
int g_drag_start_y = 0;            // Posición Y inicial del mouse al arrastrar
int g_panel_start_x = 0;           // Posición X inicial del panel al arrastrar
int g_panel_start_y = 0;           // Posición Y inicial del panel al arrastrar
bool g_drag_visual_feedback = true; // Activar retroalimentación visual durante arrastre
bool g_drag_toggle_mode = true;     // Modo alternar para arrastre
bool g_last_mouse_state = false;    // Estado anterior del mouse
int g_drag_update_counter = 0;      // Contador para actualización visual
bool g_drag_mode_locked = false;    // Bloquea cambios de estado para evitar toggle accidental
bool g_drag_mode = false;           // Modo arrastre activado/desactivado
int g_drag_offset_x = 0;            // Offset X entre el mouse y la esquina del panel
int g_drag_offset_y = 0;            // Offset Y entre el mouse y la esquina del panel

// Variables para el panel de información
string g_info_panel;          // Panel de información principal
string g_spread_label;        // Etiqueta para "Spread:"
string g_spread_value;        // Valor del spread
int g_last_spread = 0;        // Último valor de spread conocido
bool g_info_panel_created = false; // Indica si ya creamos el panel de información
datetime g_last_spread_update = 0;  // Para controlar la actualización del spread
int g_spread_update_interval_ms = 250; // Actualizar cada 250ms

// Variables para el ATR
string g_atr_label;         // Etiqueta para "ATR:"
string g_atr_value;         // Valor del ATR
double g_last_atr = 0;      // Último valor del ATR conocido
int g_atr_period = 14;      // Período para el cálculo del ATR (estándar)
int g_atr_handle = INVALID_HANDLE; // Handle del indicador ATR

// Variable para el icono de engranaje
string g_gear_icon = "LMCproPanel_GearIcon";  // Nombre del objeto para el icono de engranaje

// Panel principal posición y dimensiones
int g_panelX = 0;
int g_panelY = 80;
int g_panelWidth = 350;
int g_panelHeight = 450;
int g_titleHeight = 24; // <<< AÑADIDA LA ALTURA DE LA BARRA DE TÍTULO

// Estado global de la aplicación
bool g_isInitialized = false;
bool g_isPanelVisible = true;
bool g_isDarkTheme = false;
bool g_isHelpVisible = false;
bool g_isSymbolSelectorVisible = false;

// Configuración del gráfico
string g_currentSymbol = "";
ENUM_TIMEFRAMES g_currentTimeframe = PERIOD_CURRENT;

// Propiedades gráficas
color g_bgColor = COLOR_BG_LIGHT;
color g_textColor = COLOR_TEXT_LIGHT;
color g_borderColor = COLOR_BORDER_LIGHT;
color g_buttonColor = COLOR_BUTTON_LIGHT;
color g_buttonHoverColor = COLOR_BUTTON_HOVER_LIGHT;
color g_buttonPressColor = COLOR_BUTTON_PRESS_LIGHT;

// Nombres de objetos para los elementos de UI principales
string g_mainPanelName = OBJECT_PREFIX + "MainPanel";
string g_titleLabelName = OBJECT_PREFIX + "TitleLabel";
string g_symbolSelectorName = OBJECT_PREFIX + "SymbolSelector";
string g_themeToggleName = OBJECT_PREFIX + "ThemeToggle";
string g_helpButtonName = OBJECT_PREFIX + "HelpButton";
string g_collapseButtonName = OBJECT_PREFIX + "CollapseButton";

// Estado de errores
bool g_hasError = false;
string g_lastErrorMessage = "";

// Variables para el panel de configuración
string g_settings_panel = "Settings_Panel";       // Nombre del panel de configuración
string g_settings_title = "Settings_Title";       // Barra de título del panel de configuración
bool g_settings_visible = false;                  // Visibilidad del panel de configuración
int g_settings_x = 0;                             // Posición X del panel de configuración
int g_settings_y = 0;                             // Posición Y del panel de configuración
int g_settings_width = 250;                       // Ancho del panel de configuración
int g_settings_height = 350;                      // Altura del panel de configuración
color g_settings_bg_color = C'45,45,68';          // Color de fondo del panel
color g_settings_title_color = C'77,118,201';     // Color de la barra de título

//+------------------------------------------------------------------+
//| Función para actualizar colores según el tema                    |
//+------------------------------------------------------------------+
void UpdateThemeColors()
{
    if(g_isDarkTheme)
    {
        g_bgColor = COLOR_BG_DARK;
        g_textColor = COLOR_TEXT_DARK;
        g_borderColor = COLOR_BORDER_DARK;
        g_buttonColor = COLOR_BUTTON_DARK;
        g_buttonHoverColor = COLOR_BUTTON_HOVER_DARK;
        g_buttonPressColor = COLOR_BUTTON_PRESS_DARK;
    }
    else
    {
        g_bgColor = COLOR_BG_LIGHT;
        g_textColor = COLOR_TEXT_LIGHT;
        g_borderColor = COLOR_BORDER_LIGHT;
        g_buttonColor = COLOR_BUTTON_LIGHT;
        g_buttonHoverColor = COLOR_BUTTON_HOVER_LIGHT;
        g_buttonPressColor = COLOR_BUTTON_PRESS_LIGHT;
    }
} 