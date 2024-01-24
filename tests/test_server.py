import sys
import os

# Agregar el directorio source_code al sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'source_code')))

import unittest
from unittest.mock import patch
from flask import template_rendered
from contextlib import contextmanager
from flask import session


from server import app

@contextmanager
def captured_templates(app):
    recorded = []

    def record(sender, template, context, **extra):
        recorded.append((template, context))

    template_rendered.connect(record, app)
    try:
        yield recorded
    finally:
        template_rendered.disconnect(record, app)

class FlaskAppTests(unittest.TestCase):

    def setUp(self):
        app.config['TESTING'] = True
        self.app = app.test_client()

    @patch('server.db.read')
    def test_index_route(self, mock_db_read):
        mock_db_read.return_value = []  # Simula una respuesta vacía de la base de datos
        with captured_templates(app) as templates:
            response = self.app.get('/')
            self.assertEqual(response.status_code, 200)
            self.assertEqual(templates[0][0].name, 'index.html')
            self.assertEqual(templates[0][1]['data'], [])

    def test_add_route(self):
        with captured_templates(app) as templates:
            response = self.app.get('/add/')
            self.assertEqual(response.status_code, 200)
            self.assertEqual(templates[0][0].name, 'add.html')
            self.assertEqual(len(templates), 1)  # Asegurarse de que solo se haya renderizado una plantilla

    @patch('server.db.insert')
    def test_addphone_route(self, mock_db_insert):
        mock_db_insert.return_value = True  # Simula una inserción exitosa
        response = self.app.post('/addphone', data={'save': 'true'})
        self.assertEqual(response.status_code, 302)  # Redirección a '/'
        self.assertTrue(mock_db_insert.called)

    @patch('server.db.read')
    def test_update_route(self, mock_db_read):
        mock_db_read.return_value = [{}]  # Simula encontrar un registro
        response = self.app.get('/update/1')
        self.assertEqual(response.status_code, 308)  # Redirección permanente

    """ @patch('server.db.update')
    def test_updatephone_route(self, mock_db_update):
        with app.test_request_context('/updatephone'):
            session['update'] = 1  # Establecer manualmente el valor en session
            mock_db_update.return_value = True  # Simula una actualización exitosa
            response = self.app.post('/updatephone', data={'update': 'true'})
            self.assertEqual(response.status_code, 302)  # Redirección a '/' """

    @patch('server.db.read')
    def test_delete_route(self, mock_db_read):
        mock_db_read.return_value = [{}]  # Simula encontrar un registro
        response = self.app.get('/delete/1')
        self.assertEqual(response.status_code, 308)  # Redirección esperada

    """ @patch('server.db.delete')
    def test_deletephone_route(self, mock_db_delete):
        with app.test_request_context('/deletephone'):
            session['delete'] = 1  # Establecer manualmente el valor en session
            mock_db_delete.return_value = True  # Simula una eliminación exitosa
            response = self.app.post('/deletephone', data={'delete': 'true'})
            self.assertEqual(response.status_code, 302)  # Redirección a '/' """

if __name__ == '__main__':
    unittest.main()
