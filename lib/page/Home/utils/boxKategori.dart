import 'package:flutter/material.dart';
import 'package:spk_app/page/Sepatu/view/viewSepatu.dart';

class BoxKategori extends StatelessWidget {
  final String title;
  final String imageUrl;
  const BoxKategori({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Navigate to the next page or perform an action
            if (title == 'Compass') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSepatu(idCollection: 'compass'),
                ),
              );
            } else if (title == 'Kanky') {
              // Handle other categories if needed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSepatu(idCollection: 'kanky'),
                ),
              );
            } else if (title == 'Patrobas') {
              // Handle other categories if needed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSepatu(idCollection: 'patrobas'),
                ),
              );
            } else {
              print('Unknown category: $title');
            }
          },
          splashColor: Colors.transparent,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 239, 255, 251),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: 2.0,
                  ),
                ),
                height: 150.0,
                width: double.infinity,
              ),
            ],
          ),
        );
  }
}
