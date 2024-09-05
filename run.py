import subprocess
import time
import requests
import os

def is_flask_server_ready(url="http://10.0.2.2:5000"):
    try:
        response = requests.get(url)
        return response.status_code == 200
    except requests.ConnectionError:
        return False

def start_flask_server(flask_app):
    return subprocess.Popen(["python", flask_app])

def start_flutter_app(flutter_app, script_dir):
    subprocess.Popen(
        ["flutter", "run", "--target", flutter_app],
        cwd=os.path.join(script_dir, "friendzone_application"),
        shell=True
    )

def run_event_recommendation():
    # Get the directory of the current script
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Paths relative to the script's directory
    flask_app = os.path.join(script_dir, "event_recommendation_app.py")
    flutter_app = os.path.join(script_dir, "friendzone_application", "lib", "event", "event.dart")

    # Start the Flask server
    flask_process = start_flask_server(flask_app)

    # Give the Flask server some time to start
    time.sleep(5)  # Adjust time as necessary

    # Wait until Flask server is ready
    while not is_flask_server_ready():
        print("Waiting for Flask server to be ready...")
        time.sleep(5)

    print("Flask server is up. Starting Flutter app...")

    # Start the Flutter app
    start_flutter_app(flutter_app, script_dir)

    # Optionally, wait for the Flutter app to finish
    # flutter_process.wait() 

    # Clean up (stop Flask server)
    flask_process.terminate()

def run_friend_recommendation():
    # Get the directory of the current script
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Paths relative to the script's directory
    flask_app = os.path.join(script_dir, "friend_recommendation_app.py")
    flutter_app = os.path.join(script_dir, "friendzone_application", "lib", "home", "homepage.dart")

    # Start the Flask server
    flask_process = start_flask_server(flask_app)

    # Give the Flask server some time to start
    time.sleep(5)  # Adjust time as necessary

    # Wait until Flask server is ready
    while not is_flask_server_ready():
        print("Waiting for Flask server to be ready...")
        time.sleep(5)

    print("Flask server is up. Starting Flutter app...")

    # Start the Flutter app
    start_flutter_app(flutter_app, script_dir)

    # Optionally, wait for the Flutter app to finish
    # flutter_process.wait() 

    # Clean up (stop Flask server)
    flask_process.terminate()

if __name__ == "__main__":
    # Run event recommendation setup
    run_event_recommendation()

    # Run friend recommendation setup
    run_friend_recommendation()
