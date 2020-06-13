import 'package:aspen/aspen.dart';
import 'package:aspen_assets/aspen_assets.dart';

part 'assets.g.dart';

@Asset('asset:matrix_invite_frontend/web/config.json')
const configJson = JsonAsset(text: _configJson$content);
