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

// Variables globales para referencias a objetos 
CPanel*           g_panel = NULL;              // Panel principal
CSymbolSelector*  g_symbolSelector = NULL;     // Selector de símbolos
CTooltip*         g_tooltip = NULL;            // Sistema de tooltips
CThemeManager*    g_themeManager = NULL;       // Administrador de temas
CInfoPanel*       g_infoPanel = NULL;          // Panel de información
CStateManager*    g_stateManager = NULL;       // Administrador de estado
CEventHandler*    g_eventHandler = NULL;       // Manejador de eventos

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
   
   if(!g_symbolSelector.Initialize(g_panelX + 10, g_panelY + 35, g_panelWidth - 20))
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
   
   if(!g_infoPanel.Initialize(g_panelX + 10, g_panelY + 70, g_panelWidth - 20, 120))
   {
      Print("Error: No se pudo inicializar el panel de información");
      return INIT_FAILED;
   }
   
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
   
   g_panel = NULL;
   g_symbolSelector = NULL;
   g_tooltip = NULL;
   g_themeManager = NULL;
   g_infoPanel = NULL;
   g_stateManager = NULL;
   g_eventHandler = NULL;
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
   if(g_eventHandler != NULL) {
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