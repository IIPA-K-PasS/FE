import 'package:billow/features/home/data/naver_map_api_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NeighborhoodSettingScreen extends StatefulWidget {
  const NeighborhoodSettingScreen({super.key});

  @override
  State<NeighborhoodSettingScreen> createState() => _NeighborhoodSettingScreenState();
}

class _NeighborhoodSettingScreenState extends State<NeighborhoodSettingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NaverMapApiService _apiService = NaverMapApiService();
  List<Address> _searchResults = [];
  bool _isLoading = false;

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final results = await _apiService.searchAddress(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print("api 호출 실패");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _findCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      final address = await _apiService.coordToAddress(position.latitude, position.longitude);
      // TODO: 찾은 주소로 동네 설정 로직 구현
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('현재 동네: $address')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 동네 설정'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // 검색창
            TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: '동명(읍/면/동)으로 검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 검색 결과 또는 기본 화면
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchController.text.isEmpty
                  ? _buildDefaultView() // 기본 화면
                  : _buildSearchResultsView(), // 검색 결과
            ),

            // 현재 위치로 찾기 버튼
            ElevatedButton.icon(
              onPressed: _findCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('현재 위치로 찾기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 기본 상태의 중앙 UI
  Widget _buildDefaultView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(Icons.person_outline, size: 40, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 24),
        const Text('어떻게 동네를 설정할까요?', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('정확한 비교를 위해 현재 거주하는\n동네를 설정해주세요.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5)),
        const Spacer(),
      ],
    );
  }

  // 검색 결과 리스트 UI
  Widget _buildSearchResultsView() {
    if (_searchResults.isEmpty) {
      return const Center(child: Text('검색 결과가 없습니다.'));
    }
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final address = _searchResults[index];
        return ListTile(
          title: Text(address.roadAddress),
          subtitle: Text('[지번] ${address.jibunAddress}'),
          onTap: () {
            // TODO: 주소 선택 후 동네 설정 로직 구현
            print('선택된 주소: ${address.roadAddress}');
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  // (이전 답변과 동일) geolocator 권한 처리 및 위치 가져오기 함수
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('위치 서비스가 비활성화되어 있습니다.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한이 거부되었습니다.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('위치 권한이 영구적으로 거부되었습니다. 앱 설정에서 권한을 허용해주세요.');
    }
    return await Geolocator.getCurrentPosition();
  }
}