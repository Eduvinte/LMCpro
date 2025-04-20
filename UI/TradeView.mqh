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

// --- NUEVOS CONTROLES FILA 2 ---
#define SEPARATOR_LINE_1_NAME    TRADEVIEW_PREFIX + "Separator1"
#define LOTS_LABEL_NAME          TRADEVIEW_PREFIX + "LotsLabel"
#define LOTS_EDIT_NAME           TRADEVIEW_PREFIX + "LotsEdit"
#define LOTS_UP_BTN_NAME         TRADEVIEW_PREFIX + "LotsUpBtn"
#define LOTS_DOWN_BTN_NAME       TRADEVIEW_PREFIX + "LotsDownBtn"
#define MARKET_BUTTON_NAME       TRADEVIEW_PREFIX + "MarketBtn"
#define PRICE_EDIT_NAME          TRADEVIEW_PREFIX + "PriceEdit"
#define PRICE_UP_BTN_NAME        TRADEVIEW_PREFIX + "PriceUpBtn"
#define PRICE_DOWN_BTN_NAME      TRADEVIEW_PREFIX + "PriceDownBtn"
#define PRICE_LABEL_NAME         TRADEVIEW_PREFIX + "PriceLabel"

// --- NUEVOS CONTROLES FILA 3 --- 
#define SEPARATOR_LINE_2_NAME    TRADEVIEW_PREFIX + "Separator2"
#define TP_CHECKBOX_NAME         TRADEVIEW_PREFIX + "TPCheckbox"
#define TP_LABEL_NAME            TRADEVIEW_PREFIX + "TPLabel"
#define TP_EDIT_NAME             TRADEVIEW_PREFIX + "TPEdit"
#define TP_UP_BTN_NAME           TRADEVIEW_PREFIX + "TPUpBtn"
#define TP_DOWN_BTN_NAME         TRADEVIEW_PREFIX + "TPDownBtn"
#define ATR_BUTTON_NAME          TRADEVIEW_PREFIX + "ATRBtn"
#define SL_EDIT_NAME             TRADEVIEW_PREFIX + "SLEdit"       // Usaremos este para el valor SL/ATR
#define SL_UP_BTN_NAME           TRADEVIEW_PREFIX + "SLUpBtn"
#define SL_DOWN_BTN_NAME         TRADEVIEW_PREFIX + "SLDownBtn"
#define SL_LABEL_NAME            TRADEVIEW_PREFIX + "SLLabel"
#define SL_CHECKBOX_NAME         TRADEVIEW_PREFIX + "SLCheckbox"

// --- NUEVOS CONTROLES FILA 4 ---
#define RTP_LABEL_NAME           TRADEVIEW_PREFIX + "RTPLabel"
#define RTP_EDIT_NAME            TRADEVIEW_PREFIX + "RTPEdit"
#define RTP_UP_BTN_NAME          TRADEVIEW_PREFIX + "RTPUpBtn"
#define RTP_DOWN_BTN_NAME        TRADEVIEW_PREFIX + "RTPDownBtn"
#define RR_BUTTON_NAME           TRADEVIEW_PREFIX + "RRBtn"
#define RSL_EDIT_NAME            TRADEVIEW_PREFIX + "RSLEdit"
#define RSL_UP_BTN_NAME          TRADEVIEW_PREFIX + "RSLUpBtn"
#define RSL_DOWN_BTN_NAME        TRADEVIEW_PREFIX + "RSLDownBtn"
#define RSL_LABEL_NAME           TRADEVIEW_PREFIX + "RSLLabel"

// --- NUEVOS CONTROLES FILA 5 ---
#define BUY_BUTTON_NAME          TRADEVIEW_PREFIX + "BuyBtn"
#define EDIT_BUTTON_NAME         TRADEVIEW_PREFIX + "EditBtn"
#define SELL_BUTTON_NAME         TRADEVIEW_PREFIX + "SellBtn"

// --- NUEVOS CONTROLES FILA 6 ---
#define CLOSE_BUY_BUTTON_NAME    TRADEVIEW_PREFIX + "CloseBuyBtn"
#define CLOSE_ALL_BUTTON_NAME    TRADEVIEW_PREFIX + "CloseAllBtn"
#define CLOSE_SELL_BUTTON_NAME   TRADEVIEW_PREFIX + "CloseSellBtn"

// --- NUEVOS CONTROLES FILA 7 ---
#define DELETE_ORDERS_BUTTON_NAME TRADEVIEW_PREFIX + "DeleteOrdersBtn"
#define CLOSE_PERCENT_BUTTON_NAME TRADEVIEW_PREFIX + "ClosePercentBtn"
#define CLOSE_PERCENT_EDIT_NAME   TRADEVIEW_PREFIX + "ClosePercentEdit"
#define REVERSE_BUTTON_NAME       TRADEVIEW_PREFIX + "ReverseBtn"

// --- NUEVOS CONTROLES FILA 8 (FOOTER) ---
#define FOOTER_LABEL_LEFT_NAME    TRADEVIEW_PREFIX + "FooterLeftLabel"
#define FOOTER_LABEL_RIGHT_NAME   TRADEVIEW_PREFIX + "FooterRightLabel"

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
   
   //--- Almacenamiento para posiciones originales (para restaurar después de ocultar)
   int               m_object_original_x[]; // Posiciones X originales
   int               m_object_original_y[]; // Posiciones Y originales

   //--- Estados de los controles ---
   bool              m_tp_enabled;     // Estado del checkbox TP
   bool              m_sl_enabled;     // Estado del checkbox SL

   //--- Métodos privados
   bool              CreateLotCalcButton(int x, int y);
   bool              CreateSizeSelector(int x, int y); // Crear etiqueta + botón dropdown simulado
   bool              CreateValueInput(int x, int y);   // Crear Edit + botones Up/Down
   void              AddObjectName(const string name); // Ayudante para registrar nombres
   
   // --- Métodos para nuevos controles Fila 2 ---
   bool              CreateSeparatorLine(int y, const string name);
   bool              CreateLotsInput(int x, int y);
   bool              CreateMarketButton(int x, int y);
   bool              CreatePriceInput(int x, int y);

   // --- Métodos para nuevos controles Fila 3 ---
   bool              CreateCheckboxLabelPair(int x, int y, const string checkboxName, const string labelName, const string labelText, bool leftSide, int controlHeight, int labelYOffset);
   bool              CreateValueInputWithButtons(int x, int y, const string editName, const string upBtnName, const string downBtnName, const string initialValue, int editWidth=50, int controlHeight=20);
   bool              CreateATRButton(int x, int y, int controlHeight=20);

   //--- Nuevos métodos para guardar/restaurar posiciones
   void              SaveOriginalPositions(); // Guarda posiciones actuales
   void              RestoreOriginalPositions(); // Restaura posiciones guardadas

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

   //--- Manejo de eventos específicos de la vista ---
   void              ToggleCheckboxState(const string checkbox_name);
   bool              IsTPEnabled() const { return m_tp_enabled; }
   bool              IsSLEnabled() const { return m_sl_enabled; }
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTradeView::CTradeView(CThemeManager* themeManager) : m_themeManager(themeManager),
                                                      m_viewX(0),
                                                      m_viewY(0),
                                                      m_viewWidth(0),
                                                      m_viewHeight(0),
                                                      m_visible(false), // Empieza oculta
                                                      m_tp_enabled(false), // Inicializar estado TP
                                                      m_sl_enabled(false)  // Inicializar estado SL
{
   ArrayResize(m_object_names, 0); // Inicializar array vacío
   ArrayResize(m_object_original_x, 0); // Inicializar array de posiciones X
   ArrayResize(m_object_original_y, 0); // Inicializar array de posiciones Y
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
   
   // También redimensionar arrays de posición para mantener sincronización
   ArrayResize(m_object_original_x, size + 1);
   ArrayResize(m_object_original_y, size + 1);
   
   // Inicializar posiciones como -1 (valor inválido) hasta que se guarden realmente
   m_object_original_x[size] = -1;
   m_object_original_y[size] = -1;
}

//+------------------------------------------------------------------+
//| Guarda las posiciones actuales de los objetos                   |
//+------------------------------------------------------------------+
void CTradeView::SaveOriginalPositions()
{
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      if(ObjectFind(0, m_object_names[i]) >= 0) // Si el objeto existe
      {
         m_object_original_x[i] = (int)ObjectGetInteger(0, m_object_names[i], OBJPROP_XDISTANCE);
         m_object_original_y[i] = (int)ObjectGetInteger(0, m_object_names[i], OBJPROP_YDISTANCE);
      }
   }
}

//+------------------------------------------------------------------+
//| Restaura las posiciones originales de los objetos               |
//+------------------------------------------------------------------+
void CTradeView::RestoreOriginalPositions()
{
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      if(ObjectFind(0, m_object_names[i]) >= 0 && // Si el objeto existe
         m_object_original_x[i] >= 0 && m_object_original_y[i] >= 0) // Y tiene posiciones válidas
      {
         ObjectSetInteger(0, m_object_names[i], OBJPROP_XDISTANCE, m_object_original_x[i]);
         ObjectSetInteger(0, m_object_names[i], OBJPROP_YDISTANCE, m_object_original_y[i]);
      }
   }
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
   
   // Guardar posiciones originales después de crear los controles
   SaveOriginalPositions();
   
   // Por defecto, la vista empieza oculta
   Hide();

   return true;
}

//+------------------------------------------------------------------+
//| Crea todos los controles de la vista                             |
//+------------------------------------------------------------------+
bool CTradeView::CreateControls()
{
   // Dimensiones y espaciado (Ajustar según sea necesario)
   int firstRowY = 15;   // Margen superior para la primera fila
   int elementHeight = 20;
   int smallSpacing = 5;
   int largeSpacing = 15; // Espacio vertical entre filas REDUCIDO
   int separatorHeight = 1;
   int secondRowY = firstRowY + elementHeight + largeSpacing;
   int separatorY = secondRowY - separatorHeight - (largeSpacing / 2);
   int thirdRowY = secondRowY + elementHeight + largeSpacing;
   int separatorY2 = thirdRowY - separatorHeight - (largeSpacing / 2);

   // --- FILA 1: Lot Calc, Size Selector, Value Input (Centrados como antes) ---
   int lotCalcWidth = 80;
   int sizeSelectorWidth = 150;
   int valueInputWidth = 50 + 1 + 20; // Edit + spacing + Buttons
   int totalElementsWidth_R1 = lotCalcWidth + smallSpacing + sizeSelectorWidth + smallSpacing + valueInputWidth;
   int leftMargin_R1 = (m_viewWidth > totalElementsWidth_R1) ? (m_viewWidth - totalElementsWidth_R1) / 2 : smallSpacing;
   int lotCalcX = leftMargin_R1;
   int sizeSelectorX = lotCalcX + lotCalcWidth + smallSpacing;
   int valueInputX = sizeSelectorX + sizeSelectorWidth + smallSpacing;

   if (!CreateLotCalcButton(lotCalcX, firstRowY)) return false;
   if (!CreateSizeSelector(sizeSelectorX, firstRowY)) return false;
   if (!CreateValueInput(valueInputX, firstRowY)) return false;
   
   // --- SEPARADOR --- 
   if (!CreateSeparatorLine(separatorY, SEPARATOR_LINE_1_NAME)) return false;

   // --- FILA 2: Lots, Market, Price (Centrado como bloque) ---
   int labelWidth = 30; // Ancho para etiquetas "Lots" y "Price"
   int lotsInputWidth = 50 + 1 + 20; // Similar a ValueInput
   int marketBtnWidth = 70;
   int priceInputWidth = 70 + 1 + 20;

   // Calcular ancho total de elementos + espaciado FIJO
   int totalWidth_R2 = labelWidth + smallSpacing + lotsInputWidth + smallSpacing + marketBtnWidth + smallSpacing + priceInputWidth + smallSpacing + labelWidth;
   
   // Calcular margen izquierdo para centrar Fila 2
   int leftMargin_R2 = (m_viewWidth > totalWidth_R2) ? (m_viewWidth - totalWidth_R2) / 2 : smallSpacing;
   
   int currentX = leftMargin_R2; // Empezar desde el margen calculado
   
   // Label "Lots"
   string lotsLabelName = LOTS_LABEL_NAME;
   if(!ObjectCreate(0, lotsLabelName, OBJ_LABEL, 0, 0, 0)) return false;
   ObjectSetInteger(0, lotsLabelName, OBJPROP_XDISTANCE, m_viewX + currentX);
   ObjectSetInteger(0, lotsLabelName, OBJPROP_YDISTANCE, m_viewY + secondRowY + 4); // Ajuste vertical para alinear con input
   ObjectSetString(0, lotsLabelName, OBJPROP_TEXT, "Lots");
   ObjectSetInteger(0, lotsLabelName, OBJPROP_COLOR, clrGray); // Usar color de tema si está disponible
   ObjectSetInteger(0, lotsLabelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, lotsLabelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(lotsLabelName);
   currentX += labelWidth + smallSpacing; // Usar smallSpacing fijo
   
   // Input Lots
   if (!CreateLotsInput(currentX, secondRowY)) return false;
   currentX += lotsInputWidth + smallSpacing; // Usar smallSpacing fijo
   
   // Botón Market
   if (!CreateMarketButton(currentX, secondRowY)) return false;
   currentX += marketBtnWidth + smallSpacing; // Usar smallSpacing fijo
   
   // Input Price
   if (!CreatePriceInput(currentX, secondRowY)) return false;
   currentX += priceInputWidth + smallSpacing; // Usar smallSpacing fijo
   
   // Label "Price"
   string priceLabelName = PRICE_LABEL_NAME;
   if(!ObjectCreate(0, priceLabelName, OBJ_LABEL, 0, 0, 0)) return false;
   ObjectSetInteger(0, priceLabelName, OBJPROP_XDISTANCE, m_viewX + currentX);
   ObjectSetInteger(0, priceLabelName, OBJPROP_YDISTANCE, m_viewY + secondRowY + 4);
   ObjectSetString(0, priceLabelName, OBJPROP_TEXT, "Price");
   ObjectSetInteger(0, priceLabelName, OBJPROP_COLOR, clrGray);
   ObjectSetInteger(0, priceLabelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, priceLabelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(priceLabelName);

   // --- SEPARADOR 2 --- 
   // if (!CreateSeparatorLine(separatorY2, SEPARATOR_LINE_2_NAME)) return false; // << COMENTADO

   // --- FILA 3: TP, ATR, SL --- 
   int checkboxWidth = 20;
   int tpLabelWidth = 25; // Ancho para "TP"
   int tpInputWidth = 50 + 1 + 20; // Valor + botones
   int atrBtnWidth = 60;
   int slInputWidth = 50 + 1 + 20;
   int slLabelWidth = 25; // Ancho para "SL"
   int elementHeightR3 = 20; // Altura estándar de los elementos para alineación
   int labelYOffsetR3 = 4; // Offset vertical para alinear texto de labels con centros de inputs

   // Calcular ancho total y centrar
   int totalWidth_R3 = checkboxWidth + smallSpacing + tpLabelWidth + smallSpacing + 
                       tpInputWidth + smallSpacing + atrBtnWidth + smallSpacing + 
                       slInputWidth + smallSpacing + slLabelWidth + smallSpacing + checkboxWidth;
   int leftMargin_R3 = (m_viewWidth > totalWidth_R3) ? (m_viewWidth - totalWidth_R3) / 2 : smallSpacing;
   int currentX_R3 = leftMargin_R3; // Empezar desde el margen calculado para Fila 3
   
   // Checkbox TP + Label TP
   if (!CreateCheckboxLabelPair(currentX_R3, thirdRowY, TP_CHECKBOX_NAME, TP_LABEL_NAME, "TP", true, elementHeightR3, labelYOffsetR3)) return false;
   currentX_R3 += checkboxWidth + smallSpacing + tpLabelWidth + smallSpacing;

   // Input TP
   if (!CreateValueInputWithButtons(currentX_R3, thirdRowY, TP_EDIT_NAME, TP_UP_BTN_NAME, TP_DOWN_BTN_NAME, "13.78", 50, elementHeightR3)) return false;
   currentX_R3 += tpInputWidth + smallSpacing;

   // Botón ATR
   if (!CreateATRButton(currentX_R3, thirdRowY, elementHeightR3)) return false;
   currentX_R3 += atrBtnWidth + smallSpacing;

   // Input SL/ATR
   if (!CreateValueInputWithButtons(currentX_R3, thirdRowY, SL_EDIT_NAME, SL_UP_BTN_NAME, SL_DOWN_BTN_NAME, "13.78", 50, elementHeightR3)) return false;
   currentX_R3 += slInputWidth + smallSpacing;

   // Label SL + Checkbox SL
   if (!CreateCheckboxLabelPair(currentX_R3, thirdRowY, SL_CHECKBOX_NAME, SL_LABEL_NAME, "SL", false, elementHeightR3, labelYOffsetR3)) return false;

   // --- FILA 4: R:TP, R:R, R:SL --- 
   int fourthRowY = thirdRowY + elementHeightR3 + largeSpacing; // Posición Y de la cuarta fila
   int rLabelWidth = 40; // Ancho estimado para "R : TP" y "R : SL"
   int rrInputWidth = 50 + 1 + 20; // Igual que TP/SL inputs
   int rrButtonWidth = 60; // Ancho del botón R:R
   int elementHeightR4 = 20; // Altura para la fila 4
   int labelYOffsetR4 = 4;   // Offset Y para labels en fila 4

   // Calcular ancho total y centrar Fila 4
   int totalWidth_R4 = rLabelWidth + smallSpacing + rrInputWidth + smallSpacing +
                       rrButtonWidth + smallSpacing + rrInputWidth + smallSpacing + rLabelWidth;
   int leftMargin_R4 = (m_viewWidth > totalWidth_R4) ? (m_viewWidth - totalWidth_R4) / 2 : smallSpacing;
   int currentX_R4 = leftMargin_R4;

   // Label "R : TP"
   string rtpLabelName = RTP_LABEL_NAME;
   if(!ObjectCreate(0, rtpLabelName, OBJ_LABEL, 0, 0, 0)) return false;
   ObjectSetInteger(0, rtpLabelName, OBJPROP_XDISTANCE, m_viewX + currentX_R4);
   ObjectSetInteger(0, rtpLabelName, OBJPROP_YDISTANCE, m_viewY + fourthRowY + labelYOffsetR4);
   ObjectSetString(0, rtpLabelName, OBJPROP_TEXT, "R : TP");
   ObjectSetInteger(0, rtpLabelName, OBJPROP_COLOR, clrGray);
   ObjectSetInteger(0, rtpLabelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, rtpLabelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(rtpLabelName);
   currentX_R4 += rLabelWidth + smallSpacing;

   // Input R TP
   if (!CreateValueInputWithButtons(currentX_R4, fourthRowY, RTP_EDIT_NAME, RTP_UP_BTN_NAME, RTP_DOWN_BTN_NAME, "1.00", 50, elementHeightR4)) return false;
   currentX_R4 += rrInputWidth + smallSpacing;

   // Botón R:R
   string rrButtonName = RR_BUTTON_NAME;
   if(!ObjectCreate(0, rrButtonName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, rrButtonName, OBJPROP_XDISTANCE, m_viewX + currentX_R4);
   ObjectSetInteger(0, rrButtonName, OBJPROP_YDISTANCE, m_viewY + fourthRowY);
   ObjectSetInteger(0, rrButtonName, OBJPROP_XSIZE, rrButtonWidth);
   ObjectSetInteger(0, rrButtonName, OBJPROP_YSIZE, elementHeightR4);
   ObjectSetString(0, rrButtonName, OBJPROP_TEXT, "R:R");
   ObjectSetInteger(0, rrButtonName, OBJPROP_BGCOLOR, C'60,60,80'); // Mismo color que ATR/Market
   ObjectSetInteger(0, rrButtonName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, rrButtonName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, rrButtonName, OBJPROP_STATE, false);
   ObjectSetInteger(0, rrButtonName, OBJPROP_BACK, false);
   ObjectSetInteger(0, rrButtonName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(rrButtonName);
   currentX_R4 += rrButtonWidth + smallSpacing;

   // Input R SL
   if (!CreateValueInputWithButtons(currentX_R4, fourthRowY, RSL_EDIT_NAME, RSL_UP_BTN_NAME, RSL_DOWN_BTN_NAME, "1.00", 50, elementHeightR4)) return false;
   currentX_R4 += rrInputWidth + smallSpacing;

   // Label "R : SL"
   string rslLabelName = RSL_LABEL_NAME;
   if(!ObjectCreate(0, rslLabelName, OBJ_LABEL, 0, 0, 0)) return false;
   ObjectSetInteger(0, rslLabelName, OBJPROP_XDISTANCE, m_viewX + currentX_R4);
   ObjectSetInteger(0, rslLabelName, OBJPROP_YDISTANCE, m_viewY + fourthRowY + labelYOffsetR4);
   ObjectSetString(0, rslLabelName, OBJPROP_TEXT, "R : SL");
   ObjectSetInteger(0, rslLabelName, OBJPROP_COLOR, clrGray);
   ObjectSetInteger(0, rslLabelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, rslLabelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(rslLabelName);

   // --- FILA 5: BUY, Edit, SELL --- 
   int fifthRowY = fourthRowY + elementHeightR4 + largeSpacing; // Posición Y de la quinta fila
   int sideMarginR5 = 10; // Margen a los lados para la fila 5
   int totalAvailableWidthR5 = m_viewWidth - (2 * sideMarginR5);
   int editButtonWidth = 30;  // Ancho para botón Edit (icono)
   int buttonHeightR5 = 25; // Altura para botones en fila 5

   // Calcular el ancho para los botones BUY/SELL
   int buySellButtonWidth = (totalAvailableWidthR5 - editButtonWidth - (2 * smallSpacing)) / 2;
   if(buySellButtonWidth < 50) buySellButtonWidth = 50; // Asegurar un ancho mínimo

   // Posición X inicial (considerando el margen lateral)
   int currentX_R5 = sideMarginR5;

   // Botón BUY
   string buyButtonName = BUY_BUTTON_NAME;
   if(!ObjectCreate(0, buyButtonName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, buyButtonName, OBJPROP_XDISTANCE, m_viewX + currentX_R5);
   ObjectSetInteger(0, buyButtonName, OBJPROP_YDISTANCE, m_viewY + fifthRowY);
   ObjectSetInteger(0, buyButtonName, OBJPROP_XSIZE, buySellButtonWidth);
   ObjectSetInteger(0, buyButtonName, OBJPROP_YSIZE, buttonHeightR5);
   ObjectSetString(0, buyButtonName, OBJPROP_TEXT, "BUY");
   ObjectSetInteger(0, buyButtonName, OBJPROP_BGCOLOR, clrDodgerBlue); // Azul
   ObjectSetInteger(0, buyButtonName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, buyButtonName, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, buyButtonName, OBJPROP_STATE, false);
   ObjectSetInteger(0, buyButtonName, OBJPROP_BACK, false);
   ObjectSetInteger(0, buyButtonName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(buyButtonName);
   currentX_R5 += buySellButtonWidth + smallSpacing;

   // Botón Edit (Lápiz)
   string editButtonName = EDIT_BUTTON_NAME;
   if(!ObjectCreate(0, editButtonName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, editButtonName, OBJPROP_XDISTANCE, m_viewX + currentX_R5);
   ObjectSetInteger(0, editButtonName, OBJPROP_YDISTANCE, m_viewY + fifthRowY + (buttonHeightR5 - editButtonWidth)/2); // Centrar verticalmente si es cuadrado
   ObjectSetInteger(0, editButtonName, OBJPROP_XSIZE, editButtonWidth);
   ObjectSetInteger(0, editButtonName, OBJPROP_YSIZE, editButtonWidth); // Hacerlo cuadrado
   ObjectSetString(0, editButtonName, OBJPROP_TEXT, "✎"); // Carácter Lápiz Unicode (U+270E)
   ObjectSetInteger(0, editButtonName, OBJPROP_FONTSIZE, 14); // Tamaño fuente para el icono
   ObjectSetInteger(0, editButtonName, OBJPROP_BGCOLOR, C'80,80,90'); // Gris medio
   ObjectSetInteger(0, editButtonName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, editButtonName, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, editButtonName, OBJPROP_STATE, false);
   ObjectSetInteger(0, editButtonName, OBJPROP_BACK, false);
   ObjectSetInteger(0, editButtonName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(editButtonName);
   currentX_R5 += editButtonWidth + smallSpacing;

   // Botón SELL
   string sellButtonName = SELL_BUTTON_NAME;
   if(!ObjectCreate(0, sellButtonName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, sellButtonName, OBJPROP_XDISTANCE, m_viewX + currentX_R5);
   ObjectSetInteger(0, sellButtonName, OBJPROP_YDISTANCE, m_viewY + fifthRowY);
   ObjectSetInteger(0, sellButtonName, OBJPROP_XSIZE, buySellButtonWidth);
   ObjectSetInteger(0, sellButtonName, OBJPROP_YSIZE, buttonHeightR5);
   ObjectSetString(0, sellButtonName, OBJPROP_TEXT, "SELL");
   ObjectSetInteger(0, sellButtonName, OBJPROP_BGCOLOR, clrOrangeRed); // Rojo/Naranja
   ObjectSetInteger(0, sellButtonName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, sellButtonName, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, sellButtonName, OBJPROP_STATE, false);
   ObjectSetInteger(0, sellButtonName, OBJPROP_BACK, false);
   ObjectSetInteger(0, sellButtonName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(sellButtonName);

   // --- FILA 6: CLOSE BUY, CLOSE ALL, CLOSE SELL ---
   int sixthRowY = fifthRowY + buttonHeightR5 + largeSpacing; // Posición Y
   int buttonHeightR6 = 25; // Altura botones fila 6
   int buttonWidthR6 = (totalAvailableWidthR5 - (2 * smallSpacing)) / 3; // Distribuir ancho (aproximado)
   int currentX_R6 = sideMarginR5; // Empezar desde el margen

   // Botón CLOSE BUY
   string closeBuyBtnName = CLOSE_BUY_BUTTON_NAME;
   if(!ObjectCreate(0, closeBuyBtnName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_XDISTANCE, m_viewX + currentX_R6);
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_YDISTANCE, m_viewY + sixthRowY);
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_XSIZE, buttonWidthR6);
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_YSIZE, buttonHeightR6);
   ObjectSetString(0, closeBuyBtnName, OBJPROP_TEXT, "CLOSE BUY");
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_FONTSIZE, 8); // Reducir tamaño fuente
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_BGCOLOR, clrDodgerBlue);
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_STATE, false);
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_BACK, false);
   ObjectSetInteger(0, closeBuyBtnName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(closeBuyBtnName);
   currentX_R6 += buttonWidthR6 + smallSpacing;

   // Botón CLOSE ALL
   string closeAllBtnName = CLOSE_ALL_BUTTON_NAME;
   if(!ObjectCreate(0, closeAllBtnName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_XDISTANCE, m_viewX + currentX_R6);
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_YDISTANCE, m_viewY + sixthRowY);
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_XSIZE, buttonWidthR6);
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_YSIZE, buttonHeightR6);
   ObjectSetString(0, closeAllBtnName, OBJPROP_TEXT, "CLOSE ALL");
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_FONTSIZE, 8); // Reducir tamaño fuente
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_BGCOLOR, C'60,60,80'); // Gris
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_STATE, false);
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_BACK, false);
   ObjectSetInteger(0, closeAllBtnName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(closeAllBtnName);
   currentX_R6 += buttonWidthR6 + smallSpacing;

   // Botón CLOSE SELL
   string closeSellBtnName = CLOSE_SELL_BUTTON_NAME;
   if(!ObjectCreate(0, closeSellBtnName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_XDISTANCE, m_viewX + currentX_R6);
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_YDISTANCE, m_viewY + sixthRowY);
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_XSIZE, buttonWidthR6);
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_YSIZE, buttonHeightR6);
   ObjectSetString(0, closeSellBtnName, OBJPROP_TEXT, "CLOSE SELL");
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_FONTSIZE, 8); // Reducir tamaño fuente
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_BGCOLOR, clrOrangeRed);
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_STATE, false);
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_BACK, false);
   ObjectSetInteger(0, closeSellBtnName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(closeSellBtnName);
   currentX_R6 += buttonWidthR6 + smallSpacing;

   // --- FILA 7: DELETE ORDERS, CLOSE %, REVERSE ---
   int seventhRowY = sixthRowY + buttonHeightR6 + smallSpacing; // Posición Y (menos espacio que largeSpacing)
   int buttonHeightR7 = 25;
   int closePercentEditWidth = 40;
   int closePercentBtnWidth = buttonWidthR6 - closePercentEditWidth - smallSpacing; // Ancho botón % basado en el espacio del medio
   int deleteReverseBtnWidth = buttonWidthR6; // Usar el mismo ancho que los botones de arriba
   int currentX_R7 = sideMarginR5;

   // Botón DELETE ORDERS
   string delOrdersBtnName = DELETE_ORDERS_BUTTON_NAME;
   if(!ObjectCreate(0, delOrdersBtnName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_XDISTANCE, m_viewX + currentX_R7);
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_YDISTANCE, m_viewY + seventhRowY);
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_XSIZE, deleteReverseBtnWidth);
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_YSIZE, buttonHeightR7);
   ObjectSetString(0, delOrdersBtnName, OBJPROP_TEXT, "DELETE ORDERS");
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_FONTSIZE, 8); // Reducir tamaño fuente
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_BGCOLOR, C'60,60,80');
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_STATE, false);
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_BACK, false);
   ObjectSetInteger(0, delOrdersBtnName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(delOrdersBtnName);
   currentX_R7 += deleteReverseBtnWidth + smallSpacing;

   // Botón CLOSE %
   string closePercBtnName = CLOSE_PERCENT_BUTTON_NAME;
   if(!ObjectCreate(0, closePercBtnName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, closePercBtnName, OBJPROP_XDISTANCE, m_viewX + currentX_R7);
   ObjectSetInteger(0, closePercBtnName, OBJPROP_YDISTANCE, m_viewY + seventhRowY);
   ObjectSetInteger(0, closePercBtnName, OBJPROP_XSIZE, closePercentBtnWidth);
   ObjectSetInteger(0, closePercBtnName, OBJPROP_YSIZE, buttonHeightR7);
   ObjectSetString(0, closePercBtnName, OBJPROP_TEXT, "CLOSE %");
   ObjectSetInteger(0, closePercBtnName, OBJPROP_FONTSIZE, 8); // Reducir tamaño fuente
   ObjectSetInteger(0, closePercBtnName, OBJPROP_BGCOLOR, C'60,60,80');
   ObjectSetInteger(0, closePercBtnName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, closePercBtnName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, closePercBtnName, OBJPROP_STATE, false);
   ObjectSetInteger(0, closePercBtnName, OBJPROP_BACK, false);
   ObjectSetInteger(0, closePercBtnName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(closePercBtnName);
   currentX_R7 += closePercentBtnWidth + smallSpacing; // Solo espacio pequeño aquí

   // Edit CLOSE %
   string closePercEditName = CLOSE_PERCENT_EDIT_NAME;
   if(!ObjectCreate(0, closePercEditName, OBJ_EDIT, 0, 0, 0)) return false;
   ObjectSetInteger(0, closePercEditName, OBJPROP_XDISTANCE, m_viewX + currentX_R7);
   ObjectSetInteger(0, closePercEditName, OBJPROP_YDISTANCE, m_viewY + seventhRowY);
   ObjectSetInteger(0, closePercEditName, OBJPROP_XSIZE, closePercentEditWidth);
   ObjectSetInteger(0, closePercEditName, OBJPROP_YSIZE, buttonHeightR7);
   ObjectSetString(0, closePercEditName, OBJPROP_TEXT, "50");
   ObjectSetInteger(0, closePercEditName, OBJPROP_BGCOLOR, C'50,50,60');
   ObjectSetInteger(0, closePercEditName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, closePercEditName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, closePercEditName, OBJPROP_ALIGN, ALIGN_CENTER);
   ObjectSetInteger(0, closePercEditName, OBJPROP_BACK, false);
   ObjectSetInteger(0, closePercEditName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, closePercEditName, OBJPROP_READONLY, false);
   AddObjectName(closePercEditName);
   currentX_R7 += closePercentEditWidth + smallSpacing;

   // Botón REVERSE
   string reverseBtnName = REVERSE_BUTTON_NAME;
   if(!ObjectCreate(0, reverseBtnName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, reverseBtnName, OBJPROP_XDISTANCE, m_viewX + currentX_R7);
   ObjectSetInteger(0, reverseBtnName, OBJPROP_YDISTANCE, m_viewY + seventhRowY);
   ObjectSetInteger(0, reverseBtnName, OBJPROP_XSIZE, deleteReverseBtnWidth);
   ObjectSetInteger(0, reverseBtnName, OBJPROP_YSIZE, buttonHeightR7);
   ObjectSetString(0, reverseBtnName, OBJPROP_TEXT, "REVERSE");
   ObjectSetInteger(0, reverseBtnName, OBJPROP_FONTSIZE, 8); // Reducir tamaño fuente
   ObjectSetInteger(0, reverseBtnName, OBJPROP_BGCOLOR, C'60,60,80');
   ObjectSetInteger(0, reverseBtnName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, reverseBtnName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, reverseBtnName, OBJPROP_STATE, false);
   ObjectSetInteger(0, reverseBtnName, OBJPROP_BACK, false);
   ObjectSetInteger(0, reverseBtnName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(reverseBtnName);

   // --- FILA 8: FOOTER ---
   int footerY = seventhRowY + buttonHeightR7 + smallSpacing + 5; // Posición Y, añadiendo un pequeño espacio explícito
   int footerLabelYOffset = 2;

   // Label Izquierda (traderwaves.com)
   string footerLeftName = FOOTER_LABEL_LEFT_NAME;
   if(!ObjectCreate(0, footerLeftName, OBJ_LABEL, 0, 0, 0)) return false;
   ObjectSetInteger(0, footerLeftName, OBJPROP_XDISTANCE, m_viewX + sideMarginR5); // Alinear con margen izquierdo
   ObjectSetInteger(0, footerLeftName, OBJPROP_YDISTANCE, m_viewY + footerY + footerLabelYOffset);
   ObjectSetString(0, footerLeftName, OBJPROP_TEXT, "traderwaves.com");
   ObjectSetInteger(0, footerLeftName, OBJPROP_COLOR, clrGray);
   ObjectSetInteger(0, footerLeftName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, footerLeftName, OBJPROP_BACK, false);
   ObjectSetInteger(0, footerLeftName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(footerLeftName);

   // Label Derecha (DashPro) - Podría ser OBJ_BITMAP_LABEL si tienes la imagen
   string footerRightName = FOOTER_LABEL_RIGHT_NAME;
   if(!ObjectCreate(0, footerRightName, OBJ_LABEL, 0, 0, 0)) return false;
   ObjectSetInteger(0, footerRightName, OBJPROP_XDISTANCE, m_viewX + m_viewWidth - sideMarginR5); // Alinear con margen derecho
   ObjectSetInteger(0, footerRightName, OBJPROP_YDISTANCE, m_viewY + footerY + footerLabelYOffset);
   ObjectSetString(0, footerRightName, OBJPROP_TEXT, "DashPro"); // Placeholder - usa imagen si la tienes
   ObjectSetInteger(0, footerRightName, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER); // Anclar a la esquina superior derecha
   ObjectSetInteger(0, footerRightName, OBJPROP_COLOR, clrLightBlue); // Color ejemplo
   ObjectSetInteger(0, footerRightName, OBJPROP_FONTSIZE, 9);
   ObjectSetInteger(0, footerRightName, OBJPROP_BACK, false);
   ObjectSetInteger(0, footerRightName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(footerRightName);

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
//| Crea una línea separadora horizontal                             |
//+------------------------------------------------------------------+
bool CTradeView::CreateSeparatorLine(int y, const string name)
{
    int lineMargin = 10; // Margen a los lados
    int lineWidth = m_viewWidth - (lineMargin * 2);
    int lineHeight = 1;

    if (!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0)) return false;
    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_viewX + lineMargin);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_viewY + y);
    ObjectSetInteger(0, name, OBJPROP_XSIZE, lineWidth);
    ObjectSetInteger(0, name, OBJPROP_YSIZE, lineHeight);
    ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'60,60,70'); // << Color más oscuro
    ObjectSetInteger(0, name, OBJPROP_COLOR, C'60,60,70');   // << Color más oscuro (borde)
    ObjectSetInteger(0, name, OBJPROP_BACK, false); 
    ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    AddObjectName(name);
    return true;
}

//+------------------------------------------------------------------+
//| Crea el input de Lots (Edit + Botones Up/Down)                  |
//+------------------------------------------------------------------+
bool CTradeView::CreateLotsInput(int x, int y)
{
   int editWidth = 50;
   int buttonWidth = 20;
   int controlHeight = 20;
   int spacing = 1; 

   // 1. Campo de Edición Lots
   string editName = LOTS_EDIT_NAME;
   if(!ObjectCreate(0, editName, OBJ_EDIT, 0, 0, 0)) return false;
   ObjectSetInteger(0, editName, OBJPROP_XDISTANCE, m_viewX + x);
   ObjectSetInteger(0, editName, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, editName, OBJPROP_XSIZE, editWidth);
   ObjectSetInteger(0, editName, OBJPROP_YSIZE, controlHeight);
   ObjectSetString(0, editName, OBJPROP_TEXT, "0.01"); // Valor inicial
   ObjectSetInteger(0, editName, OBJPROP_BGCOLOR, C'50,50,60'); // Fondo oscuro
   ObjectSetInteger(0, editName, OBJPROP_COLOR, clrWhite);  // Texto blanco
   ObjectSetInteger(0, editName, OBJPROP_BORDER_COLOR, C'90,90,100'); // Borde más claro
   ObjectSetInteger(0, editName, OBJPROP_ALIGN, ALIGN_CENTER); // Centrado
   ObjectSetInteger(0, editName, OBJPROP_BACK, false);
   ObjectSetInteger(0, editName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, editName, OBJPROP_READONLY, false);
   AddObjectName(editName);

   // 2. Botón Subir Lots
   string upName = LOTS_UP_BTN_NAME;
   if(!ObjectCreate(0, upName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, upName, OBJPROP_XDISTANCE, m_viewX + x + editWidth + spacing);
   ObjectSetInteger(0, upName, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, upName, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, upName, OBJPROP_YSIZE, controlHeight / 2);
   ObjectSetString(0, upName, OBJPROP_TEXT, "▲");
   ObjectSetInteger(0, upName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, upName, OBJPROP_BGCOLOR, C'70,70,85');
   ObjectSetInteger(0, upName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, upName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, upName, OBJPROP_STATE, false);
   ObjectSetInteger(0, upName, OBJPROP_BACK, false);
   ObjectSetInteger(0, upName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(upName);

   // 3. Botón Bajar Lots
   string downName = LOTS_DOWN_BTN_NAME;
   if(!ObjectCreate(0, downName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, downName, OBJPROP_XDISTANCE, m_viewX + x + editWidth + spacing);
   ObjectSetInteger(0, downName, OBJPROP_YDISTANCE, m_viewY + y + controlHeight / 2);
   ObjectSetInteger(0, downName, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, downName, OBJPROP_YSIZE, controlHeight / 2);
   ObjectSetString(0, downName, OBJPROP_TEXT, "▼");
   ObjectSetInteger(0, downName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, downName, OBJPROP_BGCOLOR, C'70,70,85');
   ObjectSetInteger(0, downName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, downName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, downName, OBJPROP_STATE, false);
   ObjectSetInteger(0, downName, OBJPROP_BACK, false);
   ObjectSetInteger(0, downName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(downName);

   return true;
}

//+------------------------------------------------------------------+
//| Crea el botón "Market"                                           |
//+------------------------------------------------------------------+
bool CTradeView::CreateMarketButton(int x, int y)
{
   string name = MARKET_BUTTON_NAME;
   int buttonWidth = 70;
   int buttonHeight = 20;

   if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_viewX + x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, buttonHeight);
   ObjectSetString(0, name, OBJPROP_TEXT, "Market");
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'60,60,80'); // Color similar a Size Selector
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, name, OBJPROP_STATE, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(name);
   return true;
}

//+------------------------------------------------------------------+
//| Crea el input de Price (Edit + Botones Up/Down)                 |
//+------------------------------------------------------------------+
bool CTradeView::CreatePriceInput(int x, int y)
{
   int editWidth = 70;
   int buttonWidth = 20;
   int controlHeight = 20;
   int spacing = 1;

   // 1. Campo de Edición Price
   string editName = PRICE_EDIT_NAME;
   if(!ObjectCreate(0, editName, OBJ_EDIT, 0, 0, 0)) return false;
   ObjectSetInteger(0, editName, OBJPROP_XDISTANCE, m_viewX + x);
   ObjectSetInteger(0, editName, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, editName, OBJPROP_XSIZE, editWidth);
   ObjectSetInteger(0, editName, OBJPROP_YSIZE, controlHeight);
   ObjectSetString(0, editName, OBJPROP_TEXT, "0.58282"); // Valor ejemplo, debe ser dinámico
   ObjectSetInteger(0, editName, OBJPROP_BGCOLOR, C'50,50,60');
   ObjectSetInteger(0, editName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, editName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, editName, OBJPROP_ALIGN, ALIGN_CENTER);
   ObjectSetInteger(0, editName, OBJPROP_BACK, false);
   ObjectSetInteger(0, editName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, editName, OBJPROP_READONLY, false); // ¿Debería ser editable?
   AddObjectName(editName);

   // 2. Botón Subir Price
   string upName = PRICE_UP_BTN_NAME;
   if(!ObjectCreate(0, upName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, upName, OBJPROP_XDISTANCE, m_viewX + x + editWidth + spacing);
   ObjectSetInteger(0, upName, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, upName, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, upName, OBJPROP_YSIZE, controlHeight / 2);
   ObjectSetString(0, upName, OBJPROP_TEXT, "▲");
   ObjectSetInteger(0, upName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, upName, OBJPROP_BGCOLOR, C'70,70,85');
   ObjectSetInteger(0, upName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, upName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, upName, OBJPROP_STATE, false);
   ObjectSetInteger(0, upName, OBJPROP_BACK, false);
   ObjectSetInteger(0, upName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(upName);

   // 3. Botón Bajar Price
   string downName = PRICE_DOWN_BTN_NAME;
   if(!ObjectCreate(0, downName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, downName, OBJPROP_XDISTANCE, m_viewX + x + editWidth + spacing);
   ObjectSetInteger(0, downName, OBJPROP_YDISTANCE, m_viewY + y + controlHeight / 2);
   ObjectSetInteger(0, downName, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, downName, OBJPROP_YSIZE, controlHeight / 2);
   ObjectSetString(0, downName, OBJPROP_TEXT, "▼");
   ObjectSetInteger(0, downName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, downName, OBJPROP_BGCOLOR, C'70,70,85');
   ObjectSetInteger(0, downName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, downName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, downName, OBJPROP_STATE, false);
   ObjectSetInteger(0, downName, OBJPROP_BACK, false);
   ObjectSetInteger(0, downName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(downName);

   return true;
}

//+------------------------------------------------------------------+
//| Crea un par Checkbox (simulado con botón) + Label              |
//+------------------------------------------------------------------+
bool CTradeView::CreateCheckboxLabelPair(int x, int y, const string checkboxName, const string labelName, const string labelText, bool leftSide, int controlHeight, int labelYOffset)
{
   int checkboxSize = 16; // Tamaño del checkbox simulado
   int labelWidth = StringLen(labelText) * 7; // Aproximado
   int spacing = 3;

   int checkX, labelX;
   
   if(leftSide)
   {
      checkX = x;
      labelX = x + checkboxSize + spacing;
   }
   else // Checkbox a la derecha de la etiqueta
   {
      labelX = x;
      checkX = x + labelWidth + spacing;
   }

   // 1. Checkbox simulado (Botón)
   if(!ObjectCreate(0, checkboxName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, checkboxName, OBJPROP_XDISTANCE, m_viewX + checkX);
   ObjectSetInteger(0, checkboxName, OBJPROP_YDISTANCE, m_viewY + y + (controlHeight - checkboxSize) / 2);
   ObjectSetInteger(0, checkboxName, OBJPROP_XSIZE, checkboxSize);
   ObjectSetInteger(0, checkboxName, OBJPROP_YSIZE, checkboxSize);
   ObjectSetString(0, checkboxName, OBJPROP_TEXT, " "); // Sin texto inicial, usaremos color
   ObjectSetInteger(0, checkboxName, OBJPROP_BGCOLOR, clrBlack); // Fondo negro (o usar C'20,20,20')
   ObjectSetInteger(0, checkboxName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, checkboxName, OBJPROP_BORDER_COLOR, clrGray);
   ObjectSetInteger(0, checkboxName, OBJPROP_STATE, false);
   ObjectSetInteger(0, checkboxName, OBJPROP_BACK, false);
   ObjectSetInteger(0, checkboxName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   
   // Establecer estado visual inicial basado en las variables miembro
   bool initialState = false;
   if (checkboxName == TP_CHECKBOX_NAME) initialState = m_tp_enabled;
   else if (checkboxName == SL_CHECKBOX_NAME) initialState = m_sl_enabled;

   if(initialState)
   {
      ObjectSetInteger(0, checkboxName, OBJPROP_BGCOLOR, clrLimeGreen);
      // ObjectSetString(0, checkboxName, OBJPROP_TEXT, "✓"); // Opcional
   }
   else
   {
      ObjectSetInteger(0, checkboxName, OBJPROP_BGCOLOR, clrBlack);
      ObjectSetString(0, checkboxName, OBJPROP_TEXT, " ");
   }
   
   AddObjectName(checkboxName);

   // 2. Label
   if(!ObjectCreate(0, labelName, OBJ_LABEL, 0, 0, 0)) return false;
   ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, m_viewX + labelX);
   ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, m_viewY + y + labelYOffset);
   ObjectSetString(0, labelName, OBJPROP_TEXT, labelText);
   ObjectSetInteger(0, labelName, OBJPROP_COLOR, clrGray);
   ObjectSetInteger(0, labelName, OBJPROP_BACK, false);
   ObjectSetInteger(0, labelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(labelName);

   return true;
}

//+------------------------------------------------------------------+
//| Crea un Input de Valor con botones Up/Down (Reutilizable)       |
//+------------------------------------------------------------------+
bool CTradeView::CreateValueInputWithButtons(int x, int y, const string editName, const string upBtnName, const string downBtnName, const string initialValue, int editWidth=50, int controlHeight=20)
{
   int buttonWidth = 20;
   int spacing = 1; 

   // 1. Campo de Edición
   if(!ObjectCreate(0, editName, OBJ_EDIT, 0, 0, 0)) return false;
   ObjectSetInteger(0, editName, OBJPROP_XDISTANCE, m_viewX + x);
   ObjectSetInteger(0, editName, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, editName, OBJPROP_XSIZE, editWidth);
   ObjectSetInteger(0, editName, OBJPROP_YSIZE, controlHeight);
   ObjectSetString(0, editName, OBJPROP_TEXT, initialValue); 
   ObjectSetInteger(0, editName, OBJPROP_BGCOLOR, C'50,50,60'); 
   ObjectSetInteger(0, editName, OBJPROP_COLOR, clrWhite);  
   ObjectSetInteger(0, editName, OBJPROP_BORDER_COLOR, C'90,90,100'); 
   ObjectSetInteger(0, editName, OBJPROP_ALIGN, ALIGN_CENTER); 
   ObjectSetInteger(0, editName, OBJPROP_BACK, false);
   ObjectSetInteger(0, editName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, editName, OBJPROP_READONLY, false);
   AddObjectName(editName);

   // 2. Botón Subir 
   if(!ObjectCreate(0, upBtnName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, upBtnName, OBJPROP_XDISTANCE, m_viewX + x + editWidth + spacing);
   ObjectSetInteger(0, upBtnName, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, upBtnName, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, upBtnName, OBJPROP_YSIZE, controlHeight / 2);
   ObjectSetString(0, upBtnName, OBJPROP_TEXT, "▲");
   ObjectSetInteger(0, upBtnName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, upBtnName, OBJPROP_BGCOLOR, C'70,70,85');
   ObjectSetInteger(0, upBtnName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, upBtnName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, upBtnName, OBJPROP_STATE, false);
   ObjectSetInteger(0, upBtnName, OBJPROP_BACK, false);
   ObjectSetInteger(0, upBtnName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(upBtnName);

   // 3. Botón Bajar
   if(!ObjectCreate(0, downBtnName, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, downBtnName, OBJPROP_XDISTANCE, m_viewX + x + editWidth + spacing);
   ObjectSetInteger(0, downBtnName, OBJPROP_YDISTANCE, m_viewY + y + controlHeight / 2);
   ObjectSetInteger(0, downBtnName, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, downBtnName, OBJPROP_YSIZE, controlHeight / 2);
   ObjectSetString(0, downBtnName, OBJPROP_TEXT, "▼");
   ObjectSetInteger(0, downBtnName, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, downBtnName, OBJPROP_BGCOLOR, C'70,70,85');
   ObjectSetInteger(0, downBtnName, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, downBtnName, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, downBtnName, OBJPROP_STATE, false);
   ObjectSetInteger(0, downBtnName, OBJPROP_BACK, false);
   ObjectSetInteger(0, downBtnName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(downBtnName);

   return true;
}

//+------------------------------------------------------------------+
//| Crea el botón "ATR"                                              |
//+------------------------------------------------------------------+
bool CTradeView::CreateATRButton(int x, int y, int controlHeight=20)
{
   string name = ATR_BUTTON_NAME;
   int buttonWidth = 60; // Un poco más pequeño que Market
   int buttonHeight = controlHeight;

   if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0)) return false;
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_viewX + x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_viewY + y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, buttonWidth);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, buttonHeight);
   ObjectSetString(0, name, OBJPROP_TEXT, "ATR");
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, C'60,60,80'); 
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, C'90,90,100');
   ObjectSetInteger(0, name, OBJPROP_STATE, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   AddObjectName(name);
   return true;
}

//+------------------------------------------------------------------+
//| Muestra todos los controles de la vista                          |
//+------------------------------------------------------------------+
void CTradeView::Show()
{
   Print("CTradeView::Show() llamado - usando enfoque de MOVER objetos");
   
   // Si ya está visible, no hacer nada
   if(m_visible) return;
   
   // Restaurar posiciones originales
   RestoreOriginalPositions();
   
   m_visible = true;
   ChartRedraw(); // Redibujar para que los cambios sean visibles
   Print("CTradeView::Show() completado.");
}

//+------------------------------------------------------------------+
//| Oculta todos los controles de la vista                           |
//+------------------------------------------------------------------+
void CTradeView::Hide()
{
   Print("CTradeView::Hide() llamado - usando enfoque de MOVER objetos");
   
   // Si ya está oculto, no hacer nada
   if(!m_visible) return;
   
   // Guardar posiciones actuales primero (por si han cambiado desde Initialize())
   SaveOriginalPositions();
   
   // Mover objetos fuera de la pantalla visible (-5000 es un valor arbitrario muy negativo)
   for(int i = 0; i < ArraySize(m_object_names); i++)
   {
      if(ObjectFind(0, m_object_names[i]) >= 0) // Si el objeto existe
      {
         Print("Moviendo objeto fuera de pantalla: '", m_object_names[i], "'");
         ObjectSetInteger(0, m_object_names[i], OBJPROP_XDISTANCE, -5000); // Mover muy a la izquierda
      }
      else
      {
         Print("Advertencia: Objeto '", m_object_names[i], "' no encontrado para mover.");
      }
   }
   
   m_visible = false;
   ChartRedraw(); // Redibujar para que los cambios sean visibles
   Print("CTradeView::Hide() completado.");
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
//| Cambia el estado de un checkbox simulado y actualiza su apariencia |
//+------------------------------------------------------------------+
void CTradeView::ToggleCheckboxState(const string checkbox_name)
{
   bool newState = false;
   color uncheckedColor = clrBlack; // Color cuando está desmarcado
   color checkedColor = clrLimeGreen; // Color cuando está marcado
   string newText = " "; // Texto por defecto (desmarcado)

   if(checkbox_name == TP_CHECKBOX_NAME)
   {
      m_tp_enabled = !m_tp_enabled; // Alternar estado
      newState = m_tp_enabled;
      Print("Estado TP cambiado a: ", m_tp_enabled); // Debug
   }
   else if(checkbox_name == SL_CHECKBOX_NAME)
   {
      m_sl_enabled = !m_sl_enabled; // Alternar estado
      newState = m_sl_enabled;
      Print("Estado SL cambiado a: ", m_sl_enabled); // Debug
   }
   else
   {
      Print("Advertencia: ToggleCheckboxState llamado con nombre desconocido: ", checkbox_name);
      return; // No hacer nada si no es TP o SL checkbox
   }

   // Actualizar apariencia según el nuevo estado
   color finalColor = uncheckedColor;
   if(newState) // Si está activado
   {
      finalColor = checkedColor;
      // newText = "✓"; // Opcional: añadir un checkmark (puede requerir ajustar fuente/tamaño)
   }
   
   // Aplicar cambios al objeto botón
   if(ObjectFind(0, checkbox_name) >= 0)
   {
      ObjectSetInteger(0, checkbox_name, OBJPROP_BGCOLOR, finalColor);
      ObjectSetString(0, checkbox_name, OBJPROP_TEXT, newText); 
      // Si usamos texto, podríamos necesitar:
      // ObjectSetString(0, checkbox_name, OBJPROP_FONT, "Arial"); 
      // ObjectSetInteger(0, checkbox_name, OBJPROP_FONTSIZE, 10); 
      ChartRedraw();
   }
   else
   {
      Print("Error: No se encontró el objeto checkbox '", checkbox_name, "' para actualizar.");
   }
}
//+------------------------------------------------------------------+ 