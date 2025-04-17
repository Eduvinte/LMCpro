//+------------------------------------------------------------------+
//|                                               StateManager.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

#include "Constants.mqh"
#include "Globals.mqh"

//+------------------------------------------------------------------+
//| Clase para gestionar el estado global de la aplicación           |
//+------------------------------------------------------------------+
class CStateManager
{
private:
   // Variables para almacenar configuración persistente
   string            m_varPrefix;            // Prefijo para las variables globales
   string            m_configFilename;       // Nombre del archivo de configuración
   bool              m_initialized;          // Indica si el gestor está inicializado

public:
                     CStateManager();
                    ~CStateManager();
   
   // Métodos de inicialización
   bool              Initialize();
   
   // Métodos para cargar y guardar configuraciones
   bool              LoadAllSettings();
   bool              SaveAllSettings();
   void              ResetToDefaults();
   
   // Métodos para gestionar variables globales persistentes
   bool              SaveGlobalVariable(string name, double value);
   double            LoadGlobalVariable(string name, double defaultValue = 0.0);
   bool              SaveGlobalString(string name, string value);
   string            LoadGlobalString(string name, string defaultValue = "");
   bool              SaveGlobalBool(string name, bool value);
   bool              LoadGlobalBool(string name, bool defaultValue = false);
   
   // Métodos para gestionar configuraciones específicas
   bool              SavePanelSettings();
   bool              LoadPanelSettings();
   bool              SaveThemeSettings();
   bool              LoadThemeSettings();
   
   // Métodos de control de estado de la aplicación
   void              ToggleExpanded();
   void              ToggleTheme();
   bool              IsDarkTheme() { return g_dark_theme; }
   void              SetDarkTheme(bool value);
   void              ClearAllSettings();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CStateManager::CStateManager()
{
   m_varPrefix = GLOBAL_VAR_PREFIX;
   m_configFilename = "LMCPro_config.bin";
   m_initialized = false;
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CStateManager::~CStateManager()
{
   // Guardar configuraciones al finalizar si está inicializado
   if(m_initialized)
      SaveAllSettings();
}

//+------------------------------------------------------------------+
//| Inicializa el gestor de estado                                   |
//+------------------------------------------------------------------+
bool CStateManager::Initialize()
{
   if(m_initialized)
      return true;
      
   m_initialized = true;
   return true;
}

//+------------------------------------------------------------------+
//| Carga todas las configuraciones guardadas                        |
//+------------------------------------------------------------------+
bool CStateManager::LoadAllSettings()
{
   bool result = true;
   
   // Intentar cargar desde variables globales primero
   if(!LoadPanelSettings())
      result = false;
      
   if(!LoadThemeSettings())
      result = false;
      
   // Si no se pudo cargar nada, usar valores predeterminados
   if(!result)
      ResetToDefaults();
   
   return result;
}

//+------------------------------------------------------------------+
//| Guarda todas las configuraciones                                 |
//+------------------------------------------------------------------+
bool CStateManager::SaveAllSettings()
{
   bool result = true;
   
   if(!SavePanelSettings())
      result = false;
      
   if(!SaveThemeSettings())
      result = false;
      
   return result;
}

//+------------------------------------------------------------------+
//| Restablece todos los valores a predeterminados                   |
//+------------------------------------------------------------------+
void CStateManager::ResetToDefaults()
{
   // Valores predeterminados para posición del panel
   g_panelX = 20;
   g_panelY = 20;
   g_panelWidth = DEFAULT_PANEL_WIDTH;
   g_panelHeight = DEFAULT_PANEL_HEIGHT;
   
   // Tema oscuro por defecto
   g_dark_theme = true;
   
   // Panel expandido por defecto
   g_panel_expanded = true;
   
   // Actualizar variables y colores basados en el tema
   UpdateThemeColors();
   
   m_initialized = true;
}

//+------------------------------------------------------------------+
//| Guarda una variable global numérica                              |
//+------------------------------------------------------------------+
bool CStateManager::SaveGlobalVariable(string name, double value)
{
   string fullName = m_varPrefix + name;
   return GlobalVariableSet(fullName, value);
}

//+------------------------------------------------------------------+
//| Carga una variable global numérica                               |
//+------------------------------------------------------------------+
double CStateManager::LoadGlobalVariable(string name, double defaultValue = 0.0)
{
   string fullName = m_varPrefix + name;
   if(GlobalVariableCheck(fullName))
      return GlobalVariableGet(fullName);
   return defaultValue;
}

//+------------------------------------------------------------------+
//| Guarda una variable global tipo string                           |
//+------------------------------------------------------------------+
bool CStateManager::SaveGlobalString(string name, string value)
{
   // Para simplificar, solo guardamos el primer carácter como representación
   // En una implementación real, se podría serializar el string completo
   return SaveGlobalVariable(name + "_STR", StringGetCharacter(value, 0));
}

//+------------------------------------------------------------------+
//| Carga una variable global tipo string                            |
//+------------------------------------------------------------------+
string CStateManager::LoadGlobalString(string name, string defaultValue = "")
{
   if(GlobalVariableCheck(m_varPrefix + name + "_STR"))
   {
      double value = LoadGlobalVariable(name + "_STR");
      if(value != 0.0)
         return CharToString((uchar)value);
   }
   return defaultValue;
}

//+------------------------------------------------------------------+
//| Guarda una variable global tipo bool                             |
//+------------------------------------------------------------------+
bool CStateManager::SaveGlobalBool(string name, bool value)
{
   return SaveGlobalVariable(name + "_BOOL", value ? 1 : 0);
}

//+------------------------------------------------------------------+
//| Carga una variable global tipo bool                              |
//+------------------------------------------------------------------+
bool CStateManager::LoadGlobalBool(string name, bool defaultValue = false)
{
   if(GlobalVariableCheck(m_varPrefix + name + "_BOOL"))
      return LoadGlobalVariable(name + "_BOOL") != 0;
   return defaultValue;
}

//+------------------------------------------------------------------+
//| Guarda configuraciones del panel                                 |
//+------------------------------------------------------------------+
bool CStateManager::SavePanelSettings()
{
   bool result = true;
   
   // Guardar usando variables globales
   if(!SaveGlobalVariable("PanelX", g_panelX))
      result = false;
      
   if(!SaveGlobalVariable("PanelY", g_panelY))
      result = false;
      
   if(!SaveGlobalVariable("PanelWidth", g_panelWidth))
      result = false;
      
   if(!SaveGlobalVariable("PanelHeight", g_panelHeight))
      result = false;
      
   if(!SaveGlobalBool("PanelExpanded", g_panel_expanded))
      result = false;
      
   return result;
}

//+------------------------------------------------------------------+
//| Carga configuraciones del panel                                  |
//+------------------------------------------------------------------+
bool CStateManager::LoadPanelSettings()
{
   bool result = false;
   
   // Verificar si existen variables guardadas
   if(GlobalVariableCheck(m_varPrefix + "PanelX"))
   {
      g_panelX = (int)LoadGlobalVariable("PanelX", 20);
      g_panelY = (int)LoadGlobalVariable("PanelY", 20);
      g_panelWidth = (int)LoadGlobalVariable("PanelWidth", DEFAULT_PANEL_WIDTH);
      g_panelHeight = (int)LoadGlobalVariable("PanelHeight", DEFAULT_PANEL_HEIGHT);
      g_panel_expanded = LoadGlobalBool("PanelExpanded", true);
      
      // Ajustar altura del panel según el estado de expansión
      if(!g_panel_expanded)
         g_panelHeight = PANEL_HEIGHT_COLLAPSED;
         
      result = true;
   }
   
   return result;
}

//+------------------------------------------------------------------+
//| Guarda configuraciones de tema                                   |
//+------------------------------------------------------------------+
bool CStateManager::SaveThemeSettings()
{
   return SaveGlobalBool("DarkTheme", g_dark_theme);
}

//+------------------------------------------------------------------+
//| Carga configuraciones de tema                                    |
//+------------------------------------------------------------------+
bool CStateManager::LoadThemeSettings()
{
   bool result = false;
   
   if(GlobalVariableCheck(m_varPrefix + "DarkTheme_BOOL"))
   {
      g_dark_theme = LoadGlobalBool("DarkTheme", true);
      // Actualizar colores basados en el tema
      UpdateThemeColors();
      result = true;
   }
   
   return result;
}

//+------------------------------------------------------------------+
//| Cambia el estado de expansión del panel                          |
//+------------------------------------------------------------------+
void CStateManager::ToggleExpanded()
{
   g_panel_expanded = !g_panel_expanded;
   
   // Actualizar la altura del panel según el estado
   if(g_panel_expanded)
      g_panelHeight = PANEL_HEIGHT_EXPANDED;
   else
      g_panelHeight = PANEL_HEIGHT_COLLAPSED;
      
   // Guardar el nuevo estado
   SaveGlobalBool("PanelExpanded", g_panel_expanded);
}

//+------------------------------------------------------------------+
//| Cambia el tema actual                                            |
//+------------------------------------------------------------------+
void CStateManager::ToggleTheme()
{
   g_dark_theme = !g_dark_theme;
   
   // Actualizar colores basados en el nuevo tema
   UpdateThemeColors();
   
   // Guardar el nuevo estado
   SaveThemeSettings();
}

//+------------------------------------------------------------------+
//| Establece directamente el tema                                   |
//+------------------------------------------------------------------+
void CStateManager::SetDarkTheme(bool value)
{
   if(g_dark_theme != value)
   {
      g_dark_theme = value;
      
      // Actualizar colores basados en el nuevo tema
      UpdateThemeColors();
      
      // Guardar el nuevo estado
      SaveThemeSettings();
   }
}

//+------------------------------------------------------------------+
//| Elimina todas las configuraciones guardadas                      |
//+------------------------------------------------------------------+
void CStateManager::ClearAllSettings()
{
   // Eliminamos todas las variables globales que pertenecen a este programa
   for(int i = GlobalVariablesTotal() - 1; i >= 0; i--)
   {
      string name = GlobalVariableName(i);
      if(StringFind(name, m_varPrefix) == 0)
         GlobalVariableDel(name);
   }
} 