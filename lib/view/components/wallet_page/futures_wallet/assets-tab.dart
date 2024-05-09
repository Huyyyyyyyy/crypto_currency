import 'package:crypto_currency/model/assets_stream/assets_streams.dart';
import 'package:flutter/material.dart';

class AssetTab extends StatefulWidget {
  final List<AssetStream> assets;

  const AssetTab({Key? key, required this.assets}) : super(key: key);

  @override
  State<AssetTab> createState() => _AssetTabState();
}

class _AssetTabState extends State<AssetTab> {

  @override
  void initState() {
    super.initState();
  }

  Map<String,String> assetSymbols = {
    'FDUSD':'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20230621/547d0243-261e-473b-9203-5536a0aa9e78',
    'BTC':'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/87496d50-2408-43e1-ad4c-78b47b448a6a.png',
    'BNB':'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20220218/94863af2-c980-42cf-a139-7b9f462a36c2.png',
    'ETH':'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/3a8c9fe6-2a76-4ace-aa07-415d994de6f0.png',
    'USDT':'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20240508/6180cdb6-8480-4a3c-a8a9-8a193a89fc5e.png',
    'USDC':'https://bin.bnbstatic.com/image/admin_mgs_image_upload/20201110/4cf7d633-92fb-4d37-80ed-458c7d1ea410.png'
  };


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5,0,5,5),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.assets.length,
              itemBuilder: (context, index) {
                AssetStream asset = widget.assets[index];
                String? iconUrl;
                if(asset.asset.isNotEmpty){
                  iconUrl = assetSymbols[asset.asset];
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0xFF2A323D),
                              width: 0.8
                          )
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Image.network(iconUrl!, width: 25),
                            ),
                            Text(
                              textAlign: TextAlign.start,
                              asset.asset,
                              style: const TextStyle(
                                  color: Color(0xFFD7DBDE),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Số dư ví',
                                style: TextStyle(
                                  color: Color(0xFF7F8995)
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'PNL chưa được ghi nhận',
                                style: TextStyle(
                                    color: Color(0xFF7F8995)
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                asset.walletBalance,
                                style: const TextStyle(
                                    color: Color(0xFFCBD0D3)
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                asset.crossUnPnl,
                                style: const TextStyle(
                                    color: Color(0xFFCBD0D3)
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Số dư margin',
                                style: TextStyle(
                                    color: Color(0xFF7F8995)
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Có thể chuyển được',
                                style: TextStyle(
                                    color: Color(0xFF7F8995)
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                asset.marginBalance,
                                style: const TextStyle(
                                    color: Color(0xFFCBD0D3)
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                asset.maxWithdrawAmount,
                                style: const TextStyle(
                                    color: Color(0xFFCBD0D3)
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
