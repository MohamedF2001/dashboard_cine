import 'package:dashbord_cine/build_page.dart';
import 'package:flutter/material.dart';

class TheApp extends StatefulWidget {
  const TheApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TheAppState createState() => _TheAppState();
}

class _TheAppState extends State<TheApp> {
  int _selectedIndex = 0;

  // Mise à jour de l'index sélectionné
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      /*appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "DASHBOARD CINE",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),*/
      body: Row(
        children: [
          if (isLargeScreen)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7), // Noir très sombre
                    Colors.black.withOpacity(0.7), // Noir un peu plus clair
                    Colors.black.withOpacity(0.8), // Blanc très léger
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              width: 250, // Largeur fixe pour le NavigationRail personnalisé
              child: ListView(
                children: [
                  _buildNavigationRailDestination(
                    icon: Icons.home,
                    label: 'Home',
                    index: 0,
                  ),
                  _buildNavigationRailDestination(
                    icon: Icons.event_available,
                    label: 'Séances',
                    index: 1,
                  ),
                  _buildNavigationRailDestination(
                    icon: Icons.confirmation_number,
                    label: 'Réservations',
                    index: 2,
                  ),
                ],
              ),
            ),
          Expanded(child: buildPage(_selectedIndex)),
        ],
      ),
      drawer:
          isLargeScreen
              ? null
              : Drawer(
                child: ListView(
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Text("Menu"),
                    ),
                    ListTile(
                      title: const Text("Catégories"),
                      leading: const Icon(Icons.category_sharp),
                      selected: _selectedIndex == 0,
                      selectedColor: Colors.orangeAccent,
                      selectedTileColor: Colors.grey[300],
                      onTap: () {
                        _onItemTapped(0);
                        Navigator.of(context).pop(); // Ferme le drawer
                      },
                    ),
                    ListTile(
                      title: const Text("Produits"),
                      leading: const Icon(Icons.fastfood),
                      selected: _selectedIndex == 1,
                      selectedColor: Colors.orangeAccent,
                      selectedTileColor: Colors.grey[300],
                      onTap: () {
                        _onItemTapped(1);
                        Navigator.of(context).pop(); // Ferme le drawer
                      },
                    ),
                    ListTile(
                      title: const Text(
                        "Promotions",
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                      leading: const Icon(Icons.local_attraction),
                      selected: _selectedIndex == 2,
                      selectedColor: Colors.orangeAccent,
                      selectedTileColor: Colors.grey[300],
                      onTap: () {
                        _onItemTapped(2);
                        Navigator.of(context).pop(); // Ferme le drawer
                      },
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildNavigationRailDestination({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[300] : Colors.transparent,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.black : Colors.white),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
