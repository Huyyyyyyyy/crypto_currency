import 'package:flutter/material.dart';

class WishlistTab extends StatefulWidget {
  const WishlistTab({Key? key}) : super(key: key);

  @override
  _WishlistTabState createState() => _WishlistTabState();
}

class _WishlistTabState extends State<WishlistTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Text('My Wishlist Tab'),
    );
  }

  // Override this method to keep the state alive
  @override
  bool get wantKeepAlive => true;
}