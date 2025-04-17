//+------------------------------------------------------------------+
//|                                                       Panel.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

#include "../Core/Globals.mqh"
#include "../Utils/ColorUtils.mqh"
#include "ThemeManager.mqh"

//+------------------------------------------------------------------+
//| Clase para gestionar el panel principal                           |
//+------------------------------------------------------------------+
class CPanel
{
private:
   CThemeManager*    m_themeManager;
   bool              m_initialized;
   
public:
                     CPanel(CThemeManager* themeManager);
                    ~CPanel();
   bool              Initialize(int x, int y, int width, int height);
   void              ToggleExpand();
   void              UpdateControlPositions(int x, int y, int width);
   void              MovePanel(int x, int y);
   void              ToggleDragging(int x, int y);
   void              DragPanel(int x, int y);
   void              StopDragging();
   void              ToggleDragMode();
   void              ClosePanel();
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CPanel::CPanel(CThemeManager* themeManager)
{
   m_themeManager = themeManager;
   m_initialized = false;
}

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CPanel::~CPanel()
{
   // Nada que limpiar
}

//+------------------------------------------------------------------+
//| Inicializar el panel principal                                    |
//+------------------------------------------------------------------+
bool CPanel::Initialize(int x, int y, int width, int height)
{
   if(m_initialized)
      return true;
   
   g_panelX = x;
   g_panelY = y;
   g_panelWidth = width;
   g_panelHeight = height;
   
   if(!CreateMainPanel("LMCproPanel", x, y, width, height))
   {
      Print("Error al crear el panel principal");
      return false;
   }
   
   m_initialized = true;
   return true;
}

//+------------------------------------------------------------------+
//| Función para crear el panel principal con título                  |
//+------------------------------------------------------------------+
bool CreateMainPanel(string name, int x, int y, int width, int height)
{
   g_panel_name = name;
   g_title_panel = name + "_TitlePanel";
   g_help_button = name + "_HelpBtn";
   g_theme_button = name + "_ThemeBtn";
   g_expand_button = name + "_ExpandBtn";
   g_close_button = name + "_CloseBtn";
   g_drag_button = name + "_DragBtn";  // Botón de arrastre
   
   // Crear panel principal
   if(!ObjectCreate(0, g_panel_name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_panel_name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_panel_name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, g_panel_name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, g_panel_name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, g_panel_name, OBJPROP_BGCOLOR, COLOR_BG_PANEL);
   ObjectSetInteger(0, g_panel_name, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetInteger(0, g_panel_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   
   // Crear panel de título
   if(!ObjectCreate(0, g_title_panel, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_title_panel, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_title_panel, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, g_title_panel, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, g_title_panel, OBJPROP_YSIZE, 24);
   ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
   ObjectSetInteger(0, g_title_panel, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetInteger(0, g_title_panel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   
   // Definir posiciones para mejor espaciado y alineación
   int buttonSize = 22; // Aumentamos ligeramente el tamaño para mejor visibilidad
   int buttonY = y + (24 - buttonSize) / 2; // Para centrar verticalmente
   int buttonSpacing = 26; // Espacio entre botones
   int rightMargin = 10; // Margen desde el borde derecho
   
   // Calcular posiciones de los botones (de derecha a izquierda)
   int closeX = x + width - rightMargin - buttonSize;
   int expandX = closeX - buttonSpacing;
   int themeX = expandX - buttonSpacing;
   int helpX = themeX - buttonSpacing;
   int dragX = helpX - buttonSpacing;  // Posición del nuevo botón
   
   // Crear botón de cerrar (X)
   if(!ObjectCreate(0, g_close_button, OBJ_BUTTON, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_close_button, OBJPROP_XDISTANCE, closeX);
   ObjectSetInteger(0, g_close_button, OBJPROP_YDISTANCE, buttonY);
   ObjectSetInteger(0, g_close_button, OBJPROP_XSIZE, buttonSize);
   ObjectSetInteger(0, g_close_button, OBJPROP_YSIZE, buttonSize);
   ObjectSetInteger(0, g_close_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
   ObjectSetInteger(0, g_close_button, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetInteger(0, g_close_button, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetString(0, g_close_button, OBJPROP_TEXT, "×"); // Usando un signo × más grande y claro
   ObjectSetString(0, g_close_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_close_button, OBJPROP_FONTSIZE, 14); // Aumentamos tamaño
   ObjectSetInteger(0, g_close_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón de expandir (^) - cambio el símbolo inicial a flecha hacia abajo
   if(!ObjectCreate(0, g_expand_button, OBJ_BUTTON, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_expand_button, OBJPROP_XDISTANCE, expandX);
   ObjectSetInteger(0, g_expand_button, OBJPROP_YDISTANCE, buttonY);
   ObjectSetInteger(0, g_expand_button, OBJPROP_XSIZE, buttonSize);
   ObjectSetInteger(0, g_expand_button, OBJPROP_YSIZE, buttonSize);
   ObjectSetInteger(0, g_expand_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
   ObjectSetInteger(0, g_expand_button, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetInteger(0, g_expand_button, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetString(0, g_expand_button, OBJPROP_TEXT, "▼"); // Inicialmente flecha hacia abajo (panel expandido)
   ObjectSetString(0, g_expand_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_expand_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_expand_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón de tema (sol)
   if(!ObjectCreate(0, g_theme_button, OBJ_BUTTON, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_theme_button, OBJPROP_XDISTANCE, themeX);
   ObjectSetInteger(0, g_theme_button, OBJPROP_YDISTANCE, buttonY);
   ObjectSetInteger(0, g_theme_button, OBJPROP_XSIZE, buttonSize);
   ObjectSetInteger(0, g_theme_button, OBJPROP_YSIZE, buttonSize);
   ObjectSetInteger(0, g_theme_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
   ObjectSetInteger(0, g_theme_button, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetInteger(0, g_theme_button, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetString(0, g_theme_button, OBJPROP_TEXT, "☀"); // Usando un símbolo de sol más claro
   ObjectSetString(0, g_theme_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_theme_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_theme_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón de ayuda (?)
   if(!ObjectCreate(0, g_help_button, OBJ_BUTTON, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_help_button, OBJPROP_XDISTANCE, helpX);
   ObjectSetInteger(0, g_help_button, OBJPROP_YDISTANCE, buttonY);
   ObjectSetInteger(0, g_help_button, OBJPROP_XSIZE, buttonSize);
   ObjectSetInteger(0, g_help_button, OBJPROP_YSIZE, buttonSize);
   ObjectSetInteger(0, g_help_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
   ObjectSetInteger(0, g_help_button, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetInteger(0, g_help_button, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetString(0, g_help_button, OBJPROP_TEXT, "?");
   ObjectSetString(0, g_help_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_help_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_help_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón de arrastre
   if(!ObjectCreate(0, g_drag_button, OBJ_BUTTON, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_drag_button, OBJPROP_XDISTANCE, dragX);
   ObjectSetInteger(0, g_drag_button, OBJPROP_YDISTANCE, buttonY);
   ObjectSetInteger(0, g_drag_button, OBJPROP_XSIZE, buttonSize);
   ObjectSetInteger(0, g_drag_button, OBJPROP_YSIZE, buttonSize);
   ObjectSetInteger(0, g_drag_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
   ObjectSetInteger(0, g_drag_button, OBJPROP_COLOR, COLOR_TEXT);
   ObjectSetInteger(0, g_drag_button, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetString(0, g_drag_button, OBJPROP_TEXT, "✥");  // Símbolo de movimiento/arrastre
   ObjectSetString(0, g_drag_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_drag_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_drag_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   return true;
}

//+------------------------------------------------------------------+
//| Alternar entre panel expandido y contraído                        |
//+------------------------------------------------------------------+
void CPanel::ToggleExpand()
{
   // Cambiar el estado de expansión
   g_panel_expanded = !g_panel_expanded;
   
   Print("Panel ", g_panel_expanded ? "EXPANDIDO" : "CONTRAÍDO");
   
   // Obtener la posición actual del panel
   int x = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XDISTANCE);
   int y = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_YDISTANCE);
   int width = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XSIZE);
   
   // Actualizar la altura del panel según el estado
   int new_height = g_panel_expanded ? g_panel_height_expanded : g_panel_height_collapsed;
   ObjectSetInteger(0, g_panel_name, OBJPROP_YSIZE, new_height);
   
   // Cambiar el ícono del botón según el estado
   if(g_panel_expanded)
   {
      // Si está expandido, muestra flecha hacia abajo (para contraer)
      ObjectSetString(0, g_expand_button, OBJPROP_TEXT, "▼");
   }
   else
   {
      // Si está contraído, muestra flecha hacia arriba (para expandir)
      ObjectSetString(0, g_expand_button, OBJPROP_TEXT, "▲");
   }
   
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| Función para actualizar posiciones de todos los controles         |
//+------------------------------------------------------------------+
void CPanel::UpdateControlPositions(int x, int y, int width)
{
   // Posicionar botones
   int buttonSize = 22;
   int buttonY = y + (24 - buttonSize) / 2;
   int buttonSpacing = 26;
   int rightMargin = 10;
   
   int closeX = x + width - rightMargin - buttonSize;
   int expandX = closeX - buttonSpacing;
   int themeX = expandX - buttonSpacing;
   int helpX = themeX - buttonSpacing;
   int dragX = helpX - buttonSpacing;  // Posición del nuevo botón
   
   ObjectSetInteger(0, g_close_button, OBJPROP_XDISTANCE, closeX);
   ObjectSetInteger(0, g_close_button, OBJPROP_YDISTANCE, buttonY);
   
   ObjectSetInteger(0, g_expand_button, OBJPROP_XDISTANCE, expandX);
   ObjectSetInteger(0, g_expand_button, OBJPROP_YDISTANCE, buttonY);
   
   ObjectSetInteger(0, g_theme_button, OBJPROP_XDISTANCE, themeX);
   ObjectSetInteger(0, g_theme_button, OBJPROP_YDISTANCE, buttonY);
   
   ObjectSetInteger(0, g_help_button, OBJPROP_XDISTANCE, helpX);
   ObjectSetInteger(0, g_help_button, OBJPROP_YDISTANCE, buttonY);
   
   ObjectSetInteger(0, g_drag_button, OBJPROP_XDISTANCE, dragX);
   ObjectSetInteger(0, g_drag_button, OBJPROP_YDISTANCE, buttonY);
   
   // Mover selector de símbolos y otros elementos (se actualizará en sus respectivas clases)
}

//+------------------------------------------------------------------+
//| Función para mover el panel completo a una nueva posición         |
//+------------------------------------------------------------------+
void CPanel::MovePanel(int x, int y)
{
   // Obtener dimensiones actuales
   int width = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XSIZE);
   int height = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_YSIZE);
   
   // Obtener dimensiones del gráfico
   int chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   int chart_height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
   
   // Asegurar que al menos una parte del panel permanezca visible
   // Dejar al menos 100px del panel visible (o el ancho total si es menor)
   int min_visible = MathMin(100, width);
   
   // Limitar coordenadas para mantener panel visible
   x = MathMax(-width + min_visible, MathMin(x, chart_width - min_visible));
   y = MathMax(0, MathMin(y, chart_height - 20)); // Al menos 20px del título siempre visible
   
   // Mover panel principal
   ObjectSetInteger(0, g_panel_name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_panel_name, OBJPROP_YDISTANCE, y);
   
   // Mover panel de título
   ObjectSetInteger(0, g_title_panel, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_title_panel, OBJPROP_YDISTANCE, y);
   
   // Actualizar posiciones de todos los botones y elementos
   UpdateControlPositions(x, y, width);
   
   // Forzar redibujado de la pantalla
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Iniciar/detener arrastre del panel (toggle)                       |
//+------------------------------------------------------------------+
void CPanel::ToggleDragging(int x, int y) 
{
   // Si el modo de arrastre está bloqueado, no hacer nada
   if(g_drag_mode_locked) return;
   
   // Bloquear temporalmente el modo para evitar toggles accidentales
   g_drag_mode_locked = true;
   
   // Si ya estamos arrastrando, detenemos el arrastre
   if(g_is_dragging)
   {
      StopDragging();
   }
   else
   {
      // Iniciar estado de arrastre
      g_is_dragging = true;
      
      // Guardar posición inicial del mouse
      g_drag_start_x = x;
      g_drag_start_y = y;
      
      // Guardar posición inicial del panel
      g_panel_start_x = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XDISTANCE);
      g_panel_start_y = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_YDISTANCE);
      
      // Retroalimentación visual
      if(g_drag_visual_feedback) {
         // Cambiar apariencia del título para indicar modo arrastre
         color original_color = (color)ObjectGetInteger(0, g_title_panel, OBJPROP_BGCOLOR);
         color drag_color;
         
         if(g_dark_theme) {
            drag_color = ColorBrighten(original_color, 40); // Más notable
         } else {
            drag_color = ColorDarken(original_color, 40);
         }
         
         ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, drag_color);
         
         // Texto indicador
         string drag_text = g_panel_name + "_DragText";
         if(ObjectFind(0, drag_text) < 0)
         {
            ObjectCreate(0, drag_text, OBJ_LABEL, 0, 0, 0);
            ObjectSetInteger(0, drag_text, OBJPROP_XDISTANCE, g_panel_start_x + 10);
            ObjectSetInteger(0, drag_text, OBJPROP_YDISTANCE, g_panel_start_y + 12);
            ObjectSetInteger(0, drag_text, OBJPROP_COLOR, COLOR_TEXT);
            ObjectSetString(0, drag_text, OBJPROP_TEXT, "• MOVIENDO •");
            ObjectSetString(0, drag_text, OBJPROP_FONT, "Arial");
            ObjectSetInteger(0, drag_text, OBJPROP_FONTSIZE, 8);
            ObjectSetInteger(0, drag_text, OBJPROP_ANCHOR, ANCHOR_LEFT);
         }
      }
      
      Print("Modo arrastre ACTIVADO");
   }
}

//+------------------------------------------------------------------+
//| Finalizar arrastre del panel                                      |
//+------------------------------------------------------------------+
void CPanel::StopDragging() 
{
   if(!g_is_dragging) return;
   
   // Terminar estado de arrastre
   g_is_dragging = false;
   
   // Restaurar apariencia original
   if(g_drag_visual_feedback) {
      // Restaurar color original del título
      ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
      
      // Eliminar texto indicador si existe
      string drag_text = g_panel_name + "_DragText";
      if(ObjectFind(0, drag_text) >= 0)
         ObjectDelete(0, drag_text);
   }
   
   Print("Modo arrastre DESACTIVADO");
}

//+------------------------------------------------------------------+
//| Arrastrar el panel                                                |
//+------------------------------------------------------------------+
void CPanel::DragPanel(int x, int y) 
{
   if(!g_is_dragging) return;
   
   // Calcular desplazamiento desde el inicio del arrastre
   int dx = x - g_drag_start_x;
   int dy = y - g_drag_start_y;
   
   // Calcular nueva posición del panel
   int new_x = g_panel_start_x + dx;
   int new_y = g_panel_start_y + dy;
   
   // Mover el panel a la nueva posición
   MovePanel(new_x, new_y);
}

//+------------------------------------------------------------------+
//| Activar/desactivar el modo arrastre                               |
//+------------------------------------------------------------------+
void CPanel::ToggleDragMode()
{
   // Si ya está en modo arrastre, desactivarlo
   if(g_drag_mode)
   {
      // Desactivar modo arrastre
      g_drag_mode = false;
      Print("Modo arrastre DESACTIVADO");
      
      // Restaurar apariencia del botón
      ObjectSetInteger(0, g_drag_button, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
      ObjectSetInteger(0, g_drag_button, OBJPROP_COLOR, COLOR_TEXT);
      
      // Restaurar color del título
      ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, COLOR_BG_TITLE);
      
      // Eliminar texto indicador si existe
      string drag_text = g_panel_name + "_DragText";
      if(ObjectFind(0, drag_text) >= 0)
         ObjectDelete(0, drag_text);
   }
   else
   {
      // Activar modo arrastre
      g_drag_mode = true;
      Print("Modo arrastre ACTIVADO - Mueve el panel con el mouse");
      
      // Calcular y guardar el offset entre el mouse y la esquina del panel
      int panel_x = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XDISTANCE);
      int panel_y = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_YDISTANCE);
      g_drag_offset_x = g_mouse_x - panel_x;
      g_drag_offset_y = g_mouse_y - panel_y;
      
      Print("Offset de arrastre: ", g_drag_offset_x, ", ", g_drag_offset_y);
      
      // Cambiar apariencia del botón para indicar que está activo
      ObjectSetInteger(0, g_drag_button, OBJPROP_BGCOLOR, clrRed);
      ObjectSetInteger(0, g_drag_button, OBJPROP_COLOR, clrWhite);
      
      // Cambiar apariencia del título para indicar modo arrastre
      color original_color = (color)ObjectGetInteger(0, g_title_panel, OBJPROP_BGCOLOR);
      color drag_color;
      
      if(g_dark_theme) {
         drag_color = ColorBrighten(original_color, 40);
      } else {
         drag_color = ColorDarken(original_color, 40);
      }
      
      ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, drag_color);
   }
   
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Cerrar y eliminar el panel completo                               |
//+------------------------------------------------------------------+
void CPanel::ClosePanel()
{
   Print("Cerrando panel LMCpro...");
   
   // Cancelar el timer
   EventKillTimer();
   
   // Método más efectivo: eliminar TODOS los objetos creados por el indicador
   // Obtenemos el ID del programa actual
   long chartID = ChartID();
   int totalObjects = ObjectsTotal(chartID);
   
   // Eliminar todos los objetos en orden inverso para evitar problemas de índice
   for(int i = totalObjects - 1; i >= 0; i--)
   {
      string name = ObjectName(chartID, i);
      // Eliminar objetos que pertenecen a nuestro panel o herramientas
      if(StringFind(name, "LMCpro") >= 0 || StringFind(name, "Tooltip") >= 0 || 
         StringFind(name, g_panel_name) >= 0)
      {
         ObjectDelete(chartID, name);
      }
   }
   
   // Forzar redibujado del gráfico
   ChartRedraw(0);
   
   // Descargar el indicador/EA
   ExpertRemove();
} 