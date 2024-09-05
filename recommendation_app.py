from flask import Flask, request, jsonify
import json
import subprocess
from sentence_transformers import SentenceTransformer, util
from waitress import serve

app = Flask(__name__)

# Full path to your PHP executable
php_path = 'C:/xampp/php/php.exe'

# Path to your PHP script and JSON files
php_script_path_update = 'C:/xampp/htdocs/flutter_api2/api_handlers/json_update.php'
json_file_path_user = 'C:/xampp/htdocs/flutter_api2/api_handlers/user.json'
json_file_path_event = 'C:/xampp/htdocs/flutter_api2/api_handlers/event.json'

# Initialize model
model = SentenceTransformer('all-MiniLM-L6-v2')

def run_php_script(script_path):
    """Run the PHP script to update the JSON file."""
    try:
        result = subprocess.run([php_path, script_path], check=True, capture_output=True, text=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"PHP script failed: {e.stderr}")

def load_json_data(file_path):
    """Load JSON data from a file."""
    try:
        with open(file_path) as f:
            json_data = json.load(f)
    except FileNotFoundError:
        return {"error": f"File not found: {file_path}"}, 404
    except json.JSONDecodeError:
        return {"error": "Error decoding JSON."}, 400

    if isinstance(json_data, dict) and 'data' in json_data:
        return json_data['data']
    else:
        return {"error": "Unexpected JSON structure."}, 400

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

def create_embeddings_batch(texts):
    """Create embeddings for a batch of texts."""
    return model.encode(texts, batch_size=32)

def recommend_events(user_id, user_data, event_data):
    user_id_str = str(user_id)
    
    # Find user
    user = next((u for u in user_data if str(u['user_id']) == user_id_str), None)
    
    # If user is not found or fields are missing, use default recommendations
    if not user or all(not user.get(field) for field in ['nickname', 'current_state', 'school', 'location', 'award', 'quote']):
        print(f"User data not found or incomplete for user_id {user_id}. Providing default recommendations.")
        # Simply recommend popular or recent events, or fallback to any other default strategy
        recommended_events = event_data[:20]  # Just taking the first 20 events as a fallback
        for event in recommended_events:
            event['event_id'] = int(event.get('event_id', 0))
            event['business_id'] = int(event.get('business_id', 0))
        return recommended_events

    # Generate user embedding
    user_text = ' '.join([
        str(user.get('nickname', '')),
        str(user.get('current_state', '')),
        str(user.get('school', '')),
        str(user.get('location', '')),
        str(user.get('award', '')),
        str(user.get('quote', ''))
    ])
    user_embedding = model.encode([user_text])[0]

    # Generate event embeddings
    event_texts = [' '.join([
        str(event.get('title', '')),
        str(event.get('location', '')),
        str(event.get('overview', '')),
        str(event.get('objectives', '')),
        str(event.get('target_audience', ''))
    ]) for event in event_data]

    event_embeddings = create_embeddings_batch(event_texts)
    similarities = util.pytorch_cos_sim(user_embedding, event_embeddings)[0]
    
    # Get top 20 recommended events based on similarity
    top_event_indices = similarities.argsort(descending=True)[:20]
    recommended_events = [event_data[i] for i in top_event_indices]
    
    for event in recommended_events:
        event['event_id'] = int(event.get('event_id', 0))
        event['business_id'] = int(event.get('business_id', 0))

    recommended_events.sort(key=lambda e: e['event_id'])

    return recommended_events

@app.route('/update-json', methods=['POST'])
def update_json():
    """Endpoint to trigger PHP script to update the JSON files."""
    run_php_script(php_script_path_update)
    return {"status": "JSON files updated"}, 200

@app.route('/similarities', methods=['GET'])
def get_similarities():
    """Endpoint to get similarities for a specific user ID."""
    user_id_input = request.args.get('user_id')
    if not user_id_input:
        return {"error": "User ID cannot be empty"}, 400

    # Load the updated JSON data
    user_data, error = load_json_data(json_file_path_user)
    if error:
        return user_data, 500

    user_input = next((user for user in user_data if user.get('user_id') == user_id_input), None)

    if user_input:
        user_input_embeddings = create_embeddings(user_input)

        # Calculate similarities
        similarities = []
        for user in user_data:
            if user['user_id'] != user_id_input:
                user_embeddings = create_embeddings(user)
                raw_similarity = util.cos_sim(user_input_embeddings, user_embeddings).item()
                scaled_similarity = scale_similarity(raw_similarity)
                similarities.append((user['user_id'], scaled_similarity))

        return jsonify(similarities)
    else:
        return {"error": f"User {user_id_input} not found in data."}, 404

@app.route('/event_recommendations', methods=['POST'])
def recommend_events_api():
    """Endpoint to get event recommendations for a specific user ID."""
    user_id = request.json.get('user_id')
    if not user_id:
        return jsonify({"error": "user_id is required"}), 400

    run_php_script(php_script_path_update)
    user_data_response, user_error = load_json_data(json_file_path_user)
    event_data_response, event_error = load_json_data(json_file_path_event)

    if user_error:
        return jsonify(user_data_response), 500

    if event_error:
        return jsonify(event_data_response), 500

    recommended_events = recommend_events(user_id, user_data_response, event_data_response)
    
    if isinstance(recommended_events, dict) and 'error' in recommended_events:
        return jsonify(recommended_events), 500

    return jsonify(recommended_events)

if __name__ == '__main__':
    serve(app, host='0.0.0.0', port=5000)
