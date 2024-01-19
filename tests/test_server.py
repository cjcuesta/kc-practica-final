import requests

# URL base para tu aplicación Flask
BASE_URL = "http://localhost:8181"

def test_index():
    response = requests.get(f"{BASE_URL}/")
    assert response.status_code == 200

def test_add():
    data = {'name': 'Test Name222', 'phone': '123456789', 'address': 'Test Address', 'save': 'some_value'}
    response = requests.get(f"{BASE_URL}/add/")
    assert response.status_code == 200

""" def test_addphone():
    data = {'name': 'Test Name', 'phone': '123456789', 'address': 'Test Address', 'save': 'some_value'}
    response = requests.post(f"{BASE_URL}/addphone", data=data)
    assert response.status_code == 302 """

def test_update():
    # Suponiendo que tienes un ID válido para probar
    valid_id = 1
    response = requests.get(f"{BASE_URL}/update/{valid_id}/")
    assert response.status_code == 200

def test_updatephone():
    data = {
        'id': 1,
        'phone_number': '987654321',
        'description': 'Updated phone number'
    }
    response = requests.post(f"{BASE_URL}/updatephone", data=data)

def test_delete():
    # Suponiendo que tienes un ID válido para probar
    valid_id = 1
    response = requests.get(f"{BASE_URL}/delete/{valid_id}/")
    assert response.status_code == 200

""" def test_deletephone():
    data = {'id': 1}
    response = requests.post(f"{BASE_URL}/deletephone", data=data)
    assert response.status_code == 302 """

def test_metrics():
    response = requests.get(f"{BASE_URL}/metrics")
    assert response.status_code == 200

""" def test_404():
    response = requests.get(f"{BASE_URL}/nonexistent")
    assert response.status_code == 404 """
