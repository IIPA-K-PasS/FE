import 'package:flutter/material.dart';

class GreenMarketButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;
  
  const GreenMarketButton({
    super.key,
    this.isEnabled = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Semantics(
        label: '그린 마켓: 포인트로 지역화폐 교환하기',
        button: true,
        enabled: isEnabled,
        child: ElevatedButton(
          onPressed: isEnabled ? (onPressed ?? () {
            // TODO: 그린 마켓 기능 구현
            print('그린 마켓 버튼 클릭됨');
          }) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[600],
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[400],
            disabledForegroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '그린 마켓',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '포인트로 지역화폐 교환하기',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
