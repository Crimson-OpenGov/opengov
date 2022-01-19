import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: CustomScrollView(
        physics: const ScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(84 * .22),
                  child: Image.asset('assets/images/icon.png', width: 84),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Crimson OpenGov',
                      style: TextStyle(fontSize: 24),
                    ),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (_, snapshot) => snapshot.hasData
                          ? Text(
                              'Version ${snapshot.data!.version}+'
                              '${snapshot.data!.buildNumber}',
                              style: const TextStyle(fontSize: 16),
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: ListTile(
              title: const Text('Developed by Noah Rubin'),
              leading: const Icon(Icons.person),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                launch('https://nrubintech.com');
              },
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              title: const Text('Source code'),
              leading: const Icon(Icons.code),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                launch('https://github.com/nrubin29/opengov');
              },
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              title: const Text('Licenses'),
              leading: const Icon(Icons.integration_instructions),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text('\u00a9 2020-2022 Noah Rubin Technologies LLC'),
                  Text('All rights reserved'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
