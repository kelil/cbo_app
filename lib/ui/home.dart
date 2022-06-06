import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePage();
}
enum RequestState {
  ongoing,
  success,
  error,
}
class HomePage extends State<Home>{
  final _controller = TextEditingController();
 RequestState? _requestState;
  String _requestCode = "";
  String _responseCode = "";
  String _responseMessage = "";
  String _pin = "";
  String _amount = "", _phone="";
  bool check=false;
  bool buy=false;
  bool amount = false, transfer=false,phone=false, pin=false;

 
  Future<void> sendUssdRequest(type) async {
    setState(() {
      _requestState = RequestState.ongoing;
    });
    try {
      String responseMessage;
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      }
      switch (type) {
        case "CHECK_BALANCE":
          _requestCode="*841*"+_pin+"*1#";
          break;
        case "BUY_AIRTIME":
          _requestCode="*841*"+_pin+"*6*1*"+_amount+"*1#";
          break;
        case "TRANSFER_MONEY":
        //pin,2,mobile,amount,1
          _requestCode="*841*"+_pin+"*2*"+_phone+"*"+_amount+"*1#";
          break;
        default:
      }
      SimData simData = await SimDataPlugin.getSimData();
      // responseMessage = await UssdService.makeRequest(
      //     simData.cards.first.subscriptionId, _requestCode);
        responseMessage =(await UssdAdvanced.sendAdvancedUssd(code: _requestCode, subscriptionId: simData.cards.first.subscriptionId))!;
      setState(() {
        _requestState = RequestState.success;
        _responseMessage = responseMessage;
      });
    } on PlatformException catch (e) {
      setState(() {
        _requestState = RequestState.error;
        _responseCode = e is PlatformException ? e.code : "";
        _responseMessage = e.message ?? '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:  SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 25,width: 25,),
                Row(
                  children: [
                      Image.asset('images/Cooperative_Bank_of_Oromia.png', height:45, fit: BoxFit.contain),
                      const SizedBox(width: 25,height: 1),
                      const Text('Coopay-EBirr', style: TextStyle(color: Colors.lightBlue),)
                  ],
                ) ,
                const SizedBox(height: 100,),
               if (_requestState == RequestState.ongoing)
                Row(
                  children: const <Widget>[
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(width: 24),
                    Text('Ongoing request...'),
                  ],
                ),
              if (_requestState == RequestState.success) ...[
                const SizedBox(height: 30),
                Text(
                  _responseMessage,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              if (_requestState == RequestState.error) ...[
                const SizedBox(height: 30),
                Text(
                  _responseCode+" Please Try Again!",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 15),

              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.lightBlue,
                textColor: Colors.white,
                elevation: 18,
                minWidth: 200,
                height: 35,
                onPressed: (){
                setState(() {
                check = true;
                pin=true;
                _controller.clear();
                buy=false;
                transfer=false;
                amount=false;
                phone=false;
                });
              },
               child: const Text('Check Balance'),),

             if (check)
               Column(
                 children: [
                if(pin)
                   const Text("Enter Pin",style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                   PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: true,
                      obscuringCharacter: '*',
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white70,
                        selectedFillColor: Colors.lightBlue
                      
                      ),
                      
                      
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      onChanged: (newValue){
                      setState(() {
                        _pin=newValue;
                      });
                   }),
                 MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.lightBlue,
                textColor: Colors.white,
                elevation: 18,
                onPressed: _requestState == RequestState.ongoing
                    ? null
                    : () {
                        sendUssdRequest("CHECK_BALANCE");
                        setState(() {
                          check=false;
                          buy=false;
                          transfer=false;
                          phone=false;
                          amount=false;
                          pin=false;
                          _controller.clear();
                        });
                      },
                child: const Text('Check Balance'),
              ),
                 ],
               ),
             const SizedBox(height: 15),
             MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.lightBlue,
                textColor: Colors.white,
                elevation: 18,
                onPressed: (){
                setState(() {
                buy = true;
                pin=true;
                check=false;
                transfer=false;
                amount=false;
                phone=false;
                _controller.clear();
              });
           
              },
                child: const Text('Buy Airtime'),
              ),
              if (buy)
               Column(
                 children: [
                   if(pin)
                      Column(children: [
                          const Text("Enter Pin",style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                          PinCodeTextField(
                              appContext: context,
                              length: 4,
                              obscureText: true,
                              obscuringCharacter: '*',
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.underline,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.white70,
                                selectedFillColor: Colors.lightBlue
                              ),
                              
                              animationDuration: const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              onChanged: (newValue){
                              setState(() {
                                _pin=newValue;
                              });
                          }),
                          MaterialButton( 
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              color: Colors.lightBlue,
                              textColor: Colors.white,
                              elevation: 18,
                            onPressed: (){
                            setState(() {
                              amount=true;
                              pin=false;
                            });
                            },
                            child: const Text('Go'),),
                      ],)
                    ,
                  if(amount)
                    Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter Amount',
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        _amount = newValue;
                      });
                    },
                    ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          elevation: 18,
                    onPressed: _requestState == RequestState.ongoing
                        ? null
                        : () {
                            sendUssdRequest("BUY_AIRTIME");
                            setState(() {
                              check=false;
                              buy=false;
                              transfer=false;
                              phone=false;
                              amount=false;
                              pin=false;
                              _controller.clear();
                            });
                          },
                    child: const Text('Buy Airtime'),
                  ),
                      ],
                    )
                
                 ],
               ),

             const SizedBox(height: 15),

              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.lightBlue,
                textColor: Colors.white,
                elevation: 18,
                minWidth: 200,
                height: 35,
                onPressed: (){
                setState(() {
                transfer = true;
                pin=true;
                buy=false;
                check=false;
                amount=false;
                phone=false;
                _controller.clear();
                });
              },
               child: const Text('Send Money'),),
  //pin,2,mobile,amount,1
            if (transfer)
               Column(
                 children: [
                   if(pin)
                      Column(children: [
                          const Text("Enter Pin",style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                          PinCodeTextField(
                              appContext: context,
                              length: 4,
                              obscureText: true,
                              obscuringCharacter: '*',
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.underline,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.white70,
                                selectedFillColor: Colors.lightBlue
                              ),
                              
                              animationDuration: const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              onChanged: (newValue){
                              setState(() {
                                _pin=newValue;
                              });
                          }),
                          MaterialButton( 
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              color: Colors.lightBlue,
                              textColor: Colors.white,
                              elevation: 18,
                            onPressed: (){
                            setState(() {
                              phone=true;
                              amount=false;
                              pin=false;
                            });
                            },
                            child: const Text('Go'),),
                      ],)
                    ,
                    if(phone)
                      Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter phone Number',
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          _phone = newValue;
                        });
                      },
                      ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            color: Colors.lightBlue,
                            textColor: Colors.white,
                            elevation: 18,
                      onPressed: _requestState == RequestState.ongoing
                          ? null
                          : () {
                              setState(() {
                              amount=true;
                              phone=false;
                              pin=false;
                              _controller.clear();
                            });
                            },
                      child: const Text('Go'),
                    ),
                        ],
                      ),
                  if(amount)
                    Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller:_controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter Amount',
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        _amount = newValue;
                      });
                    },
                    ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          elevation: 18,
                    onPressed: _requestState == RequestState.ongoing
                        ? null
                        : () {
                            sendUssdRequest("TRANSFER_MONEY");
                            setState(() {
                              check=false;
                              buy=false;
                              transfer=false;
                              phone=false;
                              amount=false;
                              pin=false;
                              _controller.clear();
                            });
                          },
                    child: const Text('Send Money'),
                  ),
                      ],
                    )
                
                 ],
               ),
            ]),
        )
    );
  }
}