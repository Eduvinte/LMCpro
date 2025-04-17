//+------------------------------------------------------------------+
//|                                                    Constants.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

// Prefijo para variables globales de la aplicación
#define GLOBAL_VAR_PREFIX "LMCPro_"

// Prefijo para nombres de objetos gráficos
#define OBJECT_PREFIX "LMCPro_"

// Tamaños y dimensiones
#define DEFAULT_PANEL_WIDTH 350
#define DEFAULT_PANEL_HEIGHT 450
#define DEFAULT_PANEL_HEIGHT_COLLAPSED 40
#define DEFAULT_BUTTON_WIDTH 120
#define DEFAULT_BUTTON_HEIGHT 30
#define DEFAULT_LABEL_HEIGHT 20
#define DEFAULT_SPACING 5
#define DEFAULT_MARGIN 10

// Nombres de objetos GUI
#define MAIN_PANEL_NAME "LMCProMainPanel"
#define TITLE_LABEL_NAME "LMCProTitleLabel"
#define CLOSE_BUTTON_NAME "LMCProCloseButton"
#define MINIMIZE_BUTTON_NAME "LMCProMinimizeButton"
#define HELP_BUTTON_NAME "LMCProHelpButton"
#define THEME_BUTTON_NAME "LMCProThemeButton"
#define SYMBOL_SELECTOR_BUTTON_NAME "LMCProSymbolSelectorButton"

// Eventos personalizados
#define CHART_EVENT_CUSTOM_BASE 65536
#define CHART_EVENT_BUTTON_CLICKED (CHART_EVENT_CUSTOM_BASE + 1)
#define CHART_EVENT_THEME_CHANGED (CHART_EVENT_CUSTOM_BASE + 2)
#define CHART_EVENT_SYMBOL_SELECTED (CHART_EVENT_CUSTOM_BASE + 3)

// Constantes de colores
#define COLOR_BG_LIGHT C'240,240,240'
#define COLOR_BG_DARK C'40,40,40'
#define COLOR_TEXT_LIGHT C'20,20,20'
#define COLOR_TEXT_DARK C'220,220,220'
#define COLOR_BORDER_LIGHT C'180,180,180'
#define COLOR_BORDER_DARK C'70,70,70'
#define COLOR_BUTTON_BG_LIGHT C'220,220,220'
#define COLOR_BUTTON_BG_DARK C'60,60,60'
#define COLOR_BUTTON_TEXT_LIGHT C'20,20,20'
#define COLOR_BUTTON_TEXT_DARK C'220,220,220'
#define COLOR_TOOLTIP_BG_LIGHT C'255,255,220'
#define COLOR_TOOLTIP_BG_DARK C'70,70,50'
#define COLOR_ERROR_TEXT clrRed
#define COLOR_SUCCESS_TEXT clrGreen

// Límites del panel
#define MIN_PANEL_WIDTH 200
#define MIN_PANEL_HEIGHT 300

// Altura de panel expandido y colapsado
#define PANEL_HEIGHT_COLLAPSED 30
#define PANEL_HEIGHT_EXPANDED 400

// Configuración de botones
#define BUTTON_HEIGHT 24
#define BUTTON_SPACING 5
#define BUTTON_PADDING 10

// Colores para el tema claro
#define COLOR_BUTTON_LIGHT C'230,230,230'
#define COLOR_BUTTON_HOVER_LIGHT C'220,220,220'
#define COLOR_BUTTON_PRESS_LIGHT C'200,200,200'

// Colores para el tema oscuro
#define COLOR_BUTTON_DARK C'60,60,60'
#define COLOR_BUTTON_HOVER_DARK C'70,70,70'
#define COLOR_BUTTON_PRESS_DARK C'50,50,50'

// IDs para eventos personalizados
#define CHARTEVENT_CUSTOM_FIRST 65536
#define CHARTEVENT_BUTTON_CLICK (CHARTEVENT_CUSTOM_FIRST+1)
#define CHARTEVENT_PANEL_DRAG (CHARTEVENT_CUSTOM_FIRST+2)
#define CHARTEVENT_THEME_CHANGE (CHARTEVENT_CUSTOM_FIRST+3)
#define CHARTEVENT_SYMBOL_CHANGE (CHARTEVENT_CUSTOM_FIRST+4)
#define CHARTEVENT_HELP_TOGGLE (CHARTEVENT_CUSTOM_FIRST+5)

// Temporizador en milisegundos
#define TIMER_INTERVAL 100

// Colores personalizados para el estilo moderno
// Tema Oscuro
#define COLOR_BG_TITLE_DARK     C'59,82,159'   // Azul del título
#define COLOR_BG_HEADER_DARK    C'69,70,89,255'   // Azul para el header del selector
#define COLOR_BG_DROPDOWN_DARK  C'45,45,68'    // Azul oscuro para el dropdown
#define COLOR_ITEM_HOVER_DARK   C'70,70,94'    // Azul más claro para hover
#define COLOR_BG_PANEL_DARK     clrBlack       // Fondo del panel principal

// Tema Claro
#define COLOR_BG_TITLE_LIGHT     C'220,225,240'   // Azul claro del título
#define COLOR_BG_HEADER_LIGHT    C'220,225,240'   // Azul claro para el header del selector
#define COLOR_BG_DROPDOWN_LIGHT  C'245,245,250'   // Casi blanco para el dropdown
#define COLOR_ITEM_HOVER_LIGHT   C'200,210,240'   // Azul muy claro para hover
#define COLOR_BG_PANEL_LIGHT     clrWhite         // Fondo del panel principal blanco

// Constantes para la interfaz
#define TOOLTIP_AUTO_HIDE_MS 3000          // Milisegundos para ocultar automáticamente tooltip 