part of corsac_base.test;

class TestToolsConsole extends Console {
  final String commandsEntryId = 'test_tools.commands';

  TestToolsConsole(Kernel kernel)
      : super(kernel, 'test_tools', 'Testing tools');
}
