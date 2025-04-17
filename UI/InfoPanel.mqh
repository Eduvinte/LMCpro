//+------------------------------------------------------------------+
//|                                                   InfoPanel.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

#include "../Core/Globals.mqh"
#include "ThemeManager.mqh"

//+------------------------------------------------------------------+
//| Clase para gestionar el panel de información                      |
//+------------------------------------------------------------------+
class CInfoPanel
{
private:
   CThemeManager*    m_themeManager;
   bool              m_initialized;
   
public:
                     CInfoPanel(CThemeManager* themeManager);
                    ~CInfoPanel();
   bool              Initialize(int x, int y, int width, int height);
   bool              CreateInfoPanel(int x, int y, int width);
   void              UpdateSpread(int spread);
   void              UpdateATR(double atr);
   void              UpdatePosition(int x, int y, int width);
   void              InitializeATR();
   void              CreateGearIcon();
   void              UpdateGearIconPosition();
   void              CreateGearIconCentered(int center_x, int center_y);
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CInfoPanel::CInfoPanel(CThemeManager* themeManager)
{
   m_themeManager = themeManager;
   m_initialized = false;
}

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CInfoPanel::~CInfoPanel()
{
   // Nada que limpiar específicamente
}

//+------------------------------------------------------------------+
//| Inicializar el panel de información                               |
//+------------------------------------------------------------------+
bool CInfoPanel::Initialize(int x, int y, int width, int height)
{
   if(m_initialized)
      return true;
   
   if(!CreateInfoPanel(x, y, width))
   {
      Print("Error al crear el panel de información");
      return false;
   }
   
   // Inicializar el indicador ATR
   InitializeATR();
   
   // Actualizar valores inmediatamente
   UpdateSpread(0);
   UpdateATR(0);
   
   m_initialized = true;
   return true;
}

//+------------------------------------------------------------------+
//| Función para crear el panel de información                        |
//+------------------------------------------------------------------+
bool CInfoPanel::CreateInfoPanel(int x, int y, int width)
{
   // Si ya existe, no recrear
   if(g_info_panel_created)
      return true;
      
   // Definir nombres de objetos
   g_info_panel = g_panel_name + "_InfoPanel";
   g_spread_label = g_panel_name + "_SpreadLabel";
   g_spread_value = g_panel_name + "_SpreadValue";
   g_atr_label = g_panel_name + "_ATRLabel";
   g_atr_value = g_panel_name + "_ATRValue";
   
   // Mantener la altura actual
   int info_height = 36;
   
   // Crear el panel de fondo (negro)
   if(!ObjectCreate(0, g_info_panel, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_info_panel, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_info_panel, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, g_info_panel, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, g_info_panel, OBJPROP_YSIZE, info_height);
   ObjectSetInteger(0, g_info_panel, OBJPROP_BGCOLOR, COLOR_BG_PANEL);
   ObjectSetInteger(0, g_info_panel, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetInteger(0, g_info_panel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, g_info_panel, OBJPROP_ZORDER, 1);
   
   // Ajustar el posicionamiento vertical
   int text_y = y + info_height/2; // Mitad de la altura
   
   // 1. SPREAD - Alineado a la izquierda
   int spread_x = x + 15;
   
   if(!ObjectCreate(0, g_spread_label, OBJ_LABEL, 0, 0, 0))
      return false;
   
   ObjectSetInteger(0, g_spread_label, OBJPROP_XDISTANCE, spread_x);
   ObjectSetInteger(0, g_spread_label, OBJPROP_YDISTANCE, text_y);
   ObjectSetInteger(0, g_spread_label, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetString(0, g_spread_label, OBJPROP_TEXT, "Spread:");
   ObjectSetString(0, g_spread_label, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_spread_label, OBJPROP_FONTSIZE, 9);
   ObjectSetInteger(0, g_spread_label, OBJPROP_ANCHOR, ANCHOR_LEFT);
   
   if(!ObjectCreate(0, g_spread_value, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_spread_value, OBJPROP_XDISTANCE, spread_x + 50);
   ObjectSetInteger(0, g_spread_value, OBJPROP_YDISTANCE, text_y);
   ObjectSetInteger(0, g_spread_value, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetString(0, g_spread_value, OBJPROP_TEXT, "0");
   ObjectSetString(0, g_spread_value, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_spread_value, OBJPROP_FONTSIZE, 9);
   ObjectSetInteger(0, g_spread_value, OBJPROP_ANCHOR, ANCHOR_LEFT);
   
   // 2. ATR - Centrado en el panel
   int atr_x = x + width/2 - 20;
   
   if(!ObjectCreate(0, g_atr_label, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_atr_label, OBJPROP_XDISTANCE, atr_x);
   ObjectSetInteger(0, g_atr_label, OBJPROP_YDISTANCE, text_y);
   ObjectSetInteger(0, g_atr_label, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetString(0, g_atr_label, OBJPROP_TEXT, "ATR:");
   ObjectSetString(0, g_atr_label, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_atr_label, OBJPROP_FONTSIZE, 9);
   ObjectSetInteger(0, g_atr_label, OBJPROP_ANCHOR, ANCHOR_LEFT);
   
   if(!ObjectCreate(0, g_atr_value, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_atr_value, OBJPROP_XDISTANCE, atr_x + 30);
   ObjectSetInteger(0, g_atr_value, OBJPROP_YDISTANCE, text_y);
   ObjectSetInteger(0, g_atr_value, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetString(0, g_atr_value, OBJPROP_TEXT, "0");
   ObjectSetString(0, g_atr_value, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_atr_value, OBJPROP_FONTSIZE, 9);
   ObjectSetInteger(0, g_atr_value, OBJPROP_ANCHOR, ANCHOR_LEFT);
   
   // 3. El engranaje a la misma altura
   int gear_x = x + width - 30;
   int gear_y = text_y;
   
   // Crear el icono del engranaje
   CreateGearIconCentered(gear_x, gear_y);
   
   g_info_panel_created = true;
   return true;
}

//+------------------------------------------------------------------+
//| Actualizar el valor del spread                                    |
//+------------------------------------------------------------------+
void CInfoPanel::UpdateSpread(int spread)
{
   if(!g_info_panel_created || spread < 0)
      return;
      
   // Verificar si el valor ha cambiado
   if(spread != g_last_spread || spread == 0)
   {
      g_last_spread = spread;
      ObjectSetString(0, g_spread_value, OBJPROP_TEXT, IntegerToString(spread));
   }
}

//+------------------------------------------------------------------+
//| Actualizar el valor del ATR                                       |
//+------------------------------------------------------------------+
void CInfoPanel::UpdateATR(double atr)
{
   if(!g_info_panel_created)
      return;
      
   // Si el ATR ha cambiado significativamente, actualizar el valor
   if(MathAbs(atr - g_last_atr) > 0.0001 || atr == 0)
   {
      g_last_atr = atr;
      
      string atr_text = "";
      
      // Reglas para formato más limpio:
      if(atr < 0.01)
         atr_text = DoubleToString(atr, 4); // Valores muy pequeños: 4 decimales
      else if(atr < 1.0)
         atr_text = DoubleToString(atr, 3); // Valores pequeños: 3 decimales
      else if(atr < 10.0)
         atr_text = DoubleToString(atr, 2); // Valores normales: 2 decimales
      else if(atr < 100.0)
         atr_text = DoubleToString(atr, 1); // Valores grandes: 1 decimal
      else
         atr_text = DoubleToString(atr, 0); // Valores muy grandes: sin decimales
      
      // Actualizar el texto del ATR
      ObjectSetString(0, g_atr_value, OBJPROP_TEXT, atr_text);
   }
}

//+------------------------------------------------------------------+
//| Actualizar la posición del panel de información                   |
//+------------------------------------------------------------------+
void CInfoPanel::UpdatePosition(int x, int y, int width)
{
   if(!g_info_panel_created)
      return;
   
   // Actualizar posición del panel
   ObjectSetInteger(0, g_info_panel, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_info_panel, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, g_info_panel, OBJPROP_XSIZE, width);
   
   // Obtener altura del panel
   int info_height = (int)ObjectGetInteger(0, g_info_panel, OBJPROP_YSIZE);
   int text_y = y + info_height/2;
   
   // Actualizar posición de las etiquetas del spread
   int spread_x = x + 15;
   ObjectSetInteger(0, g_spread_label, OBJPROP_XDISTANCE, spread_x);
   ObjectSetInteger(0, g_spread_label, OBJPROP_YDISTANCE, text_y);
   
   ObjectSetInteger(0, g_spread_value, OBJPROP_XDISTANCE, spread_x + 50);
   ObjectSetInteger(0, g_spread_value, OBJPROP_YDISTANCE, text_y);
   
   // Actualizar posición de las etiquetas del ATR
   int atr_x = x + width/2 - 20;
   ObjectSetInteger(0, g_atr_label, OBJPROP_XDISTANCE, atr_x);
   ObjectSetInteger(0, g_atr_label, OBJPROP_YDISTANCE, text_y);
   
   ObjectSetInteger(0, g_atr_value, OBJPROP_XDISTANCE, atr_x + 30);
   ObjectSetInteger(0, g_atr_value, OBJPROP_YDISTANCE, text_y);
   
   // Actualizar posición del icono de engranaje
   int gear_x = x + width - 30;
   CreateGearIconCentered(gear_x, text_y);
}

//+------------------------------------------------------------------+
//| Inicializar el indicador ATR                                      |
//+------------------------------------------------------------------+
void CInfoPanel::InitializeATR()
{
   // Si ya hay un handle válido, liberarlo primero
   if(g_atr_handle != INVALID_HANDLE)
      IndicatorRelease(g_atr_handle);
   
   // Crear un nuevo handle para el indicador ATR
   g_atr_handle = iATR(g_current_symbol, PERIOD_CURRENT, g_atr_period);
   
   // Verificar si se creó correctamente
   if(g_atr_handle == INVALID_HANDLE)
      Print("Error al inicializar el indicador ATR: ", GetLastError());
}

//+------------------------------------------------------------------+
//| Función para crear el icono de engranaje                          |
//+------------------------------------------------------------------+
void CInfoPanel::CreateGearIcon()
{
   // Verificar que exista el objeto ATR
   if(ObjectFind(0, g_atr_value) < 0) return;
   
   // Obtener la posición exacta del valor de ATR
   int atr_x = (int)ObjectGetInteger(0, g_atr_value, OBJPROP_XDISTANCE);
   int atr_y = (int)ObjectGetInteger(0, g_atr_value, OBJPROP_YDISTANCE);
   string atr_text = ObjectGetString(0, g_atr_value, OBJPROP_TEXT);
   int text_len = StringLen(atr_text);
   int font_size = (int)ObjectGetInteger(0, g_atr_value, OBJPROP_FONTSIZE);
   
   // Estimar el ancho del texto ATR
   int text_width = (int)(text_len * (font_size / 1.2));
   
   // Posición horizontal
   int gear_x = atr_x + text_width + 10;
   
   // Ajuste de posición vertical para centrar con el texto
   int panel_height = (int)ObjectGetInteger(0, g_info_panel, OBJPROP_YSIZE);
   int panel_y = (int)ObjectGetInteger(0, g_info_panel, OBJPROP_YDISTANCE);
   
   // Calcular el centro de la barra y ajustar por el tamaño del icono
   int gear_size = 18; // Tamaño aproximado del icono
   int center_y = panel_y + (panel_height / 2) - (gear_size / 2);
   
   // Eliminar objetos anteriores
   ObjectDelete(0, g_gear_icon);
   
   // Crear bitmap desde el recurso incorporado
   ObjectCreate(0, g_gear_icon, OBJ_BITMAP_LABEL, 0, 0, 0);
   ObjectSetString(0, g_gear_icon, OBJPROP_BMPFILE, "::Images\\gear_icon.bmp");
   ObjectSetInteger(0, g_gear_icon, OBJPROP_XDISTANCE, gear_x);
   ObjectSetInteger(0, g_gear_icon, OBJPROP_YDISTANCE, center_y); // Posición centralizada
   ObjectSetInteger(0, g_gear_icon, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, g_gear_icon, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0, g_gear_icon, OBJPROP_ZORDER, 999);
}

//+------------------------------------------------------------------+
//| Función para actualizar la posición del icono de engranaje         |
//+------------------------------------------------------------------+
void CInfoPanel::UpdateGearIconPosition()
{
   CreateGearIcon(); // Simplemente volver a crear el icono con la nueva posición
}

//+------------------------------------------------------------------+
//| Función para crear un icono de engranaje centrado                 |
//+------------------------------------------------------------------+
void CInfoPanel::CreateGearIconCentered(int center_x, int center_y)
{
   // Tamaño del icono
   int gear_size = 18;
   
   // Calcular posición para que el icono quede centrado en las coordenadas
   int gear_x = center_x - gear_size/2;
   int gear_y = center_y - gear_size/2;
   
   // Eliminar objetos anteriores
   ObjectDelete(0, g_gear_icon);
   
   // Crear bitmap desde el recurso incorporado
   ObjectCreate(0, g_gear_icon, OBJ_BITMAP_LABEL, 0, 0, 0);
   ObjectSetString(0, g_gear_icon, OBJPROP_BMPFILE, "::Images\\gear_icon.bmp");
   ObjectSetInteger(0, g_gear_icon, OBJPROP_XDISTANCE, gear_x);
   ObjectSetInteger(0, g_gear_icon, OBJPROP_YDISTANCE, gear_y);
   ObjectSetInteger(0, g_gear_icon, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, g_gear_icon, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0, g_gear_icon, OBJPROP_ZORDER, 999);
} 