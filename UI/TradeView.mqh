//+------------------------------------------------------------------+
//|                                                   TradeView.mqh  |
//|              Vista para la pestaña "TRADE"                      |
//|                  Copyright 2024, Tu Nombre/Empresa               |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Tu Nombre/Empresa"
#property link      ""

#include "../Core/Globals.mqh"
#include "ThemeManager.mqh"

//--- Definiciones de nombres de objetos para la vista TRADE
#define TRADEVIEW_PREFIX         "TradeView_"
#define LOT_CALC_BUTTON_NAME     TRADEVIEW_PREFIX + "LotCalcBtn"
#define SIZE_LABEL_NAME          TRADEVIEW_PREFIX + "SizeLabel"
#define SIZE_DROPDOWN_BTN_NAME   TRADEVIEW_PREFIX + "SizeDropdownBtn" // Botón para simular dropdown
#define VALUE_EDIT_NAME          TRADEVIEW_PREFIX + "ValueEdit"
#define VALUE_UP_BTN_NAME        TRADEVIEW_PREFIX + "ValueUpBtn"
#define VALUE_DOWN_BTN_NAME      TRADEVIEW_PREFIX + "ValueDownBtn"

//+------------------------------------------------------------------+
//| Clase para la vista de la pestaña TRADE                          |
//+------------------------------------------------------------------+
class CTradeView
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
   bool              CreateLotCalcButton(int x, int y);
   bool              CreateSizeSelector(int x, int y); // Crear etiqueta + botón dropdown simulado
   bool              CreateValueInput(int x, int y);   // Crear Edit + botones Up/Down
   void              AddObjectName(const string name); // Ayudante para registrar nombres

public:
                     CTradeView(CThemeManager* themeManager);
                    ~CTradeView();

   //--- Inicialización y creación
   //    x, y: esquina superior izquierda del área disponible para esta vista
   //    width, height: dimensiones del área disponible
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
CTradeView::CTradeView(CThemeManager* themeManager) : m_themeManager(themeManager),
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
CTradeView::~CTradeView()
{
   Destroy();
}

//+------------------------------------------------------------------+
//| Registra un nombre de objeto para limpieza posterior            |
//+------------------------------------------------------------------+
void CTradeView::AddObjectName(const string name)
{
   int size = ArraySize(m_object_names);
   ArrayResize(m_object_names, size + 1);
   m_object_names[size] = name;
}

//+------------------------------------------------------------------+
//| Inicializa el área de la vista                                   |
//+------------------------------------------------------------------+
bool CTradeView::Initialize(int x, int y, int width, int height)
{
   m_viewX = x;
   m_viewY = y;
   m_viewWidth = width;
   m_viewHeight = height; // Guardamos el área, aunque no creemos un contenedor visible

   if (!CreateControls())
   {
      Print("Error creando controles para TradeView");
      return false;
   }
   
   // Por defecto, la vista empieza oculta
   Hide();

   return true;
}

//+------------------------------------------------------------------+
//| Crea todos los controles de la vista                             |
//+------------------------------------------------------------------+
bool CTradeView::CreateControls()
{
   // Dimensiones y espaciado
   int lotCalcWidth = 80;
   int sizeSelectorWidth = 150;
   int valueInputWidth = 50 + 1 + 20; // Edit + spacing + Buttons
   int elementHeight = 20; 
   int spacing = 5;      
   int currentY = 15; // Margen superior actual

   // Calcular ancho total de los elementos + espaciados
   int totalElementsWidth = lotCalcWidth + spacing + sizeSelectorWidth + spacing + valueInputWidth;

   // Calcular el margen izquierdo para centrar
   int leftMargin = 0;
   if (m_viewWidth > totalElementsWidth)
   {
      leftMargin = (m_viewWidth - totalElementsWidth) / 2;
   }
   // Asegurar que el margen no sea negativo si el panel es muy estrecho
   if (leftMargin < 0) leftMargin = 5; // Un pequeño margen por defecto si no caben

   // Calcular posiciones X relativas usando el margen
   int lotCalcX = leftMargin;
   int sizeSelectorX = lotCalcX + lotCalcWidth + spacing;
   int valueInputX = sizeSelectorX + sizeSelectorWidth + spacing;

   // 1. Botón "Lot Calc"
   if (!CreateLotCalcButton(lotCalcX, currentY)) return false;

   // 2. Selector de Tamaño (Label + Botón Dropdown)
   if (!CreateSizeSelector(sizeSelectorX, currentY)) return false;

   // 3. Input de Valor (Edit + Botones Up/Down)
   if (!CreateValueInput(valueInputX, currentY)) return false;

   return true;
}

//+------------------------------------------------------------------+
//| Crea el botón "Lot Calc"                                         |
//+------------------------------------------------------------------+
bool CTradeView::CreateLotCalcButton(int x, int y)
{
   string name = LOT_CALC_BUTTON_NAME;
   int buttonWidth = 80;
   int buttonHeight = 20;

   if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_viewX + x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, buttonHeight);
   ObjectSetString(0, name, OBJPROP_TEXT, "Lot Calc");
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'80,80,100'); // Color ejemplo
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, name, OBJPROP_STATE, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(name);
   return true;
}

//+------------------------------------------------------------------+
//| Crea el selector de Tamaño (Label + Botón simulado)             |
//+------------------------------------------------------------------+
bool CTradeView::CreateSizeSelector(int x, int y)
{
   // Creamos un "botón" que parezca un dropdown
   string name = SIZE_DROPDOWN_BTN_NAME;
   int controlWidth = 150;
   int controlHeight = 20;
   
   if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_viewX + x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, controlWidth);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, controlHeight);
   // Usamos Wingdings 3 para el carácter de flecha hacia abajo '' (o puedes usar '▼')
   ObjectSetString(0, name, OBJPROP_TEXT, "Size: $ Currency    ▼"); 
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'60,60,80'); // Color ejemplo
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, name, OBJPROP_STATE, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   //ObjectSetString(0, name, OBJPROP_FONT, "Wingdings 3"); // Descomenta si usas Wingdings
   //ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 12); // Ajusta tamaño si usas Wingdings
   AddObjectName(name);
   return true;
}

//+------------------------------------------------------------------+
//| Crea el input de Valor (Edit + Botones Up/Down)                 |
//+------------------------------------------------------------------+
bool CTradeView::CreateValueInput(int x, int y)
{
   int editWidth = 50;
   int buttonWidth = 20;
   int controlHeight = 20;
   int spacing = 1; // Espacio mínimo entre edit y botones

   // 1. Campo de Edición
   string editName = VALUE_EDIT_NAME;
   if(!ObjectCreate(0, editName, OBJ_EDIT, 0, 0, 0)) return false;
   ObjectSetInteger(0, editName, OBJPROP_XDISTANCE, m_viewX + x);
   ObjectSetInteger(0, editName, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, editName, OBJPROP_XSIZE, editWidth);
   ObjectSetInteger(0, editName, OBJPROP_YSIZE, controlHeight);
   ObjectSetString(0, editName, OBJPROP_TEXT, "5.00");
   ObjectSetInteger(0, editName, OBJPROP_BGCOLOR, clrWhite);
   ObjectSetInteger(0, editName, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, editName, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, editName, OBJPROP_ALIGN, ALIGN_RIGHT); // Alinear texto a la derecha
   ObjectSetInteger(0, editName, OBJPROP_BACK, false);
   ObjectSetInteger(0, editName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, editName, OBJPROP_READONLY, false); // Permitir edición
   AddObjectName(editName);

   // 2. Botón Subir (Arriba)
   string upName = VALUE_UP_BTN_NAME;
   if(!ObjectCreate(0, upName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, upName, OBJPROP_XDISTANCE, m_viewX + x + editWidth + spacing);
   ObjectSetInteger(0, upName, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, upName, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, upName, OBJPROP_YSIZE, controlHeight / 2); // Mitad de altura
   ObjectSetString(0, upName, OBJPROP_TEXT, "▲"); // Flecha arriba
   ObjectSetInteger(0, upName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, upName, OBJPROP_BGCOLOR, C'90,90,110');
   ObjectSetInteger(0, upName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, upName, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, upName, OBJPROP_STATE, false);
   ObjectSetInteger(0, upName, OBJPROP_BACK, false);
   ObjectSetInteger(0, upName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(upName);

   // 3. Botón Bajar (Abajo)
   string downName = VALUE_DOWN_BTN_NAME;
   if(!ObjectCreate(0, downName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, downName, OBJPROP_XDISTANCE, m_viewX + x + editWidth + spacing);
   ObjectSetInteger(0, downName, OBJPROP_YDISTANCE, m_viewY + y + controlHeight / 2); // Debajo del botón Up
   ObjectSetInteger(0, downName, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, downName, OBJPROP_YSIZE, controlHeight / 2); // Mitad de altura
   ObjectSetString(0, downName, OBJPROP_TEXT, "▼"); // Flecha abajo
   ObjectSetInteger(0, downName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, downName, OBJPROP_BGCOLOR, C'90,90,110');
   ObjectSetInteger(0, downName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, downName, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, downName, OBJPROP_STATE, false);
   ObjectSetInteger(0, downName, OBJPROP_BACK, false);
   ObjectSetInteger(0, downName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(downName);

   return true;
}


//+------------------------------------------------------------------+
//| Muestra todos los controles de la vista                          |
//+------------------------------------------------------------------+
void CTradeView::Show()
{
   if(m_visible) return; // Ya visible
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      ObjectSetInteger(0, m_object_names[i], OBJPROP_HIDDEN, false);
   }
   m_visible = true;
   //ChartRedraw(); // Opcional: redibujar si es necesario
}

//+------------------------------------------------------------------+
//| Oculta todos los controles de la vista                           |
//+------------------------------------------------------------------+
void CTradeView::Hide()
{
   if(!m_visible) return; // Ya oculto
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      ObjectSetInteger(0, m_object_names[i], OBJPROP_HIDDEN, true);
   }
   m_visible = false;
   //ChartRedraw(); // Opcional: redibujar si es necesario
}

//+------------------------------------------------------------------+
//| Mueve todos los objetos de la vista                              |
//+------------------------------------------------------------------+
void CTradeView::MoveView(int dx, int dy)
{
   // Actualizar coordenadas base de la vista
   m_viewX += dx;
   m_viewY += dy;
   
   // Mover cada objeto registrado
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
void CTradeView::Destroy()
{
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      ObjectDelete(0, m_object_names[i]);
   }
   ArrayResize(m_object_names, 0); // Limpiar el array
   m_visible = false;
}
//+------------------------------------------------------------------+ 