//+------------------------------------------------------------------+
//|                                                  ColorUtils.mqh |
//|                                      Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2025, MetaQuotes Ltd."
#property link        "https://www.mql5.com"

//+------------------------------------------------------------------+
//| Función para aclarar un color                                     |
//+------------------------------------------------------------------+
color ColorBrighten(color c, int amount)
{
   int r = (c >> 16) & 0xFF;
   int g = (c >> 8) & 0xFF;
   int b = c & 0xFF;
   
   r = MathMin(r + amount, 255);
   g = MathMin(g + amount, 255);
   b = MathMin(b + amount, 255);
   
   return (color)((r << 16) | (g << 8) | b);
}

//+------------------------------------------------------------------+
//| Función para oscurecer un color                                   |
//+------------------------------------------------------------------+
color ColorDarken(color c, int amount)
{
   int r = (c >> 16) & 0xFF;
   int g = (c >> 8) & 0xFF;
   int b = c & 0xFF;
   
   r = MathMax(r - amount, 0);
   g = MathMax(g - amount, 0);
   b = MathMax(b - amount, 0);
   
   return (color)((r << 16) | (g << 8) | b);
} 