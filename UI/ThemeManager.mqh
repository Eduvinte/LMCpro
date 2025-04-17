//+------------------------------------------------------------------+
//|                                               ThemeManager.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

#include "../Core/Globals.mqh"
#include "../Utils/ColorUtils.mqh"

//+------------------------------------------------------------------+
//| Clase para gestionar los temas del panel                          |
//+------------------------------------------------------------------+
class CThemeManager
{
private:
   bool              m_initialized;
   
public:
                     CThemeManager();
                    ~CThemeManager();
   bool              Initialize();
   void              ApplyTheme(bool darkTheme);
   void              ToggleTheme();
   bool              IsDarkTheme() { return g_dark_theme; }
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CThemeManager::CThemeManager()
{
   m_initialized = false;
}

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CThemeManager::~CThemeManager()
{
   // Nada que limpiar
}

//+------------------------------------------------------------------+
//| Inicializar                                                       |
//+------------------------------------------------------------------+
bool CThemeManager::Initialize()
{
   if(m_initialized)
      return true;
      
   // Aplicar tema inicial
   ApplyTheme(g_dark_theme);
   
   m_initialized = true;
   return true;
}

//+------------------------------------------------------------------+
//| Aplicar un tema específico                                        |
//+------------------------------------------------------------------+
void CThemeManager::ApplyTheme(bool darkTheme)
{
   // Actualizar el estado del tema
   g_dark_theme = darkTheme;
   
   // Actualizar los colores según el tema seleccionado
   if(g_dark_theme)
   {
      // Tema oscuro
      COLOR_BG_TITLE = COLOR_BG_TITLE_DARK;
      COLOR_BG_HEADER = COLOR_BG_HEADER_DARK;
      COLOR_BG_DROPDOWN = COLOR_BG_DROPDOWN_DARK;
      COLOR_ITEM_HOVER = COLOR_ITEM_HOVER_DARK;
      COLOR_TEXT = COLOR_TEXT_DARK;
      COLOR_BORDER = COLOR_BORDER_DARK;
      COLOR_BG_PANEL = COLOR_BG_PANEL_DARK;
   }
   else
   {
      // Tema claro
      COLOR_BG_TITLE = COLOR_BG_TITLE_LIGHT;
      COLOR_BG_HEADER = COLOR_BG_HEADER_LIGHT;
      COLOR_BG_DROPDOWN = COLOR_BG_DROPDOWN_LIGHT;
      COLOR_ITEM_HOVER = COLOR_ITEM_HOVER_LIGHT;
      COLOR_TEXT = COLOR_TEXT_LIGHT;
      COLOR_BORDER = COLOR_BORDER_LIGHT;
      COLOR_BG_PANEL = COLOR_BG_PANEL_LIGHT;
   }
   
   // Actualizar interfaces visuales que ya estén creadas
   UpdateInterfaceColors();
}

//+------------------------------------------------------------------+
//| Alternar entre temas claro y oscuro                               |
//+------------------------------------------------------------------+
void CThemeManager::ToggleTheme()
{
   // Cambiar el estado del tema
   bool newTheme = !g_dark_theme;
   
   // Aplicar el nuevo tema
   ApplyTheme(newTheme);
   
   // Si existe el botón de tema, actualizar su texto
   if(ObjectFind(0, g_theme_button) >= 0)
   {
      // Cambiar icono según el tema
      ObjectSetString(0, g_theme_button, OBJPROP_TEXT, g_dark_theme ? "☀" : "☾");
   }
   
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Actualiza los colores de toda la interfaz                         |
//+------------------------------------------------------------------+
void UpdateInterfaceColors()
{
   // Verificar si los objetos existen antes de actualizar
   
   // Actualizar panel principal
   if(ObjectFind(0, g_panel_name) >= 0)
      ObjectSetInteger(0, g_panel_name, OBJPROP_BGCOLOR, COLOR_BG_PANEL);
   
   // Actualizar panel de título
   if(ObjectFind(0, g_title_panel) >= 0)
      ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
   
   // Actualizar botones en la barra de título
   if(ObjectFind(0, g_theme_button) >= 0)
   {
      ObjectSetInteger(0, g_theme_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
      ObjectSetInteger(0, g_theme_button, OBJPROP_COLOR, COLOR_TEXT);
   }
   
   if(ObjectFind(0, g_expand_button) >= 0)
   {
      ObjectSetInteger(0, g_expand_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
      ObjectSetInteger(0, g_expand_button, OBJPROP_COLOR, COLOR_TEXT);
   }
   
   if(ObjectFind(0, g_close_button) >= 0)
   {
      ObjectSetInteger(0, g_close_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
      ObjectSetInteger(0, g_close_button, OBJPROP_COLOR, COLOR_TEXT);
   }
   
   // Botón de ayuda - si no está activo
   if(ObjectFind(0, g_help_button) >= 0 && !g_help_active)
   {
      ObjectSetInteger(0, g_help_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
      ObjectSetInteger(0, g_help_button, OBJPROP_COLOR, COLOR_TEXT);
   }
   
   // Actualizar selector de símbolos
   if(ObjectFind(0, g_header_panel) >= 0)
      ObjectSetInteger(0, g_header_panel, OBJPROP_BGCOLOR, COLOR_BG_HEADER);
      
   string nav_panel = g_panel_name + "_NavPanel";
   if(ObjectFind(0, nav_panel) >= 0)
      ObjectSetInteger(0, nav_panel, OBJPROP_BGCOLOR, COLOR_BG_HEADER);
   
   // Actualizar textos del selector
   if(ObjectFind(0, g_header_label) >= 0)
      ObjectSetInteger(0, g_header_label, OBJPROP_COLOR, COLOR_TEXT);
      
   if(ObjectFind(0, g_arrow_button) >= 0)
      ObjectSetInteger(0, g_arrow_button, OBJPROP_COLOR, COLOR_TEXT);
      
   if(ObjectFind(0, g_left_button) >= 0)
      ObjectSetInteger(0, g_left_button, OBJPROP_COLOR, COLOR_TEXT);
      
   if(ObjectFind(0, g_right_button) >= 0)
      ObjectSetInteger(0, g_right_button, OBJPROP_COLOR, COLOR_TEXT);
      
   if(ObjectFind(0, g_symbols_text) >= 0)
      ObjectSetInteger(0, g_symbols_text, OBJPROP_COLOR, COLOR_TEXT);
   
   // Si el dropdown está visible, actualizarlo también
   if(g_dropdown_visible && ObjectFind(0, g_dropdown_panel) >= 0)
   {
      ObjectSetInteger(0, g_dropdown_panel, OBJPROP_BGCOLOR, COLOR_BG_DROPDOWN);
      
      // Actualizar ítems del dropdown
      int total = ArraySize(g_symbols_list);
      for(int i = 0; i < g_max_dropdown_items; i++)
      {
         int symbol_idx = g_dropdown_start_idx + i;
         if(symbol_idx >= total) break;
         
         string item_panel = g_dropdown_panel + "_Item" + IntegerToString(i);
         if(ObjectFind(0, item_panel) >= 0)
         {
            ObjectSetInteger(0, item_panel, OBJPROP_BGCOLOR, 
                          symbol_idx == g_current_index ? COLOR_BG_HEADER : COLOR_BG_DROPDOWN);
            ObjectSetInteger(0, item_panel, OBJPROP_COLOR, COLOR_TEXT);
         }
      }
      
      // Actualizar indicadores de scroll
      string scroll_up = g_dropdown_panel + "_ScrollUp";
      if(ObjectFind(0, scroll_up) >= 0)
      {
         ObjectSetInteger(0, scroll_up, OBJPROP_BGCOLOR, COLOR_BG_DROPDOWN);
         ObjectSetInteger(0, scroll_up, OBJPROP_COLOR, COLOR_TEXT);
      }
      
      string scroll_down = g_dropdown_panel + "_ScrollDown";
      if(ObjectFind(0, scroll_down) >= 0)
      {
         ObjectSetInteger(0, scroll_down, OBJPROP_BGCOLOR, COLOR_BG_DROPDOWN);
         ObjectSetInteger(0, scroll_down, OBJPROP_COLOR, COLOR_TEXT);
      }
   }
   
   // Si hay un tooltip visible, actualizarlo
   if(g_tooltip_visible && g_tooltip_object != "" && ObjectFind(0, g_tooltip_object) >= 0)
   {
      color tooltipBg = g_dark_theme ? C'28,28,50' : C'240,240,250';
      color tooltipBorder = g_dark_theme ? C'40,40,80' : C'180,180,220';
      color tooltipText = g_dark_theme ? clrWhite : C'40,40,80';
      
      ObjectSetInteger(0, g_tooltip_object, OBJPROP_BGCOLOR, tooltipBg);
      ObjectSetInteger(0, g_tooltip_object, OBJPROP_BORDER_COLOR, tooltipBorder);
      
      // Actualizar todas las líneas de texto del tooltip
      string baseObjName = StringSubstr(g_tooltip_object, 0, StringLen(g_tooltip_object)-3); // Quitar "_BG"
      for(int i=0; i<10; i++) // Máximo razonable de líneas
      {
         string lineObj = baseObjName + "_Line" + IntegerToString(i);
         if(ObjectFind(0, lineObj) >= 0) // Si existe el objeto
            ObjectSetInteger(0, lineObj, OBJPROP_COLOR, tooltipText);
      }
   }
   
   // Actualizar botón de arrastre si no está en modo activo
   if(ObjectFind(0, g_drag_button) >= 0 && !g_drag_mode)
   {
      ObjectSetInteger(0, g_drag_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
      ObjectSetInteger(0, g_drag_button, OBJPROP_COLOR, COLOR_TEXT);
   }
} 