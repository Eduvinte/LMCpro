//+------------------------------------------------------------------+
//|                                                     Tooltip.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

#include "../Core/Globals.mqh"
#include "ThemeManager.mqh"

//+------------------------------------------------------------------+
//| Clase para gestionar tooltips                                     |
//+------------------------------------------------------------------+
class CTooltip
{
private:
   CThemeManager*    m_themeManager;
   bool              m_initialized;
   
public:
                     CTooltip(CThemeManager* themeManager);
                    ~CTooltip();
   bool              Initialize();
   void              Show(string text, int x, int y);
   void              Delete();
   void              CheckToolTips();
   void              ToggleHelpMode();
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CTooltip::CTooltip(CThemeManager* themeManager)
{
   m_themeManager = themeManager;
   m_initialized = false;
}

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CTooltip::~CTooltip()
{
   // Limpiar tooltips
   Delete();
}

//+------------------------------------------------------------------+
//| Inicializar el sistema de tooltips                                |
//+------------------------------------------------------------------+
bool CTooltip::Initialize()
{
   if(m_initialized)
      return true;
   
   g_help_active = false;
   g_tooltip_visible = false;
   g_current_tooltip = "";
   g_tooltip_object = "";
   g_tooltip_text = "";
   g_tooltip_timeout = 0;
   g_tooltip_appear_delay = 0;
   g_hover_element = "";
   
   m_initialized = true;
   return true;
}

//+------------------------------------------------------------------+
//| Mostrar un tooltip                                                |
//+------------------------------------------------------------------+
void CTooltip::Show(string text, int x, int y)
{
   // Si ya hay un tooltip visible con el mismo contenido, solo actualiza el tiempo
   if(g_tooltip_visible && g_current_tooltip == StringSubstr(text, 0, StringFind(text, "\n")))
   {
      g_tooltip_created_time = TimeCurrent(); // Reiniciar el tiempo
      return;
   }
   
   // Eliminar tooltip anterior si existe
   Delete();
   
   // Crear un nombre único para el tooltip
   string objName = "Tooltip_" + IntegerToString(GetTickCount());
   g_tooltip_object = objName + "_BG";
   g_tooltip_text = objName + "_Text";
   
   // Crear objeto de fondo
   ObjectCreate(0, g_tooltip_object, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   
   // Dimensiones base del tooltip
   int width = 240;  // Ancho para más espacio
   int height = 65;  // Altura base
   
   // Verificar si el texto ya tiene saltos de línea
   string formatted_text = text;
   
   // Dividir el texto en líneas
   string textLines[];
   int lineCount = StringSplit(formatted_text, '\n', textLines);
   
   // Ajustar altura según las líneas
   height = MathMax(65, 30 + (lineCount * 18)); // Aumentar la altura por línea
   
   // Asegurar que el tooltip quede dentro de la pantalla
   if(x + width > ChartGetInteger(0, CHART_WIDTH_IN_PIXELS))
      x = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS) - width - 5;
   
   // Configurar el fondo
   color tooltipBg = m_themeManager.IsDarkTheme() ? C'28,28,50' : C'240,240,250';
   color tooltipBorder = m_themeManager.IsDarkTheme() ? C'40,40,80' : C'180,180,220';
   color tooltipText = m_themeManager.IsDarkTheme() ? clrWhite : C'40,40,80';
   
   ObjectSetInteger(0, g_tooltip_object, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_tooltip_object, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, g_tooltip_object, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, g_tooltip_object, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, g_tooltip_object, OBJPROP_BGCOLOR, tooltipBg);
   ObjectSetInteger(0, g_tooltip_object, OBJPROP_BORDER_COLOR, tooltipBorder);
   ObjectSetInteger(0, g_tooltip_object, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, g_tooltip_object, OBJPROP_ZORDER, 999);
   
   // Crear múltiples etiquetas para cada línea del texto
   for(int i=0; i<lineCount; i++)
   {
      string lineObj = objName + "_Line" + IntegerToString(i);
      
      ObjectCreate(0, lineObj, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, lineObj, OBJPROP_XDISTANCE, x + 10);
      ObjectSetInteger(0, lineObj, OBJPROP_YDISTANCE, y + 15 + (i * 18)); // Espaciado entre líneas
      ObjectSetInteger(0, lineObj, OBJPROP_COLOR, tooltipText);
      ObjectSetString(0, lineObj, OBJPROP_TEXT, textLines[i]);
      ObjectSetString(0, lineObj, OBJPROP_FONT, "Arial");
      ObjectSetInteger(0, lineObj, OBJPROP_FONTSIZE, 9);
      ObjectSetInteger(0, lineObj, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0, lineObj, OBJPROP_ZORDER, 1000);
      
      // Guardar referencia para borrar después
      if(i == 0)
         g_tooltip_text = lineObj;
   }
   
   // Guardar referencia del tooltip actual - usar primera línea como identificador
   int newline_pos = StringFind(text, "\n");
   if(newline_pos > 0)
      g_current_tooltip = StringSubstr(text, 0, newline_pos);
   else
      g_current_tooltip = text;
      
   g_tooltip_visible = true;
   g_tooltip_created_time = TimeCurrent(); // Registrar tiempo de creación
   
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Eliminar tooltips                                                 |
//+------------------------------------------------------------------+
void CTooltip::Delete()
{
   // Eliminar objetos completamente, no solo ocultarlos
   if(g_tooltip_object != "")
   {
      // Eliminar fondo
      ObjectDelete(0, g_tooltip_object);
      
      // Eliminar todas las líneas de texto
      for(int i=0; i<10; i++) // Máximo razonable de líneas
      {
         string baseObjName = StringSubstr(g_tooltip_object, 0, StringLen(g_tooltip_object)-3); // Quitar "_BG"
         string lineObj = baseObjName + "_Line" + IntegerToString(i);
         ObjectDelete(0, lineObj);
      }
   }
   
   // Reiniciar variables
   g_tooltip_object = "";
   g_tooltip_text = "";
   g_current_tooltip = "";
   g_tooltip_timeout = 0;
   g_tooltip_appear_delay = 0;
   g_hover_element = "";
   g_tooltip_visible = false;
   
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Verificar tooltips                                                |
//+------------------------------------------------------------------+
void CTooltip::CheckToolTips()
{
   if(!g_help_active) return;
   
   // Obtener la posición actual del panel
   int panel_x = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XDISTANCE);
   int panel_y = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_YDISTANCE);
   int panel_width = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XSIZE);
   
   // Calcular posición relativa del mouse respecto al panel
   int rel_x = g_mouse_x - panel_x;
   int rel_y = g_mouse_y - panel_y;
   
   bool found_element = false;
   
   // Verificar si el mouse está dentro del panel y sobre qué elemento
   if(rel_x >= 0 && rel_x <= panel_width && rel_y >= 0 && rel_y <= 450)  // 450 es la altura máxima
   {
      // Verificar diferentes elementos según la posición relativa
      
      // Si está en la barra de título
      if(rel_y < 24)
      {
         found_element = true;
         Show("Mover Panel\nHaz clic y arrastra para mover", g_mouse_x + 10, g_mouse_y + 20);
      }
      
      // Si está en la fila del selector de símbolos
      else if(rel_y >= 24 && rel_y <= 46)
      {
         if(rel_x < 140)  // Selector de símbolos
         {
            found_element = true;
            Show("Selector de Símbolos\nCambia el instrumento financiero actual", g_mouse_x + 10, g_mouse_y + 20);
         }
         // ... otros elementos
      }
      
      // Verificar botones específicos
      if(ObjectGetInteger(0, g_help_button, OBJPROP_STATE))
      {
         found_element = true;
         Show("Modo Ayuda\nMuestra información sobre los elementos al pasar el cursor", g_mouse_x + 10, g_mouse_y + 20);
      }
      else if(ObjectGetInteger(0, g_theme_button, OBJPROP_STATE))
      {
         found_element = true;
         Show("Cambiar Tema\nAlterna entre tema claro y oscuro", g_mouse_x + 10, g_mouse_y + 20);
      }
      else if(ObjectGetInteger(0, g_expand_button, OBJPROP_STATE))
      {
         found_element = true;
         Show("Expandir/Contraer\nCambia el tamaño del panel", g_mouse_x + 10, g_mouse_y + 20);
      }
      else if(ObjectGetInteger(0, g_close_button, OBJPROP_STATE))
      {
         found_element = true;
         Show("Cerrar\nCierra el panel", g_mouse_x + 10, g_mouse_y + 20);
      }
      else if(ObjectGetInteger(0, g_drag_button, OBJPROP_STATE))
      {
         found_element = true;
         Show("Modo Arrastre\nActiva/desactiva el modo de arrastre del panel", g_mouse_x + 10, g_mouse_y + 20);
      }
   }
   
   // Si no se encontró ningún elemento y hay un tooltip visible, ocultarlo
   if(!found_element && g_tooltip_visible)
   {
      Delete();
   }
}

//+------------------------------------------------------------------+
//| Activar/desactivar el modo de ayuda                               |
//+------------------------------------------------------------------+
void CTooltip::ToggleHelpMode()
{
   g_help_active = !g_help_active;
   
   Print("Modo ayuda: ", g_help_active ? "ACTIVADO" : "DESACTIVADO");
   
   // Cambiar visualmente el botón de ayuda
   if(g_help_active)
   {
      // Color distintivo cuando está activo
      ObjectSetInteger(0, g_help_button, OBJPROP_BGCOLOR, clrRed);
      ObjectSetInteger(0, g_help_button, OBJPROP_COLOR, clrWhite);
      
      // Mostrar un mensaje inmediatamente para confirmar que está activo
      Show("Modo de ayuda ACTIVADO\nPasa el mouse sobre los elementos", 50, 100);
   }
   else
   {
      // Restaurar color normal
      ObjectSetInteger(0, g_help_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
      ObjectSetInteger(0, g_help_button, OBJPROP_COLOR, COLOR_TEXT);
      
      // Eliminar cualquier tooltip activo
      Delete();
   }
   
   ChartRedraw(0);
} 