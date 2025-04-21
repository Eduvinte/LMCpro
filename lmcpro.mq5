//+------------------------------------------------------------------+
//|                                                      lmcpro.mq5 |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"
#property version     "1.00"
#property indicator_chart_window

// Añadir recurso de imagen para el engranaje
#resource "\\Images\\gear_icon.bmp"
// Añadir recurso de imagen para el título
#resource "\\Images\\iconlmcpro.bmp"

// Incluir módulos del sistema
#include <LMCPro\Core\Constants.mqh>
#include <LMCPro\Core\Globals.mqh>
#include <LMCPro\Core\StateManager.mqh>
#include <LMCPro\Core\EventHandler.mqh>
#include <LMCPro\UI\Panel.mqh>
#include <LMCPro\UI\SymbolSelector.mqh>
#include <LMCPro\UI\Tooltip.mqh>
#include <LMCPro\UI\ThemeManager.mqh>
#include <LMCPro\UI\InfoPanel.mqh>
// --- NUEVOS INCLUDES PARA PESTAÑAS Y VISTAS ---
#include <LMCPro\UI\TabManager.mqh>
#include <LMCPro\UI\TradeView.mqh>
#include <LMCPro\UI\ManageView.mqh>
#include <LMCPro\UI\GridView.mqh>

// Variables globales para referencias a objetos 
CPanel*           g_panel = NULL;              // Panel principal
CSymbolSelector*  g_symbolSelector = NULL;     // Selector de símbolos
CTooltip*         g_tooltip = NULL;            // Sistema de tooltips
CThemeManager*    g_themeManager = NULL;       // Administrador de temas
CInfoPanel*       g_infoPanel = NULL;          // Panel de información
CStateManager*    g_stateManager = NULL;       // Administrador de estado
CEventHandler*    g_eventHandler = NULL;       // Manejador de eventos
// --- NUEVAS VARIABLES GLOBALES PARA PESTAÑAS Y VISTAS ---
CTabManager*      g_tabManager = NULL;         // Gestor de pestañas
CTradeView*       g_tradeView = NULL;          // Vista de Trade
CManageView*      g_manageView = NULL;         // Vista de Manage
CGridView*        g_gridView = NULL;           // Vista de Grid

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   // Inicializar componentes
   g_themeManager = new CThemeManager();
   if(g_themeManager != NULL) g_themeManager.Initialize();
   
   g_panel = new CPanel(g_themeManager);
   if(g_panel == NULL) {
      Print("Error: No se pudo crear el panel principal");
      return INIT_FAILED;
   }
   
   if(!g_panel.Initialize(g_panelX, g_panelY, g_panelWidth, g_panelHeight))
   {
      Print("Error: No se pudo inicializar el panel principal");
      return INIT_FAILED;
   }
   
   g_symbolSelector = new CSymbolSelector(g_themeManager);
   if(g_symbolSelector == NULL) {
      Print("Error: No se pudo crear el selector de símbolos");
      return INIT_FAILED;
   }
   
   if(!g_symbolSelector.Initialize(g_panelX, g_panelY + 24, g_panelWidth))
   {
      Print("Error: No se pudo inicializar el selector de símbolos");
      return INIT_FAILED;
   }
   
   g_tooltip = new CTooltip(g_themeManager);
   if(g_tooltip == NULL) {
      Print("Error: No se pudo crear el sistema de tooltips");
      return INIT_FAILED;
   }
   
   g_tooltip.Initialize();
   
   g_infoPanel = new CInfoPanel(g_themeManager);
   if(g_infoPanel == NULL) {
      Print("Error: No se pudo crear el panel de información");
      return INIT_FAILED;
   }
   
   if(!g_infoPanel.Initialize(g_panelX, g_panelY + g_titleHeight + g_item_height, g_panelWidth, 30)) // Ajustar Y y altura si es necesario
   {
      Print("Error: No se pudo inicializar el panel de información");
      return INIT_FAILED;
   }
   
   // --- INICIALIZACIÓN DE PESTAÑAS Y VISTAS ---
   g_tabManager = new CTabManager(g_themeManager);
   if (g_tabManager == NULL) { Print("Error creando TabManager"); return INIT_FAILED; }
   // La Y de las pestañas será justo debajo del InfoPanel
   int tabManagerY = g_panelY + g_titleHeight + g_item_height + 30; // Ajustar '30' si la altura de InfoPanel cambió
   if (!g_tabManager.Initialize(g_panelX, tabManagerY, g_panelWidth))
   {
      Print("Error inicializando TabManager");
      return INIT_FAILED;
   }

   // Calcular área para las vistas (debajo de las pestañas)
   // !!! Necesitas añadir GetTabButtonHeight() a CTabManager !!!
   int viewAreaY = tabManagerY + 25; // Asumiendo altura 25 por ahora, usa g_tabManager.GetTabButtonHeight() cuando lo añadas
   int viewAreaHeight = g_panelHeight - (viewAreaY - g_panelY); // Altura restante en el panel
   if (viewAreaHeight < 50) viewAreaHeight = 50; // Asegurar una altura mínima

   g_tradeView = new CTradeView(g_themeManager);
   if (g_tradeView == NULL) { Print("Error creando TradeView"); return INIT_FAILED; }
   if (!g_tradeView.Initialize(g_panelX, viewAreaY, g_panelWidth, viewAreaHeight))
   {
      Print("Error inicializando TradeView");
      return INIT_FAILED;
   }

   g_manageView = new CManageView(g_themeManager);
   if (g_manageView == NULL) { Print("Error creando ManageView"); return INIT_FAILED; }
   if (!g_manageView.Initialize(g_panelX, viewAreaY, g_panelWidth, viewAreaHeight))
   {
      Print("Error inicializando ManageView");
      return INIT_FAILED;
   }

   g_gridView = new CGridView(g_themeManager);
   if (g_gridView == NULL) { Print("Error creando GridView"); return INIT_FAILED; }
   if (!g_gridView.Initialize(g_panelX, viewAreaY, g_panelWidth, viewAreaHeight))
   {
      Print("Error inicializando GridView");
      return INIT_FAILED;
   }

   // Mostrar la vista inicial (TRADE)
   g_tradeView.Show();
   // --- FIN INICIALIZACIÓN PESTAÑAS Y VISTAS ---
   
   g_stateManager = new CStateManager();
   if(g_stateManager == NULL) {
      Print("Error: No se pudo crear el administrador de estado");
      return INIT_FAILED;
   }
   
   // Inicializar el manejador de eventos e integrar los componentes
   g_eventHandler = new CEventHandler();
   if(g_eventHandler == NULL) {
      Print("Error: No se pudo crear el manejador de eventos");
      return INIT_FAILED;
   }
   
   g_eventHandler.SetPanel(g_panel);
   g_eventHandler.SetSymbolSelector(g_symbolSelector);
   g_eventHandler.SetTooltip(g_tooltip);
   g_eventHandler.SetInfoPanel(g_infoPanel);
   g_eventHandler.SetThemeManager(g_themeManager);
   
   if(!g_eventHandler.Initialize())
   {
      Print("Error: No se pudo inicializar el manejador de eventos");
      return INIT_FAILED;
   }
   
   // Cargar estado guardado
   if(!g_stateManager.LoadAllSettings())
   {
      // Si no hay configuración guardada, usar valores predeterminados
      g_stateManager.ResetToDefaults();
   }
   
   // Aplicar tema
   g_themeManager.ApplyTheme(g_dark_theme);
   
   // Inicializar indicador ATR
   g_infoPanel.InitializeATR();
   
   // Establecer timer
   EventSetMillisecondTimer(TIMER_INTERVAL);
   
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                        |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Guardar configuración
   if(g_stateManager != NULL) {
      g_stateManager.SaveAllSettings();
   }
   
   // Detener el timer
   EventKillTimer();
   
   // Liberar el indicador ATR
   if(g_atr_handle != INVALID_HANDLE) {
      IndicatorRelease(g_atr_handle);
      g_atr_handle = INVALID_HANDLE;
   }
   
   // Eliminar objetos
   delete g_panel;
   delete g_symbolSelector;
   delete g_tooltip;
   delete g_themeManager;
   delete g_infoPanel;
   delete g_stateManager;
   delete g_eventHandler;
   // --- ELIMINAR NUEVOS OBJETOS ---
   delete g_tabManager;
   delete g_tradeView;
   delete g_manageView;
   delete g_gridView;
   
   g_panel = NULL;
   g_symbolSelector = NULL;
   g_tooltip = NULL;
   g_themeManager = NULL;
   g_infoPanel = NULL;
   g_stateManager = NULL;
   g_eventHandler = NULL;
   // --- PONER NUEVOS PUNTEROS A NULL ---
   g_tabManager = NULL;
   g_tradeView = NULL;
   g_manageView = NULL;
   g_gridView = NULL;
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   return rates_total;
}

//+------------------------------------------------------------------+
//| Custom event handler                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   // --- MANEJO DEL CAMBIO DE PESTAÑA ---
   if (id == CHARTEVENT_OBJECT_CLICK)
   {
       // Comprobar si g_tabManager existe antes de usarlo
       if (g_tabManager != NULL && g_tabManager.OnClick(sparam)) // Si TabManager manejó el clic (cambio de pestaña)
       {
           ENUM_ACTIVE_TAB activeTab = g_tabManager.GetActiveTab();

           // Ocultar todas las vistas
           if (g_tradeView != NULL) g_tradeView.Hide();
           if (g_manageView != NULL) g_manageView.Hide();
           if (g_gridView != NULL) g_gridView.Hide();

           // Mostrar la vista activa
           switch(activeTab)
           {
              case TAB_TRADE:
                 if (g_tradeView != NULL) g_tradeView.Show();
                 break;
              case TAB_MANAGE:
                 if (g_manageView != NULL) g_manageView.Show();
                 break;
              case TAB_GRID:
                 if (g_gridView != NULL) g_gridView.Show();
                 break;
           }
           ChartRedraw();
           return; // El evento fue manejado por el cambio de pestaña, no pasar a EventHandler
       }
       
       // --- MANEJO DE CLICS EN CHECKBOXES DE TRADEVIEW ---
       // Importante: Sin 'else' aquí, probar todos los tipos de clics
       if ((StringFind(sparam, TP_CHECKBOX_NAME, 0) >= 0 || StringFind(sparam, SL_CHECKBOX_NAME, 0) >= 0))
       {
           // Asegúrate de que g_tradeView exista y esté inicializada y visible
           if(CheckPointer(g_tradeView) == POINTER_INVALID)
           {
               Print("Error: g_tradeView no es válido en OnChartEvent para checkbox click.");
           }
           else if(g_tradeView.IsVisible()) // Solo procesar si la vista está visible
           {
               Print("DEBUG: Toggleando estado del checkbox: ", sparam);
               g_tradeView.ToggleCheckboxState(sparam);
               // No necesitas ChartRedraw() aquí porque ToggleCheckboxState ya lo hace
               return; // Indica que el evento fue manejado
           }
       }
       // --- FIN MANEJO CLICS CHECKBOXES ---
   }

   // --- FIN MANEJO CAMBIO DE PESTAÑA ---

   // Si el evento no fue un cambio de pestaña, pasarlo al manejador general
   // Comprobar si g_eventHandler existe antes de usarlo
   if (g_eventHandler != NULL)
   {
       g_eventHandler.OnChartEvent(id, lparam, dparam, sparam);
   }
}

//+------------------------------------------------------------------+
//| Timer event handler                                               |
//+------------------------------------------------------------------+
void OnTimer()
{
   if(g_eventHandler != NULL) {
      g_eventHandler.OnTimer();
   }
} 