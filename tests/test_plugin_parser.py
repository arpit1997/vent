import pytest

from .. import plugin_parser

def test_add_plugins():
    plugin_parser.add_plugins("foo")

def test_remove_plugins():
    plugin_parser.remove_plugins("foo")