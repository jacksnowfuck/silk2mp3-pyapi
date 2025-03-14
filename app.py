from flask import Flask, request, jsonify, send_file
import os
import subprocess

app = Flask(__name__)

def convert_silk_to_pcm(silk_file, pcm_file):
    try:
        subprocess.run(['silk-decoder', silk_file, pcm_file], check=True)
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Error converting {silk_file} to PCM: {e}")

def convert_pcm_to_mp3(pcm_file, mp3_file):
    try:
        subprocess.run(['ffmpeg', '-y', '-f', 's16le', '-ar', '24000', '-ac', '1', '-i', pcm_file, mp3_file], check=True)
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Error converting {pcm_file} to MP3: {e}")

@app.route('/convert', methods=['POST'])
def convert():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400

    silk_file = request.files['file']
    
    if silk_file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    silk_filename = silk_file.filename
    base_filename = os.path.splitext(silk_filename)[0]
    pcm_file = f"{base_filename}.pcm"
    mp3_file = f"{base_filename}.mp3"

    # Save the uploaded silk file temporarily
    silk_file.save(silk_filename)

    try:
        convert_silk_to_pcm(silk_filename, pcm_file)
        convert_pcm_to_mp3(pcm_file, mp3_file)
    except RuntimeError as e:
        return jsonify({"error": str(e)}), 500
    finally:
        # Clean up temporary files
        if os.path.exists(silk_filename):
            os.remove(silk_filename)
        if os.path.exists(pcm_file):
            os.remove(pcm_file)

    # Send back the converted mp3
    return send_file(mp3_file, as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5500)

