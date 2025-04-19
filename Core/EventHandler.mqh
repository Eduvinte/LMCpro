//+------------------------------------------------------------------+
//|                                                EventHandler.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

#include "Globals.mqh"
#include "../UI/Panel.mqh"
#include "../UI/SymbolSelector.mqh"
#include "../UI/Tooltip.mqh"
#include "../UI/InfoPanel.mqh"
#include "../UI/ThemeManager.mqh"

//+------------------------------------------------------------------+
//| Clase para gestionar los eventos del usuario                      |
//+------------------------------------------------------------------+
class CEventHandler
{
private:
   bool              m_initialized;
   CPanel*           m_panel;
   CSymbolSelector*  m_symbolSelector;
   CTooltip*         m_tooltip;
   CInfoPanel*       m_infoPanel;
   CThemeManager*    m_themeManager;
   static datetime   last_drag_activation_storage; // Almacena hora de activación del modo arrastre
   
public:
                     CEventHandler();
                    ~CEventHandler();
   bool              Initialize();
   void              SetPanel(CPanel* panel) { m_panel = panel; }
   void              SetSymbolSelector(CSymbolSelector* selector) { m_symbolSelector = selector; }
   void              SetTooltip(CTooltip* tooltip) { m_tooltip = tooltip; }
   void              SetInfoPanel(CInfoPanel* infoPanel) { m_infoPanel = infoPanel; }
   void              SetThemeManager(CThemeManager* themeManager) { m_themeManager = themeManager; }
   void              OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
   void              OnTimer();
   
   // Métodos para el panel de configuración
   void              ToggleSettingsPanel();
   void              ShowSettingsPanel();
   void              HideSettingsPanel();
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CEventHandler::CEventHandler()
{
   m_initialized = false;
   m_panel = NULL;
   m_symbolSelector = NULL;
   m_tooltip = NULL;
   m_infoPanel = NULL;
   m_themeManager = NULL;
}

//+------------------------------------------------------------------+
//| Destructor                                                        |
//+------------------------------------------------------------------+
CEventHandler::~CEventHandler()
{
   // No borrar los objetos que sólo se han referenciado
}

// Inicializar variable estática
datetime CEventHandler::last_drag_activation_storage = 0;

//+------------------------------------------------------------------+
//| Inicializar                                                       |
//+------------------------------------------------------------------+
bool CEventHandler::Initialize()
{
   if(m_initialized)
      return true;
   
   // Verificar que todos los componentes necesarios estén asignados
   if(m_panel == NULL || m_symbolSelector == NULL || m_tooltip == NULL || m_themeManager == NULL)
   {
      Print("Error: Componentes requeridos no asignados para el manejador de eventos");
      return false;
   }
   
   // Habilitar eventos de mouse
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   
   m_initialized = true;
   return true;
}

//+------------------------------------------------------------------+
//| Manejar eventos del gráfico                                       |
//+------------------------------------------------------------------+
void CEventHandler::OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   // Para eventos de movimiento del mouse
   if(id == CHARTEVENT_MOUSE_MOVE)
   {
      // Actualizar coordenadas del mouse
      g_mouse_x = (int)lparam;
      g_mouse_y = (int)dparam;
      
      // Si el modo arrastre está activado, mover el panel con el mouse
      if((g_is_dragging || g_drag_mode) && m_panel != NULL)
      {
         // Usar DragPanel que ahora usa MoveAllPanelComponents internamente
         m_panel.DragPanel(g_mouse_x, g_mouse_y);
         
         // Forzar redibujado del gráfico
         ChartRedraw();
         return; // Importante: retornar para evitar otro procesamiento
      }
      
      // Verificar tooltips si el modo ayuda está activo
      if(g_help_active && m_tooltip != NULL)
      {
         m_tooltip.CheckToolTips();
      }
   }
   
   // Para eventos de clic
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      Print("Clic en objeto: ", sparam);
      
      // Verificar si el clic fue en un área interactiva y redirigir al botón correspondiente
      string button_to_handle = sparam;
      
      // Comprobar si el objeto clicado es un área interactiva
      if(StringFind(sparam, "_area") > 0)
      {
         // Obtener el nombre del botón original quitando "_area"
         button_to_handle = StringSubstr(sparam, 0, StringLen(sparam) - 5);
         Print("Redirección de área interactiva: ", sparam, " -> ", button_to_handle);
      }
      
      // Verificar explícitamente si es cualquier objeto relacionado con el botón de cierre
      if(StringFind(button_to_handle, g_settings_panel + "_CloseBtn") >= 0 || 
         button_to_handle == g_settings_panel + "_CloseBtn")
      {
         Print("DEBUG: Cerrando panel de configuración desde botón X");
         HideSettingsPanel();
         return;
      }
      
      // Verificar si el clic es en la barra de título del panel de configuración
      if(button_to_handle == g_settings_title)
      {
         // Obtener la posición del clic
         if(g_mouse_x >= g_settings_x + g_settings_width - 30)
         {
            // Si el clic está en el área cercana al botón X (últimos 30px del ancho)
            Print("DEBUG: Cerrando panel de configuración desde área de la X en barra de título");
            HideSettingsPanel();
            return;
         }
      }
      
      // Verificar si es el icono de engranaje
      if(button_to_handle == g_gear_icon)
      {
         Print("DEBUG: Abriendo panel de configuración desde icono de engranaje");
         ToggleSettingsPanel();
         return;
      }
      
      // Si hacemos clic en el botón de arrastre
      if(button_to_handle == g_drag_button && m_panel != NULL)
      {
         Print("DEBUG: Activando ToggleDragMode desde botón de arrastre");
         m_panel.ToggleDragMode();
         
         // Guardar hora de activación para evitar desactivación inmediata
         last_drag_activation_storage = (datetime)GetTickCount64();
         
         ChartRedraw(); // Asegurar redibujado
         return; // IMPORTANTE: Retornar inmediatamente para evitar otro procesamiento
      }
      
      // Si hacemos clic en el área del botón de arrastre (área interactiva)
      if(button_to_handle == g_drag_button + "_area" && m_panel != NULL)
      {
         Print("DEBUG: Activando ToggleDragMode desde área interactiva del botón de arrastre");
         m_panel.ToggleDragMode();
         
         // Guardar hora de activación para evitar desactivación inmediata
         last_drag_activation_storage = (datetime)GetTickCount64();
         
         ChartRedraw();
         return; // IMPORTANTE: Retornar inmediatamente 
      }
      
      // Si el clic es en la barra de título
      if(button_to_handle == g_title_panel && m_panel != NULL)
      {
         if(g_is_dragging)
         {
            // Si ya estamos arrastrando, el clic finalizará el arrastre
            m_panel.StopDragging();
         }
         else 
         {
            // Si no estamos arrastrando, iniciar arrastre
            m_panel.ToggleDragging(g_mouse_x, g_mouse_y);
         }
         return;
      }
      
      // Si estamos en modo arrastre y hacemos clic en cualquier otra parte
      if(g_is_dragging && g_drag_toggle_mode && m_panel != NULL)
      {
         m_panel.StopDragging();
         return;
      }
      
      // Verificar explícitamente si es el botón de ayuda
      if(button_to_handle == g_help_button && m_tooltip != NULL)
      {
         m_tooltip.ToggleHelpMode();
         return;
      }
      
      // Verificar si es el botón de tema
      if(button_to_handle == g_theme_button && m_themeManager != NULL)
      {
         m_themeManager.ToggleTheme();
         return;
      }
      
      // Verificar si es el encabezado del selector o el botón de flecha
      if((button_to_handle == g_header_panel || button_to_handle == g_arrow_button) && m_symbolSelector != NULL)
      {
         m_symbolSelector.ToggleDropdown(!g_dropdown_visible);
         return;
      }
      
      // Verificar si son los botones de navegación
      if(button_to_handle == g_left_button && m_symbolSelector != NULL)
      {
         m_symbolSelector.UpdateSymbol(-1);
         return;
      }
      if(button_to_handle == g_right_button && m_symbolSelector != NULL)
      {
         m_symbolSelector.UpdateSymbol(1);
         return;
      }
      
      // Verificar si es un ítem del dropdown
      if(StringFind(button_to_handle, g_dropdown_panel + "_Item") == 0 && m_symbolSelector != NULL)
      {
         // Extraer el índice del ítem
         string idx_str = StringSubstr(button_to_handle, StringLen(g_dropdown_panel + "_Item"));
         int item_idx = (int)StringToInteger(idx_str);
         
         m_symbolSelector.SelectSymbolFromDropdown(item_idx);
         return;
      }
      
      // Verificar si son los botones de scroll
      if(button_to_handle == g_dropdown_panel + "_ScrollUp" && m_symbolSelector != NULL)
      {
         m_symbolSelector.ScrollDropdown(-1);
         return;
      }
      if(button_to_handle == g_dropdown_panel + "_ScrollDown" && m_symbolSelector != NULL)
      {
         m_symbolSelector.ScrollDropdown(1);
         return;
      }
      
      // Verificar si es el botón de expandir
      if(button_to_handle == g_expand_button && m_panel != NULL)
      {
         m_panel.ToggleExpand();
         return;
      }
      
      // Verificar si es el botón de cerrar
      if(button_to_handle == g_close_button && m_panel != NULL)
      {
         Print("DEBUG: Cerrando panel desde botón de cierre");
         m_panel.ClosePanel();
         return;
      }
      
      // <<< NUEVOS EVENTOS PARA BOTONES DE PESTAÑAS >>>
      // Verificar si es un clic en alguno de los botones de pestañas
      if(m_panel != NULL && m_panel.GetTabManager() != NULL)
      {
         CTabManager* tabManager = m_panel.GetTabManager(); // Obtener puntero
         // Si el TabManager procesa el evento (devuelve true), significa que se cambió la pestaña
         if(tabManager.OnClick(button_to_handle))
         {
            Print("Cambio de pestaña detectado por EventHandler: ", button_to_handle);

            // <<< Llamar a UpdateActiveView en CPanel >>>
            m_panel.UpdateActiveView(tabManager.GetActiveTab());
            // Ya no necesitamos ChartRedraw() aquí, UpdateActiveView lo hace

            return; // Evento manejado
         }
      }
      // <<< FIN NUEVOS EVENTOS >>>
   }
   
   // Para eventos de clic en el chart (fuera de objetos)
   if(id == CHARTEVENT_CLICK)
   {
      // Si estamos en modo arrastre, desactivarlo con cualquier clic en el chart
      // PERO solo si no es el clic inicial que activó el modo arrastre
      if((g_is_dragging || g_drag_mode) && g_drag_toggle_mode && m_panel != NULL)
      {
         // Verificar si este clic es parte de la misma acción que activó el modo arrastre
         datetime current_time = (datetime)GetTickCount64();
         
         // Si han pasado menos de 100ms desde la activación, ignorar este clic
         if(current_time - last_drag_activation_storage < 100)
         {
            Print("Ignorando desactivación inmediata del modo arrastre");
            return;
         }
         
         if (g_drag_mode) m_panel.ToggleDragMode();
         else m_panel.StopDragging();
         return;
      }
   }
}

//+------------------------------------------------------------------+
//| Manejar eventos del timer                                         |
//+------------------------------------------------------------------+
void CEventHandler::OnTimer()
{
   // Desbloquear el modo de arrastre después del tiempo establecido
   static datetime last_unlock_time = 0;
   
   if(g_drag_mode_locked)
   {
      datetime current_time = (datetime)GetTickCount64();
      if(current_time > last_unlock_time)
      {
         g_drag_mode_locked = false;
         last_unlock_time = current_time;
         
         // Restaurar timer normal una vez desbloqueado
         if(!g_is_dragging && !g_help_active)
            EventSetTimer(100); // Timer más lento cuando no se necesita alta frecuencia
      }
   }
   
   // Si estamos arrastrando, simplemente actualizar la posición
   if(g_is_dragging && m_panel != NULL)
   {
      m_panel.DragPanel(g_mouse_x, g_mouse_y);
   }
   
   // Solo verificar tooltips si el modo ayuda está activo
   if(g_help_active && m_tooltip != NULL)
   {
      // Verificar si un tooltip debe auto-ocultarse
      if(g_tooltip_visible)
      {
         int elapsed_seconds = (int)(TimeCurrent() - g_tooltip_created_time);
         if(elapsed_seconds >= 3) // Ocultar después de 3 segundos
         {
            m_tooltip.Delete();
         }
      }
      
      // Verificar tooltips según posición del mouse
      m_tooltip.CheckToolTips();
   }
   
   // Actualizar el spread y el ATR
   if(m_infoPanel != NULL)
   {
      // Obtener el spread actual
      datetime current_time = (datetime)GetTickCount64();
      if(current_time - g_last_spread_update >= g_spread_update_interval_ms)
      {
         g_last_spread_update = current_time;
         int current_spread = (int)SymbolInfoInteger(g_current_symbol, SYMBOL_SPREAD);
         m_infoPanel.UpdateSpread(current_spread);
         
         // Obtener el valor del ATR
         if(g_atr_handle != INVALID_HANDLE)
         {
            double atr_buffer[];
            ArraySetAsSeries(atr_buffer, true);
            
            if(CopyBuffer(g_atr_handle, 0, 0, 1, atr_buffer) == 1)
            {
               double current_atr = atr_buffer[0];
               m_infoPanel.UpdateATR(current_atr);
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Métodos para el panel de configuración                            |
//+------------------------------------------------------------------+
void CEventHandler::ToggleSettingsPanel()
{
   if(g_settings_visible)
      HideSettingsPanel();
   else
      ShowSettingsPanel();
}

void CEventHandler::ShowSettingsPanel()
{
   if(g_settings_visible) return; // Ya está visible
   
   Print("Mostrando panel de configuración");
   g_settings_visible = true;
   
   // Calcular posición para el panel de configuración
   int main_panel_x = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XDISTANCE);
   int main_panel_y = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_YDISTANCE);
   int main_panel_width = (int)ObjectGetInteger(0, g_panel_name, OBJPROP_XSIZE);
   
   // Posicionar a la derecha del panel principal
   g_settings_x = main_panel_x + main_panel_width + 10;
   g_settings_y = main_panel_y + 35; // Alinear con el área principal del panel
   
   // Dimensiones y colores
   g_settings_width = 250;
   g_settings_height = 350;
   g_settings_bg_color = C'45,45,68';
   g_settings_title_color = C'77,118,201';
   
   // Crear panel de fondo
   ObjectCreate(0, g_settings_panel, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, g_settings_panel, OBJPROP_XDISTANCE, g_settings_x);
   ObjectSetInteger(0, g_settings_panel, OBJPROP_YDISTANCE, g_settings_y);
   ObjectSetInteger(0, g_settings_panel, OBJPROP_XSIZE, g_settings_width);
   ObjectSetInteger(0, g_settings_panel, OBJPROP_YSIZE, g_settings_height);
   ObjectSetInteger(0, g_settings_panel, OBJPROP_BGCOLOR, g_settings_bg_color);
   ObjectSetInteger(0, g_settings_panel, OBJPROP_BORDER_COLOR, clrWhite);
   ObjectSetInteger(0, g_settings_panel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, g_settings_panel, OBJPROP_ZORDER, 100);
   
   // Crear barra de título
   ObjectCreate(0, g_settings_title, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, g_settings_title, OBJPROP_XDISTANCE, g_settings_x);
   ObjectSetInteger(0, g_settings_title, OBJPROP_YDISTANCE, g_settings_y);
   ObjectSetInteger(0, g_settings_title, OBJPROP_XSIZE, g_settings_width);
   ObjectSetInteger(0, g_settings_title, OBJPROP_YSIZE, 25);
   ObjectSetInteger(0, g_settings_title, OBJPROP_BGCOLOR, g_settings_title_color);
   ObjectSetInteger(0, g_settings_title, OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, g_settings_title, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, g_settings_title, OBJPROP_ZORDER, 101);
   
   // Crear texto del título
   string settings_label = g_settings_panel + "_Label";
   ObjectCreate(0, settings_label, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, settings_label, OBJPROP_XDISTANCE, g_settings_x + 10);
   ObjectSetInteger(0, settings_label, OBJPROP_YDISTANCE, g_settings_y + 13);
   ObjectSetInteger(0, settings_label, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, settings_label, OBJPROP_TEXT, "Configuración");
   ObjectSetString(0, settings_label, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, settings_label, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, settings_label, OBJPROP_ANCHOR, ANCHOR_LEFT);
   
   // Crear botón de cierre con ZORDER mayor para que reciba los clics primero
   string close_btn = g_settings_panel + "_CloseBtn";
   ObjectCreate(0, close_btn, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, close_btn, OBJPROP_XDISTANCE, g_settings_x + g_settings_width - 15);
   ObjectSetInteger(0, close_btn, OBJPROP_YDISTANCE, g_settings_y + 13);
   ObjectSetInteger(0, close_btn, OBJPROP_COLOR, clrWhite);
   ObjectSetString(0, close_btn, OBJPROP_TEXT, "✖");
   ObjectSetString(0, close_btn, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, close_btn, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, close_btn, OBJPROP_ANCHOR, ANCHOR_CENTER);
   ObjectSetInteger(0, close_btn, OBJPROP_ZORDER, 102); // Mayor ZORDER que la barra de título
   
   // Área interactiva para el botón de cierre - Hacerla más grande y mejor posicionada
   string close_area = close_btn + "_area";
   ObjectCreate(0, close_area, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, close_area, OBJPROP_XDISTANCE, g_settings_x + g_settings_width - 35);
   ObjectSetInteger(0, close_area, OBJPROP_YDISTANCE, g_settings_y);
   ObjectSetInteger(0, close_area, OBJPROP_XSIZE, 35);
   ObjectSetInteger(0, close_area, OBJPROP_YSIZE, 25);
   ObjectSetInteger(0, close_area, OBJPROP_BGCOLOR, clrNONE);
   ObjectSetInteger(0, close_area, OBJPROP_BORDER_COLOR, clrNONE);
   ObjectSetInteger(0, close_area, OBJPROP_BACK, true);
   ObjectSetInteger(0, close_area, OBJPROP_ZORDER, 103); // El ZORDER más alto para detectar los clics primero
   
   ChartRedraw();
}

void CEventHandler::HideSettingsPanel()
{
   if(!g_settings_visible) return; // Ya está oculto
   
   Print("Ocultando panel de configuración");
   g_settings_visible = false;
   
   // Eliminar todos los objetos del panel de configuración
   int totalObjects = ObjectsTotal(0);
   for(int i = totalObjects - 1; i >= 0; i--)
   {
      string name = ObjectName(0, i);
      
      // Eliminar el panel principal y todos sus componentes
      if(StringFind(name, g_settings_panel) >= 0)
      {
         ObjectDelete(0, name);
      }
      
      // Eliminar explícitamente la barra de título y sus componentes
      if(StringFind(name, g_settings_title) >= 0)
      {
         ObjectDelete(0, name);
      }
      
      // Eliminar cualquier objeto relacionado con el botón de cierre
      if(StringFind(name, g_settings_panel + "_CloseBtn") >= 0)
      {
         ObjectDelete(0, name);
      }
      
      // Eliminar todas las etiquetas y áreas interactivas relacionadas
      if(StringFind(name, g_settings_panel + "_Label") >= 0)
      {
         ObjectDelete(0, name);
      }
   }
   
   // Eliminar explícitamente los objetos principales por nombre
   ObjectDelete(0, g_settings_panel);
   ObjectDelete(0, g_settings_title);
   ObjectDelete(0, g_settings_panel + "_Label");
   ObjectDelete(0, g_settings_panel + "_CloseBtn");
   ObjectDelete(0, g_settings_panel + "_CloseBtn_area");
   
   ChartRedraw();
} 