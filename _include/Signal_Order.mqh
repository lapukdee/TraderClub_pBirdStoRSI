//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Universal
{
public:

   void              NumRowDigits(double& v)
   {
      v = NormalizeDouble(v, Digits);
   }
   double            PointToDigits(int point)
   {
      return   NormalizeDouble(point * Point, Digits);
   }

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CChart: public Universal
{
   bool              IsOnTick_Bool,    IsTimer_Bool;
   int               IsNewBar_Save[][2];
public:
   string            IsOnTick_String,  IsTimer_String;
//---
                     CChart(void)
   {
      Print(__FUNCTION__, "#", __LINE__);
      CSignal_setDefault();
   };
   void              CSignal_setDefault()
   {
      Print(__FUNCTION__, "#", __LINE__);
      CChart_IsNewBar_Init();
   }
//---
   void              CChart_IsNewBar_Init()
   {
      //ArrayResize(IsNewBar_Save, 9);
      int data[][2] = { 1, -1,
                        5, -1,
                        15, -1,
                        30, -1,
                        60, -1,
                        240, -1,
                        1440, -1,
                        10080, -1,
                        43200, -1
                      };
      ArrayCopy(IsNewBar_Save, data, 0, 0);

   }
   bool              CChart_IsNewBar(ENUM_TIMEFRAMES_OI tf)
   {
      if(tf == -1) {
         //This timefram is OFF
         return   false;
      }
      //---

      int   pointer = -1;
      int   cnt = ArraySize(IsNewBar_Save) / 2;
      for(int i = 0; i < cnt; i++) {
         if(IsNewBar_Save[i][0] == tf) {
            pointer = i;
         }
      }
      //
      int getBar = iBars(NULL, tf);
      if(IsNewBar_Save[pointer][1] != getBar) {

         if(IsNewBar_Save[pointer][1] == -1) {
            IsNewBar_Save[pointer][1] = getBar;
            return   false;
         }

         IsNewBar_Save[pointer][1] = getBar;
         return   true;
      }
      return   false;
   }

   string            OnTick_String()
   {
      IsOnTick_Bool = !IsOnTick_Bool;
      IsOnTick_String = (IsOnTick_Bool) ? "H" : "O";

      return   IsOnTick_String;
   }
   string            OnTimer_String()
   {
      IsTimer_Bool = !IsTimer_Bool;
      IsTimer_String = (IsTimer_Bool) ? "H" : "O";

      return   IsTimer_String;
   }
   bool              ObjectDelete_(string   object_name)
   {
      return   ObjectDelete( 0, ea_nameShort + "_" + object_name);
   }

   bool              HLineCreate(string                name,    // line name
                                 double                price,         // line price
                                 color                 clr,      // line color
                                 const int             width = 1,       // line width
                                 const ENUM_LINE_STYLE style = STYLE_SOLID, // line style



                                 const bool            back = false,      // in the background
                                 const bool            selection = false,  // highlight to move
                                 const bool            hidden = false,     // hidden in the object list
                                 const long            z_order = 0)       // priority for mouse click
   {
      long            chart_ID = 0;      // chart's ID
      int             sub_window = 0;    // subwindow index

      name = ea_nameShort + "_" + name;

//--- if the price is not set, set it at the current Bid price level
      if(!price)
         price = SymbolInfoDouble(Symbol(), SYMBOL_BID);

      ResetLastError();
      if(!ObjectCreate(chart_ID, name, OBJ_HLINE, sub_window, 0, price)) {

         ObjectMove(chart_ID, name, 0, 0, price);
         ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);

      } else {
         ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
         ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);

         ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
         ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
         ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
         ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
         ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
      }

      return   true;
   }
   bool              VLineCreate(string               name = "VLine",    // line name
                                 string               Text = "",           //Text
                                 datetime             time = 0,          // line time

                                 const ENUM_LINE_STYLE style = STYLE_SOLID, // line style
                                 const color           clr = clrGray,      // line color
                                 const int             width = 1,         // line width
                                 const bool            back = false,      // in the background
                                 const bool            selection = false,  // highlight to move
                                 const bool            hidden = true,     // hidden in the object list
                                 const long            z_order = 0)       // priority for mouse click
   {
      long            chart_ID = 0;      // chart's ID
      int             sub_window = 0;    // subwindow index

      name = ea_nameShort + "_" + name;

//--- if the line time is not set, draw it via the last bar
      if(!time)
         time = TimeCurrent();
//--- reset the error value
      ResetLastError();
//--- create a vertical line
      if(!ObjectCreate(chart_ID, name, OBJ_VLINE, sub_window, time, 0)) {
         ObjectMove(chart_ID, name, 0, time, 0);

         ObjectSetString(chart_ID, name, OBJPROP_TEXT, Text);
         ObjectSetString(chart_ID, name, OBJPROP_TOOLTIP, Text);

         ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);

         return(false);
      }
      ObjectMove(chart_ID, name, 0, time, 0);

      ObjectSetString(chart_ID, name, OBJPROP_TEXT, Text);
      ObjectSetString(chart_ID, name, OBJPROP_TOOLTIP, Text);

      ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);

//---
      ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);
      ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
      ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);

      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
      ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);

      ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);

      ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
      return(true);
   }
private:
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSignal: public CChart
{
   double            inStochastic(int          timeframe,               // timeframe
                                  int          mode,                    // line index
                                  int          shift,                   // shift

                                  int          method = MODE_SMA,       // averaging method
                                  int          price_field = 0          // price (Low/High or Close/Close)

                                 )
   {
      return NormalizeDouble(iStochastic(NULL, timeframe, exSig_STO_Kperiod, exSig_STO_Dperiod, exSig_STO_slowing, method, price_field, mode, shift), 4);
   }

public :

   int               Signal_Main()
   {

      return   -1;
   }

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class COrder: public CSignal
{
public:
   //---
   struct SPosition {
      int            TotalTrades;
      int            TotalPending;

      int            TotalPending_Hege;

      double         SumSize;
      double         SumProduct;
      double         Distance;
      double         PriceTop;
      double         PriceBot;
      double         Holding;


      double         Tailing_Price;       // -1 = Normal,   -2 = Invalid
      int            Tailing_DistancePoint;
      int            Tailing_State;
   };
   SPosition          Order[2];
//---
   struct SPort {
      int            TotalTrades;
      int            TotalPending;
      double         Net_Lots;
      double         Net_Holding;

      double         Drawdown;
      double         Lots_Collect;
   };
   SPort             Port;
//---
   double            OrderLot_getMartigel(double  strat, double   Multi, double   Liner)
   {
      return  NormalizeDouble(strat * MathPow(Multi, Liner), 2);
   }
   int               OrderSend_Active(int   OP_DIR, int Magicnumber, double   lot, int  OrderLiner)
   {
      string   OrderTagsCMM = ea_nameShort + "-" + string(OrderLiner);
//---
      double   price = (OP_DIR == OP_BUY) ? Ask : Bid;
      price = NormalizeDouble(price, Digits);

      Print(__FUNCSIG__, " #", __LINE__, " OP_DIR: ", OP_DIR);
      Print(__FUNCSIG__, " #", __LINE__, " lot: ", lot);
      Print(__FUNCSIG__, " #", __LINE__, " price: ", price);

      int ticket = OrderSend(Symbol(), OP_DIR, lot, price, 1, 0, 0, OrderTagsCMM, Magicnumber, 0);
      if(ticket < 0) {
         Print("OrderSend failed with error #", GetLastError());
      } else {
         Port.Lots_Collect += lot;
      }


      Print(__FUNCSIG__, " #", __LINE__, " ticket: ", ticket);

      return   ticket;
   }
   //---
   void              Order_Reader()
   {
      /*
      Every tick
      Order Close
      Order Delete
      */
      Order[OP_BUY].TotalTrades   = 0;
      Order[OP_BUY].TotalPending  = 0;

      Order[OP_BUY].TotalPending       = 0;

      Order[OP_BUY].SumSize       = 0;
      Order[OP_BUY].SumProduct    = 0;
      Order[OP_BUY].PriceTop      = 100000000;
      Order[OP_BUY].Holding       = 0;

      Order[OP_BUY].Tailing_Price   = -1;
//---
      Order[OP_SELL].TotalTrades  = 0;
      Order[OP_SELL].TotalPending = 0;

      Order[OP_SELL].TotalPending_Hege  = 0;

      Order[OP_SELL].SumSize      = 0;
      Order[OP_SELL].SumProduct   = 0;
      Order[OP_SELL].PriceBot     = 0;
      Order[OP_SELL].Holding      = 0;

      Order[OP_SELL].Tailing_Price   = -1;
//---
      Port.TotalTrades       = 0;
      Port.TotalPending      = 0;

      Port.Net_Lots          = 0;
      Port.Net_Holding       = 0;
//---

      int total = OrdersTotal();
      for(int i = 0; i < total; i++) {

         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) &&
            OrderSymbol() == Symbol()) {
            int   type        =  OrderType();
            int   MagicNumber =  OrderMagicNumber();

            if(MagicNumber == exOrder_Magicnumber) {

               {
                  if(type == OP_BUY) {
                     Order[OP_BUY].TotalTrades++;

                     Order[OP_BUY].SumProduct += OrderOpenPrice() * OrderLots();
                     Order[OP_BUY].SumSize += OrderLots();
                     Order[OP_BUY].Holding += OrderProfit() + OrderSwap() + OrderCommission();

                     Order[OP_BUY].PriceTop = MathMin(Order[OP_BUY].PriceTop, OrderOpenPrice());

                     {
                        double   OrderStopLoss_  = OrderStopLoss();
                        if(Order[OP_BUY].Tailing_Price == -1) {
                           Order[OP_BUY].Tailing_Price = OrderStopLoss_;
                        } else {
                           if(Order[OP_BUY].Tailing_Price != -2 &&
                              Order[OP_BUY].Tailing_Price != OrderStopLoss_) {

                              Order[OP_BUY].Tailing_Price = -2;

                           }
                        }
                     }

                  }
                  if(type == OP_BUYLIMIT || type == OP_BUYSTOP) {
                     Order[OP_BUY].TotalPending++;
                  }
               }
               {
                  if(type == OP_SELL) {
                     Order[OP_SELL].TotalTrades++;

                     Order[OP_SELL].SumProduct += OrderOpenPrice() * OrderLots();
                     Order[OP_SELL].SumSize += OrderLots();
                     Order[OP_SELL].Holding += OrderProfit() + OrderSwap() + OrderCommission();

                     Order[OP_SELL].PriceBot = MathMax(Order[OP_SELL].PriceBot, OrderOpenPrice());

                     {
                        double   OrderStopLoss_  = OrderStopLoss();
                        if(Order[OP_SELL].Tailing_Price == -1) {
                           Order[OP_SELL].Tailing_Price = OrderStopLoss_;
                        } else {
                           if(Order[OP_SELL].Tailing_Price != -2 &&
                              Order[OP_SELL].Tailing_Price != OrderStopLoss_) {

                              Order[OP_SELL].Tailing_Price = -2;

                           }
                        }
                     }

                  }
                  if(type == OP_SELLLIMIT || type == OP_SELLSTOP) {
                     Order[OP_SELL].TotalPending++;
                  }
               }

            }
            if(MagicNumber == 0) {

            }
         }

      }
      //---
      {
         if(Order[OP_BUY].SumProduct > 0) {
            Order[OP_BUY].SumProduct /= Order[OP_BUY].SumSize;
            NumRowDigits(Order[OP_BUY].SumProduct);

            HLineCreate("OP_BUY-SumProduct", Order[OP_BUY].SumProduct, clrRoyalBlue);
         } else {
            ObjectDelete_("OP_BUY-SumProduct");
         }
         //
         if(Order[OP_SELL].SumProduct > 0) {
            Order[OP_SELL].SumProduct /= Order[OP_SELL].SumSize;
            NumRowDigits(Order[OP_SELL].SumProduct);

            HLineCreate("OP_SELL-SumProduct", Order[OP_SELL].SumProduct, clrTomato);
         } else {
            ObjectDelete_("OP_SELL-SumProduct");
         }
      }
      {
         if(Order[OP_BUY].TotalTrades >= 1) {

            Order[OP_BUY].Distance   =  Bid - Order[OP_BUY].PriceTop;

            NumRowDigits(Order[OP_BUY].Distance);
            {
               if(Order[OP_BUY].Tailing_Price == 0) {
                  Order[OP_BUY].Tailing_DistancePoint = int((Bid - Order[OP_BUY].SumProduct) / Point);

                  Order[OP_BUY].Tailing_State  = 0;
               }
               if(Order[OP_BUY].Tailing_Price > 0) {
                  Order[OP_BUY].Tailing_DistancePoint = int((Bid - Order[OP_BUY].Tailing_Price) / Point);

                  Order[OP_BUY].Tailing_State  = 1;
               }
            }
         }
         //
         if(Order[OP_SELL].TotalTrades >= 1) {
            Order[OP_SELL].Distance   =  Order[OP_SELL].PriceBot - Ask;

            NumRowDigits(Order[OP_SELL].Distance);
            {
               if(Order[OP_SELL].Tailing_Price == 0) {
                  Order[OP_SELL].Tailing_DistancePoint = int((Order[OP_SELL].SumProduct - Ask) / Point);

                  Order[OP_SELL].Tailing_State  = 0;
               }
               if(Order[OP_SELL].Tailing_Price > 0) {
                  Order[OP_SELL].Tailing_DistancePoint = int((Order[OP_SELL].Tailing_Price - Ask) / Point);

                  Order[OP_SELL].Tailing_State  = 1;
               }
            }
         }
      }
      {
         Port.TotalTrades   = Order[OP_BUY].TotalTrades + Order[OP_SELL].TotalTrades;
         Port.TotalPending   = Order[OP_BUY].TotalPending + Order[OP_SELL].TotalPending;

         Port.Net_Lots          = Order[OP_BUY].SumSize - Order[OP_SELL].SumSize;
         Port.Net_Holding       = Order[OP_BUY].Holding + Order[OP_SELL].Holding;

         if(Port.Net_Holding < 0) {
            if(Port.Drawdown > Port.Net_Holding) {
               Port.Drawdown = Port.Net_Holding;
            }
         }

      }
   }
   //---
   void              Order_ActiveClose(int OP_DIR, int Magic)
   {

      int   ORDER_TICKET_CLOSE[];
      ArrayResize(ORDER_TICKET_CLOSE, OrdersTotal());
      ArrayInitialize(ORDER_TICKET_CLOSE, EMPTY_VALUE);

      for(int pos = OrdersTotal() - 1; pos >= 0 ; pos--) {
         //for(int pos = 0; pos < OrdersTotal(); pos++) {
         if(
            (OrderSelect(pos, SELECT_BY_POS)) &&
            (OrderSymbol() == Symbol()) &&
            ((OP_DIR != -1 && OrderType() == OP_DIR) || (OP_DIR == -1)) &&
            (OrderMagicNumber() == Magic)
         ) {
            ORDER_TICKET_CLOSE[pos] = OrderTicket();
         }

      }
      //---
      ArraySort(ORDER_TICKET_CLOSE, WHOLE_ARRAY, 0, MODE_DESCEND);

      for(int i = 0; i < ArraySize(ORDER_TICKET_CLOSE); i++) {
         if(ORDER_TICKET_CLOSE[i] != EMPTY_VALUE) {
            if(OrderSelect(ORDER_TICKET_CLOSE[i], SELECT_BY_TICKET) == true) {
               //bool z=OrderDelete(OrderTicketClose[i]);
               int MODE = (OrderType() == OP_BUY) ? MODE_BID : MODE_ASK;
               bool z = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE), 10);
               if(GetLastError() == 0) {
                  ORDER_TICKET_CLOSE[i] = EMPTY_VALUE;
               }
            }
         }
      }
      ArrayResize(ORDER_TICKET_CLOSE, 1);

      PlaySound("alert");

      Order_Reader();

   }
   //---
   void              Order_PendingDelete(int OP_DIR, int Magic)
   {

      int ORDER_TICKET_CLOSE[];
      ArrayResize(ORDER_TICKET_CLOSE, OrdersTotal());
      ArrayInitialize(ORDER_TICKET_CLOSE, EMPTY_VALUE);

      //---
      int   OP_Del = -1;

      if(OP_DIR == OP_BUY)
         OP_Del = OP_BUYSTOP;

      if(OP_DIR == OP_SELL)
         OP_Del = OP_SELLSTOP;
      //---

      for(int pos = 0; pos < OrdersTotal(); pos++) {
         if((OrderSelect(pos, SELECT_BY_POS)) &&
            (OrderSymbol() == Symbol()) &&

            ((OP_DIR != -1 && OrderType() == OP_Del) || (OP_DIR == -1 && OrderType() > OP_SELL)) &&

            (OrderMagicNumber() == Magic))

            ORDER_TICKET_CLOSE[pos] = OrderTicket();
      }
      //+---------------------------------------------------------------------+
      for(int i = 0; i < ArraySize(ORDER_TICKET_CLOSE); i++) {
         if(ORDER_TICKET_CLOSE[i] != EMPTY_VALUE) {
            if(OrderSelect(ORDER_TICKET_CLOSE[i], SELECT_BY_TICKET)) {
               bool z = OrderDelete(ORDER_TICKET_CLOSE[i]);
            }
         }
      }
      ArrayResize(ORDER_TICKET_CLOSE, 1);

      Order_Reader();

   }

};
//+------------------------------------------------------------------+
class CExpert : public COrder
{
   int               Tailing_DistancePoint;
   //---
public:
//---
   bool              OnTick_Syn()
   {

      OnTick_Order();
      Comment_();

      return   true;
   }
   bool              OnTick_Order()
   {
      Order_Reader();
      //---
      //Global Value
      //OP_DirHoding            =  -1;
      //---

      CChart_IsNewBar(exSig_TF);
      //Order[OP_BUY]
      //Order[OP_SELL]
      //Port[]



      return   false;
   }
   //---
   void              Comment_()
   {
      string   CMM   =  "\n";
      //CMM += "OP_DirHoding : " + string(OP_DirHoding) + "\n";
      CMM += "Tailing_DistancePoint_BUY : " + string(Order[OP_BUY].Tailing_DistancePoint) + "\n";
      CMM += "Tailing_DistancePoint_Sell : " + string(Order[OP_SELL].Tailing_DistancePoint) + "\n";
      CMM += "\n";

      CMM += "Port.Drawdown : " + DoubleToStr(Port.Drawdown, 2) + "\n";
      CMM += "Port.Lots_Collect : " + DoubleToStr(Port.Lots_Collect, 2) + "\n";
      CMM += "\n";

      CMM += "Balance : " + DoubleToStr(AccountBalance(), 2) + "\n";
      CMM += "Holding : " + DoubleToStr(AccountProfit(), 2) + "\n";

      Comment(CMM);

   }
   //---
//   bool              Detect_TakeValue()
//   {
//      if(!exOrder_TP_IO) {
//         return   false;
//      }
//      //---
//
//      //double   Order_TP_NAV =  (exOrder_TP_Cap / 100) * exOrder_TP_Per;
//      double   Order_TP_NAV =  (AccountBalance() / 100) * exOrder_TP_Per;
//
//      {
//         if(Order[OP_BUY].TotalTrades > 0) {
//
//            if(Order[OP_BUY].Holding >= Order_TP_NAV) {
//               Order_ActiveClose(OP_BUY, exOrder_Magicnumber);
//
//               return   true;
//            }
//         }
//      } {
//         if(Order[OP_SELL].TotalTrades > 0) {
//
//            if(Order[OP_SELL].Holding >= Order_TP_NAV) {
//               Order_ActiveClose(OP_SELL, exOrder_Magicnumber);
//
//               return   true;
//            }
//         }
//      }
//
//      return   false;
//   }

};
//+------------------------------------------------------------------+
