import 'dart:convert';

import 'package:app_lecturador/features/consumos/domain/entities/conexion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class UbicacionConexionScreen extends StatefulWidget {
  const UbicacionConexionScreen({
    super.key,
    required this.conexion,
  });

  final Conexion conexion;

  @override
  State<UbicacionConexionScreen> createState() =>
      _UbicacionConexionScreenState();
}

class _UbicacionConexionScreenState extends State<UbicacionConexionScreen> {
  bool _loading = true;
  bool _satelliteMode = false;
  String? _infoMessage;
  Position? _currentPosition;
  double? _distanceKm;
  int? _walkingMinutes;
  List<LatLng> _routePoints = const [];

  LatLng get _destination => LatLng(
        widget.conexion.direccion.latitud!,
        widget.conexion.direccion.longitud!,
      );

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    setState(() {
      _loading = true;
      _infoMessage = null;
    });

    try {
      final permissionGranted = await _ensureLocationPermission();
      if (!permissionGranted) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _infoMessage =
              'Activa la ubicacion del dispositivo para ver la ruta caminando.';
        });
        return;
      }

      final current = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final route = await _fetchWalkingRoute(current);

      if (!mounted) return;
      setState(() {
        _currentPosition = current;
        _routePoints = route.points;
        _distanceKm = route.distanceKm;
        _walkingMinutes = route.walkingMinutes;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _infoMessage =
            'No se pudo calcular la ruta en este momento. Igual puedes ver la ubicacion de la casa.';
      });
    }
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<_WalkingRoute> _fetchWalkingRoute(Position current) async {
    final uri = Uri.parse(
      'https://router.project-osrm.org/route/v1/foot/'
      '${current.longitude},${current.latitude};'
      '${_destination.longitude},${_destination.latitude}'
      '?overview=full&geometries=geojson',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('No se pudo obtener la ruta');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final routes = decoded['routes'] as List? ?? const [];
    if (routes.isEmpty) {
      throw Exception('Ruta no disponible');
    }

    final firstRoute = routes.first as Map<String, dynamic>;
    final geometry = firstRoute['geometry'] as Map<String, dynamic>? ?? {};
    final coordinates = geometry['coordinates'] as List? ?? const [];
    final points = coordinates
        .whereType<List>()
        .where((item) => item.length >= 2)
        .map(
          (item) => LatLng(
            (item[1] as num).toDouble(),
            (item[0] as num).toDouble(),
          ),
        )
        .toList();

    final distanceMeters = (firstRoute['distance'] as num?)?.toDouble() ?? 0;
    final durationSeconds = (firstRoute['duration'] as num?)?.toDouble() ?? 0;

    return _WalkingRoute(
      points: points,
      distanceKm: distanceMeters / 1000,
      walkingMinutes: (durationSeconds / 60).ceil(),
    );
  }

  LatLng get _initialCenter {
    if (_currentPosition == null) {
      return _destination;
    }

    return LatLng(
      (_currentPosition!.latitude + _destination.latitude) / 2,
      (_currentPosition!.longitude + _destination.longitude) / 2,
    );
  }

  double get _initialZoom {
    if (_currentPosition == null) {
      return 16;
    }

    if ((_distanceKm ?? 0) > 4) {
      return 13;
    }
    if ((_distanceKm ?? 0) > 2) {
      return 14;
    }
    return 15;
  }

  @override
  Widget build(BuildContext context) {
    final direccion = widget.conexion.direccion;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicacion del cliente'),
      ),
      body: Container(
        color: const Color(0xFFF4F8FB),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFDDE7F1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.conexion.cliente.nombreCompleto,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF102A43),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      direccion.descripcionCorta,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF526074),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _MapInfoChip(
                          icon: Icons.route_rounded,
                          label: _distanceKm == null
                              ? 'Distancia no disponible'
                              : '${_distanceKm!.toStringAsFixed(1)} km',
                        ),
                        _MapInfoChip(
                          icon: Icons.directions_walk_rounded,
                          label: _walkingMinutes == null
                              ? 'Tiempo no disponible'
                              : '$_walkingMinutes min caminando',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment<bool>(
                                value: false,
                                label: Text('Mapa'),
                                icon: Icon(Icons.map_outlined),
                              ),
                              ButtonSegment<bool>(
                                value: true,
                                label: Text('Satelital'),
                                icon: Icon(Icons.satellite_alt_outlined),
                              ),
                            ],
                            selected: {_satelliteMode},
                            onSelectionChanged: (selection) {
                              setState(() {
                                _satelliteMode = selection.first;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton.filledTonal(
                          onPressed: _loadRoute,
                          icon: const Icon(Icons.refresh_rounded),
                          tooltip: 'Recalcular ruta',
                        ),
                      ],
                    ),
                    if (_infoMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _infoMessage!,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: MapOptions(
                          initialCenter: _initialCenter,
                          initialZoom: _initialZoom,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: _satelliteMode
                                ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                                : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'app_lecturador',
                          ),
                          if (_routePoints.isNotEmpty)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: _routePoints,
                                  strokeWidth: 5,
                                  color: const Color(0xFF2F80ED),
                                ),
                              ],
                            ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _destination,
                                width: 72,
                                height: 72,
                                child: const _MapMarker(
                                  icon: Icons.home_rounded,
                                  color: Color(0xFFC44536),
                                  label: 'Casa',
                                ),
                              ),
                              if (_currentPosition != null)
                                Marker(
                                  point: LatLng(
                                    _currentPosition!.latitude,
                                    _currentPosition!.longitude,
                                  ),
                                  width: 82,
                                  height: 72,
                                  child: const _MapMarker(
                                    icon: Icons.my_location_rounded,
                                    color: Color(0xFF1F9D68),
                                    label: 'Tu ubicacion',
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      if (_loading)
                        Container(
                          color: Colors.white.withAlpha(180),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapInfoChip extends StatelessWidget {
  const _MapInfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0F4C81)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF102A43),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF102A43),
            ),
          ),
        ),
      ],
    );
  }
}

class _WalkingRoute {
  const _WalkingRoute({
    required this.points,
    required this.distanceKm,
    required this.walkingMinutes,
  });

  final List<LatLng> points;
  final double distanceKm;
  final int walkingMinutes;
}
