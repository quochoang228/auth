import 'package:ag/ag.dart';
import 'package:ds/ds.dart';
import 'package:di/di.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:convert';
import 'package:logs/logs.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:router/router.dart';
import 'package:utils/utils.dart';

/// part --

part 'src/constant/auth_constant.dart';
part 'src/data/api/auth_api.dart';
part 'src/data/local/auth_local_storage.dart';
part 'src/data/repository/auth_repository.dart';
part 'src/di/auth_di.dart';
part 'src/entities/user.dart';
part 'src/entities/auth_token.dart';
part 'src/entities/auth_res.dart';

part 'src/services/auth_service.dart';

part 'src/ui/page/login_page.dart';
part 'src/ui/provider/login_provider.dart';
part 'src/ui/provider/local_user_provider.dart';
