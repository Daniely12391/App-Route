import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_travel_helper/models/place/place_model.dart';
import 'package:flutter_travel_helper/repository/place_search_service.dart';

part 'marker_state.dart';

class MarkerCubit extends Cubit<MarkerState> {
  MarkerCubit({required this.placeSearchService, this.selectedMarker}) : super(MarkerInitial());

  final Set<Marker> mapMarkers = {};
  late GoogleMapController controller;
  final PlaceSearchService placeSearchService;
  Marker? selectedMarker;

  Future<void> selectPlace(
    String placeId,
  ) async {
    mapMarkers.clear();
    final results = await placeSearchService.getPlace(placeId);

    Marker marker = Marker(
      markerId: MarkerId(results!.result!.placeId!),
      position: LatLng(results.result!.geometry!.location!.lat!, results.result!.geometry!.location!.lng!),
    );

    mapMarkers.add(marker);

    selectedMarker = marker;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 12,
          target: LatLng(
            results.result!.geometry!.location!.lat!,
            results.result!.geometry!.location!.lng!,
          ),
        ),
      ),
    );
    emit(MarkerComplate(results));
  }
}
