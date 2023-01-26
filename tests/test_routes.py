import pytest
from flask.testing import FlaskClient
from app.app import create_app

@pytest.fixture
def client():
    """test client"""
    app = create_app()
    return app.test_client()

def test_base_route(client: FlaskClient):
    """This should return http 200"""

    response = client.get('/')
    assert response.status_code == 200

def test_post_base_route(client: FlaskClient):
    """This should return 405"""

    response = client.post('/')
    assert response.status_code == 405

def test_download_file(client: FlaskClient):
    """This should return 200"""

    response = client.get('/download')
    assert response.status_code == 200
