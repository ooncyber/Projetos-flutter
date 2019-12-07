import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = Set();
  CameraPosition _posicaoCamera = CameraPosition(
      target: LatLng(-23.562436, -46.655005),
      zoom: 18
  );

  _onMapCreated(c){
    _controller.complete(c);
  }

  _exibirMarcador(LatLng latlng) async{

    List<Placemark> listaEnderecos = await Geolocator().placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    if(listaEnderecos != null && listaEnderecos.length>0){
      Placemark endereco = listaEnderecos[0];
      String rua = "${endereco.thoroughfare}, ${endereco.subThoroughfare}";

      Marker marcador = Marker(
        markerId: MarkerId("marcador-${latlng.latitude}-${latlng.longitude}"),
        position: latlng,
        infoWindow: InfoWindow(
          title: rua
        )
      );
      setState(() {
      _marcadores.add(marcador);
      });
    }

  }

  _movimentarCamera() async{
    GoogleMapController c = await _controller.future;
    c.animateCamera(
      CameraUpdate.newCameraPosition(_posicaoCamera)
    );
  }

  _adicionarListenerLocalizacao(){
    var g = Geolocator();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high);
    var seguir = 0;
    if(seguir == 1)
      g.getPositionStream(locationOptions).listen((Position position){
      setState(() {
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude,), zoom: 18
        );
        _movimentarCamera();
      });
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _adicionarListenerLocalizacao();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapa"),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          onLongPress: _exibirMarcador,
          markers: _marcadores,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
