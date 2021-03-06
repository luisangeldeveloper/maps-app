import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:maps_app/bloc/mapa/mapa_bloc.dart';
import 'package:maps_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';

import 'package:maps_app/widgets/widgets.dart';


class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  @override
  void initState() {
    BlocProvider.of<MiUbicacionBloc>(context).iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<MiUbicacionBloc>(context).cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: (context, state) => crearMapa(state),
          ),

          // TODO: Hacer el toggle cuando estoy manualmente
          Positioned(
            top: 10.0,
            child: SearchBar()
          ),

          MarcadorManual()

        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnUbicacion(),
          BtnSeguirUbicacion(),
          BtnMiRuta(),
        ],
      ),
   );
  }

  Widget crearMapa( MiUbicacionState state ) {

    if ( !state.existeUbicacion ) return Center(child: Text('Ubicando..'));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add( OnNuevaUbicacion( state.ubicacion ) );

    // return Text('${state.ubicacion.longitude}, ${state.ubicacion.latitude}');
    final camaraPosition = new CameraPosition(
      target: state.ubicacion,
      zoom: 16.0
    );

    return GoogleMap(
      initialCameraPosition: camaraPosition,
      mapType: MapType.normal,
      compassEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      // onMapCreated: ( GoogleMapController controller ) => mapaBloc.initMapa(controller),
      onMapCreated: mapaBloc.initMapa,
      polylines: mapaBloc.state.polylines.values.toSet(),
      onCameraMove: (cameraPosition) {
        // cameraPosition.target = LatLng centraldel mapa
        mapaBloc.add(OnMovioMapa(cameraPosition.target));
      },
      // onCameraIdle: () {
      //   print('MapaIdle');
      // },
    );

  }

}