"""Focused tests for the source inspector, not Flutter application tests."""

from pathlib import Path
import tempfile
import unittest

import validate_ios_source as validator


class RouteInspectionTests(unittest.TestCase):
    def test_comments_cannot_create_routes_and_multiple_controllers_keep_prefix(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'src').mkdir()
            (root / 'src/example.ts').write_text('''
// @Controller('incorrect')
@Controller('first')
class First {
  /* @Delete('hidden') */
  @Get('items/:id') read() {}
}
@Controller('second')
class Second {
  @Post() create() {}
}
''')
            routes, unresolved = validator.backend_routes(root)
            self.assertEqual([(r['method'], r['path']) for r in routes],
                             [('GET', '/first/items/:id'), ('POST', '/second')])
            self.assertEqual(unresolved, [])

    def test_nested_call_argument_is_not_cut_at_named_argument_comma(self):
        source = "ApiEndpoints.user.doc(vehicleId: require('v', id), docId: doc), data: {}"
        self.assertEqual(validator.first_argument(source, 0),
                         "ApiEndpoints.user.doc(vehicleId: require('v', id), docId: doc)")

    def test_parameter_matching_does_not_claim_unknown_parameter_is_literal(self):
        self.assertTrue(validator.route_matches('/user/items/:id', '/user/items/:parameter'))
        self.assertTrue(validator.route_matches('/user/items/:id', '/user/items/41'))
        self.assertFalse(validator.route_matches('/user/items/history', '/user/items/:parameter'))
        self.assertFalse(validator.route_matches('/user/items/:id', '/admin/items/41'))
        self.assertFalse(validator.route_matches('/user/items/:id', '/user/items/41/logs'))

    def test_nested_generic_multiline_calls_and_method_mismatch(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'lib').mkdir()
            (root / 'lib/service.dart').write_text('''
final a = _apiClient.get<List<Map<String, dynamic>>>(
  ApiEndpoints.user
    .items, parser: read);
final b = _apiClient.delete<void>(ApiEndpoints.user.items, parser: read);
final c = _apiClient.get<dynamic>(unknownEndpoint, parser: read);
''')
            definitions = {'user.items': {'path': '/user/items'}}
            routes = [{'method': 'GET', 'path': '/user/items'}]
            calls = validator.api_calls(root, definitions, routes)
            self.assertEqual([r['status'] for r in calls],
                             ['matched', 'no_matching_route', 'unresolved'])

    def test_endpoint_interpolation_preserves_full_path(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'lib').mkdir()
            (root / 'lib/service.dart').write_text('''
final a = _apiClient.patch<void>('${ApiEndpoints.admin.teams}/$id', parser: read);
''')
            definitions = {'admin.teams': {'path': '/admin/teams'}}
            routes = [{'method': 'PATCH', 'path': '/admin/teams/:id'}]
            calls = validator.api_calls(root, definitions, routes)
            self.assertEqual(calls[0]['status'], 'matched')
            self.assertEqual(calls[0]['path'], '/admin/teams/:parameter')

    def test_unsupported_decorator_is_visible(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'src').mkdir()
            (root / 'src/example.ts').write_text("@Controller('x') class A { @Get(dynamicPath) get() {} }")
            routes, unresolved = validator.backend_routes(root)
            self.assertEqual(routes, [])
            self.assertEqual(len(unresolved), 1)


if __name__ == '__main__':
    unittest.main()
