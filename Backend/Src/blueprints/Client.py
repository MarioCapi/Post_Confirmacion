import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)) + '/..')

from flask import request, jsonify, render_template
from flask_cors import  cross_origin
from flask import Blueprint, request, jsonify
from blueprints.execProcedure import execute_procedure_read

client_bp = Blueprint('client', __name__)

@cross_origin
@client_bp.route('/api/client_read/<int:id>', methods=['GET'])
def client_read(id):
    id_str = str(id)
    result = execute_procedure_read('leer_cliente', (id_str,))
    return jsonify({"message":result}), 200


@cross_origin
@client_bp.route('/api/client_create', methods=['POST'])
def client_create():
    data = request.json
    _userAPI_rest = "apiRest_User"
    result = execute_procedure_read('insertar_cliente', (data['nombre_razonsocial'],(data['numero_identificacion']),data['correo_electronico'],data['telefono'],
                                                            data['direccion_envio'],(data['direccion_facturacion'])))

    return jsonify({'message': result}), 200




@cross_origin
@client_bp.route('/api/client_update', methods=['PUT'])
def client_update():
    data = request.json    
    try:
        result = execute_procedure_read('actualizar_cliente', (int(data['id']),data['nombre_razonsocial'],(data['numero_identificacion']),data['correo_electronico'],data['telefono'],
                                                            data['direccion_envio'],(data['direccion_facturacion'])))
        return jsonify({'message': 'Cliente actualizado exitosamente'})
    except Exception as e:
        return jsonify({'error': 'Error actualizando el Cliente'}), 500
    
    

@cross_origin
@client_bp.route('/api/client_delete/<int:id>', methods=['DELETE'])
def client_delete(id):
    try:
        execute_procedure_read('eliminar_cliente', (id,))
        return jsonify({'message': "Cliente Eliminado"})
    except Exception as e:
        return jsonify({'message': "Error Eliminando Cliente Eliminado"}), 500
    