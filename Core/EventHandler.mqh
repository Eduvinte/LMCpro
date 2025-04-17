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
      if(g_drag_mode && m_panel != NULL)
      {
         // Usar el offset para mantener la posición relativa inicial
         int new_x = g_mouse_x - g_drag_offset_x;
         int new_y = g_mouse_y - g_drag_offset_y;
         
         // Mover el panel a la nueva posición
         m_panel.MovePanel(new_x, new_y);
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
      
      // Si hacemos clic en el botón de arrastre
      if(button_to_handle == g_drag_button && m_panel != NULL)
      {
         Print("DEBUG: Activando ToggleDragMode desde botón de arrastre");
         m_panel.ToggleDragMode();
         return;
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
   }
   
   // Para eventos de clic en el chart (fuera de objetos)
   if(id == CHARTEVENT_CLICK)
   {
      // Si estamos en modo arrastre, desactivarlo con cualquier clic en el chart
      if(g_is_dragging && g_drag_toggle_mode && m_panel != NULL)
      {
         m_panel.StopDragging();
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