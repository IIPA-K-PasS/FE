import 'package:billow/features/home/data/naver_map_api_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // 선택된 위치 정보를 저장하고 이전 화면으로 돌아가는 함수
  Future<void> _saveLocationAndExit(double lat, double lon, String locationName) async {
    setState(() { _isLoading = true; }); // 저장 중 로딩 표시 (선택 사항)
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('user_latitude', lat);
      await prefs.setDouble('user_longitude', lon);
      await prefs.setString('user_location_name', locationName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('동네가 \'$locationName\'으로 설정되었습니다.')),
        );
        // ⭐ 변경점: 저장이 완료된 후에 pop을 호출합니다.
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print("위치 저장 실패: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('동네 저장 중 오류가 발생했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }


  Future<void> _findCurrentLocation() async {
    setState(() { _isLoading = true; }); // 현재 위치 찾는 중 로딩 표시
    try {
      Position position = await _determinePosition();
      // --- 디버깅 코드 추가 ---
      print('✅ 현재 위치 좌표: Lat ${position.latitude}, Lon ${position.longitude}');
      // ---------------------

      final address = await _apiService.coordToAddress(position.latitude, position.longitude);
      // --- 디버깅 코드 추가 ---
      print('✅ 변환된 주소: $address');
      await _saveLocationAndExit(position.latitude, position.longitude, address);
    } catch (e) {
      print("현재 위치 찾기 오류: $e");
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; }); // 로딩 종료
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
          onTap: () async {
            await _saveLocationAndExit(address.lat, address.lon, address.roadAddress);
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