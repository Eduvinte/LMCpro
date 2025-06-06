//+------------------------------------------------------------------+
//|                                              SymbolSelector.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

#include "../Core/Globals.mqh"
#include "ThemeManager.mqh"

//+------------------------------------------------------------------+
//| Clase para gestionar el selector de símbolos                      |
//+------------------------------------------------------------------+
class CSymbolSelector
{
private:
   CThemeManager*    m_themeManager;
   bool              m_initialized;
   
public:
                     CSymbolSelector(CThemeManager* themeManager);
                    ~CSymbolSelector();
   bool              Initialize(int x, int y, int width);
   void              UpdateSymbol(int direction);
   void              ToggleDropdown(bool show);
   void              ScrollDropdown(int direction);
   void              SelectSymbolFromDropdown(int item_index);
   void              DeleteDropdownObjects();
   void              UpdatePosition(int x, int y, int width);
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CSymbolSelector::CSymbolSelector(CThemeManager* themeManager)
{
   m_themeManager = themeManager;
   m_initialized = false;
}

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CSymbolSelector::~CSymbolSelector()
{
   // Limpiar dropdown si está visible
   if(g_dropdown_visible)
      DeleteDropdownObjects();
}

//+------------------------------------------------------------------+
//| Inicializar el selector de símbolos                               |
//+------------------------------------------------------------------+
bool CSymbolSelector::Initialize(int x, int y, int width)
{
   if(m_initialized)
      return true;
   
   // Asegurarnos de que g_selector_created está en false al iniciar
   g_selector_created = false;
   
   if(!CreateModernSymbolSelector(x, y, width))
   {
      Print("Error al crear el selector de símbolos");
      return false;
   }
   
   m_initialized = true;
   return true;
}

//+------------------------------------------------------------------+
//| Crear el selector de símbolos moderno                             |
//+------------------------------------------------------------------+
bool CreateModernSymbolSelector(int x, int y, int width)
{
   // Definir nombres de objetos
   g_header_panel = g_panel_name + "_SymbolHeaderPanel";
   g_header_label = g_panel_name + "_SymbolHeaderLabel";
   g_arrow_button = g_panel_name + "_SymbolArrowBtn";
   g_left_button = g_panel_name + "_SymbolLeftBtn";
   g_right_button = g_panel_name + "_SymbolRightBtn";
   g_symbols_text = g_panel_name + "_SymbolsText";
   g_dropdown_panel = g_panel_name + "_SymbolDropdownPanel";
   
   // Obtener lista de símbolos
   int total = SymbolsTotal(false);
   ArrayResize(g_symbols_list, total);
   
   for(int i = 0; i < total; i++)
   {
      g_symbols_list[i] = SymbolName(i, false);
      // Encontrar el índice del símbolo actual
      if(g_symbols_list[i] == g_current_symbol)
         g_current_index = i;
   }
   
   // Usar todo el ancho disponible
   g_selector_width = width;
   
   // Crear un panel único que ocupe todo el ancho
   if(!ObjectCreate(0, g_header_panel, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_header_panel, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_header_panel, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, g_header_panel, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, g_header_panel, OBJPROP_YSIZE, g_item_height);
   ObjectSetInteger(0, g_header_panel, OBJPROP_BGCOLOR, COLOR_BG_HEADER);
   ObjectSetInteger(0, g_header_panel, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetInteger(0, g_header_panel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   
   // Calcular distribución de elementos
   // 60% del ancho para el selector de símbolo a la izquierda
   int selector_area_width = (int)(width * 0.6);
   // 40% del ancho para los botones de navegación y texto a la derecha
   int buttons_area_width = width - selector_area_width;
   
   // Crear etiqueta para el símbolo actual - a la izquierda
   if(!ObjectCreate(0, g_header_label, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_header_label, OBJPROP_XDISTANCE, x + 10);
   ObjectSetInteger(0, g_header_label, OBJPROP_YDISTANCE, y + g_item_height/2);
   ObjectSetInteger(0, g_header_label, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetString(0, g_header_label, OBJPROP_TEXT, g_current_symbol);
   ObjectSetString(0, g_header_label, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_header_label, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, g_header_label, OBJPROP_ANCHOR, ANCHOR_LEFT);
   
   // Crear botón de flecha - al final del área del selector
   if(!ObjectCreate(0, g_arrow_button, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_arrow_button, OBJPROP_XDISTANCE, x + selector_area_width - 15);
   ObjectSetInteger(0, g_arrow_button, OBJPROP_YDISTANCE, y + g_item_height/2);
   ObjectSetInteger(0, g_arrow_button, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetString(0, g_arrow_button, OBJPROP_TEXT, "▼"); // Flecha hacia abajo
   ObjectSetString(0, g_arrow_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_arrow_button, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, g_arrow_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón de navegación izquierdo (<) - en el área de botones
   int button_x_start = x + selector_area_width + 5;
   
   if(!ObjectCreate(0, g_left_button, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_left_button, OBJPROP_XDISTANCE, button_x_start + 15);
   ObjectSetInteger(0, g_left_button, OBJPROP_YDISTANCE, y + g_item_height/2);
   ObjectSetInteger(0, g_left_button, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetString(0, g_left_button, OBJPROP_TEXT, "<");
   ObjectSetString(0, g_left_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_left_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_left_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón de navegación derecho (>) - justo a la derecha del botón izquierdo
   if(!ObjectCreate(0, g_right_button, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_right_button, OBJPROP_XDISTANCE, button_x_start + 40);
   ObjectSetInteger(0, g_right_button, OBJPROP_YDISTANCE, y + g_item_height/2);
   ObjectSetInteger(0, g_right_button, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetString(0, g_right_button, OBJPROP_TEXT, ">");
   ObjectSetString(0, g_right_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_right_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_right_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear texto "SYMBOLS" - al final del área de botones
   if(!ObjectCreate(0, g_symbols_text, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_symbols_text, OBJPROP_XDISTANCE, x + width - 40);
   ObjectSetInteger(0, g_symbols_text, OBJPROP_YDISTANCE, y + g_item_height/2);
   ObjectSetInteger(0, g_symbols_text, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetString(0, g_symbols_text, OBJPROP_TEXT, "SYMBOLS");
   ObjectSetString(0, g_symbols_text, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_symbols_text, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, g_symbols_text, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Indicar que el selector ha sido creado correctamente
   g_selector_created = true;
   
   return true;
}

//+------------------------------------------------------------------+
//| Función para actualizar el símbolo seleccionado                   |
//+------------------------------------------------------------------+
void CSymbolSelector::UpdateSymbol(int direction)
{
   // Cambiar el índice según la dirección
   int total = ArraySize(g_symbols_list);
   if(total <= 0) return;
   
   g_current_index += direction;
   
   // Mantener el índice dentro de los límites
   if(g_current_index < 0) 
      g_current_index = total - 1;
   if(g_current_index >= total) 
      g_current_index = 0;
   
   // Actualizar el símbolo actual
   g_current_symbol = g_symbols_list[g_current_index];
   
   // Actualizar el texto en el campo de edición
   ObjectSetString(0, g_header_label, OBJPROP_TEXT, g_current_symbol);
   
   // Cambiar el símbolo en el gráfico
   ChartSetSymbolPeriod(0, g_current_symbol, Period());
   
   // Forzar la actualización visual
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Función para mostrar/ocultar el dropdown                          |
//+------------------------------------------------------------------+
void CSymbolSelector::ToggleDropdown(bool show)
{
   // Si estamos mostrando el dropdown, creamos los elementos
   if(show && !g_dropdown_visible)
   {
      int x = (int)ObjectGetInteger(0, g_header_panel, OBJPROP_XDISTANCE);
      int y = (int)ObjectGetInteger(0, g_header_panel, OBJPROP_YDISTANCE) + g_item_height;
      
      // Calcular el ancho del dropdown para que sea solo la parte del selector (60% del ancho)
      int dropdown_width = (int)(g_selector_width * 0.6);
      
      // Crear el panel dropdown con el ancho reducido
      if(!ObjectCreate(0, g_dropdown_panel, OBJ_RECTANGLE_LABEL, 0, 0, 0))
         return;
         
      ObjectSetInteger(0, g_dropdown_panel, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, g_dropdown_panel, OBJPROP_YDISTANCE, y);
      ObjectSetInteger(0, g_dropdown_panel, OBJPROP_XSIZE, dropdown_width);
      ObjectSetInteger(0, g_dropdown_panel, OBJPROP_YSIZE, g_max_dropdown_items * g_item_height);
      ObjectSetInteger(0, g_dropdown_panel, OBJPROP_BGCOLOR, COLOR_BG_DROPDOWN);
      ObjectSetInteger(0, g_dropdown_panel, OBJPROP_BORDER_COLOR, COLOR_BORDER);
      ObjectSetInteger(0, g_dropdown_panel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      
      // Cambiar la flecha a apuntar hacia arriba
      ObjectSetString(0, g_arrow_button, OBJPROP_TEXT, "▲"); // Flecha hacia arriba
      
      // Ajustar la posición de inicio para mostrar el símbolo actual
      int total = ArraySize(g_symbols_list);
      g_dropdown_start_idx = MathMax(0, g_current_index - g_max_dropdown_items/2);
      if(g_dropdown_start_idx + g_max_dropdown_items > total)
         g_dropdown_start_idx = MathMax(0, total - g_max_dropdown_items);
      
      // Crear los elementos del dropdown
      for(int i = 0; i < g_max_dropdown_items; i++)
      {
         int symbol_idx = g_dropdown_start_idx + i;
         if(symbol_idx >= total) break;
         
         // Nombres de los objetos
         string item_panel = g_dropdown_panel + "_Item" + IntegerToString(i);
         
         // Crear panel de fondo para el item (botón para poder hacer clic)
         if(!ObjectCreate(0, item_panel, OBJ_BUTTON, 0, 0, 0))
            continue;
            
         ObjectSetInteger(0, item_panel, OBJPROP_XDISTANCE, x);
         ObjectSetInteger(0, item_panel, OBJPROP_YDISTANCE, y + i * g_item_height);
         ObjectSetInteger(0, item_panel, OBJPROP_XSIZE, dropdown_width);
         ObjectSetInteger(0, item_panel, OBJPROP_YSIZE, g_item_height);
         ObjectSetInteger(0, item_panel, OBJPROP_BGCOLOR, symbol_idx == g_current_index ? COLOR_BG_HEADER : COLOR_BG_DROPDOWN);
         ObjectSetInteger(0, item_panel, OBJPROP_COLOR, COLOR_TEXT);
         ObjectSetInteger(0, item_panel, OBJPROP_BORDER_COLOR, COLOR_BORDER);
         ObjectSetString(0, item_panel, OBJPROP_TEXT, g_symbols_list[symbol_idx]);
         ObjectSetString(0, item_panel, OBJPROP_FONT, "Arial");
         ObjectSetInteger(0, item_panel, OBJPROP_FONTSIZE, 10);
      }
      
      // Crear indicadores de scroll si es necesario
      if(total > g_max_dropdown_items)
      {
         string scroll_up_indicator = g_dropdown_panel + "_ScrollUp";
         string scroll_down_indicator = g_dropdown_panel + "_ScrollDown";
         
         // Indicador de scroll arriba
         if(!ObjectCreate(0, scroll_up_indicator, OBJ_BUTTON, 0, 0, 0))
            return;
            
         ObjectSetInteger(0, scroll_up_indicator, OBJPROP_XDISTANCE, x + dropdown_width - 20);
         ObjectSetInteger(0, scroll_up_indicator, OBJPROP_YDISTANCE, y + 2);
         ObjectSetInteger(0, scroll_up_indicator, OBJPROP_XSIZE, 18);
         ObjectSetInteger(0, scroll_up_indicator, OBJPROP_YSIZE, 18);
         ObjectSetInteger(0, scroll_up_indicator, OBJPROP_BGCOLOR, COLOR_BG_DROPDOWN);
         ObjectSetInteger(0, scroll_up_indicator, OBJPROP_COLOR, COLOR_TEXT);
         ObjectSetInteger(0, scroll_up_indicator, OBJPROP_BORDER_COLOR, COLOR_TEXT);
         ObjectSetString(0, scroll_up_indicator, OBJPROP_TEXT, "▲");
         ObjectSetString(0, scroll_up_indicator, OBJPROP_FONT, "Arial");
         ObjectSetInteger(0, scroll_up_indicator, OBJPROP_FONTSIZE, 8);
         
         // Indicador de scroll abajo
         if(!ObjectCreate(0, scroll_down_indicator, OBJ_BUTTON, 0, 0, 0))
            return;
            
         ObjectSetInteger(0, scroll_down_indicator, OBJPROP_XDISTANCE, x + dropdown_width - 20);
         ObjectSetInteger(0, scroll_down_indicator, OBJPROP_YDISTANCE, y + g_max_dropdown_items * g_item_height - 20);
         ObjectSetInteger(0, scroll_down_indicator, OBJPROP_XSIZE, 18);
         ObjectSetInteger(0, scroll_down_indicator, OBJPROP_YSIZE, 18);
         ObjectSetInteger(0, scroll_down_indicator, OBJPROP_BGCOLOR, COLOR_BG_DROPDOWN);
         ObjectSetInteger(0, scroll_down_indicator, OBJPROP_COLOR, COLOR_TEXT);
         ObjectSetInteger(0, scroll_down_indicator, OBJPROP_BORDER_COLOR, COLOR_TEXT);
         ObjectSetString(0, scroll_down_indicator, OBJPROP_TEXT, "▼");
         ObjectSetString(0, scroll_down_indicator, OBJPROP_FONT, "Arial");
         ObjectSetInteger(0, scroll_down_indicator, OBJPROP_FONTSIZE, 8);
      }
      
      g_dropdown_visible = true;
   }
   else if(!show && g_dropdown_visible)
   {
      // Cambiar la flecha a apuntar hacia abajo
      ObjectSetString(0, g_arrow_button, OBJPROP_TEXT, "▼"); // Flecha hacia abajo
      
      // Eliminar todos los objetos del dropdown
      DeleteDropdownObjects();
      
      g_dropdown_visible = false;
   }
   
   // Forzar la actualización visual
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Función para eliminar todos los objetos del dropdown              |
//+------------------------------------------------------------------+
void CSymbolSelector::DeleteDropdownObjects()
{
   // Eliminar el panel principal
   ObjectDelete(0, g_dropdown_panel);
   
   // Eliminar ítems del dropdown
   for(int i = 0; i < g_max_dropdown_items; i++)
   {
      string item_panel = g_dropdown_panel + "_Item" + IntegerToString(i);
      ObjectDelete(0, item_panel);
   }
   
   // Eliminar indicadores de scroll
   ObjectDelete(0, g_dropdown_panel + "_ScrollUp");
   ObjectDelete(0, g_dropdown_panel + "_ScrollDown");
}

//+------------------------------------------------------------------+
//| Función para desplazar la vista del dropdown                      |
//+------------------------------------------------------------------+
void CSymbolSelector::ScrollDropdown(int direction)
{
   int total = ArraySize(g_symbols_list);
   
   // Actualizar índice de inicio
   g_dropdown_start_idx += direction;
   
   // Mantener el índice dentro de los límites
   if(g_dropdown_start_idx < 0) 
      g_dropdown_start_idx = 0;
   if(g_dropdown_start_idx > total - g_max_dropdown_items) 
      g_dropdown_start_idx = MathMax(0, total - g_max_dropdown_items);
   
   // Actualizar todos los ítems del dropdown
   int x = (int)ObjectGetInteger(0, g_dropdown_panel, OBJPROP_XDISTANCE);
   int y = (int)ObjectGetInteger(0, g_dropdown_panel, OBJPROP_YDISTANCE);
   
   // Calcular el ancho del dropdown (60% del ancho total)
   int dropdown_width = (int)(g_selector_width * 0.6);
   
   for(int i = 0; i < g_max_dropdown_items; i++)
   {
      int symbol_idx = g_dropdown_start_idx + i;
      if(symbol_idx >= total) break;
      
      string item_panel = g_dropdown_panel + "_Item" + IntegerToString(i);
      
      // Actualizar el color de fondo (seleccionado o normal)
      ObjectSetInteger(0, item_panel, OBJPROP_BGCOLOR, symbol_idx == g_current_index ? COLOR_BG_HEADER : COLOR_BG_DROPDOWN);
      
      // Actualizar el texto
      ObjectSetString(0, item_panel, OBJPROP_TEXT, g_symbols_list[symbol_idx]);
   }
   
   // Forzar la actualización visual
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Función para seleccionar un símbolo del dropdown                  |
//+------------------------------------------------------------------+
void CSymbolSelector::SelectSymbolFromDropdown(int item_index)
{
   int symbol_idx = g_dropdown_start_idx + item_index;
   int total = ArraySize(g_symbols_list);
   
   if(symbol_idx >= 0 && symbol_idx < total)
   {
      g_current_index = symbol_idx;
      g_current_symbol = g_symbols_list[symbol_idx];
      
      // Actualizar el texto en el encabezado
      ObjectSetString(0, g_header_label, OBJPROP_TEXT, g_current_symbol);
      
      // Cambiar el símbolo en el gráfico
      ChartSetSymbolPeriod(0, g_current_symbol, Period());
      
      // Cerrar el dropdown
      ToggleDropdown(false);
   }
}

//+------------------------------------------------------------------+
//| Actualizar posición del selector de símbolos                      |
//+------------------------------------------------------------------+
void CSymbolSelector::UpdatePosition(int x, int y, int width)
{
   if(!g_selector_created)
      return;
      
   // Usar todo el ancho disponible
   g_selector_width = width;
   
   // Calcular distribución de elementos
   int selector_area_width = (int)(width * 0.6);
   int buttons_area_width = width - selector_area_width;
   int button_x_start = x + selector_area_width + 5;
   
   // Actualizar posición y tamaño del panel de encabezado
   ObjectSetInteger(0, g_header_panel, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_header_panel, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, g_header_panel, OBJPROP_XSIZE, width);
   
   // Actualizar posición del símbolo - a la izquierda
   ObjectSetInteger(0, g_header_label, OBJPROP_XDISTANCE, x + 10);
   ObjectSetInteger(0, g_header_label, OBJPROP_YDISTANCE, y + g_item_height/2);
   
   // Actualizar posición del botón de flecha
   ObjectSetInteger(0, g_arrow_button, OBJPROP_XDISTANCE, x + selector_area_width - 15);
   ObjectSetInteger(0, g_arrow_button, OBJPROP_YDISTANCE, y + g_item_height/2);
   
   // Actualizar posición de los botones de navegación
   ObjectSetInteger(0, g_left_button, OBJPROP_XDISTANCE, button_x_start + 15);
   ObjectSetInteger(0, g_left_button, OBJPROP_YDISTANCE, y + g_item_height/2);
   
   ObjectSetInteger(0, g_right_button, OBJPROP_XDISTANCE, button_x_start + 40);
   ObjectSetInteger(0, g_right_button, OBJPROP_YDISTANCE, y + g_item_height/2);
   
   // Actualizar posición del texto "SYMBOLS"
   ObjectSetInteger(0, g_symbols_text, OBJPROP_XDISTANCE, x + width - 40);
   ObjectSetInteger(0, g_symbols_text, OBJPROP_YDISTANCE, y + g_item_height/2);
} 