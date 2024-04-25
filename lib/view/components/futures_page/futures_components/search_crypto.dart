import 'package:flutter/material.dart';
import 'list_search_crypto.dart';

class CryptoSearchDialog extends StatefulWidget {
  const CryptoSearchDialog({Key? key}) : super(key: key);

  @override
  _CryptoSearchDialogState createState() => _CryptoSearchDialogState();
}

class _CryptoSearchDialogState extends State<CryptoSearchDialog> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.85, // Initial height of the draggable sheet
            minChildSize: 0.2, // Minimum height of the draggable sheet
            maxChildSize: 0.9, // Maximum height of the draggable sheet
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1F2630),

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF334155),
                          hintText: 'Tìm',
                          hintStyle: const TextStyle(color: Color(0xFF94a3b8)),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF94a3b8)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8)
                          )
                        ),
                        onChanged: (value) {
                          // Implement your search logic here
                        },
                      ),
                    ),

                     Expanded(
                      child: ListSearch(onClose: () { Navigator.pop(context);}),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
