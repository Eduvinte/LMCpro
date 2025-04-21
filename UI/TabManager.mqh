//+------------------------------------------------------------------+
//|                                                  TabManager.mqh  |
//|                     Gestor para los botones de pestañas          |
//|                        Copyright 2024, Tu Nombre/Empresa         |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Tu Nombre/Empresa"
#property link      "" // Puedes poner tu sitio web o dejarlo vacío

#include "ThemeManager.mqh" // Asumiendo que usaremos colores del tema
#include "../Core/Globals.mqh" // Para variables globales si son necesarias

//--- Definiciones de nombres de objetos para las pestañas
#define TAB_BUTTON_TRADE_NAME "TabManager_TradeBtn"
#define TAB_BUTTON_MANAGE_NAME "TabManager_ManageBtn"
#define TAB_BUTTON_GRID_NAME "TabManager_GridBtn"

//--- Enumeración para las pestañas activas
enum ENUM_ACTIVE_TAB
{
   TAB_TRADE,
   TAB_MANAGE,
   TAB_GRID,
   TAB_NONE // Ninguna activa o estado inicial
};

//+------------------------------------------------------------------+
//| Clase para gestionar las pestañas                                 |
//+------------------------------------------------------------------+
class CTabManager
{
private:
   CThemeManager*    m_themeManager;
   int               m_panel_x;
   int               m_panel_y;
   int               m_panel_width;
   int               m_tab_button_y; // Posición Y común para los botones
   int               m_tab_button_height;
   int               m_tab_button_width; // Ancho calculado para cada botón

   string            m_button_names[3]; // Nombres de los objetos botón
   ENUM_ACTIVE_TAB   m_active_tab;      // Pestaña actualmente activa

   //--- Métodos privados para crear y estilizar botones
   bool              CreateTabButton(const string name, const string text, const int x, const int y, const int width, const int height);
   void              UpdateButtonStyles(); // Para cambiar el estilo de la pestaña activa

public:
                     CTabManager(CThemeManager* themeManager);
                    ~CTabManager();

   //--- Inicialización
   bool              Initialize(int panel_x, int panel_y_below_title, int panel_width);

   //--- Gestión de eventos y estado
   ENUM_ACTIVE_TAB   GetActiveTab() const { return m_active_tab; }
   bool              OnClick(const string clicked_object_name); // Procesa un clic y actualiza la pestaña activa

   //--- Actualización y destrucción
   void              MoveTabs(int dx, int dy); // Mueve las pestañas con el panel
   void              Destroy();          // Elimina los objetos de las pestañas
   void              ShowTabs();         // <-- AÑADIR ESTA LÍNEA
   void              HideTabs();         // <-- AÑADIR ESTA LÍNEA
   int               GetHeight() const { return m_tab_button_height; } // <-- AÑADIR ESTA LÍNEA (útil para calcular layout)
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTabManager::CTabManager(CThemeManager* themeManager) : m_themeManager(themeManager),
                                                       m_panel_x(0),
                                                       m_panel_y(0),
                                                       m_panel_width(0),
                                                       m_tab_button_y(0),
                                                       m_tab_button_height(25), // Altura fija para las pestañas
                                                       m_tab_button_width(0),
                                                       m_active_tab(TAB_TRADE) // Empezamos con TRADE activa por defecto
{
   m_button_names[0] = TAB_BUTTON_TRADE_NAME;
   m_button_names[1] = TAB_BUTTON_MANAGE_NAME;
   m_button_names[2] = TAB_BUTTON_GRID_NAME;
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTabManager::~CTabManager()
{
   Destroy();
}

//+------------------------------------------------------------------+
//| Inicializa y crea los botones de pestañas                         |
//+------------------------------------------------------------------+
bool CTabManager::Initialize(int panel_x, int panel_y_below_title, int panel_width)
{
   m_panel_x = panel_x;
   m_panel_y = panel_y_below_title; // Esta será la Y justo debajo de la barra de título
   m_panel_width = panel_width;
   m_tab_button_y = m_panel_y - 7; // Las pestañas empiezan 5px más arriba

   // Calculamos el ancho de cada botón (distribución equitativa, podrías ajustarlo)
   // Quitamos el margen de 10px para que ocupen todo el ancho
   int total_button_width_area = m_panel_width;
   if (total_button_width_area <= 0) total_button_width_area = 100; // Ancho mínimo
   m_tab_button_width = total_button_width_area / 3;

   int current_x = m_panel_x; // Empezamos desde el borde izquierdo (x=0 relativo al panel)

   // Crear los botones
   if(!CreateTabButton(m_button_names[0], "TRADE", current_x, m_tab_button_y, m_tab_button_width, m_tab_button_height)) return false;
   current_x += m_tab_button_width;
   if(!CreateTabButton(m_button_names[1], "MANAGE", current_x, m_tab_button_y, m_tab_button_width, m_tab_button_height)) return false;
   current_x += m_tab_button_width;
   if(!CreateTabButton(m_button_names[2], "GRID", current_x, m_tab_button_y, m_tab_button_width, m_tab_button_height)) return false;

   // Aplicar estilo inicial (resaltar la pestaña activa)
   UpdateButtonStyles();

   return true;
}

//+------------------------------------------------------------------+
//| Crea un botón de pestaña individual                             |
//+------------------------------------------------------------------+
bool CTabManager::CreateTabButton(const string name, const string text, const int x, const int y, const int width, const int height)
{
   // Usaremos OBJ_BUTTON para tener interacción directa
   if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
   {
      PrintFormat("Error creando botón de pestaña %s: %d", name, GetLastError());
      return false;
   }

   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite); // Color del texto
   // Los colores de fondo se manejarán en UpdateButtonStyles
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7); // Ajusta según necesites
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, COLOR_BORDER); // Usar color de borde global o del tema
   ObjectSetInteger(0, name, OBJPROP_STATE, false); // Estado inicial no presionado
   ObjectSetInteger(0, name, OBJPROP_BACK, false); // Para que esté visible sobre el panel principal
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);

   return true;
}

//+------------------------------------------------------------------+
//| Actualiza los estilos de los botones según la pestaña activa     |
//+------------------------------------------------------------------+
void CTabManager::UpdateButtonStyles()
{
   // Colores base (ejemplo, deberías usar tu ThemeManager)
   color active_bg_color = C'60,90,150'; // Un azul más oscuro para la activa
   color inactive_bg_color = C'40,50,70'; // Un gris/azul oscuro para inactivas
   color border_color = COLOR_BORDER; // O desde ThemeManager

   for(int i = 0; i < 3; i++)
   {
      bool is_active = (i == (int)m_active_tab);
      color current_bg = is_active ? active_bg_color : inactive_bg_color;

      ObjectSetInteger(0, m_button_names[i], OBJPROP_BGCOLOR, current_bg);
      ObjectSetInteger(0, m_button_names[i], OBJPROP_BORDER_COLOR, border_color);
      // Podrías cambiar también el color del texto si quisieras
      // ObjectSetInteger(0, m_button_names[i], OBJPROP_COLOR, is_active ? clrWhite : clrGray);
   }
}

//+------------------------------------------------------------------+
//| Procesa un clic en un objeto del gráfico                         |
//+------------------------------------------------------------------+
bool CTabManager::OnClick(const string clicked_object_name)
{
   ENUM_ACTIVE_TAB new_active_tab = TAB_NONE;

   if(clicked_object_name == m_button_names[0])
      new_active_tab = TAB_TRADE;
   else if(clicked_object_name == m_button_names[1])
      new_active_tab = TAB_MANAGE;
   else if(clicked_object_name == m_button_names[2])
      new_active_tab = TAB_GRID;

   // Si se hizo clic en una de nuestras pestañas y no es la que ya está activa
   if(new_active_tab != TAB_NONE && new_active_tab != m_active_tab)
   {
      m_active_tab = new_active_tab;
      UpdateButtonStyles(); // Actualiza la apariencia visual
      // Aquí podrías disparar un evento personalizado si fuera necesario
      // EventChartCustom(0, CUSTOM_EVENT_TAB_CHANGED, m_active_tab, 0, "");
      return true; // Indicamos que hemos manejado el clic
   }

   return false; // No era un clic en nuestras pestañas o era en la ya activa
}

//+------------------------------------------------------------------+
//| Mueve los botones de pestaña                                       |
//+------------------------------------------------------------------+
void CTabManager::MoveTabs(int dx, int dy)
{
   // Actualizar coordenadas base (si es necesario, aunque Initialize las fija)
   m_panel_x += dx;
   m_panel_y += dy;
   m_tab_button_y +=dy;

   // Mover cada botón
   for(int i = 0; i < 3; i++)
   {
      int current_x = (int)ObjectGetInteger(0, m_button_names[i], OBJPROP_XDISTANCE);
      int current_y = (int)ObjectGetInteger(0, m_button_names[i], OBJPROP_YDISTANCE);
      ObjectSetInteger(0, m_button_names[i], OBJPROP_XDISTANCE, current_x + dx);
      ObjectSetInteger(0, m_button_names[i], OBJPROP_YDISTANCE, current_y + dy);
   }
}

//+------------------------------------------------------------------+
//| Elimina los objetos de los botones de pestaña                     |
//+------------------------------------------------------------------+
void CTabManager::Destroy()
{
   for(int i = 0; i < 3; i++)
   {
      ObjectDelete(0, m_button_names[i]);
   }
}

//+------------------------------------------------------------------+
//| Muestra los botones de pestaña                                    |
//+------------------------------------------------------------------+
void CTabManager::ShowTabs()
{
   Print("Mostrando pestañas");
   for(int i = 0; i < 3; i++)
   {
      // Comprobar si el objeto existe antes de intentar modificarlo
      if(ObjectFind(0, m_button_names[i]) >= 0)
      {
         ObjectSetInteger(0, m_button_names[i], OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
      }
   }
}

//+------------------------------------------------------------------+
//| Oculta los botones de pestaña                                     |
//+------------------------------------------------------------------+
void CTabManager::HideTabs()
{
   Print("Ocultando pestañas");
   for(int i = 0; i < 3; i++)
   {
      // Comprobar si el objeto existe antes de intentar modificarlo
      if(ObjectFind(0, m_button_names[i]) >= 0)
      {
         ObjectSetInteger(0, m_button_names[i], OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
      }
   }
}
//+------------------------------------------------------------------+ 