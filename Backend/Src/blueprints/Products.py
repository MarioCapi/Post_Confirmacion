from flask import request, jsonify, render_template
from flask_cors import  cross_origin
from flask import Blueprint, request, jsonify
from blueprints.execProcedure import execute_procedure_funct_read, execute_procedure, execute_procedure_read

products_bp = Blueprint('products', __name__)


@cross_origin
@products_bp.route('/api/products_create', methods=['POST'])
def create_product():
    data = request.json
    try:
        result = execute_procedure_read('sp_insert_product', (data['codeProducto'],data['nombre_producto'],
                                                            data['unidad_de_medida'], data['descripcion'],data['precio_unitario']))
        return jsonify({'message':result}),200
    except Exception as e:
        return jsonify({'message': 'Error creando producto','error':str(e)}),500


@cross_origin
@products_bp.route('/api/products_read', methods=['GET'])
def read_producto():
    try:
        result = execute_procedure_read('sp_read_producto')
        return jsonify({"message":result}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


@cross_origin
@products_bp.route('/api/products_update', methods=['PUT'])
def products_update():
    data = request.json    
    try:        
        result = execute_procedure_read('sp_update_product', (data['codeProducto'],
                                                            data['nombre_producto'],
                                                            data['unidad_de_medida'], 
                                                            data['descripcion'],
                                                            data['precio_unitario']))
        return jsonify({'message':result}),200
    except Exception as e:
        return jsonify({'error': 'Error actualizando el producto'}), 500

@cross_origin
@products_bp.route('/api/products_delete/<id>', methods=['DELETE'])
def delete_producto(id):    
    try:
        result = execute_procedure_read('sp_delete_producto', (id,))
        return jsonify({'message':result}),200
    except Exception as e:
        return jsonify({'error': 'Error eliminando el producto'}), 500
    

#if __name__ == '__main__':
#    app.run(debug=True)