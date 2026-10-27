import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('HyperIcons aliases the full regular Lucide icon library', () {
    const IconData icon = HyperIcons.search;
    expect(icon, LucideIcons.search);
    expect(HyperIcons.chevronRight, LucideIcons.chevronRight);
    expect(icon.fontPackage, 'lucide_icons_flutter');
  });
}
