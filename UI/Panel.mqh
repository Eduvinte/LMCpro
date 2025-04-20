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
#include "TabManager.mqh"
#include "TradeView.mqh"

//+------------------------------------------------------------------+
//| Clase para gestionar el panel principal                           |
//+------------------------------------------------------------------+
class CPanel
{
private:
   CThemeManager*    m_themeManager;
   bool              m_initialized;
   CTabManager*      m_tabManager;
   CTradeView*       m_tradeView;
   
   int               m_contentAreaX;
   int               m_contentAreaY;
   int               m_contentAreaWidth;
   int               m_contentAreaHeight;
   
   void              CalculateContentArea();
   
public:
                     CPanel(CThemeManager* themeManager);
                    ~CPanel();
   bool              Initialize(int x, int y, int width, int height);
   bool              CreateMainPanel(int x, int y, int width, int height);
   bool              CreateTitleWithImage(int x, int y, int width);
   bool              CreateInteractiveArea(string name, int x, int y, int width, int height);
   void              ToggleExpand();
   void              UpdateControlPositions(int x, int y, int width);
   void              MovePanel(int x, int y);
   void              MoveAllPanelComponents(int dx, int dy);
   void              ToggleDragging(int x, int y);
   void              DragPanel(int x, int y);
   void              StopDragging();
   void              ToggleDragMode();
   void              ClosePanel();
   CTabManager*      GetTabManager() { return m_tabManager; }
   void              UpdateActiveView(ENUM_ACTIVE_TAB activeTab);
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CPanel::CPanel(CThemeManager* themeManager)
{
   m_themeManager = themeManager;
   m_initialized = false;
   m_tabManager = new CTabManager(m_themeManager);
   if(m_tabManager == NULL)
   {
       Print("Error: No se pudo crear CTabManager");
   }
   m_tradeView = new CTradeView(m_themeManager);
   if(m_tradeView == NULL) Print("Error: No se pudo crear CTradeView");
   
   m_contentAreaX = 0;
   m_contentAreaY = 0;
   m_contentAreaWidth = 0;
   m_contentAreaHeight = 0;
}

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CPanel::~CPanel()
{
   if(m_tabManager != NULL)
   {
      delete m_tabManager;
      m_tabManager = NULL;
   }
   if(m_tradeView != NULL) delete m_tradeView;
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
   
   if(!CreateMainPanel(x, y, width, height))
   {
      Print("Error al crear el panel principal");
      return false;
   }
   
   if(!CreateTitleWithImage(x, y, width))
   {
      Print("Error al crear la barra de título");
      return false;
   }
   
   int title_height = 24;
   int info_section_height = g_item_height;
   int vertical_offset = 23;
   int tabs_y = y + title_height + info_section_height + vertical_offset;

   if(m_tabManager != NULL && !m_tabManager.Initialize(x, tabs_y, width))
   {
       Print("Error al inicializar el TabManager");
       return false;
   }
   
   CalculateContentArea();

   if(m_tradeView != NULL && !m_tradeView.Initialize(m_contentAreaX, m_contentAreaY, m_contentAreaWidth, m_contentAreaHeight))
   {
       Print("Error al inicializar TradeView");
       return false;
   }

   if(m_tabManager != NULL)
   {
      UpdateActiveView(m_tabManager.GetActiveTab());
   }
   else
   {
      Print("Error: TabManager no está inicializado para establecer la vista activa.");
      return false;
   }

   m_initialized = true;
   return true;
}

//+------------------------------------------------------------------+
//| Función para crear el panel principal con título                  |
//+------------------------------------------------------------------+
bool CPanel::CreateMainPanel(int x, int y, int width, int height)
{
   g_panel_name = "MainPanel";
   g_title_panel = "MainPanel_TitlePanel";
   g_help_button = "MainPanel_HelpBtn";
   g_theme_button = "MainPanel_ThemeBtn";
   g_expand_button = "MainPanel_ExpandBtn";
   g_close_button = "MainPanel_CloseBtn";
   g_drag_button = "MainPanel_DragBtn";  // Botón de arrastre
   
   // Crear panel principal
   if(!ObjectCreate(0, g_panel_name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_panel_name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_panel_name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, g_panel_name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, g_panel_name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, g_panel_name, OBJPROP_BGCOLOR, C'30,32,45');
   ObjectSetInteger(0, g_panel_name, OBJPROP_BORDER_COLOR, COLOR_BORDER);
   ObjectSetInteger(0, g_panel_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   
   return true;
}

//+------------------------------------------------------------------+
//| Crear barra de título con imagen                                  |
//+------------------------------------------------------------------+
bool CPanel::CreateTitleWithImage(int x, int y, int width)
{
   // Crear el fondo de la barra de título
   if(!ObjectCreate(0, g_title_panel, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;
   
   ObjectSetInteger(0, g_title_panel, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, g_title_panel, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, g_title_panel, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, g_title_panel, OBJPROP_YSIZE, 24);
   ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, C'77,118,201');
   ObjectSetInteger(0, g_title_panel, OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, g_title_panel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, g_title_panel, OBJPROP_BACK, false); // Para que esté encima
   
   // Crear símbolo de gráfico a la izquierda
   string logo_label = g_panel_name + "_LogoSymbol";
   if(!ObjectCreate(0, logo_label, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, logo_label, OBJPROP_XDISTANCE, x + 10);
   ObjectSetInteger(0, logo_label, OBJPROP_YDISTANCE, y + 12);
   ObjectSetInteger(0, logo_label, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, logo_label, OBJPROP_TEXT, "📊"); // Icono de gráfico
   ObjectSetString(0, logo_label, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, logo_label, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, logo_label, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear texto del título a la izquierda, junto al icono
   string title_label = g_panel_name + "_Title";
   if(!ObjectCreate(0, title_label, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, title_label, OBJPROP_XDISTANCE, x + 30); // Posicionado a la derecha del icono
   ObjectSetInteger(0, title_label, OBJPROP_YDISTANCE, y + 12); // Centrado verticalmente
   ObjectSetInteger(0, title_label, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, title_label, OBJPROP_TEXT, "DashPro v1.0");
   ObjectSetString(0, title_label, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, title_label, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, title_label, OBJPROP_ANCHOR, ANCHOR_LEFT); // Alineado a la izquierda
   
   // Definir posiciones para mejor espaciado y alineación de los botones
   int buttonY = y + 1;
   int buttonSize = 22;
   int buttonSpacing = 35; // Aumentar significativamente el espaciado entre botones
   int rightX = x + width - 20; // Empezar desde la derecha
   
   // Crear botón para cerrar (X)
   if(!ObjectCreate(0, g_close_button, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_close_button, OBJPROP_XDISTANCE, rightX);
   ObjectSetInteger(0, g_close_button, OBJPROP_YDISTANCE, y + 12);
   ObjectSetInteger(0, g_close_button, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, g_close_button, OBJPROP_TEXT, "❌");
   ObjectSetString(0, g_close_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_close_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_close_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón para expandir
   rightX -= buttonSpacing;
   if(!ObjectCreate(0, g_expand_button, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_expand_button, OBJPROP_XDISTANCE, rightX);
   ObjectSetInteger(0, g_expand_button, OBJPROP_YDISTANCE, y + 12);
   ObjectSetInteger(0, g_expand_button, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, g_expand_button, OBJPROP_TEXT, "△"); // Triángulo más visible
   ObjectSetString(0, g_expand_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_expand_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_expand_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón de tema
   rightX -= buttonSpacing;
   if(!ObjectCreate(0, g_theme_button, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_theme_button, OBJPROP_XDISTANCE, rightX);
   ObjectSetInteger(0, g_theme_button, OBJPROP_YDISTANCE, y + 12);
   ObjectSetInteger(0, g_theme_button, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, g_theme_button, OBJPROP_TEXT, "🌓"); // Icono de luna/tema
   ObjectSetString(0, g_theme_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_theme_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_theme_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón de ayuda
   rightX -= buttonSpacing;
   if(!ObjectCreate(0, g_help_button, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_help_button, OBJPROP_XDISTANCE, rightX);
   ObjectSetInteger(0, g_help_button, OBJPROP_YDISTANCE, y + 12);
   ObjectSetInteger(0, g_help_button, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, g_help_button, OBJPROP_TEXT, "❓");
   ObjectSetString(0, g_help_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_help_button, OBJPROP_FONTSIZE, 12);
   ObjectSetInteger(0, g_help_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear botón de arrastre
   rightX -= buttonSpacing;
   if(!ObjectCreate(0, g_drag_button, OBJ_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, g_drag_button, OBJPROP_XDISTANCE, rightX);
   ObjectSetInteger(0, g_drag_button, OBJPROP_YDISTANCE, y + 12);
   ObjectSetInteger(0, g_drag_button, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, g_drag_button, OBJPROP_TEXT, "≡"); // Símbolo diferente para arrastre
   ObjectSetString(0, g_drag_button, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, g_drag_button, OBJPROP_FONTSIZE, 14); // Tamaño ligeramente mayor
   ObjectSetInteger(0, g_drag_button, OBJPROP_ANCHOR, ANCHOR_CENTER);
   
   // Crear áreas interactivas invisibles con tamaño ligeramente mayor para mejor usabilidad
   int areaSize = 26; // Área un poco más grande que los botones
   
   // Reiniciar las posiciones para cálculos exactos
   rightX = x + width - 20; // Reiniciar para el cálculo de áreas interactivas
   
   // Área para botón cerrar (X)
   CreateInteractiveArea(g_close_button + "_area", rightX - areaSize/2, buttonY, areaSize, areaSize);
   
   // Área para botón expandir
   rightX -= buttonSpacing;
   CreateInteractiveArea(g_expand_button + "_area", rightX - areaSize/2, buttonY, areaSize, areaSize);
   
   // Área para botón tema
   rightX -= buttonSpacing;
   CreateInteractiveArea(g_theme_button + "_area", rightX - areaSize/2, buttonY, areaSize, areaSize);
   
   // Área para botón ayuda
   rightX -= buttonSpacing;
   CreateInteractiveArea(g_help_button + "_area", rightX - areaSize/2, buttonY, areaSize, areaSize);
   
   // Área para botón arrastre
   rightX -= buttonSpacing;
   CreateInteractiveArea(g_drag_button + "_area", rightX - areaSize/2, buttonY, areaSize, areaSize);
   
   // Imprimir posiciones para depuración
   Print("DEBUG - Posición área interactiva botón cerrar: ", rightX + buttonSpacing*4 - areaSize/2);
   Print("DEBUG - Posición área interactiva botón arrastre: ", rightX - areaSize/2);
   
   return true;
}

// Función auxiliar para crear áreas interactivas
bool CPanel::CreateInteractiveArea(string name, int x, int y, int width, int height)
{
   if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;
      
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clrNONE);  // Fondo transparente
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrNONE);  // Sin borde
   ObjectSetInteger(0, name, OBJPROP_BACK, true);  // En segundo plano
   
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
      ObjectSetString(0, g_expand_button, OBJPROP_TEXT, "▽");
   }
   else
   {
      // Si está contraído, muestra flecha hacia arriba (para expandir)
      ObjectSetString(0, g_expand_button, OBJPROP_TEXT, "△");
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
   int buttonY = y + 1; // Igual que en la creación: (24-22)/2
   int buttonSpacing = 26;
   int rightMargin = 10;
   
   int closeX = x + width - rightMargin - buttonSize + 11;
   int expandX = closeX - buttonSpacing;
   int themeX = expandX - buttonSpacing;
   int helpX = themeX - buttonSpacing;
   int dragX = helpX - buttonSpacing;
   
   // Actualizar posición de las etiquetas
   ObjectSetInteger(0, g_close_button, OBJPROP_XDISTANCE, closeX);
   ObjectSetInteger(0, g_close_button, OBJPROP_YDISTANCE, buttonY + 11);
   
   ObjectSetInteger(0, g_expand_button, OBJPROP_XDISTANCE, expandX);
   ObjectSetInteger(0, g_expand_button, OBJPROP_YDISTANCE, buttonY + 11);
   
   ObjectSetInteger(0, g_theme_button, OBJPROP_XDISTANCE, themeX);
   ObjectSetInteger(0, g_theme_button, OBJPROP_YDISTANCE, buttonY + 11);
   
   ObjectSetInteger(0, g_help_button, OBJPROP_XDISTANCE, helpX);
   ObjectSetInteger(0, g_help_button, OBJPROP_YDISTANCE, buttonY + 11);
   
   ObjectSetInteger(0, g_drag_button, OBJPROP_XDISTANCE, dragX);
   ObjectSetInteger(0, g_drag_button, OBJPROP_YDISTANCE, buttonY + 11);
   
   // Actualizar posición de las áreas de interacción
   ObjectSetInteger(0, g_close_button + "_area", OBJPROP_XDISTANCE, closeX - 11);
   ObjectSetInteger(0, g_close_button + "_area", OBJPROP_YDISTANCE, buttonY);
   
   ObjectSetInteger(0, g_expand_button + "_area", OBJPROP_XDISTANCE, expandX - 11);
   ObjectSetInteger(0, g_expand_button + "_area", OBJPROP_YDISTANCE, buttonY);
   
   ObjectSetInteger(0, g_theme_button + "_area", OBJPROP_XDISTANCE, themeX - 11);
   ObjectSetInteger(0, g_theme_button + "_area", OBJPROP_YDISTANCE, buttonY);
   
   ObjectSetInteger(0, g_help_button + "_area", OBJPROP_XDISTANCE, helpX - 11);
   ObjectSetInteger(0, g_help_button + "_area", OBJPROP_YDISTANCE, buttonY);
   
   ObjectSetInteger(0, g_drag_button + "_area", OBJPROP_XDISTANCE, dragX - 11);
   ObjectSetInteger(0, g_drag_button + "_area", OBJPROP_YDISTANCE, buttonY);
   
   // Actualizar posición del título
   string title_label = g_panel_name + "_Title";
   if(ObjectFind(0, title_label) >= 0)
   {
      ObjectSetInteger(0, title_label, OBJPROP_XDISTANCE, x + 10);
      ObjectSetInteger(0, title_label, OBJPROP_YDISTANCE, y + 12); // Centrado igual que en la creación
   }
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
   
   // Guardar el desplazamiento relativo 
   int dx = x - (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XDISTANCE);
   int dy = y - (int)ObjectGetInteger(0, g_panel_name, OBJPROP_YDISTANCE);
   
   // Solo realizar cambios si hay un desplazamiento real
   if(dx == 0 && dy == 0) return;
   
   // Mover todos los elementos del panel
   MoveAllPanelComponents(dx, dy);
}

//+------------------------------------------------------------------+
//| Mover todos los componentes del panel                             |
//+------------------------------------------------------------------+
void CPanel::MoveAllPanelComponents(int dx, int dy)
{
   if(dx == 0 && dy == 0) return; // No hacer nada si no hay desplazamiento
   
   // Actualizar coordenadas base del área de contenido antes de mover
   m_contentAreaX += dx;
   m_contentAreaY += dy;

   // 1. Obtenemos todos los objetos gráficos
   int total = ObjectsTotal(0);
   
   // 2. Mover los elementos principales del panel y el título explícitamente
   string panel_elements[] = {
       g_panel_name,
       g_title_panel,
       g_panel_name + "_LogoSymbol",
       g_panel_name + "_Title",
       g_close_button,
       g_expand_button,
       g_theme_button,
       g_help_button,
       g_drag_button,
       g_close_button + "_area",
       g_expand_button + "_area",
       g_theme_button + "_area",
       g_help_button + "_area",
       g_drag_button + "_area",
       // Añadimos el selector de símbolos
       g_header_panel,
       g_header_label,
       g_arrow_button,
       g_left_button,
       g_right_button,
       g_symbols_text,
       // Añadimos el panel de información
       g_info_panel,
       g_spread_label,
       g_spread_value,
       g_atr_label,
       g_atr_value,
       g_gear_icon,
       g_gear_icon + "_area"
   };
   for(int i = 0; i < ArraySize(panel_elements); i++)
   {
       if(ObjectFind(0, panel_elements[i]) >= 0)
       {
           int curr_x = (int)ObjectGetInteger(0, panel_elements[i], OBJPROP_XDISTANCE);
           int curr_y = (int)ObjectGetInteger(0, panel_elements[i], OBJPROP_YDISTANCE);
           ObjectSetInteger(0, panel_elements[i], OBJPROP_XDISTANCE, curr_x + dx);
           ObjectSetInteger(0, panel_elements[i], OBJPROP_YDISTANCE, curr_y + dy);
       }
   }
   
   // Si el dropdown está visible, también hay que moverlo
   if(g_dropdown_visible)
   {
       // Mover el panel del dropdown
       if(ObjectFind(0, g_dropdown_panel) >= 0)
       {
           int curr_x = (int)ObjectGetInteger(0, g_dropdown_panel, OBJPROP_XDISTANCE);
           int curr_y = (int)ObjectGetInteger(0, g_dropdown_panel, OBJPROP_YDISTANCE);
           ObjectSetInteger(0, g_dropdown_panel, OBJPROP_XDISTANCE, curr_x + dx);
           ObjectSetInteger(0, g_dropdown_panel, OBJPROP_YDISTANCE, curr_y + dy);
           
           // Mover también todos los elementos del dropdown
           for(int i = 0; i < g_max_dropdown_items; i++)
           {
               string item_panel = g_dropdown_panel + "_Item" + IntegerToString(i);
               if(ObjectFind(0, item_panel) >= 0)
               {
                   int item_x = (int)ObjectGetInteger(0, item_panel, OBJPROP_XDISTANCE);
                   int item_y = (int)ObjectGetInteger(0, item_panel, OBJPROP_YDISTANCE);
                   ObjectSetInteger(0, item_panel, OBJPROP_XDISTANCE, item_x + dx);
                   ObjectSetInteger(0, item_panel, OBJPROP_YDISTANCE, item_y + dy);
               }
           }
           
           // Mover los botones de scroll si existen
           string scroll_elements[] = {
               g_dropdown_panel + "_ScrollUp",
               g_dropdown_panel + "_ScrollDown"
           };
           
           for(int i = 0; i < ArraySize(scroll_elements); i++)
           {
               if(ObjectFind(0, scroll_elements[i]) >= 0)
               {
                   int scroll_x = (int)ObjectGetInteger(0, scroll_elements[i], OBJPROP_XDISTANCE);
                   int scroll_y = (int)ObjectGetInteger(0, scroll_elements[i], OBJPROP_YDISTANCE);
                   ObjectSetInteger(0, scroll_elements[i], OBJPROP_XDISTANCE, scroll_x + dx);
                   ObjectSetInteger(0, scroll_elements[i], OBJPROP_YDISTANCE, scroll_y + dy);
               }
           }
       }
   }
   
   // 3. Mover específicamente las pestañas
   if(m_tabManager != NULL)
   {
      m_tabManager.MoveTabs(dx, dy);
   }
   
   // 4. Mover las vistas
   if(m_tradeView != NULL)
   {
      m_tradeView.MoveView(dx, dy);
   }
   
   // 5. Actualizar las coordenadas globales del panel
   g_panelX += dx;
   g_panelY += dy;
   
   // 6. Forzar redibujado de la pantalla
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
      ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, C'77,118,201');
      
      // Eliminar texto indicador si existe
      string drag_text = g_panel_name + "_DragText";
      if(ObjectFind(0, drag_text) >= 0)
         ObjectDelete(0, drag_text);
   }
   
   Print("Modo arrastre DESACTIVADO");
}

//+------------------------------------------------------------------+
//| Arrastrar panel a una nueva posición                             |
//+------------------------------------------------------------------+
void CPanel::DragPanel(int x, int y)
{
   // Verificar cualquiera de los dos modos de arrastre
   if(!g_is_dragging && !g_drag_mode) 
   {
      return;
   }
   
   int dx, dy;
   
   // Calculamos el desplazamiento dependiendo del modo que se activó
   if(g_drag_mode) {
      // Modo arrastre iniciado por botón (≡)
      // Calcular movimiento para mantener el botón bajo el cursor
      int boton_x = (int)ObjectGetInteger(0, g_drag_button, OBJPROP_XDISTANCE);
      int boton_y = (int)ObjectGetInteger(0, g_drag_button, OBJPROP_YDISTANCE);
      
      // El desplazamiento es la diferencia entre donde debería estar el botón (x - offset) 
      // y donde está actualmente
      dx = (x - g_drag_offset_x) - boton_x;
      dy = (y - g_drag_offset_y) - boton_y;
      
      Print("DEBUG - Arrastre: mouse_x=", x, ", offset_x=", g_drag_offset_x, 
            ", boton_x=", boton_x, ", dx=", dx);
   } else {
      // Modo arrastre iniciado por barra de título
      dx = x - g_drag_start_x;
      dy = y - g_drag_start_y;
      
      // Actualizar posiciones para el próximo movimiento
      g_drag_start_x = x;
      g_drag_start_y = y;
   }
   
   // Si no hay desplazamiento, no hacer nada
   if(dx == 0 && dy == 0) return;
   
   // IMPORTANTE: Usar MoveAllPanelComponents que mueve TODOS los elementos
   MoveAllPanelComponents(dx, dy);
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
      g_is_dragging = false; 
      Print("Modo arrastre DESACTIVADO");
      
      // Restaurar apariencia del botón
      ObjectSetInteger(0, g_drag_button, OBJPROP_COLOR, clrWhite);
      ObjectSetString(0, g_drag_button, OBJPROP_TEXT, "≡");
      
      // Restaurar color del título
      ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, C'77,118,201');
      
      // Eliminar texto indicador si existe
      string drag_text = g_panel_name + "_DragText";
      if(ObjectFind(0, drag_text) >= 0)
         ObjectDelete(0, drag_text);
   }
   else
   {
      // Activar modo arrastre
      g_drag_mode = true;
      g_is_dragging = true;
      Print("Modo arrastre ACTIVADO - Mueve el panel con el mouse");
      
      // Obtener la posición del botón de arrastre para mantener el cursor sobre él
      int boton_x = (int)ObjectGetInteger(0, g_drag_button, OBJPROP_XDISTANCE);
      int boton_y = (int)ObjectGetInteger(0, g_drag_button, OBJPROP_YDISTANCE);
      
      // El offset debe ser la diferencia entre la posición del mouse y la posición del botón
      // Esto hace que el panel se mueva de manera que el botón permanezca bajo el cursor
      g_drag_offset_x = g_mouse_x - boton_x;
      g_drag_offset_y = g_mouse_y - boton_y;
      
      Print("DEBUG - Calculando offset de arrastre: mouse_x=", g_mouse_x, ", boton_x=", boton_x, ", offset_x=", g_drag_offset_x);
      
      // Cambiar apariencia del botón para indicar que está activo
      ObjectSetInteger(0, g_drag_button, OBJPROP_COLOR, clrRed);
      ObjectSetString(0, g_drag_button, OBJPROP_TEXT, "⊗"); // Usar un símbolo diferente para indicar stop
      
      // Cambiar apariencia del título para indicar modo arrastre
      ObjectSetInteger(0, g_title_panel, OBJPROP_BGCOLOR, C'200,118,77'); // Color naranja para indicar modo arrastre
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

   // Destruir las pestañas
   if(m_tabManager != NULL)
   {
       m_tabManager.Destroy();
   }

   // Destruir las vistas de contenido
   if(m_tradeView != NULL) m_tradeView.Destroy();
}

void CPanel::CalculateContentArea()
{
    // Asegurarse de que los objetos de pestañas existan antes de obtener sus propiedades
    if(m_tabManager == NULL || ObjectFind(0, TAB_BUTTON_TRADE_NAME) < 0)
    {
        Print("Error: No se pueden calcular las dimensiones del área de contenido porque las pestañas no existen.");
        // Establecer valores por defecto o manejar el error
        m_contentAreaX = g_panelX; 
        m_contentAreaY = g_panelY + 100; // Un valor por defecto razonable
        m_contentAreaWidth = g_panelWidth;
        m_contentAreaHeight = g_panelHeight - 100; 
        if(m_contentAreaHeight < 0) m_contentAreaHeight = 50; // Mínimo
        return;
    }

    int tabs_y = (int)ObjectGetInteger(0, TAB_BUTTON_TRADE_NAME, OBJPROP_YDISTANCE); // Obtener Y de un botón de pestaña
    int tab_button_height = (int)ObjectGetInteger(0, TAB_BUTTON_TRADE_NAME, OBJPROP_YSIZE); // Obtener altura
    int content_margin_top = 5; // Espacio entre pestañas y contenido

    m_contentAreaX = g_panelX; // El contenido empieza en la misma X que el panel
    m_contentAreaY = tabs_y + tab_button_height + content_margin_top; // Debajo de las pestañas + margen
    m_contentAreaWidth = g_panelWidth; // El contenido usa todo el ancho del panel
    
    // Calcular altura restante para el contenido
    int panel_bottom_y = g_panelY + g_panelHeight;
    m_contentAreaHeight = panel_bottom_y - m_contentAreaY;
    if (m_contentAreaHeight < 10) m_contentAreaHeight = 10; // Asegurar una altura mínima visible
}

void CPanel::UpdateActiveView(ENUM_ACTIVE_TAB activeTab)
{
    PrintFormat("Actualizando vista activa a: %d", activeTab);
    // Ocultar todas las vistas primero
    if(m_tradeView != NULL) m_tradeView.Hide();

    // Mostrar la vista activa
    switch(activeTab)
    {
        case TAB_TRADE:
            Print("Activando TradeView");
            if(m_tradeView != NULL) m_tradeView.Show();
            break;
        case TAB_MANAGE:
            Print("Activando ManageView (aún no implementada)");
            break;
        case TAB_GRID:
             Print("Activando GridView (aún no implementada)");
            break;
        default:
            Print("Error: Pestaña desconocida o ninguna activa.");
            break;
    }
    ChartRedraw(); // Redibujar para mostrar/ocultar
} 