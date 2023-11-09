//+------------------------------------------------------------------+
//|                                             TraderClub_FW001.mq4 |
//|                               Copyright 2023, Thongeax Studio TH |
//|                               https://www.facebook.com/lapukdee/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Thongeax Studio TH"
#property link      "https://www.facebook.com/lapukdee/"
//+------------------------------------------------------------------+
#define   ea_version    /*STORSI-*/"1.00"
#property version       ea_version
#property strict

#define   ea_nameShort    "STORSI"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include "_include/extern.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
extern   string               exEAname                   = "v" + string(ea_version);   //# STORSI
extern   string               exOrder                    = " --------------- Setting --------------- ";   // --------------------------------------------------
extern   int                  exOrder_Magicnumber        = 110923;            // • Magicnumber
extern   double               exOrder_Lot                = 0.1;               // • Lots
//+------------------------------------------------------------------+
extern   string               exOrder_          = " --------------- Profit --------------- ";   // --------------------------------------------------
extern   double               exOrder_TPp       = 50;       // • TP (Point)
extern   double               exOrder_SLp       = 300;      // • SL (Point)

//+------------------------------------------------------------------+
extern   string               exSig_      = " --------------- Signal --------------- ";   // --------------------------------------------------
extern   ENUM_TIMEFRAMES_OI   exSig_TF    =  TF_M5;
//+------------------------------------------------------------------+
extern   string               exSig_STO                  = " --------------- STO --------------- ";   // --------------------------------------------------
extern   int                  exSig_STO_Kperiod          = 14;                // • K
extern   int                  exSig_STO_Dperiod          = 3;                 // • D
extern   int                  exSig_STO_slowing          = 3;                 // • S
extern   double               exSig_STO_UP               = 20;                // • Level - UP
extern   double               exSig_STO_DW               = 20;                // • Level - DW
//+------------------------------------------------------------------+
extern   string               exTest_                    = " --------------- Test --------------- ";   // --------------------------------------------------
extern   bool                 exTest_OrderReason        = false;                    // • Order Reason
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include "_include/Signal_Order.mqh"
CExpert   EA;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//--- create timer
   EventSetTimer(60);

   ChartSetInteger(0, CHART_SHOW_GRID, false);
   ObjectsDeleteAll(0, ea_nameShort, 0, -1);

//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- destroy timer
   EventKillTimer();

   if(!IsTesting()) {
      Comment("");
      ObjectsDeleteAll(0, ea_nameShort, 0, -1);
   }
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   EA.OnTick_Syn();
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
//---
}
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
{
//---
   double ret = 0.0;
//---
   return(ret);
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long & lparam,
                  const double & dparam,
                  const string & sparam)
{
//---
}
//+------------------------------------------------------------------+
