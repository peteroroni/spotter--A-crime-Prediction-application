import 'package:spotter/constant-widgets/bottom_nav_bar.dart';
import 'package:spotter/constants/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityTipsView extends StatelessWidget {
  const SecurityTipsView({super.key});

  Widget bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('•  ', style: TextStyle(fontSize: 16)),
        Expanded(child: Text(text, style: kBody3Black)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 12, 1, 71),
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 250, 248, 248),
            ),
            onPressed: () => Get.offAll(() => BottomNavigationBarWidget()),
          ),
          centerTitle: true,
          title: const Text(
            'Security Tips & Guidelines',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 248, 250, 250),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.02,
            vertical: Get.height * 0.015,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. General Safety Tips:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'Always be aware of your surroundings, whether you\'re in the busy streets of Gachororo or the serene parks of the University.',
                ),
                const SizedBox(height: 12),
                bulletPoint(
                  'Avoid walking alone, especially in less populated areas or during late hours, and opt for well-lit and populated routes. Gate C can be very unsafe at odd hours.',
                ),
                const SizedBox(height: 12),
                bulletPoint(
                  'Keep your valuables secure, particularly in crowded places like the Containers or local markets, where pickpocketing incidents are reportedly common.',
                ),
                const SizedBox(height: 18),
                Text('2. Personal Safety:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'While exploring Juja\'s scenic beauty, such as the dam or the University\'s SAJOREC, walk confidently and maintain awareness of your surroundings. Be especially vigilant when cycling, hiking or trekking.',
                ),
                const SizedBox(height: 12),
                bulletPoint(
                  'Trust your intuition and be cautious of strangers, particularly in unfamiliar areas.',
                ),
                const SizedBox(height: 18),
                Text('3. Home Security:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'Ensure your home or rental apartment, as well as hostel, has sturdy locks on doors and windows. Your safety begins with you after all.',
                ),
                const SizedBox(height: 18),
                Text('4. Online Safety:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'Use strong passwords and be cautious when sharing personal information online, especially on social media platforms like Facebook or Instagram, where privacy settings are crucial.',
                ),
                const SizedBox(height: 12),
                bulletPoint(
                  'Public Wi-Fi networks may be convenient, but consider using a VPN for added security, especially when accessing sensitive information.',
                ),
                const SizedBox(height: 18),
                Text('5. Emergency Preparedness:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'Juja is equipped with efficient emergency services, including the Police Station, so familiarize yourself with emergency procedures and know how to contact emergency services if needed.',
                ),
                const SizedBox(height: 18),
                Text('6. Reporting Suspicious Activity:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'If you notice any suspicious behavior or activities, particularly in sensitive areas, report them to local law enforcement immediately and provide detailed descriptions to assist in investigations.',
                ),
                const SizedBox(height: 18),
                Text('7. Community Engagement:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'Engage with your neighbors and participate in community crime prevention efforts, particularly in residential areas, to build a strong sense of community and enhance overall safety.',
                ),
                const SizedBox(height: 12),
                bulletPoint(
                  'Stay informed about local crime prevention initiatives and community safety workshops, which are often held in community centers or local churches, to stay proactive in crime prevention efforts.',
                ),
                const SizedBox(height: 18),
                Text('8. Traffic Safety:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'Be mindful of traffic regulations and pedestrian crossings, particularly in busy areas like the junction at the highway, where traffic congestion and reckless driving may pose risks to pedestrians.',
                ),
                const SizedBox(height: 12),
                bulletPoint(
                  'Use designated pedestrian walkways and overhead bridges, especially near busy intersections to safely navigate through traffic.',
                ),
                const SizedBox(height: 18),
                Text('9. Public Transportation Safety:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'Exercise caution when using public transportation, such as buses or taxis, especially during peak hours or late at night.',
                ),
                const SizedBox(height: 12),
                bulletPoint(
                  'Choose well-known and reputable taxi services or ride-sharing apps for safer transportation options.',
                ),
                const SizedBox(height: 18),
                Text('10. Civic Responsibility:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'Dispose of waste responsibly and help maintain cleanliness in public areas, parks, and streets to promote a cleaner and safer environment for all residents.',
                ),
                const SizedBox(height: 18),
                Text('11. Cultural Sensitivity:', style: kHead3Black),
                const SizedBox(height: 6),
                bulletPoint(
                  'Respect local customs and traditions when visiting religious sites, by dressing modestly and adhering to appropriate behavior guidelines.',
                ),
                const SizedBox(height: 12),
                bulletPoint(
                  'Be mindful of cultural sensitivities and avoid engaging in activities that may be deemed offensive or disrespectful to the local population, particularly in conservative neighborhoods.',
                ),
                const SizedBox(height: 36),
                Center(
                  child: Column(
                    children: [
                      Text('Thank You and Stay Safe💚.', style: kBody3Black),
                      const SizedBox(height: 18),
                      Text('© 2025 Spotter Inc.', style: kBody3Black),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
