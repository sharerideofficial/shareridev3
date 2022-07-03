import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authentication/google_login_controller.dart';
import '/user/global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../tabPages/currentride_tab.dart';
import '/user/tabPages/History_tab.dart';
import '/user/tabPages/home_tab.dart';
import '/user/tabPages/myprofile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = index;
    });
  }

  bool driverDataloading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    getData();
  }

  Future<void> getData() async {
    if (currentUid != null) {
      userdata = await getUserDetails(currentUid);
    }

    setState(() {
      driverDataloading = false;
    });

    print("package");
  }

  @override
  Widget build(BuildContext context) {
    return !driverDataloading
        ? Consumer<GoogleSignInController>(builder: (context, model, child) {
            return BackdropScaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(40.0),
                child: BackdropAppBar(
                  backgroundColor: Colors.black,
                  title: Text("Backdrop Example"),
                  actions: <Widget>[
                    BackdropToggleButton(
                      icon: AnimatedIcons.list_view,
                    )
                  ],
                ),
              ),
              frontLayer: Scaffold(
                // backgroundColor: Colors.black,
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    HomeTabPage(),
                    CurrentRideTabPage(),
                    History(),
                    ProfileTabPage(),
                  ],
                  controller: tabController,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.add_rounded), label: "Share a ride"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.edit_road_rounded),
                        label: "Current Rides"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.history), label: "History"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: "My Profile"),
                  ],
                  unselectedItemColor: Colors.white54,
                  selectedItemColor: Colors.white,
                  backgroundColor: Colors.black,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: const TextStyle(fontSize: 14),
                  showUnselectedLabels: true,
                  currentIndex: selectedIndex,
                  onTap: onItemClicked,
                ),
              ),
              backLayer: Column(
                children: [
                  userdata != null
                      ? UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          accountName: Text('${userdata!['name']}'),
                          accountEmail: Text('${userdata!['email']}'),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text('${userdata!['name']}'
                                .substring(0, 2)
                                .toUpperCase()),
                          ),
                        )
                      : UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          accountName:
                              Text('${currentGoogleAccount!.displayName}'),
                          accountEmail: Text('${currentGoogleAccount!.email}'),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundImage: Image.network(
                                      currentGoogleAccount!.photoUrl ?? '')
                                  .image,
                              radius: 50,
                            ),
                          ),
                        ),
                  ListTile(
                    onTap: () {},
                    title: Text('My Wallet'),
                    leading: Icon(Icons.people),
                  ),
                  Divider(
                    height: 0.1,
                  ),
                  ListTile(
                      onTap: () {},
                      title: Text('Settings'),
                      leading: Icon(Icons.settings)),
                  Divider(
                    height: 0.1,
                  ),
                  ListTile(
                      onTap: () {},
                      title: Text('Share to your friends'),
                      leading: Icon(Icons.share)),
                  Divider(
                    height: 0.1,
                  ),
                  ListTile(
                      onTap: () {},
                      title: Text('Online Support'),
                      leading: Icon(Icons.contact_support)),
                  Divider(
                    height: 0.1,
                  ),
                  ListTile(
                      onTap: () {},
                      title: Text('About Us'),
                      leading: Icon(Icons.info)),
                  Divider(
                    height: 0.1,
                  ),
                  userdata != null
                      ? ListTile(
                          onTap: () {
                            fAuth.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const SplashScreen(),
                                ));
                          },
                          title: Text('Log out'),
                          leading: Icon(Icons.logout))
                      : ListTile(
                          onTap: () {
                            model.logOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const SplashScreen(),
                                ));
                          },
                          title: Text('Log out'),
                          leading: Icon(Icons.logout)),
                  Divider(
                    height: 0.1,
                  ),
                ],
              ),
            );
          })
        : Center(child: CircularProgressIndicator());
  }
}
