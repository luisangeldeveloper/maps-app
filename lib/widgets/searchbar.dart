part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if ( state.seleccionManual ) {
          return Container();
        } else {
          return FadeInDown(
            duration: Duration(milliseconds: 300),
            child: buildSearchbar(context)
          );
        }
      },
    );
  }

  Widget buildSearchbar(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric( horizontal: 30.0 ),
        width: width,
        child: GestureDetector(
          onTap: () async {
            final resultado = await showSearch(context: context, delegate: SearchDestination());
            retornoBusqueda(context, resultado);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
            width: double.infinity,
            child: Text('¿Dónde quieres ir?', style: TextStyle(color: Colors.black87, ),),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 5)
                )
              ]
            ),
          ),
        ),
      ),
    );
  }

  void retornoBusqueda( BuildContext context, SearchResult result ) {

    print('cancelo: ${result.cancelo}');
    print('manual: ${result.manual}');

    if ( result.cancelo) return;

    if ( result.manual ) {
      
      BlocProvider.of<BusquedaBloc>(context).add( OnActivarMarcadorManual() );

      return;
    }

  }


}