from flask import Flask, request, jsonify
import json
import subprocess
from sentence_transformers import SentenceTransformer, util
from waitress import serve

app = Flask(__name__)

# Full path to your PHP executable
php_path = 'C:/xampp/php/php.exe'

# Path to your PHP script
php_script_path = 'C:/xampp/htdocs/flutter_api2/api_handlers/json_update.php'

# Path to your JSON file
json_file_path = 'C:/xampp/htdocs/flutter_api2/api_handlers/preference.json'

def run_php_script(script_path):
    """Run the PHP script to update the JSON file."""
    try:
        result = subprocess.run([php_path, script_path], check=True, capture_output=True, text=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"PHP script failed: {e.stderr}")

def load_user_data():
    try:
        with open(json_file_path) as f:
            json_data = json.load(f)
    except FileNotFoundError:
        return {"error": "File not found"}, 404
    except json.JSONDecodeError:
        return {"error": "Error decoding JSON"}, 500

    # Extract user data from the correct structure
    if isinstance(json_data, dict) and 'data' in json_data:
        return json_data['data']
    else:
        return {"error": "Unexpected JSON structure"}, 500

# Initialize model
model = SentenceTransformer('all-MiniLM-L6-v2')

def create_embeddings(user):
    features = [
        user.get('mbti', ''),
        user.get('personality', ''),
        user.get('sport', ''),
        user.get('food', ''),
        user.get('fashion', ''),
        user.get('interest', '')
    ]
    text = ' '.join(features)
    return model.encode(text)

def scale_similarity(similarity, old_min=0, old_max=1, new_min=0.1, new_max=1.0):
    """Scale similarity to a new range [new_min, new_max]."""
    return new_min + (similarity - old_min) * (new_max - new_min) / (old_max - old_min)

@app.route('/update-json', methods=['POST'])
def update_json():
    """Endpoint to trigger PHP script to update the JSON file."""
    run_php_script(php_script_path)
    return {"status": "JSON file updated"}, 200

@app.route('/similarities', methods=['GET'])
def get_similarities():
    """Endpoint to get similarities for a specific user ID."""
    user_id_input = request.args.get('user_id')
    if not user_id_input:
        return {"error": "User ID cannot be empty"}, 400

    print(f"Received user_id: {user_id_input}")

    # Load the updated JSON data
    user_data = load_user_data()
    if isinstance(user_data, dict) and 'error' in user_data:
        return user_data, 500

    print(f"Loaded user_data: {user_data}")

    user_input = next((user for user in user_data if user.get('user_id') == user_id_input), None)
    if not user_input:
        return {"error": f"User {user_id_input} not found in data."}, 404

    print(f"Found user_input: {user_input}")

    user_input_embeddings = create_embeddings(user_input)

    # Calculate similarities
    similarities = []
    for user in user_data:
        if user['user_id'] != user_id_input:
            user_embeddings = create_embeddings(user)
            raw_similarity = util.cos_sim(user_input_embeddings, user_embeddings).item()
            scaled_similarity = scale_similarity(raw_similarity)
            similarities.append({
                'user_id': user['user_id'],
                'similarity': int(scaled_similarity * 100)
            })


    return jsonify(similarities)


if __name__ == '__main__':
    serve(app, host='0.0.0.0', port=5000)  
