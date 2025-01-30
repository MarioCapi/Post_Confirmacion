from flask import request, jsonify, render_template
from flask_cors import cross_origin
from flask import Blueprint, request, jsonify
from blueprints.execProcedure import execute_procedure, execute_procedure_read

provider_bp = Blueprint('providers', __name__)

@cross_origin
@provider_bp.route('/api/providers_read', methods=['GET'])
@provider_bp.route('/api/providers_read/<int:id>', methods=['GET'])
def read_provider(id=None):
    try:
        if id is not None:          
            result = execute_procedure('sp_read_proveedor', (None,id))
        else:
            result = execute_procedure_read('sp_read_proveedor', ())
        return jsonify({"message":result}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400   



@cross_origin
@provider_bp.route('/providers_create', methods=['POST'])  
def create_provider():
    data = request.get_json()
    try:
        if not isinstance(data['nit_proveedor'], int):
            raise ValueError("El NIT del proveedor debe ser un número entero")      
        result = execute_procedure_read('sp_create_proveedor', (
            data['nit_proveedor'],
            data['nombre'],
            data['razon'],
            data['telefono'],
            data['direccion'],
            data['correo_electronico']
        ))
        return jsonify({'message': result}), 200
    except KeyError as e:
        return jsonify({"error": f"Falta el campo requerido: {str(e)}"}), 400
    except ValueError as e:
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        return jsonify({"error": f"Error al procesar la solicitud: {str(e)}"}), 400



@cross_origin
@provider_bp.route('/api/provider_update', methods=['PUT'])
def provider_update():
    data = request.json    
    try:        
        result = execute_procedure_read(
            'sp_update_proveedor',
            (
                int(data['nit']), 
                str(data['nombre']),
                str(data['razon']),
                str(data['tel']),
                str(data['direccion']),
                str(data['email'])
            )
        )
        return jsonify({'message': result}), 200
    except Exception as e:
        return jsonify({'error': f"Error actualizando el proveedor: {str(e)}"}), 500


@cross_origin
@provider_bp.route('/api/providers_delete/<string:nit>', methods=['DELETE'])
def delete_provider(nit):
    try:
        result = execute_procedure_read('sp_delete_proveedor', (nit,))
        if result:
            return jsonify({'message': result}), 200
        else:
            return jsonify({'error': 'No se recibió respuesta del procedimiento almacenado'}), 500
    except Exception as e:        
        return jsonify({'error': f"Error al eliminar el proveedor: {str(e)}"}), 400



#if __name__ == '__main__':
#    app.run(debug=True)