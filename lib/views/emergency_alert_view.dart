import 'package:sos/commons.dart';

class EmergencyAlertView extends StatefulWidget {
  final EmergencyType? emergencyType;

  const EmergencyAlertView({this.emergencyType});

  @override
  _EmergencyAlertViewState createState() => _EmergencyAlertViewState();
}

class _EmergencyAlertViewState extends State<EmergencyAlertView>
    with TickerProviderStateMixin {
  final EmergencyController _controller = EmergencyController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _alertSent = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);

    if (widget.emergencyType != null) {
      _sendEmergencyAlert();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.stopAlerts();
    super.dispose();
  }

  Future<void> _sendEmergencyAlert() async {
    setState(() {
      _alertSent = true;
    });

    await _controller.triggerEmergencyAlert(widget.emergencyType!);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.emergencyType == null) {
      return Scaffold(body: Center(child: Text('No emergency type specified')));
    }

    return Scaffold(
      backgroundColor: widget.emergencyType!.color,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Emergency Icon
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.warning,
                        size: 60,
                        color: widget.emergencyType!.color,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 40),

              // Emergency Type
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'EMERGENCY ALERT',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: widget.emergencyType!.color,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 20),

                    Text(
                      widget.emergencyType!.displayName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 20),

                    if (_alertSent) ...[
                      Icon(Icons.check_circle, color: Colors.green, size: 40),
                      SizedBox(height: 10),
                      Text(
                        'Emergency contacts have been notified!\nHelp is on the way!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.emergencyType!.color,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Sending emergency alerts...',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 40),

              // Instructions
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '📱 SMS and WhatsApp messages sent\n🔊 Emergency sound playing\n📳 Phone vibrating\n\nStay calm. Help is coming!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 40),

              // Stop Alert Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    _controller.stopAlerts();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: widget.emergencyType!.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'STOP ALERT',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
