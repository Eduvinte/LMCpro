//+------------------------------------------------------------------+
//|                                                   GridView.mqh   |
//|              Vista para la pestaña "GRID"                       |
//|                  Copyright 2024, Tu Nombre/Empresa               |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Tu Nombre/Empresa"
#property link      ""

#include "../Core/Globals.mqh"
#include "ThemeManager.mqh"

//--- Definiciones de nombres de objetos (si son necesarios más adelante)
#define GRIDVIEW_PREFIX "GridView_"
// #define SOME_GRID_CONTROL_NAME GRIDVIEW_PREFIX + "SomeControl"

//+------------------------------------------------------------------+
//| Clase para la vista de la pestaña GRID                           |
//+------------------------------------------------------------------+
class CGridView
{
private:
   CThemeManager*    m_themeManager;
   int               m_viewX;           // Posición X del área de la vista
   int               m_viewY;           // Posición Y del área de la vista
   int               m_viewWidth;       // Ancho del área de la vista
   int               m_viewHeight;      // Alto del área de la vista
   bool              m_visible;         // Estado de visibilidad

   //--- Nombres de los objetos creados por esta vista
   string            m_object_names[]; // Array dinámico para guardar nombres

   //--- Métodos privados
   // bool              CreateSpecificGridControls(); // Añadir controles específicos aquí
   void              AddObjectName(const string name); // Ayudante para registrar nombres

public:
                     CGridView(CThemeManager* themeManager);
                    ~CGridView();

   //--- Inicialización y creación
   bool              Initialize(int x, int y, int width, int height);
   bool              CreateControls();  // Crea todos los controles de la vista

   //--- Visibilidad
   void              Show();
   void              Hide();
   bool              IsVisible() const { return m_visible; }

   //--- Movimiento y destrucción
   void              MoveView(int dx, int dy); // Mueve todos los objetos de la vista
   void              Destroy();          // Elimina todos los objetos de la vista
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CGridView::CGridView(CThemeManager* themeManager) : m_themeManager(themeManager),
                                                     m_viewX(0),
                                                     m_viewY(0),
                                                     m_viewWidth(0),
                                                     m_viewHeight(0),
                                                     m_visible(false) // Empieza oculta
{
   ArrayResize(m_object_names, 0); // Inicializar array vacío
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CGridView::~CGridView()
{
   Destroy();
}

//+------------------------------------------------------------------+
//| Registra un nombre de objeto para limpieza posterior            |
//+------------------------------------------------------------------+
void CGridView::AddObjectName(const string name)
{
   int size = ArraySize(m_object_names);
   ArrayResize(m_object_names, size + 1);
   m_object_names[size] = name;
}

//+------------------------------------------------------------------+
//| Inicializa el área de la vista                                   |
//+------------------------------------------------------------------+
bool CGridView::Initialize(int x, int y, int width, int height)
{
   m_viewX = x;
   m_viewY = y;
   m_viewWidth = width;
   m_viewHeight = height;

   if (!CreateControls())
   {
      Print("Error creando controles para GridView");
      return false;
   }
   
   // Por defecto, la vista empieza oculta
   Hide();

   return true;
}

//+------------------------------------------------------------------+
//| Crea todos los controles de la vista (Implementación básica)    |
//+------------------------------------------------------------------+
bool CGridView::CreateControls()
{
   // TODO: Añadir aquí la creación de los controles específicos de GRID
   Print("GridView::CreateControls() - Placeholder, añadir controles reales.");
   return true;
}

//+------------------------------------------------------------------+
//| Muestra todos los controles de la vista                          |
//+------------------------------------------------------------------+
void CGridView::Show()
{
   if(m_visible) return; // Ya visible
   Print("Mostrando GridView"); // Mensaje de depuración
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      ObjectSetInteger(0, m_object_names[i], OBJPROP_HIDDEN, false);
   }
   m_visible = true;
   //ChartRedraw();
}

//+------------------------------------------------------------------+
//| Oculta todos los controles de la vista                           |
//+------------------------------------------------------------------+
void CGridView::Hide()
{
   if(!m_visible) return; // Ya oculto
   Print("Ocultando GridView"); // Mensaje de depuración
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      ObjectSetInteger(0, m_object_names[i], OBJPROP_HIDDEN, true);
   }
   m_visible = false;
   //ChartRedraw();
}

//+------------------------------------------------------------------+
//| Mueve todos los objetos de la vista                              |
//+------------------------------------------------------------------+
void CGridView::MoveView(int dx, int dy)
{
   m_viewX += dx;
   m_viewY += dy;
   
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      int current_x = (int)ObjectGetInteger(0, m_object_names[i], OBJPROP_XDISTANCE);
      int current_y = (int)ObjectGetInteger(0, m_object_names[i], OBJPROP_YDISTANCE);
      ObjectSetInteger(0, m_object_names[i], OBJPROP_XDISTANCE, current_x + dx);
      ObjectSetInteger(0, m_object_names[i], OBJPROP_YDISTANCE, current_y + dy);
   }
}

//+------------------------------------------------------------------+
//| Elimina todos los objetos creados por esta vista                 |
//+------------------------------------------------------------------+
void CGridView::Destroy()
{
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      ObjectDelete(0, m_object_names[i]);
   }
   ArrayResize(m_object_names, 0);
   m_visible = false;
}
//+------------------------------------------------------------------+ 